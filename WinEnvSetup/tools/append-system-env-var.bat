@echo off
:: getting registry environment variable value
    SET __REGISTRY_VAR=
    FOR /F "usebackq tokens=2,* skip=2" %%L IN (
        `reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v %1 2^>nul`
    ) DO SET __REGISTRY_VAR=%%M 2>nul
    CALL is-defined __REGISTRY_VAR || GOTO :UNDEF
        SET __REGISTRY_VAR=%__REGISTRY_VAR:~0,-1%
    :UNDEF

:: checking whether value already exists in the registry environment variable
    CALL env-var-item-exists __REGISTRY_VAR %2 || GOTO :NOT_FOUND
        ECHO.SYSTEM %1 already contains %~2
        GOTO :eof
    :NOT_FOUND

:: appending the desired value and saving
    ECHO.SYSTEM %1 += %~2
    CALL env-var-insert-item __REGISTRY_VAR %2
    REM IF __REGISTRY_VAR ENDS WITH "\", MUST DOUBLE IT (e.g. "\\")
    IF "%__REGISTRY_VAR:~-1%"=="\" (
        CALL SETX %1 "%%__REGISTRY_VAR:~0,-1%%\\" /M > nul
    ) ELSE (
        CALL SETX %1 "%%__REGISTRY_VAR%%" /M > nul
    )

:: cleanup
    SET __REGISTRY_VAR=

:: checking whether value already exists in the local environment variable and adding
    CALL env-var-item-exists %1 %2 || CALL env-var-insert-item %1 %2

:: NOTES
:: -----
:: 
:: CALL is used inside code blocks to prevent issue when variable expansions contains the char `)`
:: which causes the premature ending of the code block. This happens for example if the %2 param
:: contains the path "C:\Program Files (x86)". Variables to be protected must have the char '%'
:: doubled when refering to them: e.g. %VAR$ => %%VAR%%
:: Code blocks should be avoided when using parameters like %2. It will not be possible to usebackq
:: the CALL because after calling %2 could have other meaning. Instead, we should use labels and
:: GOTO's to make IF's and ELSE's.