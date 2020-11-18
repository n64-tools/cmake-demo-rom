
$filepath = "$PSScriptRoot/temp/"
New-Item -ItemType Directory -Force -Path $filepath

$url = "https://n64tools.blob.core.windows.net/binaries/N64-tools/libdragon/develop/latest/libdragon-win64.zip"
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

$url = "https://n64tools.blob.core.windows.net/binaries/N64-tools/mips64-gcc-toolchain/master/latest/gcc-toolchain-mips64-win64.zip"
$output = "$PSScriptRoot/temp/gcc-toolchain-mips64.zip"
$tempdestination = "$PSScriptRoot/temp/gcc-toolchain-mips64/"
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
Expand-Archive -Force -Path $output -DestinationPath $tempdestination

Move-Item -Path "$tempdestination/gcc-toolchain-mips64-win64" -Destination "$destination"
Write-Host "Downloaded GCC Toolchain successfully."

$url = "https://github.com/ninja-build/ninja/releases/download/v1.10.1/ninja-win.zip"
$output = "$PSScriptRoot/temp/ninja-win.zip"
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
