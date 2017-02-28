Set args = VBImport("args-v1.1.0\args.vbs")
Set uac = VBImport("uac-v1.2.0\uac.vbs")
If uac.IsElevated Then X = "Is Elevated" Else X = "Is Not Elevated"
WScript.Echo X, args.CommandLineArgs()
