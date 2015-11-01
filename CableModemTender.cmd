@ECHO OFF
@ECHO Cable Modem Tender v1.0 by: Jerry (Barnacules)
@ECHO.
@ECHO Come visit me @ Baracules Nerdgasm (http://youtube.com/barnacules1)
@ECHO.

SET _TARGET=%1
SET _SWITCH=%2
SET _SLEEP=10

:BEGIN
IF /I ^"%_TARGET%^"==^"^" (
   @ECHO Must Specify target Host Name or IP Address and switch name
   @ECHO.
   @ECHO Example:
   @ECHO   CableModemTender.cmd "Google.com" "WeMo Modem"
   @EXIT /B 1
)

IF /I ^"%_SWITCH%^"==^"^" (
   @ECHO You must specify a WeMo switch name
   @ECHO.
   @ECHO Example:
   @ECHO   CableModemTender.cmd "Google.com" "WeMo Modem"
   @EXIT /B 1
)

@ECHO [%date% %time%] Monitoring Cable Modem

:LOOP
CALL :PING %_TARGET%
IF "%ERRORLEVEL%" NEQ "0" (
 @ECHO [%date% %time%] Connection dropped, resetting cable modem
 CALL :RESET
) ELSE (
 @ECHO [%date% %time%] Connection working, sleeping 10 seconds
 TIMEOUT %_SLEEP% > NUL
)
GOTO LOOP

:PING %1
ECHO [%date% %time%] Pinging %_TARGET% to verify connection
PING -4 %1 > NUL
EXIT /B %errorlevel%

:RESET
@ECHO [%date% %time%] Sending 'off' command to %_SWITCH%
WeMo.exe /device %_SWITCH% /action off > NUL
IF "%ERRORLEVEL%" NEQ "0" (
  @ECHO {%date% %time%] Failed to send 'off' command to switch
  EXIT /B 1
)
@ECHO [%date% %time%] waiting 30 seconds before power on
TIMEOUT 30 > NUL
@ECHO [%date% %time%] Sending 'On command to %_SWITCH%
WeMo.exe /device %_SWITCH% /action on > NUL
IF "%ERRORLEVEL%" NEQ "0" (
  @echo [%date% %time%] Failed to send 'On' command to switch
  EXIT /B 1
)
@ECHO [%date% %time%] waiting 60 seconds for modem to acquire IP
timeout 60 > NUL
EXIT /B 0
