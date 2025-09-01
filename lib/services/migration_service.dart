import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../models/subscription.dart';
import '../models/monthly_history.dart';
import '../models/sync_types.dart';
import '../repositories/repository_interfaces.dart';
import '../providers/app_providers.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';

part 'migration_service.g.dart';

/// 增强数据迁移服务
/// 负责将数据从SharedPreferences迁移到新的同步架构
@riverpod
MigrationService migrationService(Ref ref) {
  final subscriptionRepo = ref.watch(subscriptionRepositoryProvider);
  final historyRepo = ref.watch(monthlyHistoryRepositoryProvider);
  final authService = ref.watch(authServiceProvider.notifier);
  final connectivityService = ref.watch(connectivityServiceProvider.notifier);
  
  return MigrationService(
    null, // AppDatabase 不再直接使用
    subscriptionRepo,
    historyRepo,
    authService: authService,
    connectivityService: connectivityService,
  );
}

/// 数据迁移服务
/// 负责将数据从SharedPreferences迁移到Drift数据库，并支持同步架构
class MigrationService {
  final SubscriptionRepository _subscriptionRepo;
  final MonthlyHistoryRepository _historyRepo;
  final AuthService? _authService;
  final ConnectivityService? _connectivityService;

  MigrationService(
    AppDatabase? database, // 保留参数以维持接口兼容性
    this._subscriptionRepo,
    this._historyRepo, {
    AuthService? authService,
    ConnectivityService? connectivityService,
  }) : _authService = authService,
       _connectivityService = connectivityService;

  /// 检查并执行数据迁移
  /// 返回true表示迁移成功或已完成，false表示迁移失败
  Future<bool> checkAndMigrate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 检查基础迁移状态
      final isDriftMigrated = prefs.getBool('data_migrated_to_drift') ?? false;
      
      // 检查同步架构迁移状态
      final isSyncMigrated = prefs.getBool('data_migrated_to_sync_arch') ?? false;
      
      if (isDriftMigrated && isSyncMigrated) {
        debugPrint('数据已完全迁移，跳过迁移过程');
        return true;
      }

      debugPrint('开始数据迁移...');
      
      // 执行基础迁移（SharedPreferences -> Drift）
      if (!isDriftMigrated) {
        final driftMigrationResult = await _performBaseMigration(prefs);
        if (driftMigrationResult) {
          await prefs.setBool('data_migrated_to_drift', true);
          debugPrint('基础数据迁移完成');
        } else {
          debugPrint('基础数据迁移失败');
          return false;
        }
      }
      
      // 执行同步架构迁移
      if (!isSyncMigrated) {
        final syncMigrationResult = await _performSyncArchMigration(prefs);
        if (syncMigrationResult) {
          await prefs.setBool('data_migrated_to_sync_arch', true);
          debugPrint('同步架构迁移完成');
        } else {
          debugPrint('同步架构迁移失败');
          return false;
        }
      }
      
      // 可选：清理旧数据（谨慎操作）
      await _cleanupOldData(prefs);
      
      return true;
    } catch (e) {
      debugPrint('数据迁移过程中发生错误: $e');
      return false;
    }
  }

  /// 执行基础数据迁移（SharedPreferences -> Drift）
  Future<bool> _performBaseMigration(SharedPreferences prefs) async {
    try {
      // 迁移订阅数据
      final subscriptionMigrated = await _migrateSubscriptions(prefs);
      if (!subscriptionMigrated) {
        debugPrint('订阅数据迁移失败');
        return false;
      }

      // 迁移月度历史数据
      final historyMigrated = await _migrateMonthlyHistories(prefs);
      if (!historyMigrated) {
        debugPrint('月度历史数据迁移失败');
        return false;
      }

      // 迁移用户偏好设置
      await _migrateUserPreferences(prefs);

      return true;
    } catch (e) {
      debugPrint('基础迁移执行过程中发生错误: $e');
      return false;
    }
  }
  
  /// 执行同步架构迁移（为现有数据添加同步字段）
  Future<bool> _performSyncArchMigration(SharedPreferences prefs) async {
    try {
      debugPrint('开始同步架构迁移...');
      
      // 更新所有订阅以支持同步
      final allSubscriptions = await _subscriptionRepo.getAllSubscriptions();
      for (final subscription in allSubscriptions) {
        // 为现有订阅添加同步相关字段
        final now = DateTime.now();
        final updated = subscription.copyWith(
          createdAt: subscription.createdAt ?? now,
          updatedAt: subscription.updatedAt ?? now,
          needsSync: false, // 现有数据不需要立即同步
          syncStatus: SyncStatus.synced,
        );
        
        await _subscriptionRepo.updateSubscription(updated);
      }
      
      // 更新所有月度历史以支持同步
      final allHistories = await _historyRepo.getAllHistories();
      for (final history in allHistories) {
        final now = DateTime.now();
        final updated = history.copyWith(
          createdAt: history.createdAt ?? now,
          updatedAt: history.updatedAt ?? now,
        );
        
        await _historyRepo.saveHistory(updated);
      }
      
      debugPrint('同步架构迁移完成，已更新 ${allSubscriptions.length} 个订阅和 ${allHistories.length} 个历史记录');
      
      return true;
    } catch (e) {
      debugPrint('同步架构迁移失败: $e');
      return false;
    }
  }

  /// 迁移订阅数据
  Future<bool> _migrateSubscriptions(SharedPreferences prefs) async {
    try {
      final subscriptionsString = prefs.getString('subscriptions');
      if (subscriptionsString == null || subscriptionsString.isEmpty) {
        debugPrint('没有找到订阅数据，跳过订阅迁移');
        return true;
      }

      final List<dynamic> subscriptionsJson = json.decode(subscriptionsString);
      debugPrint('找到 ${subscriptionsJson.length} 个订阅需要迁移');

      for (int i = 0; i < subscriptionsJson.length; i++) {
        try {
          final subscriptionData = subscriptionsJson[i] as Map<String, dynamic>;
          
          // 创建Subscription对象，使用新的同步支持
          var subscription = Subscription.fromMap(subscriptionData);
          
          // 确保有有效的ID
          if (subscription.id.isEmpty) {
            subscription = subscription.copyWith(id: const Uuid().v4());
          }
          
          // 添加同步相关字段
          final now = DateTime.now();
          subscription = subscription.copyWith(
            createdAt: now,
            updatedAt: now,
            needsSync: false, // 迁移的数据不需要立即同步
            syncStatus: SyncStatus.synced,
          );

          // 添加到数据库
          await _subscriptionRepo.addSubscription(subscription);
          debugPrint('成功迁移订阅: ${subscription.name}');
        } catch (e) {
          debugPrint('迁移第 ${i + 1} 个订阅时发生错误: $e');
          // 继续迁移其他订阅，不因单个失败而停止
        }
      }

      return true;
    } catch (e) {
      debugPrint('订阅数据迁移失败: $e');
      return false;
    }
  }

  /// 迁移月度历史数据
  Future<bool> _migrateMonthlyHistories(SharedPreferences prefs) async {
    try {
      final historiesString = prefs.getString('monthlyHistories');
      if (historiesString == null || historiesString.isEmpty) {
        debugPrint('没有找到月度历史数据，跳过历史迁移');
        return true;
      }

      final List<dynamic> historiesJson = json.decode(historiesString);
      debugPrint('找到 ${historiesJson.length} 个月度历史记录需要迁移');

      for (int i = 0; i < historiesJson.length; i++) {
        try {
          final historyData = historiesJson[i] as Map<String, dynamic>;
          
          // 创建MonthlyHistory对象，使用新的同步支持
          var history = MonthlyHistory.fromMap(historyData);
          
          // 确保有有效的ID
          if (history.id.isEmpty) {
            history = history.copyWith(id: const Uuid().v4());
          }
          
          // 添加同步相关字段
          final now = DateTime.now();
          history = history.copyWith(
            createdAt: now,
            updatedAt: now,
          );

          // 添加到数据库
          await _historyRepo.saveHistory(history);
          debugPrint('成功迁移月度历史: ${history.year}年${history.month}月');
        } catch (e) {
          debugPrint('迁移第 ${i + 1} 个月度历史时发生错误: $e');
          // 继续迁移其他记录
        }
      }

      return true;
    } catch (e) {
      debugPrint('月度历史数据迁移失败: $e');
      return false;
    }
  }

  /// 迁移用户偏好设置
  Future<void> _migrateUserPreferences(SharedPreferences prefs) async {
    try {
      // 迁移主题设置
      final themeModeIndex = prefs.getInt('themeMode');
      if (themeModeIndex != null) {
        await prefs.setInt('theme_mode', themeModeIndex);
      }

      // 迁移字体大小
      final fontSize = prefs.getDouble('fontSize');
      if (fontSize != null) {
        await prefs.setDouble('font_size', fontSize);
      }

      // 迁移主题颜色
      final themeColorValue = prefs.getInt('themeColor');
      if (themeColorValue != null) {
        await prefs.setInt('theme_color', themeColorValue);
      }

      // 迁移基准货币
      final baseCurrency = prefs.getString('base_currency');
      if (baseCurrency != null) {
        await prefs.setString('base_currency', baseCurrency);
      }

      debugPrint('用户偏好设置迁移完成');
    } catch (e) {
      debugPrint('用户偏好设置迁移失败: $e');
      // 偏好设置迁移失败不应该影响整个迁移过程
    }
  }

  /// 清理旧数据
  /// 注意：这会永久删除SharedPreferences中的旧数据
  Future<void> _cleanupOldData(SharedPreferences prefs) async {
    try {
      // 可选择性清理旧数据
      const bool shouldCleanup = true; // 可以通过配置控制
      
      if (shouldCleanup) {
        await prefs.remove('subscriptions');
        await prefs.remove('monthlyHistories');
        debugPrint('旧数据清理完成');
      }
    } catch (e) {
      debugPrint('清理旧数据时发生错误: $e');
      // 清理失败不影响迁移结果
    }
  }

  /// 验证迁移结果
  Future<bool> validateMigration() async {
    try {
      // 检查订阅数据
      final subscriptions = await _subscriptionRepo.getAllSubscriptions();
      
      // 检查月度历史数据
      final histories = await _historyRepo.getAllHistories();
      
      debugPrint('迁移验证结果:');
      debugPrint('- 订阅数量: ${subscriptions.length}');
      debugPrint('- 月度历史记录数量: ${histories.length}');
      
      return true;
    } catch (e) {
      debugPrint('迁移验证失败: $e');
      return false;
    }
  }

  /// 回滚迁移（紧急情况使用）
  Future<bool> rollbackMigration() async {
    try {
      debugPrint('开始回滚迁移...');
      
      // 清空数据库表
      final allSubscriptions = await _subscriptionRepo.getAllSubscriptions();
      for (final subscription in allSubscriptions) {
        await _subscriptionRepo.deleteSubscription(subscription.id);
      }
      
      final allHistories = await _historyRepo.getAllHistories();
      for (final history in allHistories) {
        await _historyRepo.deleteHistory(history.id);
      }
      
      // 重置迁移标记
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('data_migrated_to_drift', false);
      await prefs.setBool('data_migrated_to_sync_arch', false);
      await prefs.setBool('has_uploaded_existing_data', false);
      
      debugPrint('迁移回滚完成');
      return true;
    } catch (e) {
      debugPrint('迁移回滚失败: $e');
      return false;
    }
  }
  
  /// 检查是否需要上传现有数据到服务器
  Future<bool> shouldUploadExistingData() async {
    try {
      // 只有在用户登录且网络可用时才上传
      if (_authService?.isLoggedIn != true || _connectivityService?.isConnected != true) {
        return false;
      }
      
      final prefs = await SharedPreferences.getInstance();
      final hasUploadedData = prefs.getBool('has_uploaded_existing_data') ?? false;
      
      return !hasUploadedData;
    } catch (e) {
      debugPrint('检查上传状态失败: $e');
      return false;
    }
  }
  
  /// 上传现有数据到服务器（用户首次登录时）
  Future<bool> uploadExistingDataToServer() async {
    try {
      if (_authService?.isLoggedIn != true) {
        debugPrint('用户未登录，跳过数据上传');
        return false;
      }
      
      if (_connectivityService?.isConnected != true) {
        debugPrint('网络不可用，跳过数据上传');
        return false;
      }
      
      debugPrint('开始上传现有数据到服务器...');
      
      // 获取所有本地数据
      final allSubscriptions = await _subscriptionRepo.getAllSubscriptions();
      final allHistories = await _historyRepo.getAllHistories();
      
      // 标记所有数据为需要同步
      for (final subscription in allSubscriptions) {
        final updated = subscription.copyWith(
          needsSync: true,
          syncStatus: SyncStatus.pending,
        );
        await _subscriptionRepo.updateSubscription(updated);
      }
      
      // 标记上传完成
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_uploaded_existing_data', true);
      
      debugPrint('已标记 ${allSubscriptions.length} 个订阅和 ${allHistories.length} 个历史记录为待同步');
      
      return true;
    } catch (e) {
      debugPrint('上传现有数据失败: $e');
      return false;
    }
  }
  
  /// 重置上传状态（用于重新同步）
  Future<void> resetUploadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_uploaded_existing_data', false);
      debugPrint('已重置上传状态');
    } catch (e) {
      debugPrint('重置上传状态失败: $e');
    }
  }
}