' Version: 1.0.1
NameAndVersion = "shct v1.0.1"
VBSLoadRunTime
Set dbg = VBImport("..\debug-v1.2.0\debug.vbs")
Set su = VBImport("..\scripting-v1.0.1\force.cscript.vbs")
Set uac = VBImport("..\uac-v1.2.0\uac.vbs")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set oWS = WScript.CreateObject("WScript.Shell")

silent = True
Set NamedArgs = WScript.Arguments.Named

'FORCE CSCRIPT
If Not silent Then su.ForceCScriptExecution "close-cmd"

dbg.EnterBlock "shct.vbs"

ItDl=0
prefix="Creating shortcut"
If NamedArgs.Exists("target") Then
    target = NamedArgs.Item("target")
    If NamedArgs.Exists("link") Then link = NamedArgs.Item("link") Else link = "."
    link = Trim(link)
    extLink = LCase(objFSO.GetExtensionName(link))
    targetAbs = objFSO.GetAbsolutePathName(target)
    If objFSO.FolderExists(targetAbs) Or objFSO.FolderExists(targetAbs) Then
        target = targetAbs
    End If
    If extLink <> "lnk" Then
        If objFSO.FolderExists(link) Or Right(link, 1) = "\" Then
            If Right(link, 1) <> "\" Then link = link & "\"
            proposedName = objFSO.GetFileName(target)
            If proposedName = "" Then proposedName = objFSO.GetDriveName(target)
            If Right(proposedName, 1) = ":" Then proposedName = Mid(proposedName, 1, Len(proposedName) - 1)
            link = link & proposedName & ".lnk"
        Else
            link = Mid(link, 1, Len(link) - Len(extLink))
            If Right(link, 1) <> "." Then link = link & "."
            link = link & "lnk"
        End If
    End If
    link = objFSO.GetAbsolutePathName(link)

    If Not silent Then WScript.Echo Replace(prefix,"#","#"&ItDl)&": " & link & " => " & target

    Set oLink = oWS.CreateShortcut(link)
    oLink.TargetPath = target
    If NamedArgs.Exists("args") Then oLink.Arguments = NamedArgs.Item("args")
    If NamedArgs.Exists("desc") Then oLink.Description = NamedArgs.Item("desc")
    If NamedArgs.Exists("hotkeys") Then oLink.HotKey = NamedArgs.Item("hotkeys")
    If NamedArgs.Exists("icon") Then oLink.IconLocation = NamedArgs.Item("icon")
    If NamedArgs.Exists("style") Then oLink.WindowStyle = NamedArgs.Item("style")
    If NamedArgs.Exists("workdir") Then oLink.WorkingDirectory = NamedArgs.Item("workdir")
    oLink.Save
Else
    WScript.Echo    NameAndVersion & vbCrLf &_
                    "Usage:" & vbCrLf &_
                    "shct /target:target-object [/link:(lnk-file|destination-folder)] [/args:...] [/desc:...] [/hotkeys:...] [/icon:...] [/style:...] [/workdir:...]"
End If
If Not silent Then WScript.Echo "Finished!"

dbg.ExitBlock "shct.vbs"

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