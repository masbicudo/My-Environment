@echo off
CLS
CHCP 437
GOTO :ELEVATE

SET __ARG0=%1
IF "%1"=="" GOTO :ALL
IF "%__ARG0:~0,1%"==":" ( SHIFT & GOTO %1 ) >nul 2>nul

:MAIN

    SET PATH=%PATH%;%cd%\tools
    ::rd /s /q %temp%\WindowsInit
    
    ::call get basic-tools-dls.txt
    ::call unzip %temp%\WindowsInit\7za920.zip
    
    ::call get node-dls.txt
    ::call unzip %temp%\WindowsInit\npm-1.4.9.zip
    
    ::call %temp%\WindowsInit\npm install
    
    call installers\svg-explorer-extension-v0.1.1.bat %*
    call installers\windirstat-v1.1.2.bat %*
    
    ::call install-chocolatey.bat
    ::cinst scriptcs
    ::call setup-masb-environment.bat
    ::call setup-command-window.bat
    
    pause

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
    ECHO args = args ^& strArg ^& " "  >> "%temp%\OEgetPrivileges.vbs"
    ECHO Next >> "%temp%\OEgetPrivileges.vbs"
    ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
    SET __EXEC_NAME_ELEV=%~s0
    SHIFT
    "%SystemRoot%\System32\WScript.exe" "%temp%\OEgetPrivileges.vbs" __EXEC_NAME_ELEV %*
    GOTO :eof

    :gotPrivileges
    if '%1'=='ELEV' shift /1
    setlocal & pushd .
    cd /d %~dp0

    GOTO :MAIN

