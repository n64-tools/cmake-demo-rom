$buildpath = "$PSScriptRoot/build"
if (Test-Path $buildpath) 
{
    Remove-Item -LiteralPath $buildpath -Force -Recurse
    Write-Host "Cleaned build folder!"
}
else
{
    Write-Host "Failed to delete build folder!"
}