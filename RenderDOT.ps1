<#
RenderDOT - Copyright (c) 2021 Robert Müller
-----------------------------------------------------------
Usage: powershell -File RenderDOT.ps1 example.dot
#>

Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -AssemblyName PresentationCore,PresentationFramework

if (-not $args[0] -or -not $args[0].EndsWith('.dot') -or -not (Test-Path $args[0] -PathType leaf)) {
	[System.Windows.MessageBox]::Show('First argument must be the path of an existing dot file.', 'Wrong argument.',
		[System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error) | Out-Null
	return
}
$outputFile = New-TemporaryFile | Rename-Item -NewName { $_.Name -replace '.tmp','.png' } -PassThru
dot $args[0] -Tpng -o $outputFile.FullName
if (-not $?) {
	[System.Windows.MessageBox]::Show('Failed to run dot. Is dot available on the system path?', 'Running dot failed.',
		[System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error)  | Out-Null
	return
}
$dotFile = Get-Item $args[0]

[System.Windows.Forms.Application]::EnableVisualStyles()
$screen = [System.Windows.Forms.Screen]::AllScreens[0]
$image = [System.Drawing.Image]::Fromfile($outputFile)
$form = New-Object Windows.Forms.Form -Property @{
	Text = $args[0]
	# Add extra space for scrollbars
	Width = (($image.Size.Width+16), $screen.WorkingArea.Width | Measure-Object -Minimum).Minimum
	Height = (($image.Size.Height+40), $screen.WorkingArea.Height | Measure-Object -Minimum).Minimum
	AutoScroll = $true
}
$pictureBox = New-Object Windows.Forms.PictureBox -Property @{
	Width = $image.Size.Width
	Height = $image.Size.Height
	Image = $image
}
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
			Start-Process $outputFile | Out-Null
		}
		if ($_.KeyCode -eq "S") {
			$saveDialog = New-Object System.Windows.Forms.SaveFileDialog -Property @{
				InitialDirectory = $dotFile.Directory
				FileName = $dotFile.BaseName
				Filter = "PNG (*.png)|*.png"
			}
			if ($saveDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
				$image.save($saveDialog.FileName)
			}
		}
	}
})
$form.KeyPreview = $true
$form.Add_Shown({ $form.Activate() })
$form.ShowDialog() | Out-Null