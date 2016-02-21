' criando banco de dados

Set conn = CreateObject("ADODB.Connection")
conn.Open "Provider=SQLOLEDB.1;Data Source=MIGUELANGELO-NB\SQL2008R2; Integrated Security=SSPI;"

On Error Resume Next
    Set command = CreateObject("ADODB.Command")
    command.ActiveConnection = conn
    
    command.CommandText = "CREATE DATABASE TestDb"
    command.Execute()
    If Err.Number = 0 Then

        command.CommandText = "     " &_
        "   USE TestDb;             " &_
        "   CREATE TABLE Pessoas    " &_
        "   (                       " &_
        "       id int NOT NULL,    " &_
        "       nome varchar(max),  " &_
        "       PRIMARY KEY (id)    " &_
        "   );                      "
        command.Execute()

        If Err.Number = 0 Then

            command.CommandText = "USE TestDb; INSERT INTO Pessoas (id,nome) VALUES (0, 'Miguel');"
            command.Execute()

            command.CommandText = "USE TestDb; INSERT INTO Pessoas (id,nome) VALUES (1, 'Angelo');"
            command.Execute()

            command.CommandText = "USE TestDb; INSERT INTO Pessoas (id,nome) VALUES (2, 'Santos');"
            command.Execute()

            command.CommandText = "USE TestDb; INSERT INTO Pessoas (id,nome) VALUES (3, 'Bicudo');"
            command.Execute()

        End If
    End If
On Error Goto 0
conn.Close()

' lendo o banco de dados

Set conn = CreateObject("ADODB.Connection")
conn.Open "Provider=SQLOLEDB.1;Data Source=MIGUELANGELO-NB\SQL2008R2; Initial Catalog=TestDb; Integrated Security=SSPI;"

Set rs = CreateObject("ADODB.Recordset")

Set fso = CreateObject("Scripting.FileSystemObject")
const ForWriting = 2
Set file = fso.OpenTextFile("saida.txt", ForWriting, True)

rs.Open "SELECT * FROM Pessoas;", conn
While Not rs.EOF
    id = rs("id")
    nome = rs("nome")
    file.WriteLine "id = " & id & "; nome = " & nome
    rs.MoveNext()
Wend

rs.Close()
conn.Close()
file.Close()
