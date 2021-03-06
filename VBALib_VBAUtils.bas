Attribute VB_Name = "VBALib_VBAUtils"
' Common VBA Library - VBAUtils
' Provides useful functions for manipulating the VBA project object model.
' @reference Microsoft Visual Basic for Applications Extensibility 5.3
' (C:\Program Files\Common Files\Microsoft Shared\vba\VBA6\VBE6.DLL)

Option Explicit

' Determines whether a VBA code module with a given name exists.
' @param wb: The workbook to check for the given module name (defaults to the
' active workbook).
Public Function ModuleExists(moduleName As String, Optional wb As Workbook) _
    As Boolean
    
    If wb Is Nothing Then Set wb = ActiveWorkbook
    Dim c As Variant ' VBComponent
    
    On Error GoTo notFound
    Set c = wb.VBProject.VBComponents.Item(moduleName)
    ModuleExists = True
    Exit Function
    
notFound:
    ModuleExists = False
End Function

' Removes the VBA code module with the given name.
' @param wb: The workbook to remove the module from (defaults to the active
' workbook).
Public Sub RemoveModule(moduleName As String, Optional wb As Workbook)
    If wb Is Nothing Then Set wb = ActiveWorkbook
    If Not ModuleExists(moduleName, wb) Then
        Err.Raise 32000, Description:= _
            "Module '" & moduleName & "' not found."
    End If
    Dim c As Variant ' VBComponent
    Set c = wb.VBProject.VBComponents.Item(moduleName)
    wb.VBProject.VBComponents.Remove c
    
    ' Sometimes the line above does not remove the module successfully.  When
    ' this happens, c.Name does not return an error - otherwise it does.
    On Error GoTo nameError
    Dim n As String
    n = c.Name
    On Error GoTo 0
    Err.Raise 32000, Description:= _
        "Failed to remove module '" & moduleName & "'.  Try again later."
    
nameError:
    ' Everything worked fine (the module was removed)
End Sub

' Exports a VBA code module to a text file.
' @param wb: The workbook that contains the module to export (defaults to the
' active workbook).
Public Sub ExportModule(moduleName As String, moduleFilename As String, _
    Optional wb As Workbook)
    
    If wb Is Nothing Then Set wb = ActiveWorkbook
    If Not ModuleExists(moduleName, wb) Then
        Err.Raise 32000, Description:= _
            "Module '" & moduleName & "' not found."
    End If
    wb.VBProject.VBComponents.Item(moduleName).Export moduleFilename
End Sub

' Imports a VBA code module from a text file.
' @param wb: The workbook that will receive the imported module (defaults to
' the active workbook).
Public Function ImportModule(moduleFilename As String, _
    Optional wb As Workbook) As VBComponent
    
    If wb Is Nothing Then Set wb = ActiveWorkbook
    Set ImportModule = wb.VBProject.VBComponents.Import(moduleFilename)
End Function
