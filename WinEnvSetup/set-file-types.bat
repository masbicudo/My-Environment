
:: Associating `.nupkg` files with the same program that is associated with `.zip`
assoc .nuspec=NuGet.Specification
ftype NuGet.Specification="C:\Program Files (x86)\Notepad++\notepad++.exe" %1

FOR /F "usebackq tokens=1-2 delims==" %%L IN (
    `assoc .zip`
) DO assoc .nupkg=%%M
