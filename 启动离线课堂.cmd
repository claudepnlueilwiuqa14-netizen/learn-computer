@echo off
setlocal
cd /d "%~dp0学习者记忆库\语音课程"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0学习者记忆库\语音课程\启动课堂模式.ps1" -OpenBrowser
if errorlevel 1 (
  echo.
  echo 本地课堂没有启动成功。请把这段窗口文字发给老师检查。
  pause
)
endlocal
