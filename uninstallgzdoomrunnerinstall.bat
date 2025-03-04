@ECHO OFF
TITLE Uninstall GZDoom Runner Install - Kolton

:checks if gzdoom folder exists for deletion
IF EXIST "%appdata%\GZDoom" (
	RMDIR /S /Q "%appdata%\GZDoom"
	ECHO [33m[INFO] GZDoom folder removed.[0m
) else (
	ECHO [33m[INFO] No GZDoom Runner Install found...[0m
)

PAUSE