For X = 0 To 2
    WScript.Echo 1, Err.Number
    On Error Resume Next
    WScript.Echo 2, Err.Number
    Err.Raise -10000
    WScript.Echo 3, Err.Number
    If X = 2 Then Exit For
    If X = 0 And Err.Number = -10000 Then _
        On Error GoTo 0
    WScript.Echo 4, Err.Number
Next
WScript.Echo 5, Err.Number
Err.Raise -10101
WScript.Echo 6, Err.Number
