# cmake-demo-rom
Generates a ROM built with CMake

Note: this is currently WiP for Windows 10 based dev environments.

Requires:
* https://cmake.org/download/ to be installed (make sure the PATH variable is set).
* VSCode with `CMake`, `CMake Tools` and `C/C++` extensions
![Required VSCode Extensions](vscode-extensions.png)

* Run `UpdateToolchain.ps1` to download the required toolchain and libdragon files
* Adjust .vscode/cmake-variants.json for your paths if necessary (although should work out the box)
* Adjust .vscode/settings.json for your paths (although should work out the box)

In vscode hit F7 to build the ROM
