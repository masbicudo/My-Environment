'TODO: A IMPLEMENTAÇÃO DO CARA ESTÁ ERRADA!

' Version: 
On Error Resume Next
Set dbg = VBImport("..\debug-v1.2.0\debug.vbs")
On Error GoTo 0

'/****************************************************************************** 
' *  Copyright (C) 2000 by Robert Hubley.                                      * 
' *  All rights reserved.                                                      * 
' *                                                                            * 
' *  This software is provided ``AS IS'' and any express or implied            * 
' *  warranties, including, but not limited to, the implied warranties of      * 
' *  merchantability and fitness for a particular purpose, are disclaimed.     * 
' *  In no event shall the authors be liable for any direct, indirect,         * 
' *  incidental, special, exemplary, or consequential damages (including, but  * 
' *  not limited to, procurement of substitute goods or services; loss of use, * 
' *  data, or profits; or business interruption) however caused and on any     * 
' *  theory of liability, whether in contract, strict liability, or tort       * 
' *  (including negligence or otherwise) arising in any way out of the use of  * 
' *  this software, even if advised of the possibility of such damage.         * 
' *                                                                            * 
' ****************************************************************************** 
' 
'  CLASS: MD5 
' 
'  DESCRIPTION: 
'     This is a class which encapsulates a set of MD5 Message Digest functions. 
'     MD5 algorithm produces a 128 bit digital fingerprint (signature) from an 
'     dataset of arbitrary length.  For details see RFC 1321 (summarized below). 
'     This implementation is derived from the RSA Data Security, Inc. MD5 Message-Digest 
'     algorithm reference implementation (originally written in C) 
' 
'  AUTHOR: 
'     Robert M. Hubley 12/1999 
' 
' 
'  NOTES: 
'      Network Working Group                                    R. Rivest 
'      Request for Comments: 1321     MIT Laboratory for Computer Science 
'                                             and RSA Data Security, Inc. 
'                                                              April 1992 
' 
' 
'                           The MD5 Message-Digest Algorithm 
' 
'      Summary 
' 
'         This document describes the MD5 message-digest algorithm. The 
'         algorithm takes as input a message of arbitrary length and produces 
'         as output a 128-bit "fingerprint" or "message digest" of the input. 
'         It is conjectured that it is computationally infeasible to produce 
'         two messages having the same message digest, or to produce any 
'         message having a given prespecified target message digest. The MD5 
'         algorithm is intended for digital signature applications, where a 
'         large file must be "compressed" in a secure manner before being 
'         encrypted with a private (secret) key under a public-key cryptosystem 
'         such as RSA. 
' 
'         The MD5 algorithm is designed to be quite fast on 32-bit machines. In 
'         addition, the MD5 algorithm does not require any large substitution 
'         tables; the algorithm can be coded quite compactly. 
' 
'         The MD5 algorithm is an extension of the MD4 message-digest algorithm 
'         1,2]. MD5 is slightly slower than MD4, but is more "conservative" in 
'         design. MD5 was designed because it was felt that MD4 was perhaps 
'         being adopted for use more quickly than justified by the existing 
'         critical review; because MD4 was designed to be exceptionally fast, 
'         it is "at the edge" in terms of risking successful cryptanalytic 
'         attack. MD5 backs off a bit, giving up a little in speed for a much 
'         greater likelihood of ultimate security. It incorporates some 
'         suggestions made by various reviewers, and contains additional 
'         optimizations. The MD5 algorithm is being placed in the public domain 
'         for review and possible adoption as a standard. 
' 
'         RFC Author: 
'         Ronald L.Rivest 
'         Massachusetts Institute of Technology 
'         Laboratory for Computer Science 
'         NE43 -324545    Technology Square 
'         Cambridge, MA  02139-1986 
'         Phone: (617) 253-5880 
'         EMail:    Rivest@ theory.lcs.mit.edu 
' 
' 
' 
'  CHANGE HISTORY: 
' 
'     0.1.0  RMH    1999/12/29      Original version 
'                   2016/02/06      Translated to VBScript
' 

'= 
'= Constants 
'= 
Const OFFSET_4 = 4294967296
Const MAXINT_4 = 2147483647

Const S11 = 7 
Const S12 = 12 
Const S13 = 17 
Const S14 = 22 
Const S21 = 5 
Const S22 = 9 
Const S23 = 14 
Const S24 = 20 
Const S31 = 4 
Const S32 = 11 
Const S33 = 16 
Const S34 = 23 
Const S41 = 6 
Const S42 = 10 
Const S43 = 15 
Const S44 = 21 

Const ForReading = 1    
Const ForWriting = 2

Const adTypeBinary = 1
Const adTypeText = 2
        
Class MD5

    '= 
    '= Class Variables 
    '= 
    Private State(4) 
    Private ByteCounter 
    Private ByteBuffer

    Private Sub Class_Initialize()
        ByteBuffer = CreateEmptyByteArray(64)
    End Sub
    
    Private Function CreateEmptyByteArray(Size)
        Set BinaryStream = CreateObject("ADODB.Stream")
        BinaryStream.Type = adTypeText
        BinaryStream.Open
        BinaryStream.CharSet = "ASCII"
        BinaryStream.WriteText String(Size, 0)
        BinaryStream.Position = 0
        BinaryStream.Type = adTypeBinary
        CreateEmptyByteArray = BinaryStream.Read
        BinaryStream.Close()
    End Function

    Private Function BuildByteTable()
        allCharSets = Array( _
            "us-ascii"    ,_
            "utf-7"       ,_
            "utf-8"       ,_
            "iso-8859-1"  ,_
            "iso-8859-2"  ,_
            "iso-8859-3"  ,_
            "iso-8859-4"  ,_
            "iso-8859-5"  ,_
            "iso-8859-6"  ,_
            "iso-8859-7"  ,_
            "iso-8859-8"  ,_
            "iso-8859-9"  ,_
            "koi8-r"      ,_
            "shift-jis"   ,_
            "big5"        ,_
            "euc-jp"      ,_
            "euc-kr"      ,_
            "gb2312"      ,_
            "iso-2022-jp" ,_
            "iso-2022-kr" )

        Redim result(255)
        Set BinaryStream = CreateObject("ADODB.Stream")
        BinaryStream.Open
        For l = 0 To UBound(allCharSets)
            charset = allCharSets(l)
            For x = 0 To 255
                BinaryStream.Position = 0
                BinaryStream.SetEOS
                BinaryStream.Type = adTypeText
                BinaryStream.CharSet = charset
                BinaryStream.WriteText Chr(x)
                BinaryStream.Position = 0
                BinaryStream.Type = 1
                byteArray = BinaryStream.Read
                For y = 0 To UBound(byteArray)
                    valb = CLng(AscB(MidB(byteArray, y+1, 1)))
                    If VarType(result(valb)) = 0 Then
                        BinaryStream.Position = y
                        singleByteArray = BinaryStream.Read(1)
                        result(valb) = singleByteArray
                    End If
                Next
            Next
        Next
        BuildByteTable = result
        BinaryStream.Close()
    End Function

    Private Function ToByteArray(a)
        table = BuildByteTable()
        Set BinaryStream = CreateObject("ADODB.Stream")
        BinaryStream.Open
        BinaryStream.Type = 1
        For x = 0 To UBound(a)
            If VarType(a(x)) <> vbInteger And VarType(a(x)) <> vbLong Then Err.Raise -12893, "md5.vbs: ToByteArray", "All elements in array must be integers. (" & x &") is "& VarType(a(x))
            BinaryStream.Write table(a(x))
        Next
        BinaryStream.Position = 0
        ToByteArray = BinaryStream.Read
        BinaryStream.Close()
    End Function

    Private Function CopyBytes(destBuffer, destPos, srcBuffer, srcPos, size)
        If size > 0 Then
            Set BinaryStream = CreateObject("ADODB.Stream")
            BinaryStream.Type = adTypeBinary
            BinaryStream.Open
            BinaryStream.Write srcBuffer
            BinaryStream.Position = srcPos
            srcCrop = BinaryStream.Read(size)

            BinaryStream.Position = 0
            BinaryStream.Write destBuffer
            BinaryStream.Position = destPos
            BinaryStream.Write srcCrop
            BinaryStream.Position = 0
            CopyBytes = BinaryStream.Read(UBound(destBuffer)+1)
            BinaryStream.Close()
        Else
            CopyBytes = destBuffer
        End If
    End Function

    '= 
    '= Class Properties 
    '= 
    Property Get RegisterA() 
        RegisterA = State(1) 
    End Property 

    Property Get RegisterB() 
        RegisterB = State(2) 
    End Property 

    Property Get RegisterC() 
        RegisterC = State(3) 
    End Property 

    Property Get RegisterD() 
        RegisterD = State(4) 
    End Property 


    '= 
    '= Class Functions 
    '= 

    ' 
    ' Function to quickly digest a file into a hex string 
    ' 
    Public Function DigestFileToHexStr(FileName)
    
        Set transf = CreateObject("ADODB.Stream")
        transf.Open()
        transf.Type = adTypeBinary
        emptyArr = CreateEmptyByteArray(64)
        transf.Write emptyArr
    
        Dim BinaryStream
        Set BinaryStream = CreateObject("ADODB.Stream")
        BinaryStream.Type = adTypeBinary
        BinaryStream.Open
        BinaryStream.LoadFromFile FileName
        MD5Init
        Do While Not BinaryStream.EOS
            temp = BinaryStream.Read(64)
            ByteBuffer = temp
            
            transf.Position = 0
            transf.Write ByteBuffer
            transf.Position = 0
            ByteBuffer = transf.Read
            
            If BinaryStream.Position < BinaryStream.Size Then 
                ByteCounter = ByteCounter + 64 
                MD5Transform ByteBuffer 
            End If
        Loop
        ByteCounter = ByteCounter + (BinaryStream.Size Mod 64) 
        BinaryStream.Close
        MD5Final 
        DigestFileToHexStr = GetValues 
        
        transf.Close()
    End Function 

    ' 
    ' Function to digest a text string and output the result as a string 
    ' of hexadecimal characters. 
    ' 
    Public Function DigestStrToHexStr(SourceString) 
        MD5Init 
        MD5Update Len(SourceString), StringToArray(SourceString) 
        MD5Final 
        DigestStrToHexStr = GetValues 
    End Function 

    ' 
    ' A utility function which converts a string into an array of 
    ' bytes. 
    ' 
    Private Function StringToArray(InString)
        Dim I 
        Dim bytBuffer() 
        ReDim bytBuffer(Len(InString)) 
        For I = 0 To Len(InString) - 1 
            bytBuffer(I) = Asc(Mid(InString, I + 1, 1)) 
        Next
        StringToArray = bytBuffer 
    End Function 

    ' 
    ' Concatenate the four state vaules into one string 
    ' 
    Public Function GetValues() 
        GetValues = LongToString(State(1)) & LongToString(State(2)) & LongToString(State(3)) & LongToString(State(4)) 
    End Function 

    ' 
    ' Convert a Long to a Hex string 
    ' 
    Private Function LongToString(Num) 
            Dim a 
            Dim b 
            Dim c 
            Dim d 
             
            a = Num And &HFF& 
            If a < 16 Then 
                LongToString = "0" & Hex(a) 
            Else 
                LongToString = Hex(a) 
            End If 
                    
            b = (Num And &HFF00&) \ 256 
            If b < 16 Then 
                LongToString = LongToString & "0" & Hex(b) 
            Else 
                LongToString = LongToString & Hex(b) 
            End If 
             
            c = (Num And &HFF0000) \ 65536 
            If c < 16 Then 
                LongToString = LongToString & "0" & Hex(c) 
            Else 
                LongToString = LongToString & Hex(c) 
            End If 
            
            If Num < 0 Then 
                d = ((Num And &H7F000000) \ 16777216) Or &H80& 
            Else 
                d = (Num And &HFF000000) \ 16777216 
            End If 
             
            If d < 16 Then 
                LongToString = LongToString & "0" & Hex(d) 
            Else 
                LongToString = LongToString & Hex(d) 
            End If 
         
    End Function 

    ' 
    ' Initialize the class 
    '   This must be called before a digest calculation is started 
    ' 
    Public Sub MD5Init() 
        ByteCounter = 0 
        State(1) = UnsignedToLong(1732584193) 
        State(2) = UnsignedToLong(4023233417) 
        State(3) = UnsignedToLong(2562383102) 
        State(4) = UnsignedToLong(271733878) 
    End Sub 

    ' 
    ' MD5 Final 
    ' 
    Public Sub MD5Final() 
        Dim dblBits 
         
        Dim padding(72) 
        For x = 0 To 72
            padding(x) = 0
        Next
        Dim lngBytesBuffered
         
        padding(0) = &H80 
         
        dblBits = ByteCounter * 8 
         
        ' Pad out 
        lngBytesBuffered = ByteCounter Mod 64 
        If lngBytesBuffered <= 56 Then 
            MD5Update CLng(56 - lngBytesBuffered), ToByteArray(padding)
        Else 
            MD5Update CLng(120 - ByteCounter), ToByteArray(padding)
        End If 
         
         
        padding(0) = UnsignedToLong(dblBits) And &HFF& 
        padding(1) = UnsignedToLong(dblBits) \ 256 And &HFF& 
        padding(2) = UnsignedToLong(dblBits) \ 65536 And &HFF& 
        padding(3) = UnsignedToLong(dblBits) \ 16777216 And &HFF& 
        padding(4) = 0 
        padding(5) = 0 
        padding(6) = 0 
        padding(7) = 0 
         
        MD5Update CLng(8), ToByteArray(padding)
    End Sub 

    ' 
    ' Break up input stream into 64 byte chunks 
    ' 
    Public Sub MD5Update(InputLen, InputBuffer)
        If VarType(InputLen) <> vbLong Then Err.Raise -10284, "md5.vbs: MD5Update", "InputLen must be Long. " & VarType(InputLen)
        If VarType(InputBuffer) <> vbArray+vbByte Then Err.Raise -10284, "md5.vbs: MD5Update", "InputLen must be Byte Array. " & VarType(InputBuffer)
        Dim II 
        Dim I 
        Dim J 
        Dim K 
        Dim lngBufferedBytes 
        Dim lngBufferRemaining 
        Dim lngRem 
         
        lngBufferedBytes = ByteCounter Mod 64 
        lngBufferRemaining = 64 - lngBufferedBytes 
        ByteCounter = ByteCounter + InputLen 
        ' Use up old buffer results first 
        If InputLen >= lngBufferRemaining Then 
            ByteBuffer = CopyBytes(ByteBuffer, lngBufferedBytes, InputBuffer, 0, lngBufferRemaining)
            MD5Transform ByteBuffer 
             
            lngRem = (InputLen) Mod 64 
            ' The transfer is a multiple of 64 lets do some transformations 
            For I = lngBufferRemaining To InputLen - II - lngRem Step 64 
                ByteBuffer = CopyBytes(ByteBuffer, 0, InputBuffer, I, 64)
                MD5Transform ByteBuffer 
            Next
            lngBufferedBytes = 0 
        Else 
          I = 0 
        End If 
         
        ' Buffer any remaining input 
        ByteBuffer = CopyBytes(ByteBuffer, lngBufferedBytes, InputBuffer, I, InputLen - I)
         
    End Sub 

    ' 
    ' MD5 Transform 
    ' 
    Private Sub MD5Transform(Buffer) 
        Dim x(16) 
        Dim a 
        Dim b 
        Dim c 
        Dim d 
         
        a = State(1) 
        b = State(2) 
        c = State(3) 
        d = State(4) 
         
        Decode 64, x, Buffer 

        ' Round 1 
        FF a, b, c, d, x(0), S11, -680876936 
        FF d, a, b, c, x(1), S12, -389564586 
        FF c, d, a, b, x(2), S13, 606105819 
        FF b, c, d, a, x(3), S14, -1044525330 
        FF a, b, c, d, x(4), S11, -176418897 
        FF d, a, b, c, x(5), S12, 1200080426 
        FF c, d, a, b, x(6), S13, -1473231341 
        FF b, c, d, a, x(7), S14, -45705983 
        FF a, b, c, d, x(8), S11, 1770035416 
        FF d, a, b, c, x(9), S12, -1958414417 
        FF c, d, a, b, x(10), S13, -42063 
        FF b, c, d, a, x(11), S14, -1990404162 
        FF a, b, c, d, x(12), S11, 1804603682 
        FF d, a, b, c, x(13), S12, -40341101 
        FF c, d, a, b, x(14), S13, -1502002290 
        FF b, c, d, a, x(15), S14, 1236535329 
         
        ' Round 2 
        GG a, b, c, d, x(1), S21, -165796510 
        GG d, a, b, c, x(6), S22, -1069501632 
        GG c, d, a, b, x(11), S23, 643717713 
        GG b, c, d, a, x(0), S24, -373897302 
        GG a, b, c, d, x(5), S21, -701558691 
        GG d, a, b, c, x(10), S22, 38016083 
        GG c, d, a, b, x(15), S23, -660478335 
        GG b, c, d, a, x(4), S24, -405537848 
        GG a, b, c, d, x(9), S21, 568446438 
        GG d, a, b, c, x(14), S22, -1019803690 
        GG c, d, a, b, x(3), S23, -187363961 
        GG b, c, d, a, x(8), S24, 1163531501 
        GG a, b, c, d, x(13), S21, -1444681467 
        GG d, a, b, c, x(2), S22, -51403784 
        GG c, d, a, b, x(7), S23, 1735328473 
        GG b, c, d, a, x(12), S24, -1926607734 
         
        ' Round 3 
        HH a, b, c, d, x(5), S31, -378558 
        HH d, a, b, c, x(8), S32, -2022574463 
        HH c, d, a, b, x(11), S33, 1839030562 
        HH b, c, d, a, x(14), S34, -35309556 
        HH a, b, c, d, x(1), S31, -1530992060 
        HH d, a, b, c, x(4), S32, 1272893353 
        HH c, d, a, b, x(7), S33, -155497632 
        HH b, c, d, a, x(10), S34, -1094730640 
        HH a, b, c, d, x(13), S31, 681279174 
        HH d, a, b, c, x(0), S32, -358537222 
        HH c, d, a, b, x(3), S33, -722521979 
        HH b, c, d, a, x(6), S34, 76029189 
        HH a, b, c, d, x(9), S31, -640364487 
        HH d, a, b, c, x(12), S32, -421815835 
        HH c, d, a, b, x(15), S33, 530742520 
        HH b, c, d, a, x(2), S34, -995338651 
         
        ' Round 4 
        II a, b, c, d, x(0), S41, -198630844 
        II d, a, b, c, x(7), S42, 1126891415 
        II c, d, a, b, x(14), S43, -1416354905 
        II b, c, d, a, x(5), S44, -57434055 
        II a, b, c, d, x(12), S41, 1700485571 
        II d, a, b, c, x(3), S42, -1894986606 
        II c, d, a, b, x(10), S43, -1051523 
        II b, c, d, a, x(1), S44, -2054922799 
        II a, b, c, d, x(8), S41, 1873313359 
        II d, a, b, c, x(15), S42, -30611744 
        II c, d, a, b, x(6), S43, -1560198380 
        II b, c, d, a, x(13), S44, 1309151649 
        II a, b, c, d, x(4), S41, -145523070 
        II d, a, b, c, x(11), S42, -1120210379 
        II c, d, a, b, x(2), S43, 718787259 
        II b, c, d, a, x(9), S44, -343485551 
         
         
        State(1) = LongOverflowAdd(State(1), a) 
        State(2) = LongOverflowAdd(State(2), b) 
        State(3) = LongOverflowAdd(State(3), c) 
        State(4) = LongOverflowAdd(State(4), d) 

    '  /* Zeroize sensitive information. 
    '*/ 
    '  MD5_memset ((POINTER)x, 0, sizeof (x)); 
         
    End Sub 

    Private Sub DebugByteArray(ba)
        For x = 0 To UBound(ba)
            valb = CLng(AscB(Midb(ba, x+1, 1)))
            If x > 0 Then WScript.StdOut.Write " "
            WScript.StdOut.Write valb
        Next
        WScript.Echo ""
    End Sub
    
    Private Sub Decode(Length, OutputBuffer, InputBuffer) 
        Dim intDblIndex 
        Dim intByteIndex 
        Dim dblSum 
         
        intDblIndex = 0 
        For intByteIndex = 0 To Length - 1 Step 4 
            'DebugByteArray InputBuffer
            'WScript.Echo intByteIndex, Length
            dblSum = CLng(AscB(Midb(InputBuffer, intByteIndex+1, 1)))
            dblSum = dblSum + CLng(AscB(Midb(InputBuffer, intByteIndex+2, 1))) * 256
            dblSum = dblSum + CLng(AscB(Midb(InputBuffer, intByteIndex+3, 1))) * 65536
            dblSum = dblSum + CLng(AscB(Midb(InputBuffer, intByteIndex+4, 1))) * 16777216
            'WScript.Echo VarType(InputBuffer), UBound(InputBuffer), dblSum
            OutputBuffer(intDblIndex) = UnsignedToLong(dblSum) 
            intDblIndex = intDblIndex + 1 
        Next
    End Sub 

    ' 
    ' FF, GG, HH, and II transformations for rounds 1, 2, 3, and 4. 
    ' Rotation is separate from addition to prevent recomputation. 
    ' 
    Private Function FF(a, _ 
                        b, _ 
                        c, _ 
                        d, _ 
                        x, _ 
                        s, _ 
                        ac) 
        a = LongOverflowAdd4(a, (b And c) Or (Not (b) And d), x, ac) 
        a = LongLeftRotate(a, s) 
        a = LongOverflowAdd(a, b) 
    End Function 

    Private Function GG(a, _ 
                        b, _ 
                        c, _ 
                        d, _ 
                        x, _ 
                        s, _ 
                        ac) 
        a = LongOverflowAdd4(a, (b And d) Or (c And Not (d)), x, ac) 
        a = LongLeftRotate(a, s) 
        a = LongOverflowAdd(a, b) 
    End Function 

    Private Function HH(a, _ 
                        b, _ 
                        c, _ 
                        d, _ 
                        x, _ 
                        s, _ 
                        ac) 
        a = LongOverflowAdd4(a, b Xor c Xor d, x, ac) 
        a = LongLeftRotate(a, s) 
        a = LongOverflowAdd(a, b) 
    End Function 

    Private Function II(a, _ 
                        b, _ 
                        c, _ 
                        d, _ 
                        x, _ 
                        s, _ 
                        ac) 
        a = LongOverflowAdd4(a, c Xor (b Or Not (d)), x, ac) 
        a = LongLeftRotate(a, s) 
        a = LongOverflowAdd(a, b) 
    End Function 

    ' 
    ' Rotate a long to the right 
    ' 
    Function LongLeftRotate(value, bits) 
        Dim lngSign 
        Dim lngI 
        bits = bits Mod 32 
        If bits = 0 Then LongLeftRotate = value: Exit Function 
        For lngI = 1 To bits 
            lngSign = value And &HC0000000 
            value = (value And &H3FFFFFFF) * 2 
            value = value Or ((lngSign < 0) And 1) Or (CBool(lngSign And _ 
                    &H40000000) And &H80000000) 
        Next 
        LongLeftRotate = value 
    End Function 

    ' 
    ' Function to add two unsigned numbers together as in C. 
    ' Overflows are ignored! 
    ' 
    Private Function LongOverflowAdd(Val1, Val2) 
        Dim lngHighWord 
        Dim lngLowWord 
        Dim lngOverflow 

        lngLowWord = (Val1 And &HFFFF&) + (Val2 And &HFFFF&) 
        lngOverflow = lngLowWord \ 65536 
        lngHighWord = (((Val1 And &HFFFF0000) \ 65536) + ((Val2 And &HFFFF0000) \ 65536) + lngOverflow) And &HFFFF& 
        LongOverflowAdd = UnsignedToLong((lngHighWord * 65536) + (lngLowWord And &HFFFF&)) 
    End Function 

    ' 
    ' Function to add two unsigned numbers together as in C. 
    ' Overflows are ignored! 
    ' 
    Private Function LongOverflowAdd4(Val1, Val2, val3, val4) 
        Dim lngHighWord 
        Dim lngLowWord 
        Dim lngOverflow 

        lngLowWord = (Val1 And &HFFFF&) + (Val2 And &HFFFF&) + (val3 And &HFFFF&) + (val4 And &HFFFF&) 
        lngOverflow = lngLowWord \ 65536 
        lngHighWord = (((Val1 And &HFFFF0000) \ 65536) + _ 
                       ((Val2 And &HFFFF0000) \ 65536) + _ 
                       ((val3 And &HFFFF0000) \ 65536) + _ 
                       ((val4 And &HFFFF0000) \ 65536) + _ 
                       lngOverflow) And &HFFFF& 
        LongOverflowAdd4 = UnsignedToLong((lngHighWord * 65536) + (lngLowWord And &HFFFF&)) 
    End Function 

    ' 
    ' Convert an unsigned double into a long 
    ' 
    Private Function UnsignedToLong(value) 
            If value < 0 Or value >= OFFSET_4 Then Error 6 ' Overflow 
            If value <= MAXINT_4 Then 
              UnsignedToLong = value 
            Else 
              UnsignedToLong = value - OFFSET_4 
            End If 
          End Function 

    ' 
    ' Convert a long to an unsigned Double 
    ' 
    Private Function LongToUnsigned(value) 
            If value < 0 Then 
              LongToUnsigned = value + OFFSET_4 
            Else 
              LongToUnsigned = value 
            End If 
    End Function 

    Private lvl
    Private Function DebugTime(t)
        DebugTime = t
        If VarType(dbg) <> 0 Then DebugTime = t*dbg.SleepUnit + dbg.SleepBase
    End Function
    Private Sub DebugEcho(t,i,m)
        If VarType(dbg) <> 0 Then dbg.Echo t,i,m Else WScript.Echo String((lvl+i)*4," ")&m:_
            If IsCScript Then WScript.Sleep t*1000
    End Sub
    Private Sub DebugEnter(n)
        If VarType(dbg) <> 0 Then dbg.EnterBlock n Else WScript.Echo String((lvl+i)*4," ")&n
        lvl=lvl+1
    End Sub
    Private Sub DebugExit(n)
        lvl=lvl-1:If lvl<0 Then lvl=0
        If VarType(dbg) <> 0 Then dbg.ExitBlock n Else WScript.Echo String((lvl+i)*4," ")&n
    End Sub
    Private Sub DebugEnterArgs(n,m)
        lvl=lvl+1
        If VarType(dbg) <> 0 Then dbg.EnterBlockArgs n,m Else WScript.Echo String((lvl+i)*4," ")&n&"("&m&")"
    End Sub
    Private Sub DebugExitResult(n,m)
        lvl=lvl-1:If lvl<0 Then lvl=0
        If VarType(dbg) <> 0 Then dbg.ExitBlockResult n,m Else WScript.Echo String((lvl+i)*4," ")&n&" = "&m
    End Sub

End Class

Set Export = New MD5
WScript.Echo Export.DigestFileToHexStr("hello.txt")
WScript.Echo Export.DigestFileToHexStr("RandomNumbers")