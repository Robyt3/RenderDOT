<#
RenderDOT - Copyright (c) 2021 Robert Müller
-----------------------------------------------------------
Usage: powershell -File RenderDOT.ps1 example.dot
#>

Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -AssemblyName PresentationCore,PresentationFramework

if (-not $args[0] -or -not $args[0].EndsWith('.dot') -or -not (Test-Path $args[0] -PathType leaf)) {
	[System.Windows.MessageBox]::Show('First argument must be the path of an existing dot file.', 'Wrong argument.', [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error)
	return
}
$outputFile = New-TemporaryFile | Rename-Item -NewName { $_.Name -replace '.tmp','.png' } -PassThru
dot $args[0] -Tpng -o $outputFile.FullName
if (-not $?) {
	[System.Windows.MessageBox]::Show('Failed to run dot. Is dot available on the system path?', 'Running dot failed.', [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error)
	return
}

[System.Windows.Forms.Application]::EnableVisualStyles()
$screen = [System.Windows.Forms.Screen]::AllScreens[0]
$image = [System.Drawing.Image]::Fromfile($outputFile)
$form = New-Object Windows.Forms.Form
$form.Text = $args[0]
# Add extra space for scrollbars
$form.Width = (($image.Size.Width+16), $screen.WorkingArea.Width | Measure-Object -Minimum).Minimum
$form.Height = (($image.Size.Height+40), $screen.WorkingArea.Height | Measure-Object -Minimum).Minimum
$form.AutoScroll = $true
$pictureBox = New-Object Windows.Forms.PictureBox
$pictureBox.Width = $image.Size.Width
$pictureBox.Height = $image.Size.Height
$pictureBox.Image = $image
$form.Controls.add($pictureBox)
$form.Add_KeyDown({
	if ($_.KeyCode -eq "Escape") {
		$form.Close()
	}
	if ($_.Control) {
		if ($_.KeyCode -eq "C") {
			[System.Windows.Forms.Clipboard]::SetImage($image);
		}
		if ($_.KeyCode -eq "E") {
			Start-Process $outputFile
		}
	}
})
$form.KeyPreview = $true
$form.Add_Shown({ $form.Activate() })
$form.ShowDialog()