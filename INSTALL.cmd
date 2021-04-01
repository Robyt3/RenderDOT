@echo off
echo ##### RenderDOT #####
echo.
echo This script associates .dot files with a VBS script, which launches the actual
echo RenderDOT Powershell without opening any console windows.
echo.
echo Make sure to run this install script as admin.
echo.
echo Press any key to install with the current folder location...
pause >nul
echo.
ftype dotgraphfile=wscript.exe "%~dp0PsRunArg.vbs" "%~dp0RenderDOT.ps1" "%%1"
assoc .dot=dotgraphfile
echo.
echo Double click the example.dot file and select the checkbox
echo to always open dot files with the Windows Script Host.
echo The Graphviz dot application must be available on the system path.
pause >nul
exit