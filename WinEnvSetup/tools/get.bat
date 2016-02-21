@echo off
FOR /F "tokens=*" %%F IN ('dir "%~dp0..\modules\get-v1*" /B') DO (
    cscript.exe //nologo "%~dp0..\modules\%%F\get.vbs" %*
    GOTO :eof
)
ECHO VBScript file was not found.