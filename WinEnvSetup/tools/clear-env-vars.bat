:LOOP
if "%~1" NEQ "" (
  IF "%~1"=="/SYSTEM" (
      SET __CLEAR_SYS=1
  ) ELSE IF "%~1"=="/USER" (
      SET __CLEAR_USR=1
  ) ELSE IF "%~1"=="/LOCAL" (
      SET __CLEAR_LOCAL=1
  ) ELSE IF "%~1"=="/S" (
      SET __CLEAR_SYS=1
  ) ELSE IF "%~1"=="/U" (
      SET __CLEAR_USR=1
  ) ELSE IF "%~1"=="/L" (
      SET __CLEAR_LOCAL=1
  ) ELSE (
      CALL env-var-insert-item __TEMP_VAR_EB4A63E2 %1
  )
  SHIFT
  goto :LOOP
)

FOR /F "delims=;" %%A in ("%__TEMP_VAR_EB4A63E2%") do (
  IF "%__CLEAR_SYS%"=="1" REG delete HKCU\Environment /F /V %%A >nul 2>&1
  IF "%__CLEAR_USR%"=="1" REG delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /F /V %%A >nul 2>&1
  IF "%__CLEAR_LOCAL%"=="1" SET %%A=
)

SET __CLEAR_SYS=
SET __CLEAR_USR=
SET __CLEAR_LOCAL=
SET __TEMP_VAR_EB4A63E2=
