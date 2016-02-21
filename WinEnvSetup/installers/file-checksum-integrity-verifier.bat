@echo off
REM https://support.microsoft.com/pt-br/kb/841290
SET URL=http://download.microsoft.com/download/c/f/4/cf454ae0-a4bb-4123-8333-a1b6737712f7/Windows-KB841290-x86-ENU.exe
SET FILE_NAME=%temp%\WindowsInit\Windows-KB841290-x86-ENU.exe
:DOWNLOAD
IF EXIST "%FILE_NAME%" GOTO :INSTALL
call get "%URL%" "%temp%\WindowsInit\"
:INSTALL
IF EXIST "C:\Programas\KB841290\fciv.exe" GOTO :SHORTCUT
echo Installing: File Checksum Integrity Verifier
REM call %FILE_NAME% /Q /T:"%TEMP%\WindowsInit\KB841290\"
call %FILE_NAME% /Q /T:"C:\Programas\KB841290\"
:SHORTCUT
IF EXIST "%SHORTCUTS%\fciv.lnk" GOTO :eof
call shct /target:C:\Programas\KB841290\fciv.exe /link:"%SHORTCUTS%\fciv.lnk" /desc:"File Checksum Integrity Verifier"
