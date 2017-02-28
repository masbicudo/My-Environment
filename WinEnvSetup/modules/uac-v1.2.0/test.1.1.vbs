Set test = VBImport("tester.vbs")

test.DoTest 1, 1

''' IMPORT.VBS - MINIFIED VERSION - v3.0.0 '''
' Author: Miguel Angelo Santos Bicudo
Dim VBImport_Items:Function VBImport(F):A="Scripting."
If Not IsObject(VBImport_Items)Then Set I=CreateObject(A&"Dictionary"):Set VBImport_Items=I
Set W=WScript:Set M=W.CreateObject(A&"FileSystemObject"):Set I=VBImport_Items
If InStr(F,":\")>0Then N=F:B=F Else B=M.GetParentFolderName(W.ScriptFullName):N=M.GetAbsolutePathName(M.BuildPath(B,F))
If ubound(split(F,"..\"))=ubound(split(B,"\"))+1Then Err.Raise -10937, "VBImport", "Cannot find "&M.GetFileName(F)
If I.Exists(N)Then Set R=I.Item(N)Else If M.FileExists(N)Then Set S=M.OpenTextFile(N,1):Set R=E_ImpVb(S.ReadAll()):_
  S.Close()Else If InStr(N,"\")<>InstrRev(N,"\")Then Set R=VBImport(M.BuildPath("..",F)) Else Set R=Nothing
If Not I.Exists(N)Then I.Add N,R
Set VBImport=R:End Function:Function E_ImpVb(D):Set Export=Nothing:Execute D:Set E_ImpVb=Export:End Function
''' END IMPORT.VBS '''
