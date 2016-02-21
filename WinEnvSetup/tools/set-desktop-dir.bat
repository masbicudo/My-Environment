FOR /F "usebackq tokens=2,* skip=2" %%L IN (
    `REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop`
) DO SET DESKTOPDIR=%%M
