' Version: 1.0.6
VBSLoadRunTime
Set dbg = VBImport("..\debug-v1.2.0\debug.vbs")
Set su = VBImport("..\scripting-v1.0.1\force.cscript.vbs")
Set uac = VBImport("..\uac-v1.2.0\uac.vbs")
Set http = VBImport("..\http-v1.0.3\http.vbs")
Set objFSO = CreateObject("Scripting.FileSystemObject")

'dbg.Enable
dbg.SleepUnit = uac.PatternMatch(0, 0, 0)

WScript.Echo WScript.Arguments(0)
WScript.Echo WScript.Arguments(1)

If Not su.IsCscript Then
    dbg.IgnoreBlock "UAC"
End If
dbg.EnterBlock "get.vbs"

hasWork = WScript.Arguments.Length <> 0
Set NamedArgs = WScript.Arguments.Named
silent = NamedArgs.Exists("silent") Or Not hasWork

dbg.Echo 1,0,"uac.IsElevated = "& uac.IsElevated

'ELEVATE
If hasWork Then uac.ElevateWithOutput

'FORCE CSCRIPT
If Not silent Then su.ForceCScriptExecution "close-cmd"

listFile = ""
If NamedArgs.Exists("list") Then
    listFile = NamedArgs.Item("list")
ElseIf WScript.Arguments.Length = 1 Then
    arg0 = Trim(WScript.Arguments(0))
    If Right(Left(arg0, 3), 2) = ":\" Or objFSO.FileExists(arg0) Then
        listFile = arg0
    End If
End If

ItDl=0
prefix="Downloading"
Set Ignore = CreateObject("Scripting.Dictionary")
If listFile <> "" Then
    If Not silent Then WScript.Echo "Downloading list "&listFile
    prefix = "  #"

    'Const ForReading = 1, ForWriting = 2, ForAppending = 8
    'Const TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0

    Set objStream = CreateObject("ADODB.Stream")
    objStream.Type = 2
    objStream.CharSet = "utf-8"
    objStream.Open
    objStream.LoadFromFile listFile

    Dim File, Url, DlYet, Ignore, objFSO
    Url = ""
    File = ""
    DlYet = True
    Set wshShell = CreateObject( "WScript.Shell" )
    Do Until objStream.EOS
        Line = Trim(objStream.ReadText(-2)) ' read line
        If Line = "" And Not DlYet And Url <> "" And File <> "" Then
            DlYet = True
            Download Url, File
        ElseIf InStr(Line, ":") > 0 Then
            DlYet = False
            LineSplit = Split(Line, ":", 2)
            Label = UCase(LineSplit(0))
            If Label = "URL" Then Url = LineSplit(1)
            If Label = "FILE" Then File = LineSplit(1)
            If Label = "FILE-EXPAND" Then File = wshShell.ExpandEnvironmentStrings( LineSplit(1) )
            If Label = "IGNORE" And Not Ignore.Exists(LineSplit(1)) Then Ignore.Add LineSplit(1), True
        End If
    Loop
    If Not DlYet Then Download Url, File
    
    objStream.Close
ElseIf NamedArgs.Exists("url") And NamedArgs.Exists("file") Then
    File = NamedArgs.Item("file")
    Url = NamedArgs.Item("url")
    Download Url, File
ElseIf WScript.Arguments.Count = 2 Then
    arg0 = WScript.Arguments(0)
    arg1 = WScript.Arguments(1)
    If InStr(arg0, ":") > 2 Then Url = arg0: File = arg1 Else Url = arg1: File = arg0
    Download Url, File
Else
    WScript.Echo "An URI must be indicated, or a list file with multiple items to download."
End If
If Not silent Then WScript.Echo "Finished!"

Sub Download(Url, File)
    If Not silent Then WScript.Echo Replace(prefix,"#","#"&ItDl)&": " & Url
    result = http.Download(Url, File)
    ItDl=ItDl+1
    If Left(result, 6) <> "ERROR:" And Ignore.Exists(objFSO.GetExtensionName(result)) Then
        objFSO.DeleteFile result
    End If
End Sub

dbg.ExitBlock "get.vbs"

''' IMPORT RUNTIME.VBS - MINIFIED VERSION - v1.0.0 '''
' Author: Miguel Angelo Santos Bicudo
Sub VBSLoadRunTime():Set W=WScript:F="RunTime.vbs":Set M=W.CreateObject("Scripting.FileSystemObject")
A=Array("","modules\"):G=M.BuildPath(CreateObject("WScript.Shell").ExpandEnvironmentStrings("%WSRTGLB%"),".")&"\"
J=M.BuildPath(M.GetParentFolderName(W.ScriptFullName),".")&"\":P=""
For Z=0 To 99:V=0:If Z=0 And InStr(G,":\")>0 Then V=1
For Y=0 To V:Q=J&P:If Y=1 Then Q=G
For X=0 To 1:N=Q&A(X)&F:If M.FileExists(N) Then:Set S=M.OpenTextFile(N,1):ExecuteGlobal S.ReadAll():S.Close:Exit Sub
Next:Next:B=M.GetAbsolutePathName(J&P&F):P="..\"&P
If InStr(B,"\")=InstrRev(B,"\")Then Exit For
Next:Err.Raise -10937, "VBSLoadRunTime", "Cannot find "&F:End Sub
''' END IMPORT RUNTIME.VBS '''