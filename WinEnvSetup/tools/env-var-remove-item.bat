@echo off
CALL SET __TEMP=%%%1%%
SET __TEMP=;%__TEMP:;=;;%;
CALL SET __TEMP=%%__TEMP:;%~2;=%%
SET __TEMP=%__TEMP:~1,-1%
SET __TEMP=%__TEMP:;;=;%
CALL SET %1=%%__TEMP%%
SET __TEMP=
