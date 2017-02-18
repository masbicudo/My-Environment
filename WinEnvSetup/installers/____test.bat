@ECHO off
IF "%1"=="" GOTO :ALL
echo %1 | findstr /b : >nul 2>nul && ( SHIFT & GOTO %1 ) >nul 2>nul

:ALL
    CALL :A %*
    CALL :B %*
    CALL :C %*
GOTO :eof
:A
    ECHO.TEST A
    :FORCE-A
    ECHO.DO A
GOTO :eof
:B
    ECHO.TEST B
    :FORCE-B
    ECHO.DO B
GOTO :eof
:C
    ECHO.TEST C
    :FORCE-C
    ECHO.DO C
GOTO :eof
:FORCE-ALL
:FORCE
    CALL :FORCE-A %*
    CALL :FORCE-B %*
    CALL :FORCE-C %*
GOTO :eof
:REMOVE
    CALL :REMOVE-A %*
    CALL :REMOVE-B %*
    CALL :REMOVE-C %*
GOTO :eof
:REMOVE-A
    ECHO.REMOVE A
GOTO :eof
:REMOVE-B
    ECHO.REMOVE B
GOTO :eof
:REMOVE-C
    ECHO.REMOVE C
GOTO :eof
