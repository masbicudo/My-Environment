@echo off
:: getting registry environment variable value
    SET __REGISTRY_VAR=
    FOR /F "usebackq tokens=2,* skip=2" %%L IN (
        `reg query "HKCU\Environment" /v %1 2^>nul`
    ) DO SET __REGISTRY_VAR=%%M 2>nul
    CALL is-defined __REGISTRY_VAR || GOTO :UNDEF
        SET __REGISTRY_VAR=%__REGISTRY_VAR:~0,-1%
    :UNDEF

:: set value of local variable with registry value
    IF "%2"=="" (
      ECHO.%__REGISTRY_VAR%
    ) ELSE (
      SET %2=%__REGISTRY_VAR%
    )

:: cleanup
    SET __REGISTRY_VAR=
