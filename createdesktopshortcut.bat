@ECHO OFF
TITLE Creating Shortcut...
SETLOCAL enabledelayedexpansion

for /f "usebackq tokens=1,2,*" %%B IN (`reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop`) do set DESKTOP=%%D

MKLINK "%DESKTOP%\GZDoom Runner" "%localappdata%\GZDoom\gzdoomrunner.bat"
