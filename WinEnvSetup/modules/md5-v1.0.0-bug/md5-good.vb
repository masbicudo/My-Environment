
Public Class MD5
    '**********************VARIABLES***********************************



    '**********************Statics*************************************

    ''' <summary>
    ''' lookup table 4294967296*sin(i)
    ''' </summary>
    Protected Shared ReadOnly T As UInteger() = New UInteger(63) {&Hd76aa478UI, &He8c7b756UI, &H242070db, &Hc1bdceeeUI, &Hf57c0fafUI, &H4787c62a, _
        &Ha8304613UI, &Hfd469501UI, &H698098d8, &H8b44f7afUI, &Hffff5bb1UI, &H895cd7beUI, _
        &H6b901122, &Hfd987193UI, &Ha679438eUI, &H49b40821, &Hf61e2562UI, &Hc040b340UI, _
        &H265e5a51, &He9b6c7aaUI, &Hd62f105dUI, &H2441453, &Hd8a1e681UI, &He7d3fbc8UI, _
        &H21e1cde6, &Hc33707d6UI, &Hf4d50d87UI, &H455a14ed, &Ha9e3e905UI, &Hfcefa3f8UI, _
        &H676f02d9, &H8d2a4c8aUI, &Hfffa3942UI, &H8771f681UI, &H6d9d6122, &Hfde5380cUI, _
        &Ha4beea44UI, &H4bdecfa9, &Hf6bb4b60UI, &Hbebfbc70UI, &H289b7ec6, &Heaa127faUI, _
        &Hd4ef3085UI, &H4881d05, &Hd9d4d039UI, &He6db99e5UI, &H1fa27cf8, &Hc4ac5665UI, _
        &Hf4292244UI, &H432aff97, &Hab9423a7UI, &Hfc93a039UI, &H655b59c3, &H8f0ccc92UI, _
        &Hffeff47dUI, &H85845dd1UI, &H6fa87e4f, &Hfe2ce6e0UI, &Ha3014314UI, &H4e0811a1, _
        &Hf7537e82UI, &Hbd3af235UI, &H2ad7d2bb, &Heb86d391UI}

    '****instance variables*************

    ''' <summary>
    ''' X used to proces data in 
    '''    512 bits chunks as 16 32 bit word
    ''' </summary>
    Protected X As UInteger() = New UInteger(15) {}

    ''' <summary>
    ''' the finger print obtained. 
    ''' </summary>
    Protected dgFingerPrint As Digest

    ''' <summary>
    ''' the input bytes
    ''' </summary>
    Protected m_byteInput As Byte()



    '*********************EVENTS AND DELEGATES******************************************


    Public Delegate Sub ValueChanging(sender As Object, Changing As MD5ChangingEventArgs)
    Public Delegate Sub ValueChanged(sender As Object, Changed As MD5ChangedEventArgs)


    Public Event OnValueChanging As ValueChanging
    Public Event OnValueChanged As ValueChanged



    '******************************************************************

    '**********************PROPERTIES **********************

    ''' <summary>
    '''gets or sets as string
    ''' </summary>
    Public Property Value() As String
        Get
            Dim st As String
            Dim tempCharArray As Char() = New [Char](m_byteInput.Length - 1) {}

            For i As Integer = 0 To m_byteInput.Length - 1
                tempCharArray(i) = CChar(m_byteInput(i))
            Next

            st = New [String](tempCharArray)
            Return st
        End Get
        Set
            ''' raise the event to notify the changing 
            RaiseEvent OnValueChanging(Me, New MD5ChangingEventArgs(value))


            m_byteInput = New Byte(value.Length - 1) {}
            For i As Integer = 0 To value.Length - 1
                m_byteInput(i) = CByte(value(i))
            Next
            dgFingerPrint = CalculateMD5Value()

            ''' raise the event to notify the change

            RaiseEvent OnValueChanged(Me, New MD5ChangedEventArgs(value, dgFingerPrint.ToString()))
        End Set
    End Property

    ''' <summary>
    ''' get/sets as byte array 
    ''' </summary>
    Public Property ValueAsByte() As Byte()
        Get
            Dim bt As Byte() = New Byte(m_byteInput.Length - 1) {}
            For i As Integer = 0 To m_byteInput.Length - 1
                bt(i) = m_byteInput(i)
            Next
            Return bt
        End Get
        Set
            ''' raise the event to notify the changing
            RaiseEvent OnValueChanging(Me, New MD5ChangingEventArgs(value))

            m_byteInput = New Byte(value.Length - 1) {}
            For i As Integer = 0 To value.Length - 1
                m_byteInput(i) = value(i)
            Next
            dgFingerPrint = CalculateMD5Value()


            ''' notify the changed value
            RaiseEvent OnValueChanged(Me, New MD5ChangedEventArgs(value, dgFingerPrint.ToString()))
        End Set
    End Property

    'gets the signature/figner print as string
    Public ReadOnly Property FingerPrint() As String
        Get
            Return dgFingerPrint.ToString()
        End Get
    End Property


    '***********************************************************************

    ''' <summary>
    ''' Constructor
    ''' </summary>
    Public Sub New()
        Value = ""
    End Sub


    '****************************************************************************

    '********************METHODS*************************


    ''' <summary>
    ''' calculat md5 signature of the string in Input
    ''' </summary>
    ''' <returns> Digest: the finger print of msg</returns>
    Protected Function CalculateMD5Value() As Digest
        '**********vairable declaration*************

        Dim bMsg As Byte()
        'buffer to hold bits
        Dim N As UInteger
        'N is the size of msg as word (32 bit) 
        Dim dg As New Digest()
        ' the value to be returned
        ' create a buffer with bits padded and length is alos padded
        bMsg = CreatePaddedBuffer()

        N = CUInt(bMsg.Length * 8) / 32
        'no of 32 bit blocks
        For i As UInteger = 0 To N / 16 - 1
            CopyBlock(bMsg, i)
            PerformTransformation(dg.A, dg.B, dg.C, dg.D)
        Next
        Return dg
    End Function

    '*******************************************************
' * TRANSFORMATIONS : FF , GG , HH , II acc to RFC 1321
' * where each Each letter represnets the aux function used
' ********************************************************




    ''' <summary>
    ''' perform transformatio using f(((b&c) | (~(b)&d))
    ''' </summary>
    Protected Sub TransF(ByRef a As UInteger, b As UInteger, c As UInteger, d As UInteger, k As UInteger, s As UShort, _
        i As UInteger)
        a = b + MD5Helper.RotateLeft((a + ((b And c) Or (Not (b) And d)) + X(k) + T(i - 1)), s)
    End Sub

    ''' <summary>
    ''' perform transformatio using g((b&d) | (c & ~d) )
    ''' </summary>
    Protected Sub TransG(ByRef a As UInteger, b As UInteger, c As UInteger, d As UInteger, k As UInteger, s As UShort, _
        i As UInteger)
        a = b + MD5Helper.RotateLeft((a + ((b And d) Or (c And Not d)) + X(k) + T(i - 1)), s)
    End Sub

    ''' <summary>
    ''' perform transformatio using h(b^c^d)
    ''' </summary>
    Protected Sub TransH(ByRef a As UInteger, b As UInteger, c As UInteger, d As UInteger, k As UInteger, s As UShort, _
        i As UInteger)
        a = b + MD5Helper.RotateLeft((a + (b Xor c Xor d) + X(k) + T(i - 1)), s)
    End Sub

    ''' <summary>
    ''' perform transformatio using i (c^(b|~d))
    ''' </summary>
    Protected Sub TransI(ByRef a As UInteger, b As UInteger, c As UInteger, d As UInteger, k As UInteger, s As UShort, _
        i As UInteger)
        a = b + MD5Helper.RotateLeft((a + (c Xor (b Or Not d)) + X(k) + T(i - 1)), s)
    End Sub



    ''' <summary>
    ''' Perform All the transformation on the data
    ''' </summary>
    ''' <param name="A">A</param>
    ''' <param name="B">B </param>
    ''' <param name="C">C</param>
    ''' <param name="D">D</param>
    Protected Sub PerformTransformation(ByRef A As UInteger, ByRef B As UInteger, ByRef C As UInteger, ByRef D As UInteger)
        '''/ saving ABCD to be used in end of loop

        Dim AA As UInteger, BB As UInteger, CC As UInteger, DD As UInteger

        AA = A
        BB = B
        CC = C
        DD = D

        ' Round 1 
' * [ABCD 0 7 1] [DABC 1 12 2] [CDAB 2 17 3] [BCDA 3 22 4]
' * [ABCD 4 7 5] [DABC 5 12 6] [CDAB 6 17 7] [BCDA 7 22 8]
' * [ABCD 8 7 9] [DABC 9 12 10] [CDAB 10 17 11] [BCDA 11 22 12]
' * [ABCD 12 7 13] [DABC 13 12 14] [CDAB 14 17 15] [BCDA 15 22 16]
' * * 

        TransF(A, B, C, D, 0, 7, _
            1)
        TransF(D, A, B, C, 1, 12, _
            2)
        TransF(C, D, A, B, 2, 17, _
            3)
        TransF(B, C, D, A, 3, 22, _
            4)
        TransF(A, B, C, D, 4, 7, _
            5)
        TransF(D, A, B, C, 5, 12, _
            6)
        TransF(C, D, A, B, 6, 17, _
            7)
        TransF(B, C, D, A, 7, 22, _
            8)
        TransF(A, B, C, D, 8, 7, _
            9)
        TransF(D, A, B, C, 9, 12, _
            10)
        TransF(C, D, A, B, 10, 17, _
            11)
        TransF(B, C, D, A, 11, 22, _
            12)
        TransF(A, B, C, D, 12, 7, _
            13)
        TransF(D, A, B, C, 13, 12, _
            14)
        TransF(C, D, A, B, 14, 17, _
            15)
        TransF(B, C, D, A, 15, 22, _
            16)
        '* rOUND 2
' **[ABCD 1 5 17] [DABC 6 9 18] [CDAB 11 14 19] [BCDA 0 20 20]
' *[ABCD 5 5 21] [DABC 10 9 22] [CDAB 15 14 23] [BCDA 4 20 24]
' *[ABCD 9 5 25] [DABC 14 9 26] [CDAB 3 14 27] [BCDA 8 20 28]
' *[ABCD 13 5 29] [DABC 2 9 30] [CDAB 7 14 31] [BCDA 12 20 32]
' 

        TransG(A, B, C, D, 1, 5, _
            17)
        TransG(D, A, B, C, 6, 9, _
            18)
        TransG(C, D, A, B, 11, 14, _
            19)
        TransG(B, C, D, A, 0, 20, _
            20)
        TransG(A, B, C, D, 5, 5, _
            21)
        TransG(D, A, B, C, 10, 9, _
            22)
        TransG(C, D, A, B, 15, 14, _
            23)
        TransG(B, C, D, A, 4, 20, _
            24)
        TransG(A, B, C, D, 9, 5, _
            25)
        TransG(D, A, B, C, 14, 9, _
            26)
        TransG(C, D, A, B, 3, 14, _
            27)
        TransG(B, C, D, A, 8, 20, _
            28)
        TransG(A, B, C, D, 13, 5, _
            29)
        TransG(D, A, B, C, 2, 9, _
            30)
        TransG(C, D, A, B, 7, 14, _
            31)
        TransG(B, C, D, A, 12, 20, _
            32)
        ' rOUND 3
' * [ABCD 5 4 33] [DABC 8 11 34] [CDAB 11 16 35] [BCDA 14 23 36]
' * [ABCD 1 4 37] [DABC 4 11 38] [CDAB 7 16 39] [BCDA 10 23 40]
' * [ABCD 13 4 41] [DABC 0 11 42] [CDAB 3 16 43] [BCDA 6 23 44]
' * [ABCD 9 4 45] [DABC 12 11 46] [CDAB 15 16 47] [BCDA 2 23 48]
' * 

        TransH(A, B, C, D, 5, 4, _
            33)
        TransH(D, A, B, C, 8, 11, _
            34)
        TransH(C, D, A, B, 11, 16, _
            35)
        TransH(B, C, D, A, 14, 23, _
            36)
        TransH(A, B, C, D, 1, 4, _
            37)
        TransH(D, A, B, C, 4, 11, _
            38)
        TransH(C, D, A, B, 7, 16, _
            39)
        TransH(B, C, D, A, 10, 23, _
            40)
        TransH(A, B, C, D, 13, 4, _
            41)
        TransH(D, A, B, C, 0, 11, _
            42)
        TransH(C, D, A, B, 3, 16, _
            43)
        TransH(B, C, D, A, 6, 23, _
            44)
        TransH(A, B, C, D, 9, 4, _
            45)
        TransH(D, A, B, C, 12, 11, _
            46)
        TransH(C, D, A, B, 15, 16, _
            47)
        TransH(B, C, D, A, 2, 23, _
            48)
        'ORUNF 4
' *[ABCD 0 6 49] [DABC 7 10 50] [CDAB 14 15 51] [BCDA 5 21 52]
' *[ABCD 12 6 53] [DABC 3 10 54] [CDAB 10 15 55] [BCDA 1 21 56]
' *[ABCD 8 6 57] [DABC 15 10 58] [CDAB 6 15 59] [BCDA 13 21 60]
' *[ABCD 4 6 61] [DABC 11 10 62] [CDAB 2 15 63] [BCDA 9 21 64]
' * 

        TransI(A, B, C, D, 0, 6, _
            49)
        TransI(D, A, B, C, 7, 10, _
            50)
        TransI(C, D, A, B, 14, 15, _
            51)
        TransI(B, C, D, A, 5, 21, _
            52)
        TransI(A, B, C, D, 12, 6, _
            53)
        TransI(D, A, B, C, 3, 10, _
            54)
        TransI(C, D, A, B, 10, 15, _
            55)
        TransI(B, C, D, A, 1, 21, _
            56)
        TransI(A, B, C, D, 8, 6, _
            57)
        TransI(D, A, B, C, 15, 10, _
            58)
        TransI(C, D, A, B, 6, 15, _
            59)
        TransI(B, C, D, A, 13, 21, _
            60)
        TransI(A, B, C, D, 4, 6, _
            61)
        TransI(D, A, B, C, 11, 10, _
            62)
        TransI(C, D, A, B, 2, 15, _
            63)
        TransI(B, C, D, A, 9, 21, _
            64)


        A = A + AA
        B = B + BB
        C = C + CC
        D = D + DD


    End Sub


    ''' <summary>
    ''' Create Padded buffer for processing , buffer is padded with 0 along 
    ''' with the size in the end
    ''' </summary>
    ''' <returns>the padded buffer as byte array</returns>
    Protected Function CreatePaddedBuffer() As Byte()
        Dim pad As UInteger
        'no of padding bits for 448 mod 512 
        Dim bMsg As Byte()
        'buffer to hold bits
        Dim sizeMsg As ULong
        '64 bit size pad
        Dim sizeMsgBuff As UInteger
        'buffer size in multiple of bytes
        Dim temp As Integer = (448 - ((m_byteInput.Length * 8) Mod 512))
        'temporary 

        pad = CUInt((temp + 512) Mod 512)
        'getting no of bits to be pad
        If pad = 0 Then
            '''pad is in bits
            pad = 512
        End If
        'at least 1 or max 512 can be added
        sizeMsgBuff = CUInt((m_byteInput.Length) + (pad / 8) + 8)
        sizeMsg = CULng(m_byteInput.Length) * 8
        bMsg = New Byte(sizeMsgBuff - 1) {}
        '''no need to pad with 0 coz new bytes 
        ' are already initialize to 0 :)



        '''/copying string to buffer 
        For i As Integer = 0 To m_byteInput.Length - 1
            bMsg(i) = m_byteInput(i)
        Next

        bMsg(m_byteInput.Length) = bMsg(m_byteInput.Length) Or &H80
        '''making first bit of padding 1,
        'wrting the size value
        For i As Integer = 8 To 1 Step -1
            bMsg(sizeMsgBuff - i) = CByte(sizeMsg >> ((8 - i) * 8) And &Hff)
        Next

        Return bMsg
    End Function


    ''' <summary>
    ''' Copies a 512 bit block into X as 16 32 bit words
    ''' </summary>
    ''' <param name="bMsg"> source buffer</param>
    ''' <param name="block">no of block to copy starting from 0</param>
    Protected Sub CopyBlock(bMsg As Byte(), block As UInteger)

        block = block << 6
        For j As UInteger = 0 To 60 Step 4

            X(j >> 2) = (CUInt(bMsg(block + (j + 3))) << 24) Or (CUInt(bMsg(block + (j + 2))) << 16) Or (CUInt(bMsg(block + (j + 1))) << 8) Or CUInt(bMsg(block + (j)))
        Next
    End Sub
End Class

'=======================================================
'Service provided by Telerik (www.telerik.com)
'Conversion powered by NRefactory.
'Twitter: @telerik
'Facebook: facebook.com/telerik
'=======================================================