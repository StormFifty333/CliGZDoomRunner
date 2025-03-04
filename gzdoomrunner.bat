@ECHO OFF
TITLE GZDoom Runner - Kolton

:checks if gzdoom folder already exists and creates one if not
IF NOT EXIST "%appdata%\GZDoom" (
	MKDIR "%appdata%\GZDoom"
	ECHO [33m[INFO] GZDoom folder created in %appdata%[0m
) ELSE (
	ECHO [33m[INFO] GZDoom folder already exists![0m
)

:checks for existing gzdoom exe
if NOT EXIST "%appdata%\GZDoom\gzdoom.exe" (

	:downloads gzdoom from the internet
	if NOT EXIST "%appdata%\GZDoom\gzdoom-4-14-0a-windows.zip" (
		ECHO [33m[INFO] Attempting gzdoom-4-14-0a-windows.zip download...[0m
		curl -L -O https://github.com/ZDoom/gzdoom/releases/download/g4.14.0/gzdoom-4-14-0a-windows.zip
		ECHO [33m[INFO] gzdoom-4-14-0a-windows.zip download complete![0m
		MOVE gzdoom-4-14-0a-windows.zip "%appdata%\GZDoom"
	) ELSE (
		ECHO [33m[INFO] gzdoom-4-14-0a-windows.zip already exists![0m
	)
	
	:extracts gzdoom zip
	ECHO [33m[INFO] Beginning zip extraction...[0m
	powershell Expand-Archive "%appdata%\GZDoom\gzdoom-4-14-0a-windows.zip" "%appdata%\GZDoom"
	ECHO [33m[INFO] Extraction complete![0m
	
	:removes zip
	DEL "%appdata%\GZDoom\gzdoom-4-14-0a-windows.zip"
	
) ELSE (
	ECHO [33m[INFO] Existing install found! No corruption free guarantee![0m
)

PAUSE