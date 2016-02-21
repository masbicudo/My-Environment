Imports EnvDTE
Imports EnvDTE80
Imports Microsoft.VisualBasic

Public Class C
    Implements VisualCommanderExt.ICommand

    Sub Run(DTE As EnvDTE80.DTE2, package As Microsoft.VisualStudio.Shell.Package) Implements VisualCommanderExt.ICommand.Run
        InsertGuid(DTE)
    End Sub

    Sub InsertGuid(DTE As EnvDTE80.DTE2)
        Dim objTextSelection As TextSelection
        objTextSelection = CType(DTE.ActiveDocument.Selection(), EnvDTE.TextSelection)
        objTextSelection.Text = System.Guid.NewGuid.ToString.ToUpper(System.Globalization.CultureInfo.InvariantCulture)
    End Sub

End Class
