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
    CALL env-var-item-exists __REGISTRY_VAR %2 && (
        ECHO.SYSTEM: %1: already added %~2
        GOTO :eof
    )

:: appending the desired value and saving
    ECHO.SYSTEM: %1: adding %~2
    CALL env-var-insert-item __REGISTRY_VAR %2
    REM IF __REGISTRY_VAR ENDS WITH "\", MUST DOUBLE IT (e.g. "\\")
    IF "%__REGISTRY_VAR:~-1%"=="\" (
        SETX %1 "%__REGISTRY_VAR:~0,-1%\\" /M > nul
    ) ELSE (
        SETX %1 "%__REGISTRY_VAR%" /M > nul
    )

:: cleanup
    SET __REGISTRY_VAR=

:: checking whether value already exists in the local environment variable and adding
    CALL env-var-item-exists %1 %2 || CALL env-var-insert-item %1 %2
