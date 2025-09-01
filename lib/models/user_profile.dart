import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

/// 用户配置模型
/// 
/// 包含用户的个人设置和偏好配置
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    /// 用户ID (对应Supabase auth.users.id)
    required String userId,
    
    /// 显示名称
    String? displayName,
    
    /// 头像URL
    String? avatarUrl,
    
    /// 基础货币
    @Default('CNY') String baseCurrency,
    
    /// 主题模式
    @Default('system') String themeMode,
    
    /// 字体大小
    @Default(14.0) double fontSize,
    
    /// 主题颜色
    String? themeColor,
    
    /// 是否启用同步
    @Default(true) bool syncEnabled,
    
    /// 创建时间
    DateTime? createdAt,
    
    /// 最后更新时间
    DateTime? updatedAt,
  }) = _UserProfile;
  
  const UserProfile._();
  
  /// 从Supabase JSON创建UserProfile
  factory UserProfile.fromSupabaseJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['id'],
      displayName: json['display_name'],
      avatarUrl: json['avatar_url'],
      baseCurrency: json['base_currency'] ?? 'CNY',
      themeMode: json['theme_mode'] ?? 'system',
      fontSize: (json['font_size'] ?? 14.0).toDouble(),
      themeColor: json['theme_color'],
      syncEnabled: json['sync_enabled'] ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
  
  /// 转换为Supabase JSON格式
  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': userId,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'base_currency': baseCurrency,
      'theme_mode': themeMode,
      'font_size': fontSize,
      'theme_color': themeColor,
      'sync_enabled': syncEnabled,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
  
  /// 更新配置
  UserProfile updateProfile({
    String? displayName,
    String? avatarUrl,
    String? baseCurrency,
    String? themeMode,
    double? fontSize,
    String? themeColor,
    bool? syncEnabled,
  }) {
    return copyWith(
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      themeColor: themeColor ?? this.themeColor,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      updatedAt: DateTime.now(),
    );
  }
  
  /// 检查主题模式
  bool get isDarkMode => themeMode == 'dark';
  bool get isLightMode => themeMode == 'light';
  bool get isSystemMode => themeMode == 'system';
}