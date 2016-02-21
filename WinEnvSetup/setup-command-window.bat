@echo off

:MAIN

    REM Code page 65001 - utf-8
    ::REG ADD HKCU\Console /v CodePage /t REG_DWORD /d 65001
    REM Code page 437 - en-US
    REG ADD HKCU\Console /v CodePage /t REG_DWORD /d 437

GOTO :eof
