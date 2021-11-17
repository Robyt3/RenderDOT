@echo off
echo ##### RenderDOT - uninstall #####
echo.
echo Make sure to run this uninstall script with admin privileges.
echo.
echo Press any key to remove the .gv and .dot file associations...
pause >nul
echo.
ftype dotgraphfile= >nul
if ERRORLEVEL 1 goto failed
assoc .gv= >nul
if ERRORLEVEL 1 goto failed
assoc .dot= >nul
if ERRORLEVEL 1 goto failed

:uninstalled
echo.
echo Uninstalled successfully.
echo Now close this console window and manually delete the folder %~dp0
goto quit

:failed
echo.
echo Failed to delete file associations.
echo Make sure to run this uninstall script with admin privileges.
goto quit

:quit
echo.
echo Press any key to quit...
pause >nul
exit
