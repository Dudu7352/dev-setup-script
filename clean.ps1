Write-Output "Removing code from path"

$vscode_path = "${(get-location).Drive.Name}\VSCode\bin"
$env:Path = (
    $env:Path.Split(";") 
    | Where-Object -FilterScript { $_ -ne $vscode_path }
) -join ";"