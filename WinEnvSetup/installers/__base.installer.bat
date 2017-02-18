:: CREATING AN INSTALLER
:: An installer is capable of the following actions
:: - download: get the installation package from the internet, and then remove the file
:: - install: setup the package for execution in the computer, without user interaction
:: - uninstall: remove a previously installed package without user interaction
:: It can also support other actions like
:: - shortcuts: create shortcuts in a central location
:: - remove shortcuts: delete created shortcuts
:: - recreate shortcuts: 
:: - interactive install: collect user options during installation
:: - interactive uninstall: ask questions for the user when uninstalling, if needed
:: - reinstall:
:: - download and keep: download package and keep it in the packages folder
:: - redownload: 
@ECHO off
:: site of the app
SET TITLE=title of the app                  e.g. Xpto App Title
SET URL=url to download                     e.g. http://www.xpto.com/dl?507783
SET INST=installer file name                e.g. name.msi
SET INST_MD5=md5 of the installer           e.g. fedcba98765432100123456789abcdef
SET INST_ARGS=arguments of the installer    e.g. /silent ==or== /q
SET LINK_NAME=when creating a shortcut      e.g. %SHORTCUTS%\name
SET LINK_TARGET=when creating a shortcut    e.g. %ProgramFiles%\App Dir\Name.exe
SET UNINST=command to uninstall             e.g. %ProgramFiles%\App Dir\Uninstall.exe
SET UNINST_ARGS=command to uninstall        e.g. /silent ==or== /q

IF "%1"=="" GOTO :ALL
echo %1 | findstr /b : >nul 2>nul && ( SHIFT & GOTO %1 ) >nul 2>nul

:ALL
    CALL :DOWNLOAD %*
    CALL :INSTALL  %*
    CALL :SHORTCUTS %*
GOTO :eof
:DOWNLOAD
    IF NOT EXIST "%temp%\WindowsInit\%FILE%" GOTO :FORCE_DOWNLOAD
    CALL test-md5 "%temp%\WindowsInit\%FILE%" %INST_MD5% && GOTO :eof
    :FORCE_DOWNLOAD
    CALL get "%URL%" "%temp%\WindowsInit\"
GOTO :eof
:INSTALL
    ECHO Installing: %TITLE%
    :FORCE_INSTALL
    CALL "%temp%\WindowsInit\%INST%" %INST_ARGS%
GOTO :eof
:SHORTCUTS
    IF EXIST "%LINK_NAME%.lnk" GOTO :eof
    :FORCE_SHORTCUTS
    CALL shct /target:%LINK_TARGET% /link:"%LINK_NAME%.lnk" /desc:"%TITLE%"
GOTO :eof
:FORCE_ALL
    CALL :FORCE_DOWNLOAD %*
    CALL :FORCE_INSTALL  %*
    CALL :FORCE_SHORTCUTS %*
GOTO :eof
:REMOVE
    CALL :REMOVE_SHORTCUTS %*
    CALL :UNINSTALL  %*
    CALL :REMOVE_DOWNLOAD %*
GOTO :eof
:REMOVE_DOWNLOAD
    del "%temp%\WindowsInit\%INST%" >nul 2>nul
GOTO :eof
:UNINSTALL
    ECHO Uninstalling: %TITLE%
    IF NOT EXIST "%UNINST%" GOTO :eof
    CALL "%UNINST%" %INST_ARGS%
GOTO :eof
:REMOVE_SHORTCUTS
    del "%LINK_NAME%.lnk" >nul 2>nul
GOTO :eof
