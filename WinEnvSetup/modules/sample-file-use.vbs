Const ForReading = 1, ForWriting = 2, ForAppending = 8

signalFile = "File.txt"

Set x = SignalExecution()

WScript.Sleep 8000

Function SignalExecution()
    Set WSHShell = CreateObject("WScript.Shell")
    Set FSO = CreateObject("Scripting.FileSystemObject")
    'If WScript.Arguments.Named.Exists("UAC-Signal-File-GUID") Then
        'guid = WScript.Arguments.Named.Item("UAC-Signal-File-GUID")
        'signalFile = WSHShell.ExpandEnvironmentStrings("%TEMP%\"&guid)
        Set SignalExecution = FSO.OpenTextFile(signalFile, ForWriting, False)
        SignalExecution.Write "STARTED"
        'MUST NOT CLOSE THE STREAM
    'End If
End Function
