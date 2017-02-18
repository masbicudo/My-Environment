@echo off
for /f "delims=" %%i in ( 'CALL get-system-env-var %1' ) do set __SYS_OUT=%%i
for /f "delims=" %%i in ( 'CALL get-user-env-var %1' ) do set __USR_OUT=%%i
ECHO.SYSTEM %1 = %__SYS_OUT%
ECHO.USER %1 = %__USR_OUT%
CALL ECHO.LOCAL %1 = %%%1%%
SET __SYS_OUT=
SET __USR_OUT=
