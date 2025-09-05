# Flutter应用的ProGuard规则

# 保留注解
-keepattributes Annotation
-keepattributes Signature

# Flutter包装类
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.BuildConfig { *; }
-keep class io.flutter.embedding.** { *; }
-keep class androidx.lifecycle.DefaultLifecycleObserver

# Android相关
-keep class android.** { *; }
-keep class androidx.** { *; }

# Google服务
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }

# 保持自定义Application类
-keep class * extends android.app.Application

# 保持自定义Activity类
-keep class * extends android.app.Activity

# 保持自定义Service类
-keep class * extends android.app.Service

# 保持自定义BroadcastReceiver类
-keep class * extends android.content.BroadcastReceiver

# 保持自定义ContentProvider类
-keep class * extends android.content.ContentProvider

# 保持自定义View类
-keep class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
    public void set*(...);
}

# 保持枚举类型
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# 保持Parcelable实现类
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Gson相关规则
-keepattributes EnclosingMethod
-keep class com.google.gson.** { *; }
-keep class com.google.gson.examples.android.model.** { *; }

# 保留所有Model类的成员变量名（根据实际包名修改）
-keepclassmembers class com.example.subscription_manager.models.** {
    <fields>;
    <init>(...);
    <methods>;
}

# 保留所有Repository类（根据实际包名修改）
-keep class com.example.subscription_manager.repositories.** { *; }

# 保留所有Service类（根据实际包名修改）
-keep class com.example.subscription_manager.services.** { *; }

# 保留所有Network相关类（根据实际包名修改）
-keep class com.example.subscription_manager.network.** { *; }

# 保留所有Database相关类（根据实际包名修改）
-keep class com.example.subscription_manager.database.** { *; }

# 保留所有Provider类（根据实际包名修改）
-keep class com.example.subscription_manager.providers.** { *; }

# 保留所有Util类（根据实际包名修改）
-keep class com.example.subscription_manager.utils.** { *; }

# 保留所有Constants类（根据实际包名修改）
-keep class com.example.subscription_manager.constants.** { *; }

# 保留所有Feature相关类（根据实际包名修改）
-keep class com.example.subscription_manager.features.** { *; }

# 保留所有Widget类（根据实际包名修改）
-keep class com.example.subscription_manager.widgets.** { *; }

# 保留所有Screen类（根据实际包名修改）
-keep class com.example.subscription_manager.screens.** { *; }

# 保留所有Dialog类（根据实际包名修改）
-keep class com.example.subscription_manager.dialogs.** { *; }

# 保留所有Cache相关类（根据实际包名修改）
-keep class com.example.subscription_manager.cache.** { *; }

# 保留所有Config相关类（根据实际包名修改）
-keep class com.example.subscription_manager.config.** { *; }

# 保留所有第三方库的类
-keep class io.reactivex.** { *; }
-keep class io.reactivex.rxjava3.** { *; }
-keep class retrofit2.** { *; }
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-keep class com.squareup.picasso.** { *; }
-keep class com.bumptech.glide.** { *; }
-keep class org.joda.time.** { *; }

# 不要混淆Dart的内部类
-keep class * extends io.flutter.embedding.engine.** {*;}

# 不要混淆Supabase相关类
-keep class io.supabase.** { *; }
-keep class com.supabase.** { *; }

# 不要混淆Drift数据库相关类
-keep class com.squareup.moshi.** { *; }
-keep class androidx.room.** { *; }
-keep class dev.dartning.drift.** { *; }

# 不要混淆Hive相关类
-keep class hive.** { *; }

# 不要混淆UUID相关类
-keep class com.fasterxml.uuid.** { *; }

# 不要混淆SharedPreferences相关类
-keep class android.content.SharedPreferences { *; }

# 不要混淆Connectivity相关类
-keep class dev.dartning.connectivity_plus.** { *; }

# 不要混淆Logger相关类
-keep class logger.** { *; }

# 不要混淆Riverpod相关类
-keep class com.example.subscription_manager.**_Providers { *; }

# 不要混淆Freezed相关类
-keep class **$$** { *; }

# 不要混淆Json相关类
-keep class **_Factory { *; }
-keep class **_Adapter { *; }

# 优化选项
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification

# 混淆时保持文件名和行号
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable