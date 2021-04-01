' SYNOPSIS
'   Run a PowerShell script with arguments in the user context without a script window being displayed.
' EXAMPLE
'   wscript.exe PsRunArg.vbs Run-Script.ps1 42 "Arg 2"
' AUTHOR
'   Glen Buktenica - (MIT Licence, see https://github.com/gbuktenica/PsRun)
'   Robert Müller - adapted to accept program arguments instead of multiple PS files

Set objShell = CreateObject("Wscript.Shell")
ReDim args(WScript.Arguments.Count-1)
For i = 0 To WScript.Arguments.Count-1
  args(i) = """"+WScript.Arguments(i)+""""
Next

Dim PsPath
Set fso = CreateObject("Scripting.FileSystemObject")
If fso.FileExists("C:\Program Files\PowerShell\7\pwsh.exe") Then
    PsPath="""C:\Program Files\PowerShell\7\pwsh.exe"""
ElseIf fso.FileExists("C:\Program Files\PowerShell\7-preview\pwsh.exe") Then
    PsPath="""C:\Program Files\PowerShell\7-preview\pwsh.exe"""
ElseIf fso.FileExists("C:\Program Files\PowerShell\6\pwsh.exe") Then
    PsPath="""C:\Program Files\PowerShell\6\pwsh.exe"""
Else
    PsPath="""C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"""
End If

Dim PSRun
PSRun = PsPath & " -WindowStyle hidden -ExecutionPolicy bypass -NonInteractive -File " & join(args)
objShell.Run(PSRun), 0