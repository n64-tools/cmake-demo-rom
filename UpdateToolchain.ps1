
$filepath = "$PSScriptRoot/temp/"
New-Item -ItemType Directory -Force -Path $filepath

$url = "https://github.com/n64-tools/libdragon/releases/download/develop-dragonminded-windows-tools-latest/libdragon-library.zip"
$output = "$PSScriptRoot/temp/libdragon.zip"
$destination = "$PSScriptRoot/toolchain/libdragon/"

if (Test-Path $output) 
{
    Remove-Item -LiteralPath $output -Force -Recurse
}
Write-Host "Downloading Libdragon..."
(New-Object Net.WebClient).Downloadfile($url , $output)

if (Test-Path $destination) 
{
    Remove-Item -LiteralPath $destination -Force -Recurse
}
Expand-Archive -Force -Path $output -DestinationPath $destination
Write-Host "Downloaded Libdragon successfully."

$url = "https://github.com/n64-tools/libdragon/releases/download/develop-dragonminded-windows-tools-latest/libdragon-tools-win_x86_64.zip"
$output = "$PSScriptRoot/temp/libdragon-tools.zip"
$destination = "$PSScriptRoot/toolchain/libdragon/"

if (Test-Path $output) 
{
    Remove-Item -LiteralPath $output -Force -Recurse
}
Write-Host "Downloading Libdragon tools..."
(New-Object Net.WebClient).Downloadfile($url , $output)

# if (Test-Path $destination) 
# {
#     Remove-Item -LiteralPath $destination -Force -Recurse
# }
Expand-Archive -Force -Path $output -DestinationPath $destination
Write-Host "Downloaded Libdragon tools successfully."

$url = "https://github.com/n64-tools/gcc-toolchain-mips64/releases/download/latest/gcc-toolchain-mips64-win64.zip"
$output = "$PSScriptRoot/temp/gcc-toolchain-mips64.zip"
$destination = "$PSScriptRoot/toolchain/gcc-toolchain-mips64/"

if (Test-Path $output) 
{
    Remove-Item -LiteralPath $output -Force -Recurse
}
Write-Host "Downloading GCC..."
(New-Object Net.WebClient).Downloadfile($url , $output)
if (Test-Path $destination) 
{
    Remove-Item -LiteralPath $destination -Force -Recurse
}
Expand-Archive -Force -Path $output -DestinationPath $destination
Write-Host "Downloaded GCC Toolchain successfully."

$url = "https://github.com/ninja-build/ninja/releases/latest/download/ninja-win.zip"
$output = "$PSScriptRoot/temp/ninja.zip"
$destination = "$PSScriptRoot/tools/"

if (Test-Path $output) 
{
    Remove-Item -LiteralPath $output -Force -Recurse
}
Write-Host "Downloading Ninja-Build..."
(New-Object Net.WebClient).Downloadfile($url , $output)
if (Test-Path $destination) 
{
    Remove-Item -LiteralPath $destination -Force -Recurse
}
Expand-Archive -Force -Path $output -DestinationPath $destination
Write-Host "Downloaded Ninja-Build successfully."

$filepath = "$PSScriptRoot/temp/"
if (Test-Path $filepath) 
{
    Remove-Item -LiteralPath $filepath -Force -Recurse
}
Write-Host "Finished cleanup of temp directories.."

Write-Host "Toolchain install completed sucessfully."
