$variantsfile = "$PSScriptRoot\cmake-variants.json"
$settingsfile = "$PSScriptRoot\.vscode\settings.json"
$launchfile = "$PSScriptRoot\.vscode\launch.json"

$find = "FIX_THIS_PATH"
$replace = $PSScriptRoot -replace '\\', '/'

Write-Output "Editing cmake-variants.json"

$filePath = $variantsfile
$tempFilePath = "$env:TEMP\$($filePath | Split-Path -Leaf)"

(Get-Content -Path $filePath) -replace $find, $replace | Add-Content -Path $tempFilePath

Remove-Item -Path $filePath
Move-Item -Path $tempFilePath -Destination $filePath

Write-Output "Done.`r`n"

Write-Output "Editing .vscode\settings.json"

$filePath = $settingsfile
$tempFilePath = "$env:TEMP\$($filePath | Split-Path -Leaf)"

(Get-Content -Path $filePath) -replace $find, $replace | Add-Content -Path $tempFilePath

Remove-Item -Path $filePath
Move-Item -Path $tempFilePath -Destination $filePath

Write-Output "Done.`r`n"

Write-Output "Editing .vscode\launch.json"

$filePath = $launchfile
$tempFilePath = "$env:TEMP\$($filePath | Split-Path -Leaf)"

(Get-Content -Path $filePath) -replace $find, $replace | Add-Content -Path $tempFilePath

Remove-Item -Path $filePath
Move-Item -Path $tempFilePath -Destination $filePath

Write-Output "Done.`r`n"

Write-Output "File paths updated.`r`n"

$previousForegroundColor = $host.UI.RawUI.ForegroundColor
$previousBackgroundColor = $host.UI.RawUI.BackgroundColor

$host.ui.RawUI.ForegroundColor = "Yellow"
$host.UI.RawUI.BackgroundColor = "Black"
Write-Output "If CMake is not installed to 'C:\Program Files\CMake' `r`nyou must manually update the location in .vscode\settings.json accordingly"


$host.UI.RawUI.ForegroundColor = $previousForegroundColor
$host.UI.RawUI.BackgroundColor = $previousBackgroundColor