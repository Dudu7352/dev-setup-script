Write-Output "Adding code to path"

$vscodePath = $PSScriptRoot + "\VSCode\bin"
$env:Path = "$vscodePath;$env:Path"