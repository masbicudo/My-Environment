@echo off
CLS
CHCP 437
GOTO :ELEVATE

SET __ARG0=%1
IF "%1"=="" GOTO :ALL
IF "%__ARG0:~0,1%"==":" ( SHIFT & GOTO %1 ) >nul 2>nul

:MAIN

    set __REST_VAR=%1
    SHIFT
    :loop1
        if "%1"=="" goto after_loop
        set __REST_VAR=%__REST_VAR% %1
        shift
        goto loop1

    :after_loop
        %__REST_VAR%

GOTO :eof

:ELEVATE
    ECHO == Running Admin shell ==
    ECHO.

    :checkPrivileges
    NET FILE 1>NUL 2>NUL
    if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

    :getPrivileges
    if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
    ECHO Invoking UAC for Privilege Escalation

    setlocal DisableDelayedExpansion
    set "batchPath=%~s0"
    setlocal EnableDelayedExpansion
    ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
    ECHO args = "ELEV " >> "%temp%\OEgetPrivileges.vbs"
    ECHO For Each strArg in WScript.Arguments >> "%temp%\OEgetPrivileges.vbs"
    ECHO If InStr(strArg, " ") Then strArg = """" ^& strArg ^& """"  >> "%temp%\OEgetPrivileges.vbs"
    ECHO args = args ^& strArg ^& " "  >> "%temp%\OEgetPrivileges.vbs"
    ECHO Next >> "%temp%\OEgetPrivileges.vbs"
    ECHO UAC.ShellExecute "cmd", "/k """"!batchPath!"" " ^& args ^& """", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
    SET __EXEC_NAME_ELEV=%~s0
    SHIFT
    ECHO "%SystemRoot%\System32\WScript.exe" "%temp%\OEgetPrivileges.vbs" __EXEC_NAME_ELEV "%cd%" %*
    "%SystemRoot%\System32\WScript.exe" "%temp%\OEgetPrivileges.vbs" __EXEC_NAME_ELEV "%cd%" %*
    GOTO :eof

    :gotPrivileges
    if '%1'=='ELEV' shift /1
    CD /D %2
    SHIFT
    SHIFT
    setlocal & pushd .
    ::cd /d %~dp0

    GOTO :MAIN

