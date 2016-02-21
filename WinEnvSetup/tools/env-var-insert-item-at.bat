@echo off
CALL SET __LIST_IT=%%%1%%
FOR /F "tokens=%2 delims=;" %%I IN ("%__LIST_IT%") DO (
    SET __ITEM_NAME=%%I
)
CALL SET %1=;%%%1:;=;;%%;
CALL SET %1=%%%1:;%__ITEM_NAME%;=;%~3;;%__ITEM_NAME%;%%
CALL SET %1=%%%1:~1,-1%%
CALL SET %1=%%%1:;;=;%%
SET __LIST_IT=
SET __ITEM_NAME=
