@echo off

CALL is-defined %1 && GOTO :IS_DEFINED
GOTO :eof

:IS_DEFINED
CALL SET __COPY=%%%1%%
CALL SET __COPY_REM=%%%1%%
CALL env-var-remove-item __COPY_REM %2
IF "%__COPY%"=="%__COPY_REM%" (
    SET __COPY=
    SET __COPY_REM=
    CALL set-error-level 1
    GOTO :eof
)
SET __COPY_REM=
SET __COPY=
CALL set-error-level 0
