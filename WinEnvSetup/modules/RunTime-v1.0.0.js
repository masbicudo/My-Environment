function jsimport(fileName){
    var jsimportMap = jsimport.items = jsimport.items || {};
    
    var W=WScript;
    var M=W.CreateObject("Scripting.FileSystemObject");
    var I=VBImport_Items;
    
    if (jsimportMap[fileName]) return jsimportMap[fileName];
    
    var fso = W.CreateObject("Scripting.FileSystemObject");
    var fileName = fso.BuildPath(fso.GetFile(W.ScriptFullName).ParentFolder, fileName);
    
    var fileStream = fso.OpenTextFile(fileName, 1 /*ForReading*/);
    try {
        var _export = evalImport(fileStream.ReadAll());
        jsimportMap[fileName] = _export;
        return _export;
    }
    finally{ fileStream.close(); }
}
function evalImport(s){
    var _export = {};
    eval(s);
    return _export;
}
