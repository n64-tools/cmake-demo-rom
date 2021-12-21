New-Item -ItemType Directory -Force -Path "$PSScriptRoot\temp\"

$url = "https://github.com/N64-tools/libdragon/releases/download/v0.0.1-alpha.1/libdragon-win64.zip"
$output = "$PSScriptRoot\temp\libdragon.zip"

Invoke-WebRequest -Uri $url -OutFile $output
Expand-Archive -Force -Path $output -DestinationPath "$PSScriptRoot\toolchain\libdragon\"

$url = "https://github.com/N64-tools/mips64-gcc-toolchain/releases/download/10.2.0/gcc-toolchain-mips64-win64.zip"
$output = "$PSScriptRoot\temp\gcc-toolchain-mips64.zip"

Invoke-WebRequest -Uri $url -OutFile $output
Expand-Archive -Force -Path $output -DestinationPath "$PSScriptRoot\toolchain\gcc-toolchain-mips64\"

$url = "https://github.com/ninja-build/ninja/releases/latest/download/ninja-win.zip"
$output = "$PSScriptRoot\temp\ninja.zip"

Invoke-WebRequest -Uri $url -OutFile $output
Expand-Archive -Force -Path $output -DestinationPath "$PSScriptRoot\tools\"

Remove-Item -LiteralPath "$PSScriptRoot\temp\" -Force -Recurse
