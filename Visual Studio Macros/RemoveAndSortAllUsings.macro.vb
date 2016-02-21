Imports EnvDTE
Imports EnvDTE80
Imports Microsoft.VisualBasic

Public Class M
    Implements VisualCommanderExt.ICommand

    Sub Run(DTE As EnvDTE80.DTE2, package As Microsoft.VisualStudio.Shell.Package) Implements VisualCommanderExt.ICommand.Run
        OrganizeSolution(DTE)
    End Sub

    Sub OrganizeSolution(DTE As EnvDTE80.DTE2)
        Dim sol As Solution = DTE.Solution
        For i As Integer = 1 To sol.Projects.Count-1
            OrganizeProject(DTE, sol.Projects.Item(i))
        Next
    End Sub

    Private Sub OrganizeProject(DTE As EnvDTE80.DTE2, ByVal proj As Project)
        For i As Integer = 1 To proj.ProjectItems.Count
            OrganizeProjectItem(DTE, proj.ProjectItems.Item(i))
        Next
    End Sub

    Private Sub OrganizeProjectItem(DTE As EnvDTE80.DTE2, ByVal projectItem As ProjectItem)
        Dim fileIsOpen As Boolean = False
        If projectItem.Kind = EnvDTE.Constants.vsProjectItemKindPhysicalFile Then
            'If this is a c# file             
            If projectItem.Name.LastIndexOf(".cs") = projectItem.Name.Length - 3 Then
                'Set flag to true if file is already open                 
                fileIsOpen = projectItem.IsOpen
                Dim window As Window = projectItem.Open(EnvDTE.Constants.vsViewKindCode)
                window.Activate()
                projectItem.Document.DTE.ExecuteCommand("Edit.RemoveAndSort")
                'Only close the file if it was not already open                 
                If Not fileIsOpen Then
                    window.Close(vsSaveChanges.vsSaveChangesYes)
                End If
            End If
        End If
        'Be sure to apply RemoveAndSort on all of the ProjectItems.         
        If Not projectItem.ProjectItems Is Nothing Then
            For i As Integer = 1 To projectItem.ProjectItems.Count
                OrganizeProjectItem(DTE, projectItem.ProjectItems.Item(i))
            Next
        End If
        'Apply RemoveAndSort on a SubProject if it exists.         
        If Not projectItem.SubProject Is Nothing Then
            OrganizeProject(DTE, projectItem.SubProject)
        End If
    End Sub

End Class
