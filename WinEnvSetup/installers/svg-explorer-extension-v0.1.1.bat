@echo off
:: https://svgextension.codeplex.com/
SET "URL=http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=svgextension&DownloadId=803086&FileTime=130374127018230000&Build=21031"
SET FILE=dssee_setup_x64_v011_signed.exe
SET ARGS=/silent

SET __ARG0=%1
IF "%1"=="" GOTO :ALL
IF "%__ARG0:~0,1%"==":" ( SHIFT & GOTO %1 ) >nul 2>nul
:ALL
    CALL :DOWNLOAD %*
    CALL :INSTALL  %*
GOTO :eof
:DOWNLOAD
    IF NOT EXIST "%temp%\WindowsInit\%FILE%" GOTO :FORCE_DOWNLOAD
    CALL test-md5 "%temp%\WindowsInit\%FILE%" cdc8a5df6ebe4b9bfb7e227bb8887b2d && GOTO :eof
    :FORCE_DOWNLOAD
    DEL /Q "%temp%\WindowsInit\%FILE%" >nul 2>nul
    CALL get "%URL%" "%temp%\WindowsInit\"
GOTO :eof
:INSTALL
    echo Installing: SVG Explorer Extension
    call %temp%\WindowsInit\%FILE% %ARGS%
GOTO :eof
