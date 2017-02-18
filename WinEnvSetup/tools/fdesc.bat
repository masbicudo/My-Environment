@echo off
reg query "HKCR\%1" > nul 2>1 && (
    ECHO.KEY EXISTS
) || (
    ECHO.KEY DOES NOT EXIST
)