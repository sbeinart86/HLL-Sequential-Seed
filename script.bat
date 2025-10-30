@echo off
for /f "delims=" %%x in (config.txt) do (set "%%x")
echo Checking to see if HLL is running...
set "APPLICATION=HLL-Win64-Shipping.exe"
echo Launching Seed...
echo.
echo Checking Player counts ..

for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLPATH% ^| %JQ_PATH% -r ".result.player_count_by_team.allied"`) do set alliedcountPATH=%%i
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLPATH% ^| %JQ_PATH% -r ".result.player_count_by_team.axis"`) do set axiscountPATH=%%i

IF NOT DEFINED axiscountPATH goto ServerDownPATH
IF DEFINED axiscountPATH goto ServerUpPATH
:ServerDownPATH
echo Server is Down. Skipping to next Server
goto ESPTSEED
:ServerUpPATH
echo.Allied Faction has %alliedcountPATH% players
echo.Axis Faction has %axiscountPATH% players
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLPATH% ^| %JQ_PATH% -r ".result.player_count"`) do set countPATH=%%i
echo.Player Count %countPATH%
If %countPATH% gtr %SEEDED_PATH% (
goto ESPTSEED
)

if %alliedcountPATH% leq %axiscountPATH% (
echo Launching as Allies. Time to Launch 4.5 Minutes.
SpawnSL.exe Allied %SERVER_NAMEPATH%
timeout /t 10 >nul
goto PATHloop
) else (
echo Launching as Axis. Time to Launch 4.5 Minutes.
SpawnSL.exe Axis %SERVER_NAMEPATH%
timeout /t 10 >nul

goto PATHloop
)



:PATHloop

for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLPATH% ^| %JQ_PATH% -r ".result.player_count"`) do set countPATH=%%i
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLPATH% ^| %JQ_PATH% -r ".result.time_remaining"`) do set timePATH=%%i
for /f "tokens=1,2 delims=." %%a  in ("%timePATH%") do (set timePATH=%%a)
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLPATH% ^| %JQ_PATH% -r ".result.player_count_by_team.allied"`) do set alliedcountPATH=%%i
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLPATH% ^| %JQ_PATH% -r ".result.player_count_by_team.axis"`) do set axiscountPATH=%%i

if %countPATH% gtr %SEEDED_PATH% (
    echo Player count is greater than %SEEDED_PATH%.
    goto endloop
) else (
    echo Player count is %countPATH%. Waiting 30 seconds...
	echo Timeleft: %timePATH%
	if %timePATH% geq 5280 (
	echo New Map.
		if %alliedcountPATH% leq %axiscountPATH% (
		echo Spawning
		ReSpawnSL.exe Allied
		) else (
		echo Spawning
		ReSpawnSL.exe Axis
		)
	timeout /t 120 >nul
	goto PATHloop
	) else (
    timeout /t 30 >nul
    goto PATHloop
)
)

:endloop
altf4.exe
echo Waiting for HLL to Close.
timeout /t 60 >nul
:ESPTSEED
echo Server is seeded. Onto ESPT
echo Launching Seed...
echo.
echo Checking Player counts ..

for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLESPT% ^| %JQ_PATH% -r ".result.player_count_by_team.allied"`) do set alliedcountESPT=%%i
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLESPT% ^| %JQ_PATH% -r ".result.player_count_by_team.axis"`) do set axiscountESPT=%%i

IF NOT DEFINED axiscountESPT goto ServerDownESPT
IF DEFINED axiscountESPT goto ServerUpESPT
:ServerDownESPT
echo Server is Down. Skipping to Outpost.
goto HOTSeed
:ServerUpESPT
echo.Allied Faction has %alliedcountESPT% players
echo.Axis Faction has %axiscountESPT% players
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLESPT% ^| %JQ_PATH% -r ".result.player_count"`) do set countESPT=%%i
echo.Player Count %countESPT%
If %countESPT% gtr %SEEDED_ESPT% (
goto PathHOT
)

if %alliedcountESPT% leq %axiscountESPT% (
echo Launching as Allies. Time to Launch 4.5 Minutes.
SpawnSL.exe Allied %SEVER_NAMEESPT%
timeout /t 10 >nul
goto ESPTloop
) else (
echo Launching as Axis. Time to Launch 4.5 Minutes.
SpawnSL.exe Axis %SEVER_NAMEESPT%
timeout /t 10 >nul

goto ESPTloop
)



:ESPTloop

for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLESPT% ^| %JQ_PATH% -r ".result.player_count"`) do set countESPT=%%i
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLESPT% ^| %JQ_PATH% -r ".result.time_remaining"`) do set timeESPT=%%i
for /f "tokens=1,2 delims=." %%a  in ("%timeESPT%") do (set timeESPT=%%a)
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLESPT% ^| %JQ_PATH% -r ".result.player_count_by_team.allied"`) do set alliedcountESPT=%%i
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLESPT% ^| %JQ_PATH% -r ".result.player_count_by_team.axis"`) do set axiscountESPT=%%i

if %countESPT% gtr %SEEDED_ESPT% (
    echo Player count is greater than %SEEDED_ESPT%.
    goto endloop
) else (
    echo Player count is %countESPT%. Waiting 30 seconds...
	echo Timeleft: %timeESPT%
	if %timeESPT% geq 5280 (
	echo New Map.
		if %alliedcountESPT% leq %axiscountESPT% (
		echo Spawning
		ReSpawnSL.exe Allied
		) else (
		echo Spawning
		ReSpawnSL.exe Axis
		)
	timeout /t 120 >nul
	goto ESPTloop
	) else (
    timeout /t 30 >nul
    goto ESPTloop
)
)

:endloop

altf4.exe
echo Waiting for HLL to Close.
timeout /t 60 >nul
:HOTSEED
echo Server is seeded. Onto Outpost
echo Launching Seed...
echo.
echo Checking Player counts ..

for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLHOT% ^| %JQ_PATH% -r ".result.player_count_by_team.allied"`) do set alliedcountHOT=%%i
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLHOT% ^| %JQ_PATH% -r ".result.player_count_by_team.axis"`) do set axiscountHOT=%%i

IF NOT DEFINED axiscountHOT goto ServerDownHOT
IF DEFINED axiscountHOT goto ServerUpHOT
:ServerDownHOT
echo Server is Down. Skipping to end.
goto endloop
:ServerUpHOT
echo.Allied Faction has %alliedcountHOT% players
echo.Axis Faction has %axiscountHOT% players
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLHOT% ^| %JQ_PATH% -r ".result.player_count"`) do set countHOT=%%i
echo.Player Count %countHOT%
If %countHOT% gtr %SEEDED_HOT% (
goto endloop
)

If %alliedcountHOT% leq %axiscountHOT% (
echo Launching as Allies. Time to Launch 4.5 Minutes.
SpawnSL.exe Allied %SERVER_NAMEHOT%
timeout /t 10 >nul
goto HOTloop
) else (
echo Launching as Axis. Time to Launch 4.5 Minutes.
SpawnSL.exe Axis %SERVER_NAMEHOT%
timeout /t 10 >nul

goto HOTloop
)



:HOTloop

for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLHOT% ^| %JQ_PATH% -r ".result.player_count"`) do set countHOT=%%i
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLHOT% ^| %JQ_PATH% -r ".result.time_remaining"`) do set timeHOT=%%i
for /f "tokens=1,2 delims=." %%a  in ("%timeHOT%") do (set timeHOT=%%a)
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLHOT% ^| %JQ_PATH% -r ".result.player_count_by_team.allied"`) do set alliedcountHOT=%%i
for /f "usebackq delims=," %%i in (`curl -s -X GET %RCON_URLHOT% ^| %JQ_PATH% -r ".result.player_count_by_team.axis"`) do set axiscountHOT=%%i

if %countHOT% gtr %SEEDED_HOT% (
    echo Player count is greater than %SEEDED_HOT%.
    goto endloop
) else (
    echo Player count is %countHOT%. Waiting 30 seconds...
	echo Timeleft: %timeHOT%
	if %timeHOT% geq 5280 (
	echo New Map.
		if %alliedcountHOT% leq %axiscountHOT% (
		echo Spawning
		ReSpawnSL.exe Allied
		) else (
		echo Spawning
		ReSpawnSL.exe Axis
		)
	timeout /t 120 >nul
	goto PATHloop
	) else (
    timeout /t 30 >nul
    goto PATHloop
)
)

:endloop

altf4.exe
echo Waiting for HLL to Close.
timeout /t 60 >nul
echo Putting the PC to sleep...
REM powercfg -h off
REM rundll32.exe powrprof.dll,SetSuspendState 0,1,0
REM powercfg -h on

REM echo PC is now asleep.