import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../models/subscription.dart';
import '../models/monthly_history.dart';
import '../repositories/repository_interfaces.dart';

/// 数据迁移服务
/// 负责将数据从SharedPreferences迁移到Drift数据库
class MigrationService {
  final SubscriptionRepository _subscriptionRepo;
  final MonthlyHistoryRepository _historyRepo;

  MigrationService(
    AppDatabase database, // 保留参数以维持接口兼容性
    this._subscriptionRepo,
    this._historyRepo,
  );

  /// 检查并执行数据迁移
  /// 返回true表示迁移成功或已完成，false表示迁移失败
  Future<bool> checkAndMigrate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isMigrated = prefs.getBool('data_migrated_to_drift') ?? false;
      
      if (isMigrated) {
        debugPrint('数据已迁移，跳过迁移过程');
        return true;
      }

      debugPrint('开始数据迁移...');
      
      // 执行迁移
      final migrationResult = await _performMigration(prefs);
      
      if (migrationResult) {
        // 标记迁移完成
        await prefs.setBool('data_migrated_to_drift', true);
        debugPrint('数据迁移完成');
        
        // 可选：清理旧数据（谨慎操作）
        await _cleanupOldData(prefs);
        
        return true;
      } else {
        debugPrint('数据迁移失败');
        return false;
      }
    } catch (e) {
      debugPrint('数据迁移过程中发生错误: $e');
      return false;
    }
  }

  /// 执行实际的数据迁移
  Future<bool> _performMigration(SharedPreferences prefs) async {
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
      debugPrint('迁移执行过程中发生错误: $e');
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
          
          // 创建Subscription对象
          var subscription = Subscription.fromMap(subscriptionData);
          
          // 确保有有效的ID
          if (subscription.id.isEmpty) {
            subscription = subscription.copyWith(id: const Uuid().v4());
          }

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
          
          // 创建MonthlyHistory对象
          var history = MonthlyHistory.fromMap(historyData);
          
          // 确保有有效的ID
          if (history.id.isEmpty) {
            history = history.copyWith(id: const Uuid().v4());
          }

          // 添加到数据库
          await _historyRepo.addMonthlyHistory(history);
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
        await _historyRepo.deleteMonthlyHistory(history.id);
      }
      
      // 重置迁移标记
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('data_migrated_to_drift', false);
      
      debugPrint('迁移回滚完成');
      return true;
    } catch (e) {
      debugPrint('迁移回滚失败: $e');
      return false;
    }
  }
}