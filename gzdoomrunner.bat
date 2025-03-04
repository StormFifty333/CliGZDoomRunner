@ECHO OFF
TITLE GZDoom Runner - Kolton

:checks if gzdoom folder already exists and creates one if not
IF NOT EXIST "%appdata%\GZDoom" (
	MKDIR "%appdata%\GZDoom"
	ECHO [33m[INFO] GZDoom folder created in %appdata%[0m
) ELSE (
	ECHO [33m[INFO] GZDoom folder already exists...[0m
)

:downloads gzdoom from the internet
ECHO [33m[INFO] Attempting gzdoom-4-14-0a-windows.zip download...[0m
curl -L -O https://github.com/ZDoom/gzdoom/releases/download/g4.14.0/gzdoom-4-14-0a-windows.zip
ECHO [33m[INFO] gzdoom-4-14-0a-windows.zip download complete![0m

MOVE gzdoom-4-14-0a-windows.zip "%appdata%\GZDoom"

PAUSE