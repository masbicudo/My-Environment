@echo off

SET PATH=%PATH%;%cd%\tools

for %%f in ("%cd%") do SET __CURDIR83=%%~sf

CALL append-user-env-var   PATH "%__CURDIR83%\tools" --if-exist
CALL set-system-env-var    MyEnv "%__CURDIR83%" /M

CALL set-desktop-dir
CALL append-system-env-var PATHEXT ".LNK"
CALL append-user-env-var   PATH "%DESKTOPDIR%" --if-exist
CALL append-user-env-var   PATH "%DESKTOPDIR%\Shortcuts" --if-exist
CALL append-user-env-var   SHORTCUTS "%DESKTOPDIR%\Shortcuts" --if-exist

CALL append-user-env-var   PROJECTS "C:\Projetos" --if-exist
CALL append-user-env-var   PROJECTS "C:\Projects" --if-exist
CALL append-user-env-var   PATH "%PROJECTS%\CMD-scripts"  --if-exist

CALL append-user-env-var   PROGRAMS "C:\Programas" --if-exist
CALL append-user-env-var   PROGRAMS "C:\Programs" --if-exist
CALL append-user-env-var   PATH "%PROGRAMS%" --if-exist
CALL append-user-env-var   PATH "%PROGRAMS%\JavaApps" --if-exist
CALL append-user-env-var   CLASSPATH "."
CALL append-user-env-var   CLASSPATH "%PROGRAMS%\JavaApps\antlr4-complete.jar" --if-exist

CALL append-user-env-var   PATH "%PROGRAMS%\GnuWin32\bin" --if-exist
CALL append-user-env-var   PATH "%PROGRAMS%\UnxUtils\usr\local\wbin" --if-exist
CALL append-user-env-var   PATH "%PROGRAMS%\UnxUtils\bin" --if-exist

SET __CURDIR83=