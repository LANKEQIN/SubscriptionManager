-- ===========================================
-- Supabase数据库Schema
-- 用于SubscriptionManager应用的账户和数据同步功能
-- ===========================================

-- 启用UUID扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ===========================================
-- 用户配置表 (profiles)
-- ===========================================

CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  base_currency TEXT DEFAULT 'CNY' NOT NULL,
  theme_mode TEXT DEFAULT 'system' NOT NULL,
  font_size REAL DEFAULT 14.0 NOT NULL,
  theme_color TEXT,
  sync_enabled BOOLEAN DEFAULT true NOT NULL,
  
  CONSTRAINT valid_theme_mode CHECK (theme_mode IN ('system', 'light', 'dark')),
  CONSTRAINT valid_currency CHECK (base_currency IN ('CNY', 'USD', 'EUR', 'GBP', 'JPY')),
  CONSTRAINT valid_font_size CHECK (font_size >= 10.0 AND font_size <= 24.0)
);

-- 用户配置表索引
CREATE INDEX idx_profiles_created_at ON profiles(created_at);
CREATE INDEX idx_profiles_updated_at ON profiles(updated_at);

-- ===========================================
-- 订阅表 (subscriptions)
-- ===========================================

CREATE TABLE subscriptions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  currency TEXT NOT NULL,
  billing_cycle TEXT NOT NULL,
  next_payment_date DATE NOT NULL,
  description TEXT,
  icon_name TEXT,
  color TEXT,
  is_active BOOLEAN DEFAULT true NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  local_id TEXT, -- 用于本地数据迁移
  last_synced_at TIMESTAMP WITH TIME ZONE,
  
  CONSTRAINT valid_price CHECK (price >= 0),
  CONSTRAINT valid_currency CHECK (currency IN ('CNY', 'USD', 'EUR', 'GBP', 'JPY')),
  CONSTRAINT valid_billing_cycle CHECK (billing_cycle IN ('weekly', 'monthly', 'quarterly', 'yearly'))
);

-- 订阅表索引
CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_created_at ON subscriptions(created_at);
CREATE INDEX idx_subscriptions_updated_at ON subscriptions(updated_at);
CREATE INDEX idx_subscriptions_next_payment ON subscriptions(next_payment_date);
CREATE INDEX idx_subscriptions_local_id ON subscriptions(local_id);
CREATE INDEX idx_subscriptions_is_active ON subscriptions(is_active);

-- ===========================================
-- 月度历史记录表 (monthly_histories)
-- ===========================================

CREATE TABLE monthly_histories (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  year INTEGER NOT NULL,
  month INTEGER NOT NULL,
  total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  currency TEXT NOT NULL DEFAULT 'CNY',
  subscription_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  last_synced_at TIMESTAMP WITH TIME ZONE,
  
  CONSTRAINT valid_year CHECK (year >= 2020 AND year <= 2100),
  CONSTRAINT valid_month CHECK (month >= 1 AND month <= 12),
  CONSTRAINT valid_total_amount CHECK (total_amount >= 0),
  CONSTRAINT valid_subscription_count CHECK (subscription_count >= 0),
  CONSTRAINT unique_user_year_month UNIQUE(user_id, year, month)
);

-- 月度历史记录表索引
CREATE INDEX idx_monthly_histories_user_id ON monthly_histories(user_id);
CREATE INDEX idx_monthly_histories_year_month ON monthly_histories(year, month);
CREATE INDEX idx_monthly_histories_created_at ON monthly_histories(created_at);

-- ===========================================
-- 行级安全策略 (Row Level Security)
-- ===========================================

-- 启用RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE monthly_histories ENABLE ROW LEVEL SECURITY;

-- 用户配置表策略
CREATE POLICY "用户只能查看自己的配置" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "用户只能更新自己的配置" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "用户可以插入自己的配置" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- 订阅表策略
CREATE POLICY "用户只能查看自己的订阅" ON subscriptions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "用户只能修改自己的订阅" ON subscriptions
  FOR ALL USING (auth.uid() = user_id);

-- 月度历史记录表策略
CREATE POLICY "用户只能查看自己的历史记录" ON monthly_histories
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "用户只能修改自己的历史记录" ON monthly_histories
  FOR ALL USING (auth.uid() = user_id);

-- ===========================================
-- 触发器函数
-- ===========================================

-- 自动更新updated_at字段的函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为表添加更新时间触发器
CREATE TRIGGER update_profiles_updated_at 
  BEFORE UPDATE ON profiles 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_subscriptions_updated_at 
  BEFORE UPDATE ON subscriptions 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_monthly_histories_updated_at 
  BEFORE UPDATE ON monthly_histories 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 自动创建用户配置的函数
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'display_name');
  RETURN NEW;
END;
$$ language 'plpgsql' SECURITY definer;

-- 新用户注册时自动创建配置记录
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ===========================================
-- 实时订阅配置
-- ===========================================

-- 为订阅表启用实时功能
ALTER PUBLICATION supabase_realtime ADD TABLE subscriptions;
ALTER PUBLICATION supabase_realtime ADD TABLE monthly_histories;
ALTER PUBLICATION supabase_realtime ADD TABLE profiles;