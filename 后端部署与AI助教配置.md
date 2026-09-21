# 后端、云端助教与免费部署

## 先处理密钥

不要把 `sk-...` 写进 HTML、GitHub、截图、聊天记录或浏览器代码。已经在对话里暴露过的密钥应在服务商后台立即撤销并重新生成。新密钥只放在服务器的环境变量 `AI_API_KEY` 中。

## 助教工作方式

`serve_classroom.py` 现在有两层回复：

1. 没有 `AI_API_KEY` 时，使用本地上下文助教。它读取课程、当前模块、概念回答、英语练习、关卡和 Lab 记录，立即回复，并写入 `课堂记录/助教聊天/<课程号>.jsonl`。
2. 配置 `AI_API_KEY` 后，后端向 OpenAI-compatible 的 `/v1/chat/completions` 发送最小必要课堂上下文。浏览器不会接触密钥；网络失败时自动回退到本地助教。

默认中转地址是 `https://api.985la.cn`，可用 `AI_BASE_URL` 改成其他兼容服务。若服务商提供完整的 `.../v1/chat/completions` 地址，也可以直接填入；代码会自动补齐路径。

## 本机配置

PowerShell 示例（只对当前窗口生效）：

```powershell
$env:AI_BASE_URL = "https://api.985la.cn"
$env:AI_MODEL = "gpt-4o-mini"
$env:AI_API_KEY = "在服务商后台新生成的密钥"
$env:AI_TIMEOUT_SECONDS = "35"
python .\学习者记忆库\语音课程\serve_classroom.py --root .\学习者记忆库\语音课程 --port 8765
```

关闭窗口后这些变量会消失。不要把它们写入 Git 仓库，也不要在前端 JavaScript 中配置。

## 免费公网试运行

仓库已加入 `Dockerfile` 和 `render.yaml`，可以在 Render 创建 Web Service 并连接这个私有仓库：

1. 在 Render 选择 New → Web Service → 连接 `learn-computer`。
2. 选择 Docker，计划选择 Free。
3. 在 Environment 中填写 `AI_API_KEY`、`CORS_ORIGIN` 和需要的模型名；密钥字段只能在 Render 后台填写。
4. 部署完成后打开 `/api/health`，必须返回 `{"ok":true}`，再把课堂前端的 API 地址接到该服务。

免费 Web Service 通常会休眠，且本地文件系统可能在重启或重新部署后被清空。因此它适合验证云端助教，不等于永久学习记录。要永久保存记录，需要把 JSONL 迁移到带持久化磁盘或托管 Postgres/Supabase，并配置定期备份。当前最可靠的永久记录仍是本机 `学习者记忆库/课堂记录/`。

## 安全边界

- 公开 GitHub Pages 只能展示课程和静态助教回退，不能安全保存云端密钥。
- 云端服务器不要把 `课堂记录/`、Cookie、密码、API key 或个人证据提交回 GitHub。
- 生产环境还应增加登录、请求限流、费用上限、HTTPS、数据库备份和删除记录的管理入口。
