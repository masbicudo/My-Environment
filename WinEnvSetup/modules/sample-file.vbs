Const ForReading = 1, ForWriting = 2, ForAppending = 8
Set FSO = CreateObject("Scripting.FileSystemObject")
signalFile = "File.txt"

FSO.OpenTextFile(signalFile, ForWriting, True).Close()

text = ""
WScript.Echo "Trying to read file"
it = 0
Do
    On Error Resume Next
    Set stream = CreateObject("Scripting.FileSystemObject")_
        .OpenTextFile(signalFile, ForReading)
    text = stream.ReadAll()
    stream.Close()
    On Error GoTo 0
    If text = "STARTED" Then Exit Do
    it=it+1
    WScript.Echo "    Retry #"&it
    WScript.Sleep 500
Loop
WScript.Echo "Started"

WScript.Echo "Trying to delete file"
it = 0
Do While FSO.FileExists(signalFile)
    On Error Resume Next
    FSO.DeleteFile(signalFile)
    On Error GoTo 0
    it=it+1
    WScript.Echo "    Retry #"&it
    WScript.Sleep 500
Loop
