
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



$url = "https://www.cen64.com/uploads/stable/cen64-windows-x86_64.exe"
$url2 = "https://cen64.com/uploads/stable/OpenAL32.dll"
$output = "$PSScriptRoot/temp/cen64-windows-x86_64.exe"
$output2 = "$PSScriptRoot/temp/OpenAL32.dll"
$destination = "$PSScriptRoot/tools/cen64/"

if (Test-Path $output) 
{
    Remove-Item -LiteralPath $output -Force -Recurse
}
Write-Host "Downloading Cen64 Emulator..."
(New-Object Net.WebClient).Downloadfile($url , $output)
(New-Object Net.WebClient).Downloadfile($url2 , $output2)
if (Test-Path $destination) 
{
    Remove-Item -LiteralPath $destination -Force -Recurse
}
New-Item -ItemType Directory -Force -Path $destination
Move-Item -Path $output -Destination $destination
Move-Item -Path $output2 -Destination $destination
Write-Host "Downloaded Cen64 Emulator successfully."
Write-Host "NOTE: Cen64 not work without manually installing pifdata.bin to $destination!" -ForegroundColor orange



$url = "https://dev.azure.com/n64-tools/_apis/resources/Containers/8383168/binaries?itemPath=binaries%2Fusb64%2Fnet45%2Fusb64.exe"
$output = "$PSScriptRoot/temp/usbtool.exe"
$destination = "$PSScriptRoot/tools/ed64usb/"

if (Test-Path $output) 
{
    Remove-Item -LiteralPath $output -Force -Recurse
}
Write-Host "Downloading ED64 USB tool..."
(New-Object Net.WebClient).Downloadfile($url , $output)
if (Test-Path $destination) 
{
    Remove-Item -LiteralPath $destination -Force -Recurse
}
New-Item -ItemType Directory -Force -Path $destination
Move-Item -Path $output -Destination $destination
Write-Host "Downloaded ED64 USB tool successfully."
Write-Host "NOTE: ED64 USB tool will not work without a minimum of V3.05 OS on the flashcart!" -ForegroundColor orange



$filepath = "$PSScriptRoot/temp/"
if (Test-Path $filepath) 
{
    Remove-Item -LiteralPath $filepath -Force -Recurse
}
Write-Host "Finished cleanup of temp directories.."

Write-Host "Toolchain install completed sucessfully."

Start-Sleep 10
