@echo off
rem Don't destroy an existing file
:next
:: ECHO.:next
:: ECHO.SET __TEMP="%~1"
SET __TEMP="%~1"
:: ECHO.if %__TEMP: =_%=="" goto :eof
if %__TEMP: =_%=="" goto :eof
:: ECHO.if exist "%~1" goto :updtime
if exist "%~1" goto :updtime
:: Create the zero-byte file
::ECHO.type nul^>"%~1"
type nul>"%~1"
:updtime
:: ECHO.:updtime
:: ECHO.copy /b "%~1" +,,
copy /b "%~1" +,,
:_nocreate
:: ECHO.:_nocreate
:: ECHO.shift
shift
:: ECHO.goto :next
goto :next
