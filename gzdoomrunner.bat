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
		IF EXIST "%appdata%\GZDoom\gzdoom_portable.ini" (
			ECHO [33m[INFO] Config download complete^^![0m
		) ELSE (
			ECHO [31m[ERROR] Config not found^^! Download possibly failed or file lost...[0m
			goto prompt_config
		)
		
		GOTO :pass_config_prompts
	) ELSE (
		IF %input%==2 (
			::downloads and applies the default config
			ECHO [33m[INFO] Attempting Default Config download from https://raw.githubusercontent.com/StormFifty333/CliGZDoomRunner/refs/heads/main/defaultconfig.ini ...[0m
			curl -L -o "%appdata%\GZDoom\gzdoom_portable.ini" https://raw.githubusercontent.com/StormFifty333/CliGZDoomRunner/refs/heads/main/defaultconfig.ini
			IF EXIST "%appdata%\GZDoom\gzdoom_portable.ini" (
				ECHO [33m[INFO] Config download complete^^![0m
			) ELSE (
				ECHO [31m[ERROR] Config not found^^! Download possibly failed or file lost...[0m
				GOTO prompt_config
			)
			
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
::finds connected drives and locates steam doom directory
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

::this part is modified to exit once directory is found
FOR /L %%n IN (1 1 !num!) DO (
	IF EXIST "!drive%%n!:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\base\DOOM.WAD" (
		IF EXIST "!drive%%n!:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\base\doom2\DOOM2.WAD" (
			SET directory="!drive%%n!:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\base"
			GOTO directory_found
		) ELSE (
			IF EXIST "!drive%%n!:\SteamLibrary\steamapps\common\Ultimate Doom\base\DOOM.WAD" (
				IF EXIST "!drive%%n!:\SteamLibrary\steamapps\common\Ultimate Doom\base\doom2\DOOM2.WAD" (
					SET directory="!drive%%n!:\SteamLibrary\steamapps\common\Ultimate Doom\base"
					GOTO directory_found
				)
			)
		)
	) ELSE (
		IF EXIST "!drive%%n!:\SteamLibrary\steamapps\common\Ultimate Doom\base\DOOM.WAD" (
			IF EXIST "!drive%%n!:\SteamLibrary\steamapps\common\Ultimate Doom\base\doom2\DOOM2.WAD" (
				SET directory="!drive%%n!:\SteamLibrary\steamapps\common\Ultimate Doom\base"
				GOTO directory_found
			)
		)
	)
)

::this means the directory wasn't located
GOTO directory_not_found



:directory_found
	
	IF NOT EXIST "%appdata%\GZDoom\DOOM.WAD" (
		ECHO [33m[INFO] Located Steam DOOM + DOOM II directory at %directory%[0m
	) ELSE (
		IF NOT EXIST "%appdata%\GZDoom\DOOM2.WAD" (
			ECHO [33m[INFO] Located Steam DOOM + DOOM II directory at %directory%[0m
		) ELSE (
			ECHO [33m[INFO] DOOM.WAD and DOOM2.WAD found in %appdata%\GZDoom[0m
		)
	)
	
	IF NOT EXIST "%appdata%\GZDoom\DOOM.WAD" (
		xcopy %directory%\DOOM.WAD %appdata%\GZDoom
	)
	
	IF NOT EXIST "%appdata%\GZDoom\DOOM2.WAD" (
		xcopy %directory%\doom2\DOOM2.WAD %appdata%\GZDoom
	)
	
	GOTO download_shareware

:directory_not_found

	IF NOT EXIST "%appdata%\GZDoom\DOOM.WAD" (
		IF NOT EXIST "%appdata%\GZDoom\DOOM2.WAD" (
			ECHO [33m[INFO] Steam DOOM + DOOM II installation not found^^! You can manually install DOOM.WAD and DOOM2.WAD into %appdata%\GZDoom[0m
		)
	)

	GOTO download_shareware

::prompts user to download shareware wad
:download_shareware
	ECHO [36m[PROMPT] Would you like to download DOOM Shareware version (FREE)?[0m
	ECHO [34m[OPTION] Yes: 1[0m
	ECHO [34m[OPTION] No: 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		::download shareware here
		ECHO download
	) ELSE (
		IF %input%==2 (
			::continue on
			ECHO continue
		) ELSE (
			ECHO [31m[ERROR] Invalid Input^^![0m
			GOTO download_shareware
		)
	)

ENDLOCAL
PAUSE