@ECHO OFF
TITLE CliGZDoomRunner - StormFifty333

::checks if gzdoom folder already exists and creates one if not
IF NOT EXIST "%appdata%\GZDoom" (
	MKDIR "%appdata%\GZDoom"
	ECHO [33m[INFO] GZDoom folder created in %appdata%[0m
) ELSE (
	ECHO [33m[INFO] GZDoom folder already exists at %appdata%[0m
)

::checks for existing gzdoom exe
IF NOT EXIST "%appdata%\GZDoom\gzdoom.exe" (

	::downloads gzdoom from the internet
	IF NOT EXIST "%appdata%\GZDoom\gzdoom-4-14-0a-windows.zip" (
		ECHO [33m[INFO] Attempting GZDoom download from https://github.com/ZDoom/gzdoom/releases/download/g4.14.0/gzdoom-4-14-0a-windows.zip...[0m
		curl -L -O https://github.com/ZDoom/gzdoom/releases/download/g4.14.0/gzdoom-4-14-0a-windows.zip
		ECHO [33m[INFO] gzdoom-4-14-0a-windows.zip download complete![0m
		MOVE gzdoom-4-14-0a-windows.zip "%appdata%\GZDoom"
	) ELSE (
		ECHO [33m[INFO] gzdoom-4-14-0a-windows.zip already exists![0m
	)
	
	::extracts gzdoom zip
	IF EXIST "%appdata%\GZDoom\gzdoom-4-14-0a-windows.zip" (
		ECHO [33m[INFO] Beginning to extract gzdoom-4-14-0a-windows.zip...[0m
		powershell Expand-Archive "%appdata%\GZDoom\gzdoom-4-14-0a-windows.zip" "%appdata%\GZDoom"
		ECHO [33m[INFO] Extraction complete![0m
	
		::removes zip
		ECHO [33m[INFO] Removing gzdoom-4-14-0a-windows.zip...[0m
		DEL "%appdata%\GZDoom\gzdoom-4-14-0a-windows.zip"
	) ELSE (
		ECHO [31m[ERROR] Zip not found! Download possibly failed or file lost...[0m
	)
	
) ELSE (
	ECHO [33m[INFO] Existing install found! No corruption free guarantee![0m
)

::prompts user to select config
:prompt_config
	ECHO [36m[PROMPT] Which config would you like to apply?[0m
	ECHO [34m[OPTION] StormFifty333's config: 1[0m
	ECHO [34m[OPTION] Default config: 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		::download and apply config here
		ECHO [33m[INFO] Attempting download from ...[0m
	) ELSE (
		IF %input%==2 (
			ECHO 2
		) ELSE (
			ECHO OTHER
			goto prompt_config
		)
	)

PAUSE