@ECHO off

FOR /F "tokens=1*" %%F IN ('powercfg /list ^| text-replace /s /r /ci "(?:^^|\n)[^^\:]*\:\s*(\S+)\s+\(([^^\)]+)\)" "$1 $2\n"') DO (
    ECHO.%%G
    call shct /target:"powercfg" /args:"-setactive %%F" /link:"%SHORTCUTS%\%%G.lnk" /desc:"%%G" /icon:"C:\Windows\System32\powercpl.dll,0"
)
copy "%SHORTCUTS%\Equilibrado.lnk" "%SHORTCUTS%\ppeq.lnk"           /Y /L /B > nul 2> nul

copy "%SHORTCUTS%\Alto desempenho.lnk" "%SHORTCUTS%\pphi.lnk"       /Y /L /B > nul 2> nul
copy "%SHORTCUTS%\pphi.lnk" "%SHORTCUTS%\AltoDesempenho.lnk"        /Y /L /B > nul 2> nul
copy "%SHORTCUTS%\pphi.lnk" "%SHORTCUTS%\Desempenho.lnk"            /Y /L /B > nul 2> nul

copy "%SHORTCUTS%\Economia de energia.lnk" "%SHORTCUTS%\pplo.lnk"   /Y /L /B > nul 2> nul
copy "%SHORTCUTS%\pplo.lnk" "%SHORTCUTS%\EconomiaDeEnergia.lnk"     /Y /L /B > nul 2> nul
copy "%SHORTCUTS%\pplo.lnk" "%SHORTCUTS%\Economia.lnk"              /Y /L /B > nul 2> nul
copy "%SHORTCUTS%\pplo.lnk" "%SHORTCUTS%\ppeco.lnk"                 /Y /L /B > nul 2> nul
