@echo off

:: setting the desired value and saving
    ECHO.SYSTEM %1 = %~2
    SET __REGISTRY_VAR=%~2
    REM IF __REGISTRY_VAR ENDS WITH "\", MUST DOUBLE IT (e.g. "\\")
    IF "%__REGISTRY_VAR:~-1%"=="\" (
        SETX %1 "%__REGISTRY_VAR:~0,-1%\\" /M > nul
    ) ELSE (
        SETX %1 "%__REGISTRY_VAR%" /M > nul
    )

:: cleanup
    SET __REGISTRY_VAR=

:: setting the local environment variable
    SET %1=%2
