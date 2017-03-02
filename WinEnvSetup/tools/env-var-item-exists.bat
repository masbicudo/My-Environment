@echo off
CALL is-defined %1 && GOTO :IS_DEFINED
GOTO :eof
:IS_DEFINED
:: The use of CALL one time, will leave items with
:: variable references unexpanded. This means that
:: even if two pathes are the same when variable gets
:: expanded, it won't be seen as being equal to the
:: value being searched for. This is usefull when
:: dealing with global definitions, since each user
:: can define the variables to different values,
:: so that we cannot know the value for sure.
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
