@echo off
echo ##### RenderDOT - install #####
echo.
echo Checking availability of Graphviz dot application on the system path:
dot -V
if ERRORLEVEL 9009 (
	echo NOTE: Graphviz must be installed separately, with the dot application on the system path.
)
echo.
echo This script associates .gv and .dot files with a VBS script, which launches the actual
echo RenderDOT Powershell without opening any console windows.
echo.
echo Make sure to run this install script with admin privileges.
echo.
echo Current folder: %~dp0
echo Press any key to install with the current folder location...
pause >nul
echo.

ftype dotgraphfile=wscript.exe "%~dp0PsRunArg.vbs" "%~dp0RenderDOT.ps1" "%%1" >nul
if ERRORLEVEL 1 goto failed
assoc .gv=dotgraphfile >nul
if ERRORLEVEL 1 goto failed
assoc .dot=dotgraphfile >nul
if ERRORLEVEL 1 goto failed

:installed
echo.
echo Installed successfully.
echo Double click the example.gv file and select the checkbox
echo to always open .gv files with the Windows Script Host.
goto quit

:failed
echo.
echo Failed to create file associations.
echo Make sure to run this install script with admin privileges.
goto quit

:quit
echo.
echo Press any key to quit...
pause >nul
exit
