# 本地视频素材目录

把自己制作、已获授权或明确允许离线使用的 MP4/WebM 文件放在这里，然后在上一级的 `视频课件配置.json` 中填写相对路径，例如：

```json
{
  "id": "PRE0-LOCAL-01",
  "title": "我的电脑基础演示",
  "provider": "本地课件",
  "kind": "local video",
  "local_path": "videos/PRE0-intro.mp4",
  "course_ids": ["PRE0"]
}
```

不要填写 Windows 绝对路径，不要放入密码、Cookie、API Key 或私人录屏。大文件会占用磁盘空间，建议在外部磁盘另做备份。课堂页面只会把播放当作辅助材料，不会因播放自动通过关卡。
