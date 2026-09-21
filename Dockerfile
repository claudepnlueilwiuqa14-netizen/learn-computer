FROM python:3.12-slim

WORKDIR /app
COPY . /app

ENV PYTHONUNBUFFERED=1
ENV CLASSROOM_HOST=0.0.0.0
ENV PORT=10000

CMD ["sh", "-c", "python 学习者记忆库/语音课程/serve_classroom.py --host ${CLASSROOM_HOST:-0.0.0.0} --port ${PORT:-10000} --root 学习者记忆库/语音课程"]
