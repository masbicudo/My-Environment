@echo off
SETLOCAL

:: getting registry environment variable value
    SET __REGISTRY_VAR=
    FOR /F "usebackq tokens=2,* skip=2" %%L IN (
        `reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v %1 2^>nul`
    ) DO SET __REGISTRY_VAR=%%M 2>nul
    CALL is-defined __REGISTRY_VAR || GOTO :UNDEF
        SET __REGISTRY_VAR=%__REGISTRY_VAR:~0,-1%
    :UNDEF

:: checking whether value exists in the registry environment variable
    CALL env-var-item-exists __REGISTRY_VAR %2 || (
        ECHO.\033[90mSYSTEM\033[0m \033[35m%1 does not contain %~2\033[0m | cmdcolor
        GOTO :eof
    )

:: removing the desired value and saving
    ECHO.\033[90mSYSTEM\033[0m \033[94m%1 -= %~2\033[0m | cmdcolor
    CALL env-var-remove-item __REGISTRY_VAR %2
    REM IF __REGISTRY_VAR ENDS WITH "\", MUST DOUBLE IT (e.g. "\\")
    IF "%__REGISTRY_VAR:~-1%"=="\" (
        SETX %1 "%__REGISTRY_VAR:~0,-1%\\" /M > nul
    ) ELSE (
        SETX %1 "%__REGISTRY_VAR%" /M > nul
    )

ENDLOCAL

:: checking whether value exists in the local environment variable and removing
    CALL env-var-item-exists %1 %2 && CALL env-var-remove-item %1 %2
