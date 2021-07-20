# RenderDOT

`RenderDOT.ps1` is a Powershell script that renders a Graphviz DOT file as a PNG image and displays the image in a simple window with zoom controls.

In order to completely hide the Powershell console window, the file extension is associated with the `PsRunArg.vbs` script, which launches an invisible Powershell instance. The PsRunArg script was adapted from [PsRun](https://github.com/gbuktenica/PsRun).

## Install

Install [Graphviz](https://graphviz.org/), so the command `dot` is available on the system path.

Download this repository as a ZIP file and extract it into a new folder at a permanent location, or `git clone` the repository at a location of choice.

Run `INSTALL.cmd` as admin and follow the instructions. The install script just calls `assoc` and `ftype` to create the file associations. Note that Windows 10 will still require consent from the user before the program is actually used as default. After running the install script, double click the `example.dot` file, check the checkbox to always use the Script Host for DOT files and confirm opening the file.

## Usage

After installing, you should be able to double click a DOT file to open a simple image viewer with default zoom hotkeys.

The following additional **hotkeys** are available:

- Ctrl + S: save the rendered image to a file
- Ctrl + C: copy the rendered image into the clipboard
- Ctrl + E: open the rendered image in the default external viewer
- Esc: Close viewer

## Upgrade

Replace the old files with the new files, after downloading the latest ZIP file. If you've installed using `git clone`, you can just use `git pull` to update.

It's not necessary to run `INSTALL.cmd` again, unless the file association is missing or broken. You may need to do this after Windows 10 upgrades, as they may reset the file association for DOT files back to its default.

## Uninstall

Delete the folder.

Select a different application to open dot files with, if you previously had one.