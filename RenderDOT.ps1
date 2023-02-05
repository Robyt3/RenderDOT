<#
RenderDOT - Copyright (c) 2021 - 2023 Robert Müller
-----------------------------------------------------------
Usage: powershell -File RenderDOT.ps1 example.dot
#>

Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -AssemblyName PresentationCore,PresentationFramework

if (-not $args[0] -or -not (Test-Path $args[0] -PathType leaf)) {
	[System.Windows.MessageBox]::Show('First argument must be the path of an existing file.', 'Wrong argument.',
		[System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error) | Out-Null
	return
}
$script:input = $args[0];
$outputFile = New-TemporaryFile | Rename-Item -NewName { $_.Name -replace '.tmp','.png' } -PassThru
try {
	$dotOutput = & dot $script:input -Tpng -o $outputFile.FullName 2>&1
} catch {
	[System.Windows.MessageBox]::Show('Failed to run dot. Is dot available on the system path?', 'Running dot failed.',
		[System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error) | Out-Null
	return
}
if ($dotOutput) {
	[System.Windows.MessageBox]::Show($dotOutput, 'Errors in dot graph file.',
		[System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error) | Out-Null
	return
}
$dotFile = Get-Item $script:input

[System.Windows.Forms.Application]::EnableVisualStyles()
$screen = [System.Windows.Forms.Screen]::AllScreens[0]
$image = [System.Drawing.Image]::Fromfile($outputFile)
# Add extra space for scrollbars
$FormWidth = (($image.Size.Width+34), $screen.WorkingArea.Width | Measure-Object -Minimum).Minimum
$FormHeight = (($image.Size.Height+56), $screen.WorkingArea.Height | Measure-Object -Minimum).Minimum
$form = New-Object Windows.Forms.Form -Property @{
	Text = $script:input
	Width = $FormWidth
	Height = $FormHeight
}
if (($FormWidth -ge $screen.WorkingArea.Width) -and ($FormHeight -ge $screen.WorkingArea.Height)) {
	$form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized
}
$browser = New-Object System.Windows.Forms.WebBrowser -Property @{
	DocumentText = '<html><body style="margin:0;padding:0;overflow:scroll"><img src="' + $outputFile + '"></body></html>'
	Width = $image.Size.Width
	Height = $image.Size.Height
	Dock = [System.Windows.Forms.DockStyle]::Fill
	IsWebBrowserContextMenuEnabled = $False
	AllowNavigation = $False
	AllowWebBrowserDrop = $False
}
$form.Controls.add($browser)
$browser.Add_PreviewKeyDown({
	if ($_.KeyCode -eq "Escape") {
		$form.Close()
	}
	if ($_.Control) {
		if ($_.KeyCode -eq "C") {
			[System.Windows.Forms.Clipboard]::SetImage($image);
		}
		if ($_.KeyCode -eq "E") {
			Start-Process $outputFile | Out-Null
		}
		if ($_.KeyCode -eq "S") {
			$saveDialog = New-Object System.Windows.Forms.SaveFileDialog -Property @{
				InitialDirectory = $dotFile.Directory
				FileName = $dotFile.BaseName
				Filter = "Portable Document Format (*.pdf)|*.pdf|Scalable Vector Graphics (*.svg)|*.svg|Portable Network Graphics (*.png)|*.png"
			}
			if ($saveDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
				if ($saveDialog.FileName.EndsWith(".pdf")) {
					dot $script:input -Tpdf -Gmargin=0 -o $saveDialog.FileName
				}
				if ($saveDialog.FileName.EndsWith(".svg")) {
					dot $script:input -Tsvg -Gmargin=0 -o $saveDialog.FileName
				}
				if ($saveDialog.FileName.EndsWith(".png")) {
					$image.save($saveDialog.FileName)
				}
			}
		}
	}
	# Translate numpad 0, because WebBrowser does not support it
	if ($_.KeyCode -eq "NumPad0") {
		[System.Windows.Forms.SendKeys]::Send("0")
	}
	# Only forward zoom control key events to WebBrowser
	if (-not (@("ControlKey", "Oemplus", "OemMinus", "D0", "Add", "Subtract") -contains $_.KeyCode)) {
		$_.IsInputKey = $True
	}
})
$form.KeyPreview = $true
$form.Add_Shown({ $form.Activate() })
$form.ShowDialog() | Out-Null