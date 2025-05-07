@ECHO OFF
TITLE CliGZDoomRunner - StormFifty333
SETLOCAL enabledelayedexpansion

IF EXIST "%appdata%\GZDoom" (
	MOVE "%appdata%\GZDoom" "%localappdata%"
)

for /f "usebackq delims=" %%i in (`powershell -c "(Get-Item "%localappdata%\GZDoom\gzdoom.exe").VersionInfo.ProductVersion"`) do set version=%%i

::checks if gzdoom folder already exists and creates one if not
IF NOT EXIST "%localappdata%\GZDoom" (
	MKDIR "%localappdata%\GZDoom"
	ECHO [33m[INFO] GZDoom folder created in %localappdata%[0m
	GOTO pass_uninstall
) ELSE (
	ECHO [33m[INFO] GZDoom folder already exists at %localappdata%[0m
	IF EXIST "%localappdata%\GZDoom\gzdoom.exe" (
		IF NOT "%version%"=="g4.14.2-m" (
			GOTO prompt_upgrade_or_uninstall
		) ELSE (
			GOTO prompt_uninstall_gzdoom
		)
	)
)

:prompt_upgrade_or_uninstall
	::assumes version is less and offers to upgrade installation
	ECHO [36m[PROMPT] Older GZDoom version detected! Would you like to upgrade or uninstall?[0m
	ECHO [34m[OPTION] Upgrade: 1[0m
	ECHO [34m[OPTION] Uninstall: 2[0m
	ECHO [34m[OPTION] Nothing: 3[0m

	SET /p "input=[32m[INPUT]: [0m"
	
	IF %input%==2 (
		GOTO prompt_uninstall_gzdoom
	) ELSE (
		IF %input%==1 (
			DEL "%localappdata%\GZDoom\gzdoom.exe"
			GOTO pass_uninstall 
		) ELSE (
			IF %input%==3 (
				GOTO pass_uninstall
			) ELSE (
				ECHO [31m[ERROR] Invalid Input^^![0m
				GOTO prompt_upgrade_or_uninstall
			)
		)
	)

:prompt_uninstall_gzdoom
	ECHO [36m[PROMPT] Would you like to remove Cli GZDoom Runner install? (removes game, wads, configs, and saves)[0m
	ECHO [34m[OPTION] No: 1[0m
	ECHO [34m[OPTION] Yes: 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		GOTO pass_uninstall
	) ELSE (
		IF %input%==2 (
			IF EXIST "%localappdata%\GZDoom" (
				RMDIR /S /Q "%localappdata%\GZDoom"
				ECHO [33m[INFO] GZDoom folder removed.[0m
				GOTO pass_all
			) ELSE (
				ECHO [33m[INFO] No GZDoom Runner Install found...[0m
				GOTO pass_all
			)
		) ELSE (
			ECHO [31m[ERROR] Invalid Input^^![0m
			GOTO prompt_uninstall_gzdoom
		)
	)

:pass_uninstall

::checks for existing gzdoom exe
IF NOT EXIST "%localappdata%\GZDoom\gzdoom.exe" (

	::downloads gzdoom from the internet
	IF NOT EXIST "%localappdata%\GZDoom\gzdoom-4-14-2-windows.zip" (
		ECHO [33m[INFO] Attempting GZDoom download from https://github.com/ZDoom/gzdoom/releases/download/g4.14.2/gzdoom-4-14-2-windows.zip...[0m
		curl -L -O https://github.com/ZDoom/gzdoom/releases/download/g4.14.2/gzdoom-4-14-2-windows.zip
		ECHO [33m[INFO] GZDoom download complete^^![0m
		MOVE gzdoom-4-14-2-windows.zip "%localappdata%\GZDoom"
	) ELSE (
		ECHO [33m[INFO] gzdoom-4-14-2-windows.zip already exists^^![0m
	)
	
	::extracts gzdoom zip
	IF EXIST "%localappdata%\GZDoom\gzdoom-4-14-2-windows.zip" (
		ECHO [33m[INFO] Beginning to extract gzdoom-4-14-2-windows.zip...[0m
		powershell -command "Expand-Archive -Path "%localappdata%\GZDoom\gzdoom-4-14-2-windows.zip" -DestinationPath "%localappdata%\GZDoom" -Force"
		ECHO [33m[INFO] Extraction complete^^![0m
	
		::removes zip
		ECHO [33m[INFO] Removing gzdoom-4-14-2-windows.zip...[0m
		DEL "%localappdata%\GZDoom\gzdoom-4-14-2-windows.zip"
	) ELSE (
		ECHO [31m[ERROR] Zip not found^^! Download possibly failed or file lost...[0m
	)
	
) ELSE (
	ECHO [33m[INFO] Existing install found^^! No corruption free guarantee^^![0m
)


IF NOT EXIST "%localappdata%\GZDoom\gzdoom_portable.ini" (
	GOTO prompt_config
) ELSE (
	GOTO prompt_new_config
)

::prompts user to select config
:prompt_config
	ECHO [36m[PROMPT] Which config would you like to apply?[0m
	ECHO [34m[OPTION] StormFifty333's config: 1[0m
	ECHO [34m[OPTION] Default config: 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		::downloads and applies my config
		ECHO [33m[INFO] Attempting StormFifty333's Config download from https://raw.githubusercontent.com/StormFifty333/CliGZDoomRunner/refs/heads/main/gzdoom_portable.ini...[0m
		curl -L -o "%localappdata%\GZDoom\gzdoom_portable.ini" https://raw.githubusercontent.com/StormFifty333/CliGZDoomRunner/refs/heads/main/stormfifty333config.ini
		IF EXIST "%localappdata%\GZDoom\gzdoom_portable.ini" (
			ECHO [33m[INFO] Config download complete^^![0m
		) ELSE (
			ECHO [31m[ERROR] Config not found^^! Download possibly failed or file lost...[0m
			goto prompt_config
		)
		
		GOTO :pass_config_prompts
	) ELSE (
		IF %input%==2 (
			::downloads and applies the default config
			ECHO [33m[INFO] Attempting Default Config download from https://raw.githubusercontent.com/StormFifty333/CliGZDoomRunner/refs/heads/main/defaultconfig.ini...[0m
			curl -L -o "%localappdata%\GZDoom\gzdoom_portable.ini" https://raw.githubusercontent.com/StormFifty333/CliGZDoomRunner/refs/heads/main/defaultconfig.ini
			IF EXIST "%localappdata%\GZDoom\gzdoom_portable.ini" (
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
	
	IF NOT EXIST "%localappdata%\GZDoom\DOOM.WAD" (
		ECHO [33m[INFO] Located Steam DOOM + DOOM II directory at %directory%[0m
	) ELSE (
		IF NOT EXIST "%localappdata%\GZDoom\DOOM2.WAD" (
			ECHO [33m[INFO] Located Steam DOOM + DOOM II directory at %directory%[0m
		) ELSE (
			ECHO [33m[INFO] DOOM.WAD and DOOM2.WAD found in %localappdata%\GZDoom[0m
		)
	)
	
	IF NOT EXIST "%localappdata%\GZDoom\DOOM.WAD" (
		ECHO [33m[INFO] Copying %directory%\DOOM.WAD to %localappdata%\GZDoom[0m
		xcopy %directory%\DOOM.WAD %localappdata%\GZDoom
	)
	
	IF NOT EXIST "%localappdata%\GZDoom\DOOM2.WAD" (
		ECHO [33m[INFO] Copying %directory%\doom2\DOOM2.WAD to %localappdata%\GZDoom[0m
		xcopy %directory%\doom2\DOOM2.WAD %localappdata%\GZDoom
	)
	
	IF NOT EXIST "%localappdata%\GZDoom\DOOM1.WAD" (
		GOTO download_shareware
	)
	ECHO [33m[INFO] DOOM1.WAD found in %localappdata%\GZDoom[0m
	GOTO pass_shareware_prompt

:directory_not_found

	IF NOT EXIST "%localappdata%\GZDoom\DOOM.WAD" (
		IF NOT EXIST "%localappdata%\GZDoom\DOOM2.WAD" (
			ECHO [33m[INFO] Steam DOOM + DOOM II installation not found^^! You can manually install DOOM.WAD and DOOM2.WAD into %localappdata%\GZDoom[0m
		) ELSE (
			ECHO [33m[INFO] DOOM2.WAD found in %localappdata%\GZDoom[0m
		)
	) ELSE (
		IF NOT EXIST "%localappdata%\GZDoom\DOOM2.WAD" (
			ECHO [33m[INFO] DOOM.WAD found in %localappdata%\GZDoom[0m
		) ELSE (
			ECHO [33m[INFO] DOOM.WAD and DOOM2.WAD found in %localappdata%\GZDoom[0m
		)
	)

	IF NOT EXIST "%localappdata%\GZDoom\DOOM1.WAD" (
		GOTO download_shareware
	)
	ECHO [33m[INFO] DOOM1.WAD found in %localappdata%\GZDoom[0m
	GOTO pass_shareware_prompt

::prompts user to download shareware wad
:download_shareware
	ECHO [36m[PROMPT] Would you like to download DOOM Shareware version (FREE)?[0m
	ECHO [34m[OPTION] Yes: 1[0m
	ECHO [34m[OPTION] No: 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		::downloads shareware wad
		ECHO [33m[INFO] Attempting DOOM Shareware download from https://distro.ibiblio.org/slitaz/sources/packages/d/doom1.wad...[0m
		curl -L -o "%localappdata%\GZDoom\DOOM1.WAD" https://distro.ibiblio.org/slitaz/sources/packages/d/doom1.wad
		IF EXIST "%localappdata%\GZDoom\DOOM1.WAD" (
			ECHO [33m[INFO] DOOM Shareware download complete^^![0m
		) ELSE (
			ECHO [31m[ERROR] DOOM Shareware not found^^! Download possibly failed or file lost...[0m
			GOTO download_shareware
		)
	) ELSE (
		IF %input%==2 (
			GOTO pass_shareware_prompt
		) ELSE (
			ECHO [31m[ERROR] Invalid Input^^![0m
			GOTO download_shareware
		)
	)

:pass_shareware_prompt


IF EXIST "%localappdata%\GZDoom\brutalv22test4.pk3" (
	ECHO [33m[INFO] brutalv22test4.pk3 found in %localappdata%\GZDoom[0m
	GOTO pass_brutaldoom_prompt
)

IF EXIST "%localappdata%\GZDoom\brutalv22test4.zip" (
	ECHO [33m[INFO] brutalv22test4.zip found in %localappdata%\GZDoom[0m
	GOTO extract_brutaldoom
)

IF EXIST "%userprofile%\Downloads\brutalv22test4.zip" (
	ECHO [33m[INFO] brutalv22test4.zip found in %userprofile%\Downloads[0m
	MOVE "%userprofile%\Downloads\brutalv22test4.zip" "%localappdata%\GZDoom"
	GOTO extract_brutaldoom
)

::prompts user to download brutal doom mod
:download_brutaldoom
	ECHO [36m[PROMPT] Would you like to download Brutal DOOM mod?[0m
	ECHO [34m[OPTION] Yes: 1[0m
	ECHO [34m[OPTION] No: 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		ECHO [33m[INFO] Attempting Brutal DOOM download from https://www.moddb.com/downloads/start/265147?referer=https%3A%2F%2Fwww.moddb.com%2Fmods%2Fbrutal-doom%2Fdownloads...[0m
		ECHO [33m[INFO] Please wait for download to complete^^![0m
		start https://www.moddb.com/downloads/start/265147?referer=https%3A%2F%2Fwww.moddb.com%2Fmods%2Fbrutal-doom%2Fdownloads
		ECHO [33m[INFO] Checking %userprofile%\Downloads and %localappdata%\GZDoom for brutalv22test4.zip[0m
		
		:loop22
			IF NOT EXIST "%userprofile%\Downloads\brutalv22test4.zip" (
				IF NOT EXIST "%localappdata%\GZDoom\brutalv22test4.zip" (
					GOTO loop22
				) ELSE (
					GOTO extract_brutaldoom
				)
			)
		
		:loop33
			IF EXIST "%userprofile%\Downloads\brutalv22test4.zip" (
				set fileee="%userprofile%\Downloads\brutalv22test4.zip"
				FOR /F "usebackq" %%A IN ('%fileee%') DO set size=%%~zA
			)
		
		IF "%size%"=="148502419" (
			MOVE "%userprofile%\Downloads\brutalv22test4.zip" "%localappdata%\GZDoom"
			DEL "%userprofile%\Downloads\brutalv22test4.zip"
		) ELSE (
			GOTO loop33
		)
		
		IF EXIST "%localappdata%\GZDoom\brutalv22test4.zip" (
			ECHO [33m[INFO] Brutal DOOM download complete^^![0m
			GOTO extract_brutaldoom
		)
	) ELSE (
		IF %input%==2 (
			GOTO pass_brutaldoom_prompt
		) ELSE (
			ECHO [31m[ERROR] Invalid Input^^![0m
			GOTO download_brutaldoom
		)
	)
	

:extract_brutaldoom
	::extracts gzdoom zip
	IF EXIST "%localappdata%\GZDoom\brutalv22test4.zip" (
		ECHO [33m[INFO] Beginning to extract brutalv22test4.zip...[0m
		powershell Expand-Archive -F "%localappdata%\GZDoom\brutalv22test4.zip" "%localappdata%\GZDoom"
		ECHO [33m[INFO] Extraction complete^^![0m
	
		::removes zip
		ECHO [33m[INFO] Removing brutalv22test4.zip...[0m
		DEL "%localappdata%\GZDoom\brutalv22test4.zip"
		IF EXIST "%userprofile%\Downloads\brutalv22test4.zip" (
			DEL "%userprofile%\Downloads\brutalv22test4.zip"
		)
		
		GOTO pass_brutaldoom_prompt
	) ELSE (
		ECHO [31m[ERROR] Zip not found^^! Download possibly failed or file lost...[0m
		GOTO download_brutaldoom
	)


:pass_brutaldoom_prompt


IF EXIST "%localappdata%\GZDoom\DOOM.WAD" (
	IF NOT EXIST "%localappdata%\GZDoom\DOOM2.WAD" (
		IF NOT EXIST "%localappdata%\GZDoom\DOOM1.WAD" (
			ECHO [33m[INFO] DOOM.WAD selected^^![0m
			SET selected_wad=DOOM.WAD
			GOTO pass_wad_select
		) ELSE (
			ECHO [33m[INFO] DOOM.WAD and DOOM1.WAD found^^![0m
			GOTO select_wad_two2
		)
	) ELSE (
		IF NOT EXIST "%localappdata%\GZDoom\DOOM1.WAD" (
			ECHO [33m[INFO] DOOM.WAD and DOOM2.WAD found^^![0m
			GOTO select_wad_two
		) ELSE (
			ECHO [33m[INFO] DOOM.WAD, DOOM2.WAD and DOOM1.WAD found^^![0m
			GOTO select_wad_all
		)
	)
) ELSE (
	IF NOT EXIST "%localappdata%\GZDoom\DOOM2.WAD" (
		IF EXIST "%localappdata%\GZDoom\DOOM1.WAD" (
			ECHO [33m[INFO] DOOM1.WAD selected^^![0m
			SET selected_wad=DOOM1.WAD
			GOTO pass_wad_select
		) ELSE (
			GOTO failed_wad
		)
	) ELSE (
		IF NOT EXIST "%localappdata%\GZDoom\DOOM1.WAD" (
			ECHO [33m[INFO] DOOM2.WAD selected^^![0m
			SET selected_wad=DOOM2.WAD
			GOTO pass_wad_select
		) ELSE (
			ECHO [33m[INFO] DOOM2.WAD and DOOM1.WAD found^^![0m
			GOTO select_wad_two3
		)
	)
)



::prompts user to select a wad out of all options
:select_wad_all
	ECHO [36m[PROMPT] Which game would you like to play? (if joining multiplayer: pick same as host)[0m
	ECHO [34m[OPTION] DOOM: 1[0m
	ECHO [34m[OPTION] DOOM 2: 2[0m
	ECHO [34m[OPTION] DOOM Shareware: 3[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		SET selected_wad=DOOM.WAD
		GOTO pass_wad_select
	) ELSE (
		IF %input%==2 (
			SET selected_wad=DOOM2.WAD
			GOTO pass_wad_select
		) ELSE (
			IF %input%==3 (
				SET selected_wad=DOOM1.WAD
				GOTO pass_wad_select
			) ELSE (
				ECHO [31m[ERROR] Invalid Input^^![0m
				GOTO select_wad_all
			)
		)
	)


::prompts user to select a wad out of DOOM.WAD and DOOM2.WAD options
:select_wad_two
	ECHO [36m[PROMPT] Which game would you like to play? (if joining multiplayer: pick same as host)[0m
	ECHO [34m[OPTION] DOOM: 1[0m
	ECHO [34m[OPTION] DOOM 2: 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		SET selected_wad=DOOM.WAD
		GOTO pass_wad_select
	) ELSE (
		IF %input%==2 (
			SET selected_wad=DOOM2.WAD
			GOTO pass_wad_select
		) ELSE (
			ECHO [31m[ERROR] Invalid Input^^![0m
			GOTO select_wad_two
		)
	)


::prompts user to select a wad out of DOOM.WAD and DOOM1.WAD options
:select_wad_two2
	ECHO [36m[PROMPT] Which game would you like to play? (if joining multiplayer: pick same as host)[0m
	ECHO [34m[OPTION] DOOM: 1[0m
	ECHO [34m[OPTION] DOOM Shareware: 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		SET selected_wad=DOOM.WAD
		GOTO pass_wad_select
	) ELSE (
		IF %input%==2 (
			SET selected_wad=DOOM1.WAD
			GOTO pass_wad_select
		) ELSE (
			ECHO [31m[ERROR] Invalid Input^^![0m
			GOTO select_wad_two2
		)
	)


::prompts user to select a wad out of DOOM2.WAD and DOOM1.WAD options
:select_wad_two3
	ECHO [36m[PROMPT] Which game would you like to play? (if joining multiplayer: pick same as host)[0m
	ECHO [34m[OPTION] DOOM 2: 1[0m
	ECHO [34m[OPTION] DOOM Shareware: 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		SET selected_wad=DOOM2.WAD
		GOTO pass_wad_select
	) ELSE (
		IF %input%==2 (
			SET selected_wad=DOOM1.WAD
			GOTO pass_wad_select
		) ELSE (
			ECHO [31m[ERROR] Invalid Input^^![0m
			GOTO select_wad_two3
		)
	)


::if failed to find wad
:failed_wad
	ECHO [31m[ERROR] No WAD Found^^! Please buy DOOM + DOOM 2 on Steam, manually drag DOOM.WAD and DOOM2.WAD into %localappdata%\GZDoom, or install DOOM Shareware[0m
	GOTO download_shareware


:pass_wad_select

IF %selected_wad%==DOOM1.WAD (
	SET mod_enabled=false
	ECHO [33m[INFO] Mods cannot be used with DOOM Shareware^^![0m
	GOTO pass_mod_select
)

IF NOT EXIST "%localappdata%\GZDoom\brutalv22test4.pk3" (
	SET mod_enabled=false
	ECHO [33m[INFO] Brutal DOOM not found^^![0m
	GOTO pass_mod_select
)


::prompts user to opt playing brutal doom
:select_mod
	ECHO [36m[PROMPT] Would you like to play Brutal DOOM? (if joining multiplayer: pick same as host)[0m
	ECHO [34m[OPTION] Yes: 1[0m
	ECHO [34m[OPTION] No: 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		SET mod_enabled=true
		SET selected_mod=brutalv22test4.pk3
		GOTO pass_mod_select
	) ELSE (
		IF %input%==2 (
			SET mod_enabled=false
			GOTO pass_mod_select
		) ELSE (
			ECHO [31m[ERROR] Invalid Input^^![0m
			GOTO select_mod
		)
	)

:pass_mod_select


IF %mod_enabled%==true (
	ECHO [33m[INFO] Selected %selected_wad% with %selected_mod%^^![0m
) ELSE (
	ECHO [33m[INFO] Selected %selected_wad%^^![0m
)

::prompts user to play singleplayer or multiplayer
:select_player
	ECHO [36m[PROMPT] Would you like to play Singleplayer or Multiplayer? (if joining multiplayer: you must type IP and PORT)[0m
	ECHO [34m[OPTION] Singleplayer: 1[0m
	ECHO [34m[OPTION] Multiplayer (connect only no host): 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		SET multiplayer=false
		ECHO [33m[INFO] Playing singleplayer^^![0m
		GOTO pass_player
	) ELSE (
		IF %input%==2 (
			SET multiplayer=true
			ECHO [33m[INFO] Playing multiplayer^^![0m
			GOTO enter_ip
		) ELSE (
			ECHO [31m[ERROR] Invalid Input^^![0m
			GOTO select_player
		)
	)

:enter_ip
	SET /p "ip=[32m[INPUT] Enter Host's IP and PORT (ex: 192.168.1.1:5029): [0m"

:pass_player


::final check when player is ready to join
:ready
	ECHO [36m[PROMPT] Ready to play? (if joining multiplayer: host must start game first)[0m
	ECHO [34m[OPTION] YES: 1[0m
	ECHO [34m[OPTION] Nah: 2[0m

	SET /p "input=[32m[INPUT]: [0m"

	IF %input%==1 (
		
		ECHO [33m[INFO] Lets GO^^![0m
		
		IF %multiplayer%==false (
			IF %mod_enabled%==false (
				"%localappdata%\GZDoom\gzdoom.exe" -iwad "%localappdata%\GZDoom\%selected_wad%"
			) ELSE (
				"%localappdata%\GZDoom\gzdoom.exe" -iwad "%localappdata%\GZDoom\%selected_wad%" -file "%localappdata%\GZDoom\%selected_mod%"
			)
		) ELSE (
			IF %mod_enabled%==false (
				"%localappdata%\GZDoom\gzdoom.exe" -iwad "%localappdata%\GZDoom\%selected_wad%" -join %ip%
			) ELSE (
				"%localappdata%\GZDoom\gzdoom.exe" -iwad "%localappdata%\GZDoom\%selected_wad%" -file "%localappdata%\GZDoom\%selected_mod%" -join %ip%
			)
		)
		
	) ELSE (
		IF %input%==2 (
			ECHO [33m[INFO] alright...[0m
			GOTO pass_all
		) ELSE (
			ECHO [31m[ERROR] Invalid Input^^![0m
			GOTO ready
		)
	)

:pass_all


ENDLOCAL
EXIT
