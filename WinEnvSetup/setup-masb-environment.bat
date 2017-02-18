@echo off

SET PATH=%PATH%;%cd%\tools

for %%f in ("%cd%") do SET __CURDIR83=%%~sf

CALL set-desktop-dir
CALL append-system-env-var PATHEXT ".LNK"
CALL append-user-env-var   PATH "%DESKTOPDIR%"
CALL append-user-env-var   PATH "%__CURDIR83%\tools"
CALL set-system-env-var    MyEnv "%__CURDIR83%" /M
CALL append-user-env-var   PATH "%DESKTOPDIR%\Shortcuts"
CALL append-user-env-var   SHORTCUTS "%DESKTOPDIR%\Shortcuts"
CALL append-user-env-var   PROJECTS "C:\Projetos"
CALL append-user-env-var   PATH "%PROJECTS%\CMD-scripts"
CALL append-user-env-var   CLASSPATH "C:\Programas\JavaApps"

SET __CURDIR83=