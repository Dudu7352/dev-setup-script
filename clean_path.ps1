Write-Output "Removing code from path"

$vscodePath = $PSScriptRoot + "\VSCode\bin"
$env:Path = (
    $env:Path.Split(";") 
    | Where-Object -FilterScript { $_ -ne $vscodePath }
) -join ";"