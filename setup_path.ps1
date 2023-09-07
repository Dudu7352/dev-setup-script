Write-Output "Adding code to path"

$vscode_path = "${(get-location).Drive.Name}\VSCode\bin"
$env:Path = "$env:Path;$vscode_path"