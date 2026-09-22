# 备选部署方式：用 Docker 跑（适合不想配 systemd/nginx 的场景）
# 用法：
#   docker build -t classroom .
#   docker run -d --name classroom -p 8765:8765 \
#       -e AI_API_KEY=你的key -e AI_MODEL=gpt-5.5 \
#       classroom
# 镜像只暴露 8765；前面仍建议用 nginx/caddy 套一层 HTTPS + 访问密码

FROM python:3.13-slim

WORKDIR /app

# 整个仓库复制进来；课堂模式.html 与数据都在 学习者记忆库/语音课程 下
COPY . /app/

ENV AI_MODEL=gpt-5.5
ENV AI_BASE_URL=https://api.985la.cn
ENV AI_TIMEOUT_SECONDS=90
ENV AI_API_KEY=""

EXPOSE 8765

# --root 指向含 课堂模式.html 的目录；memory_root 自动取其父目录(学习者记忆库)
CMD ["python3", "serve_classroom.py", \
     "--root", "/app/学习者记忆库/语音课程", \
     "--port", "8765", \
     "--host", "0.0.0.0"]
