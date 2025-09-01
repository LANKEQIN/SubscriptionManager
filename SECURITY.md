# 🔒 安全配置指南

## 环境变量配置

为了保护 Supabase 等敏感信息，本项目使用环境变量进行配置管理。

### 设置步骤

1. **复制环境变量模板**：
   ```bash
   cp .env.example .env
   ```

2. **编辑 .env 文件**，填入您的实际 Supabase 配置：
   ```bash
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your_actual_anon_key_here
   ```

3. **获取 Supabase 配置**：
   - 登录 [Supabase Dashboard](https://supabase.com/dashboard)
   - 选择您的项目
   - 进入 Settings → API
   - 复制 "Project URL" 和 "anon public" 密钥

### 重要提醒

- ✅ `.env` 文件已添加到 `.gitignore`，不会被推送到 Git
- ⚠️ **绝对不要**将 `.env` 文件提交到版本控制系统
- 📝 只有 `.env.example` 文件应该被提交到 Git

### 安全最佳实践

1. **定期轮换密钥**: 定期在 Supabase Dashboard 中重新生成 API 密钥
2. **使用 RLS**: 在 Supabase 中启用行级安全性 (Row Level Security)
3. **监控使用情况**: 定期检查 Supabase 项目的使用情况和日志
4. **权限最小化**: 确保 anon 角色只有必要的权限

### 部署注意事项

当您部署应用到生产环境时：
- 使用相应平台的环境变量设置功能
- 确保生产环境的密钥与开发环境分离
- 考虑使用不同的 Supabase 项目用于不同环境

## 如果密钥泄露了怎么办？

1. **立即重新生成**: 在 Supabase Dashboard 中重新生成 API 密钥
2. **更新配置**: 在所有环境中更新新的密钥
3. **检查日志**: 查看是否有异常访问
4. **考虑 RLS**: 如果还没有，立即启用行级安全性