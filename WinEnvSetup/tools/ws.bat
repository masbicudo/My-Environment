@echo off

SET __7241346659_ARG0=[%1]
SET __7241346659_ARG0F=%~1
SET __7241346659_FULL=%~f1
SET __7241346659_EXT0=%~x1
IF "%__7241346659_ARG0: =_%"=="[]" GOTO :END

FOR /F %%a IN ('POWERSHELL -COMMAND ^"^$^([guid]::NewGuid^(^).ToString^(^)^)^"') DO ( SET __7241346659_NEWGUID=%%a)
SET __7241346659_TEMP_FILE="%TEMP%\temp_%__7241346659_NEWGUID%.wsf"
ECHO ^<job id="foo"^> > %__7241346659_TEMP_FILE%
ECHO ^<script language="VBScript"^> >> %__7241346659_TEMP_FILE%
ECHO AppPath = "%__7241346659_FULL%" >> %__7241346659_TEMP_FILE%
ECHO ModulesPath = "%MyEnv%\modules" >> %__7241346659_TEMP_FILE%
ECHO ^</script^> >> %__7241346659_TEMP_FILE%
ECHO ^<script language="JavaScript" src="%MyEnv%\modules\RunTime-v1.0.0.js"/^> >> %__7241346659_TEMP_FILE%
ECHO ^<script language="VBScript" src="%MyEnv%\modules\RunTime-v3.0.0.vbs"/^> >> %__7241346659_TEMP_FILE%
IF /I "%__7241346659_EXT0%"==".VBS" ECHO ^<script language="VBScript" src="%__7241346659_FULL%"/^> >> %__7241346659_TEMP_FILE%
IF /I "%__7241346659_EXT0%"==".JS" ECHO ^<script language="JavaScript" src="%__7241346659_FULL%"/^> >> %__7241346659_TEMP_FILE%
ECHO ^</job^> >> %__7241346659_TEMP_FILE%

SHIFT
set __7241346659_ALL_BUT_FIRST=
:LOOP
SET __7241346659_ARG_N=[%1]
if "%__7241346659_ARG_N: =_%"=="[]" GOTO BREAK
set __7241346659_ALL_BUT_FIRST=%__7241346659_ALL_BUT_FIRST% %1
SHIFT
GOTO LOOP
:BREAK

REM ECHO "%SystemRoot%\System32\WScript.exe" %__7241346659_TEMP_FILE%%__7241346659_ALL_BUT_FIRST%
REM TYPE %__7241346659_TEMP_FILE%

"%SystemRoot%\System32\WScript.exe" %__7241346659_TEMP_FILE%%__7241346659_ALL_BUT_FIRST%

:END
DEL %__7241346659_TEMP_FILE%
SET __7241346659_TEMP_FILE=
SET __7241346659_NEWGUID=
SET __7241346659_ALL_BUT_FIRST=
SET __7241346659_FULL=
SET __7241346659_ARGN=
SET __7241346659_ARG0=
SET __7241346659_ARG0F=
SET __7241346659_EXT0=
