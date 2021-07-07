# RenderDOT

`RenderDOT.ps1` is a Powershell script that renders a Graphviz DOT file as a PNG image and displays the image in a simple window.

In order to completely hide the Powershell console window, the file extension is associated with the `PsRunArg.vbs` script, which launches an invisible Powershell instance. The PsRunArg script was adapted from [PsRun](https://github.com/gbuktenica/PsRun).

## Install

Install [Graphviz](https://graphviz.org/) on the system path.

Download this repository as a ZIP file and extract it into a new folder at a permanent location.

Run `INSTALL.cmd` as admin and follow the instructions. The install script just calls `assoc` and `ftype`. Note that Windows 10 will still require consent from the user before the program is actually used as default. After running the install script, double click the `example.dot` file and check the checkbox to always use the Script Host for dot files.

## Usage

After installing, you should be able to double click a dot file to open a simple image viewer.

The following **hotkeys** are available:

- Ctrl + S: save the rendered image to a file
- Ctrl + C: copy the rendered image into the clipboard
- Ctrl + E: open the rendered image in the default external viewer
- Esc: Close viewer

## Uninstall

Delete the folder.

Select a different application to open dot files with, if you previously had one.