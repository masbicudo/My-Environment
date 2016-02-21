@echo off
FOR /F "tokens=*" %%F IN ('dir "%~dp0..\modules\shortcut-v1*" /B') DO (
    cscript.exe //nologo "%~dp0..\modules\%%F\shct.vbs" %*
    GOTO :eof
)
ECHO VBScript file was not found.