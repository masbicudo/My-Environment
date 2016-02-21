@echo off
CALL env-var-item-exists %1 %2
IF NOT "%__RETURN%"=="%TRUE%" GOTO :eof
CALL env-var-insert-item %1 %2
