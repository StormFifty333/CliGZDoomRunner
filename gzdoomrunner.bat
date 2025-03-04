@ECHO OFF
TITLE GZDoom Runner - Kolton

:checks if gzdoom folder already exists and creates one if not
IF NOT EXIST "%appdata%\GZDoom" (
	MKDIR "%appdata%\GZDoom"
	ECHO [33m[INFO] GZDoom folder created in %appdata%[0m
) ELSE (
	ECHO [33m[INFO] GZDoom folder already exists...[0m
)
CD "%appdata%\GZDoom"



PAUSE