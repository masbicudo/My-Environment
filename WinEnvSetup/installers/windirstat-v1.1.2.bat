@echo off
:: https://windirstat.info/
SET EXE_NAME=%temp%\WindowsInit\windirstat1_1_2_setup.exe
SET URL=http://tenet.dl.sourceforge.net/project/windirstat/windirstat/1.1.2%20installer%20re-release%20%28more%20languages%21%29/windirstat1_1_2_setup.exe
IF EXIST %EXE_NAME% GOTO :INSTALL
:DOWNLOAD
call get "" "%temp%\WindowsInit\"
:INSTALL
echo Installing: Windows Directory Statistics
call %EXE_NAME% /silent
