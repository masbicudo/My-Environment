using System;
using System.Runtime.InteropServices;

[DllImport("user32.dll", SetLastError = true)]
static extern bool SystemParametersInfo(int uiAction, int uiParam, IntPtr pvParam, int fWinIni);

SystemParametersInfo(0x0057, 0, IntPtr.Zero, 0);
