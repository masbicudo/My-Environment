@echo off
CALL is-defined %1 && GOTO :IS_DEFINED
GOTO :eof
:IS_DEFINED
:: The use of CALL two times, expands the variables
:: referred to by the source variable. This makes
:: the search more realistic from the point of view
:: of the current user, but might have side effects,
:: since other users could have defined the variables
:: with other values. This is usefull when dealing
:: with current user definitions, instead of global.
CALL CALL SET __COPY=%%%1%%
CALL CALL SET __COPY_REM=%%%1%%
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
