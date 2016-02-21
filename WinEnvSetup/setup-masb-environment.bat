@echo off

SET PATH=%PATH%;%cd%\tools

for %%f in ("%cd%") do SET __CURDIR83=%%~sf

CALL set-desktop-dir
CALL append-system-env-var PATHEXT ".LNK"
CALL append-user-env-var   PATH "%DESKTOPDIR%"
CALL append-user-env-var   PATH "%__CURDIR83%\tools"
CALL append-user-env-var   PATH "%DESKTOPDIR%\Shortcuts"
CALL append-user-env-var   SHORTCUTS "%DESKTOPDIR%\Shortcuts"

SET __CURDIR83=