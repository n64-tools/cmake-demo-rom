New-Item -ItemType Directory -Force -Path "$PSScriptRoot\temp\"

$url = "https://n64tools.blob.core.windows.net/binaries/N64-tools/libdragon/develop/latest/libdragon-win64.zip"
$output = "$PSScriptRoot/temp/libdragon.zip"
$destination = "$PSScriptRoot/toolchain/libdragon/"

Remove-Item -LiteralPath $output -Force -Recurse
Invoke-WebRequest -Uri $url -OutFile $output
Remove-Item -LiteralPath $destination -Force -Recurse
Expand-Archive -Force -Path $output -DestinationPath $destination

$url = "https://n64tools.blob.core.windows.net/binaries/N64-tools/mips64-gcc-toolchain/master/latest/gcc-toolchain-mips64-win64.zip"
$output = "$PSScriptRoot/temp/gcc-toolchain-mips64.zip"
$tempdestination = "$PSScriptRoot/temp/gcc-toolchain-mips64/"
$destination = "$PSScriptRoot/toolchain/gcc-toolchain-mips64/"

Remove-Item -LiteralPath $output -Force -Recurse
Invoke-WebRequest -Uri $url -OutFile $output
Remove-Item -LiteralPath $destination -Force -Recurse
Expand-Archive -Force -Path $output -DestinationPath $tempdestination

Move-Item -Path "$tempdestination/gcc-toolchain-mips64-win64" -Destination "$destination"

$url = "https://github.com/ninja-build/ninja/releases/download/v1.10.1/ninja-win.zip"
$output = "$PSScriptRoot/temp/ninja-win.zip"
$destination = "$PSScriptRoot/tools/"

Remove-Item -LiteralPath $output -Force -Recurse
Invoke-WebRequest -Uri $url -OutFile $output
Remove-Item -LiteralPath $destination -Force -Recurse
Expand-Archive -Force -Path $output -DestinationPath $destination

Remove-Item -LiteralPath "$PSScriptRoot/temp/" -Force -Recurse