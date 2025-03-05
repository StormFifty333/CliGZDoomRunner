@ECHO OFF
TITLE CliGZDoomRunner - StormFifty333
SETLOCAL enabledelayedexpansion

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
		ECHO [33m[INFO] GZDoom download complete^^![0m
		MOVE gzdoom-4-14-0a-windows.zip "%appdata%\GZDoom"
	) ELSE (
		ECHO [33m[INFO] gzdoom-4-14-0a-windows.zip already exists^^![0m
	)
	
	::extracts gzdoom zip
	IF EXIST "%appdata%\GZDoom\gzdoom-4-14-0a-windows.zip" (
		ECHO [33m[INFO] Beginning to extract gzdoom-4-14-0a-windows.zip...[0m
		powershell Expand-Archive "%appdata%\GZDoom\gzdoom-4-14-0a-windows.zip" "%appdata%\GZDoom"
		ECHO [33m[INFO] Extraction complete^^![0m
	
		::removes zip
		ECHO [33m[INFO] Removing gzdoom-4-14-0a-windows.zip...[0m
		DEL "%appdata%\GZDoom\gzdoom-4-14-0a-windows.zip"
	) ELSE (
		ECHO [31m[ERROR] Zip not found^^! Download possibly failed or file lost...[0m
	)
	
) ELSE (
	ECHO [33m[INFO] Existing install found^^! No corruption free guarantee^^![0m
)

IF NOT EXIST "%appdata%\GZDoom\gzdoom_portable.ini" (
	GOTO :prompt_config
) ELSE (
	GOTO :prompt_new_config
)

::prompts user to select config
:prompt_config
	ECHO [36m[PROMPT] Which config would you like to apply?[0m
	ECHO [34m[OPTION] StormFifty333's config: 1[0m
	ECHO [34m[OPTION] Default config: 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		::downloads and applies my config
		ECHO [33m[INFO] Attempting StormFifty333's Config download from https://raw.githubusercontent.com/StormFifty333/CliGZDoomRunner/refs/heads/main/gzdoom_portable.ini ...[0m
		curl -L -o "%appdata%\GZDoom\gzdoom_portable.ini" https://raw.githubusercontent.com/StormFifty333/CliGZDoomRunner/refs/heads/main/stormfifty333config.ini
		ECHO [33m[INFO] Config download complete^^![0m
		
		GOTO :pass_config_prompts
	) ELSE (
		IF %input%==2 (
			::downloads and applies the default config
			ECHO [33m[INFO] Attempting Default Config download from https://raw.githubusercontent.com/StormFifty333/CliGZDoomRunner/refs/heads/main/defaultconfig.ini ...[0m
			curl -L -o "%appdata%\GZDoom\gzdoom_portable.ini" https://raw.githubusercontent.com/StormFifty333/CliGZDoomRunner/refs/heads/main/defaultconfig.ini
			ECHO [33m[INFO] Config download complete^^![0m
			
			GOTO pass_config_prompts
		) ELSE (
			ECHO [31m[ERROR] Invalid Input^^![0m
			GOTO prompt_config
		)
	)


::prompts user to use previous or new config
:prompt_new_config
	ECHO [36m[PROMPT] Previous config found^^! Replace?[0m
	ECHO [34m[OPTION] Keep config: 1[0m
	ECHO [34m[OPTION] Replace config: 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		::keeps config
		GOTO pass_config_prompts
	) ELSE (
		IF %input%==2 (
			::moves to promt_config
			GOTO prompt_config
		) ELSE (
			ECHO [31m[ERROR] Invalid Input^^![0m
			GOTO prompt_new_config
		)
	)

:pass_config_prompts


::this chunk of code is taken from John Gibbons on Server Fault Stack Exchange
::https://serverfault.com/questions/132685/batch-scripting-iterate-over-drive-letters
::finds connected drives and outputs drive letters
FOR /F "tokens=* USEBACKQ" %%F IN (`fsutil fsinfo drives`) DO (
	SET ogdrives=%%F
)
SET drives=!ogdrives!

SET drives=!drives:Drives^: =!
SET drives=!drives:^:\=1!
SET drives=!drives: =+!

SET charms=0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
FOR /L %%N IN (10 1 62) DO (
	FOR /F %%C IN ("!charms:~%%N,1!") DO (
		SET drives=!drives:%%C=!
	)
)

SET drives=!drives:~0,-1!
SET /a num=!drives!

SET drives=!ogdrives!

SET drives=!drives:Drives^: =!
SET drives=!drives:^:\=!
SET drives=!drives: =!


:loop

	SET /a iter=!iter!+1

	SET /a pos=!iter!-1

	SET drive!iter!=!drives:~%pos%,1!

	IF !iter!==!num! GOTO oloop
	GOTO loop

:oloop

FOR /L %%n IN (1 1 !num!) DO (
	ECHO drive %%n is !drive%%n!
)


ENDLOCAL
PAUSE