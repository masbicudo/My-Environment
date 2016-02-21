@echo off
CALL SET __TEMP=%%%1%%
IF "%__TEMP%"=="" (
    SET %1=%~2
    SET __TEMP=
    GOTO :eof
)
SET __TEMP=
CALL SET %1=%%%1%%;%~2
