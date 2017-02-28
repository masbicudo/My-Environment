''' IMPORT.VBS - v3.0.0 '''
' Author: Miguel Angelo Santos Bicudo
Dim VBImport_Items
Set VBImport_Items=CreateObject("Scripting.Dictionary")
Function VBImport(F)
    Set I=VBImport_Items
    Set W=WScript
    Set M=W.CreateObject("Scripting.FileSystemObject")

    If InStr(F,":\")>0 Then
        B=F
        N=F
    Else
        If IsEmpty(ModulesPath) Then
            B = M.GetParentFolderName(WScript.ScriptFullName)
        Else
            B = ModulesPath
        End If
        N=M.GetAbsolutePathName(M.BuildPath(B,F))
    End If

    If ubound(split(F,"..\"))=ubound(split(B,"\"))+1 Then
        Err.Raise -10937, "VBImport", "Cannot find "&M.GetFileName(F)
    End If

    If I.Exists(N) Then
        Set R=I.Item(N)
    ElseIf M.FileExists(N) Then
        Set S=M.OpenTextFile(N,1)
        Set R=E_ImpVb(S.ReadAll())
        S.Close()
    ElseIf InStr(N,"\")<>InstrRev(N,"\") Then
        Set R=VBImport(M.BuildPath("..",F))
    Else
        Set R=Nothing
    End If

    If Not I.Exists(N)Then I.Add N,R

    Set VBImport=R
End Function
Function E_ImpVb(D)
    Set Export=Nothing
    Execute D
    Set E_ImpVb=Export
End Function
''' END IMPORT.VBS '''
