@echo off

SET PATH=%PATH%;%cd%\tools

for %%f in ("%cd%") do SET __CURDIR83=%%~sf

CALL append-user-env-var   PATH "%__CURDIR83%\tools"
CALL set-system-env-var    MyEnv "%__CURDIR83%" /M

CALL set-desktop-dir
CALL append-system-env-var PATHEXT ".LNK"
CALL append-user-env-var   PATH "%DESKTOPDIR%"
CALL append-user-env-var   PATH "%DESKTOPDIR%\Shortcuts"
CALL append-user-env-var   SHORTCUTS "%DESKTOPDIR%\Shortcuts"

IF EXIST "C:\Projetos\" CALL append-user-env-var   PROJECTS "C:\Projetos"
IF EXIST "C:\Projects\" CALL append-user-env-var   PROJECTS "C:\Projects"
CALL append-user-env-var   PATH "%PROJECTS%\CMD-scripts"

IF EXIST "C:\Programas\" CALL append-user-env-var  PROGRAMS "C:\Programas"
IF EXIST "C:\Programs\" CALL append-user-env-var   PROGRAMS "C:\Programs"
CALL append-user-env-var   PATH "%PROGRAMS%\JavaApps"
CALL append-user-env-var   CLASSPATH "."
CALL append-user-env-var   CLASSPATH "%PROGRAMS%\JavaApps\antlr4-complete.jar"

CALL append-user-env-var   PATH "%PROGRAMS%\GnuWin32\bin"
CALL append-user-env-var   PATH "%PROGRAMS%\UnxUtils\usr\local\wbin"
CALL append-user-env-var   PATH "%PROGRAMS%\UnxUtils\bin"

SET __CURDIR83=