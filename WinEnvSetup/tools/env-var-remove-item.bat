@echo off
CALL SET %1=;%%%1:;=;;%%;
CALL SET %1=%%%1:;%~2;=%%
CALL SET %1=%%%1:~1,-1%%
CALL SET %1=%%%1:;;=;%%
