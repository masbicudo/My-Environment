// criando banco de dados

conn = new ActiveXObject("ADODB.Connection");
conn.Open("Provider=SQLOLEDB.1;Data Source=MIGUELANGELO-NB\\SQL2008R2; Integrated Security=SSPI;");

try {
    command = new ActiveXObject("ADODB.Command");
    command.ActiveConnection = conn;
    
    command.CommandText = "     \
        CREATE DATABASE TestDb  \
    ";
    command.Execute();

    command.CommandText = "     \
        USE TestDb;             \
        CREATE TABLE Pessoas    \
        (                       \
            id int NOT NULL,    \
            nome varchar(max),  \
            PRIMARY KEY (id)    \
        );                      \
    ";
    command.Execute();

    command.CommandText = "USE TestDb; INSERT INTO Pessoas (id,nome) VALUES (0, 'Miguel');";
    command.Execute();

    command.CommandText = "USE TestDb; INSERT INTO Pessoas (id,nome) VALUES (1, 'Angelo');";
    command.Execute();

    command.CommandText = "USE TestDb; INSERT INTO Pessoas (id,nome) VALUES (2, 'Santos');";
    command.Execute();

    command.CommandText = "USE TestDb; INSERT INTO Pessoas (id,nome) VALUES (3, 'Bicudo');";
    command.Execute();
}
catch (ex) {
    
} finally {
    conn.Close();
}

// lendo o banco de dados

conn = new ActiveXObject("ADODB.Connection");
conn.Open("Provider=SQLOLEDB.1;Data Source=MIGUELANGELO-NB\\SQL2008R2; Initial Catalog=TestDb; Integrated Security=SSPI;");

var set = new ActiveXObject("ADODB.Recordset")

var fso = new ActiveXObject("Scripting.FileSystemObject");
var ForWriting = 2;
var file = fso.OpenTextFile("saida.txt", ForWriting, true);

set.Open("SELECT * FROM Pessoas;", conn);
while (!set.EOF) {
    var id = set("id");
    var nome = set("nome");
    file.WriteLine("id = " + id + "; nome = " + nome);
    set.MoveNext();
}

set.Close();
conn.Close();
file.Close();
