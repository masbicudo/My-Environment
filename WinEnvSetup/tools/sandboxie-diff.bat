@echo off
:Main
    SET __ARG0=%1
    SET __MODE=0
    IF "%1"=="" GOTO :START
    IF "%1"=="/Q" SET __MODE=Q
    IF "%1"=="/q" SET __MODE=Q
    IF "%__ARG0:~0,1%"==":" ( SHIFT & GOTO %1 )
    :START

    IF NOT EXIST %SystemDrive%\Sandbox GOTO :NOSB

    CALL env-var-insert-item PATH %~sdp0

    SET __CD=%CD%
    %SystemDrive%
    CD %SystemDrive%\Sandbox

    IF "%__MODE%"=="Q" GOTO :QUIET1
    ECHO.  Alternatives:
    FOR /F %%F IN ('DIR /AD /B') DO ECHO.    %%F
    ECHO.  Choose:
    SET /P __SB_USERNAME=
    :QUIET1
    CALL is-defined __SB_USERNAME || SET __SB_USERNAME=%USERNAME: =_%
    ECHO.  Selected: %__SB_USERNAME%
    CD %__SB_USERNAME%

    ECHO.
    IF "%__MODE%"=="Q" GOTO :QUIET2
    ECHO.  Alternatives:
    FOR /F %%F IN ('DIR /AD /B') DO ECHO.    %%F
    ECHO.  Choose:
    SET /P __SB_BOXNAME=
    :QUIET2
    CALL is-defined __SB_BOXNAME || SET __SB_BOXNAME=DefaultBox
    ECHO.  Selected: %__SB_BOXNAME%

    REM The only way of clearing the Sandbox is using RMDIR
    REM I tried to list the files and dirs, and delete one at a time
    REM but it did't work. Sandboxie seems to have hooked this folder
    REM so that when you access it, everything is denied access
    REM except the RMDIR command.
    ECHO.
    IF EXIST "%__SB_BOXNAME%" CALL :SB_CLEAR %__MODE%

    IF NOT EXIST "%__SB_BOXNAME%" MD %__SB_BOXNAME%

    IF "%__MODE%"=="Q" GOTO :QUIET3
    ECHO.
    ECHO.  Waiting for something to be done in the sandbox.
    ECHO.  Press any key when you want to proceed.
    PAUSE
    :QUIET3

    :: LISTING ALL FILES AND HASHES
    ECHO.
    ECHO.  Listing all files and hashing

    ::CD %__SB_BOXNAME%
    ::FOR /R %%F IN (*) DO (
    ::   ECHO.  %%~dpnxF
    ::)
    ::CD ..

    SET __SB_FILES=%__CD%\sandbox-files.txt
    DEL "%__SB_FILES%" >nul 2>nul
    FCIV -add "%SystemDrive%\Sandbox\%__SB_USERNAME%\%__SB_BOXNAME%" -r ^
        | text-replace /s /r /ci "%SystemDrive%\\sandbox\\%__SB_USERNAME%\\%__SB_BOXNAME%\\drive\\([a-z])" "#MARKER#$1:" ^
        | FINDSTR #MARKER# ^
        | text-replace /s /ci "#MARKER#" "" ^
        | CALL %0 :REPLACE ALLUSERSPROFILE         ^
        | CALL %0 :REPLACE APPDATA                 ^
        | CALL %0 :REPLACE CommonProgramFiles      ^
        | CALL %0 :REPLACE CommonProgramFiles(x86) ^
        | CALL %0 :REPLACE LOCALAPPDATA            ^
        | CALL %0 :REPLACE ProgramData             ^
        | CALL %0 :REPLACE ProgramFiles            ^
        | CALL %0 :REPLACE ProgramFiles(x86)       ^
        | CALL %0 :REPLACE PSModulePath            ^
        | CALL %0 :REPLACE PUBLIC                  ^
        | CALL %0 :REPLACE TEMP                    ^
        | CALL %0 :REPLACE USERPROFILE             ^
        | CALL %0 :REPLACE VS110COMNTOOLS          ^
        | CALL %0 :REPLACE VS120COMNTOOLS          ^
        | CALL %0 :REPLACE VS140COMNTOOLS          ^
        | CALL %0 :REPLACE windir                  ^
        > "%__SB_FILES%"
    :: For some reason, calling the following results in a corrupted file
    ::    | CALL %0 :REPLACE SystemRoot              ^

    ECHO.
    ECHO.  Extracting registry
    :: https://www.random.org/strings/?num=10&len=20&digits=on&upperalpha=on&loweralpha=on&unique=on&format=html&rnd=new
    SET __SB_FILES=%__CD%\sandbox-registry.reg

    DEL "%__SB_FILES%" >nul 2>nul
    REG LOAD HKU\CqWcSPWzhAMdV7KTg2HS "%SystemDrive%\Sandbox\%__SB_USERNAME%\%__SB_BOXNAME%\RegHive" >nul 2>nul
    REG EXPORT HKU\CqWcSPWzhAMdV7KTg2HS "%__SB_FILES%" >nul 2>nul
    REG UNLOAD HKU\CqWcSPWzhAMdV7KTg2HS >nul 2>nul

    type "%__SB_FILES%" ^
        | text-replace /s /ci "[HKEY_USERS\CqWcSPWzhAMdV7KTg2HS]" "" ^
        | text-replace /s /ci "HKEY_USERS\CqWcSPWzhAMdV7KTg2HS\machine" "HKEY_LOCAL_MACHINE" ^
        | text-replace /s /ci "[HKEY_LOCAL_MACHINE]" "" ^
        | text-replace /s /ci "HKEY_USERS\CqWcSPWzhAMdV7KTg2HS\user\current_classes" "HKEY_CLASSES_ROOT" ^
        | text-replace /s /ci "[HKEY_CLASSES_ROOT]" "" ^
        | text-replace /s /ci "HKEY_USERS\CqWcSPWzhAMdV7KTg2HS\user\current" "HKEY_CURRENT_USER" ^
        | text-replace /s /ci "[HKEY_CURRENT_USER]" "" ^
        | text-replace /s /ci /r "(?:\r?\n)+" "\r\n" ^
        | text-replace /s /ci /r "(\[[^\]]+)\](?=(?:\r?\n)\[)" "" ^
        | text-replace /s /ci /r "(?:\r?\n)+" "\r\n" ^
        > "%__SB_FILES%"

    ECHO.
    ECHO.  DONE!

    :CLEANUP
    ::FOR %%F IN ("%__CD%") DO %%~sdF
    CD %__CD%
    SET __SB_FILES=
    SET __SB_BOXNAME=
    SET __SB_USERNAME=
    SET __CD=
    SET __ARG0=
    SET __MODE=

    GOTO :eof

    :NOSB
    ECHO.  Sandboxie not installed
GOTO :CLEANUP

:SB_CLEAR
    IF "%__MODE%"=="Q" GOTO :DONT_CLEAR
    ECHO.  Clear the sandbox? (Y/N)
    SET /P __CLEAR_SB=
    IF "%__CLEAR_SB%"=="Y" GOTO :DO_CLEAR
    IF "%__CLEAR_SB%"=="y" GOTO :DO_CLEAR
    IF "%__CLEAR_SB%"=="N" GOTO :DONT_CLEAR
    IF "%__CLEAR_SB%"=="n" GOTO :DONT_CLEAR
    GOTO :SB_CLEAR
    :DO_CLEAR
    ECHO.  Selected: Y - Clearing the sandbox.
    RMDIR /S /Q %__SB_BOXNAME%
    GOTO :eof
    :DONT_CLEAR
    ECHO.  Selected: N - Keep sandbox as is.
GOTO :eof

:REPLACE
::ECHO.%0
::ECHO.%1
::ECHO.%2
    CALL is-defined %1 || GOTO :eof
    IF "%1"=="" GOTO :eof
    CALL SET "__TEMPxe7dOu5jnlQmMON7obWf=%%%1%%"
    SET %1=
::CALL ECHO.CALL text-replace /s /ci "%__TEMPxe7dOu5jnlQmMON7obWf%" "%%%%%%1%%%%"
    CALL text-replace /s /ci "%__TEMPxe7dOu5jnlQmMON7obWf%" "%%%%%%1%%%%"
    CALL SET %1=%__TEMPxe7dOu5jnlQmMON7obWf%
    SET __TEMPxe7dOu5jnlQmMON7obWf=
GOTO :eof
