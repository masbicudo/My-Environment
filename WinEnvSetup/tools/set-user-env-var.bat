@echo off
SETLOCAL

:: setting the desired value and saving
    ECHO.\033[90mUSER\033[0m \033[32m%1 = %~2\033[0m | cmdcolor
    SET __REGISTRY_VAR=%~2
    REM IF __REGISTRY_VAR ENDS WITH "\", MUST DOUBLE IT (e.g. "\\")
    IF "%__REGISTRY_VAR:~-1%"=="\" (
        SETX %1 "%__REGISTRY_VAR:~0,-1%\\" > nul
    ) ELSE (
        SETX %1 "%__REGISTRY_VAR%" > nul
    )

ENDLOCAL

:: setting the local environment variable
    SET %1=%2
