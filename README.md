# cmake-demo-rom
Generates a ROM built with CMake

Requirements:
* Turning on Windows 10 or 11 developer mode Or Windows 7 with latest PowerShell version installed
* Enabling Remote Powershell execution policy (`Set-ExecutionPolicy Unrestricted`)
* https://cmake.org/download/ (tested working with 3.18.4) to be installed (make sure the PATH variable is set).
* VSCode with `CMake`, `CMake Tools` and `C/C++` extensions
![Required VSCode Extensions](vscode-extensions.png)

* Run `UpdateToolchain.ps1` to download the required toolchain and libdragon files
* Adjust .vscode/cmake-variants.json for your paths if necessary (although should work automatically out the box)
* Adjust .vscode/settings.json for your paths (although should work automatically out the box)

Building the ROM:
In VS-Code
* Click on the Bottom bar to set the "build variant": ![CMake variant](vscode-set-variant.png)
* Use any kit e.g. "Unspecified" (as this is handled by Ninja-Build)
* Hit F7 to build the ROM
