@echo off
:: getting registry environment variable value
    SET __REGISTRY_VAR=
    FOR /F "usebackq tokens=2,* skip=2" %%L IN (
        `reg query "HKCU\Environment" /v %1 2^>nul`
    ) DO SET __REGISTRY_VAR=%%M 2>nul
    CALL is-defined __REGISTRY_VAR || GOTO :UNDEF
        SET __REGISTRY_VAR=%__REGISTRY_VAR:~0,-1%
    :UNDEF

:: checking whether value exists in the registry environment variable
    CALL env-var-item-exists __REGISTRY_VAR %2 || (
        ECHO.USER %1 does not contain %~2
        GOTO :eof
    )

:: removing the desired value and saving
    ECHO.USER %1 -= %~2
    CALL env-var-remove-item __REGISTRY_VAR %2
    REM IF __REGISTRY_VAR ENDS WITH "\", MUST DOUBLE IT (e.g. "\\")
    IF "%__REGISTRY_VAR:~-1%"=="\" (
        SETX %1 "%__REGISTRY_VAR:~0,-1%\\" > nul
    ) ELSE (
        SETX %1 "%__REGISTRY_VAR%" > nul
    )

:: cleanup
    SET __REGISTRY_VAR=

:: checking whether value exists in the local environment variable and removing
    CALL env-var-item-exists %1 %2 && CALL env-var-remove-item %1 %2
