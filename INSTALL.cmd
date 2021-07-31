@echo off
echo ##### RenderDOT #####
echo.
echo Checking availability of Graphviz dot application on the system path:
dot -V
if ERRORLEVEL 9009 echo Graphviz must be installed separately, with the dot application on the system path.
echo.
echo This script associates .dot files with a VBS script, which launches the actual
echo RenderDOT Powershell without opening any console windows.
echo.
echo Make sure to run this install script with admin privileges.
echo.
echo Current folder: %~dp0
echo Press any key to install with the current folder location...
pause >nul
echo.
ftype dotgraphfile=wscript.exe "%~dp0PsRunArg.vbs" "%~dp0RenderDOT.ps1" "%%1"
assoc .dot=dotgraphfile
echo.
echo Double click the example.dot file and select the checkbox
echo to always open .dot files with the Windows Script Host.
pause >nul
exit
