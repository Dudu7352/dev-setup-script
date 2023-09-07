Write-Output "Removing code from path"

$vscodePath = "${(get-location).Drive.Name}\VSCode\bin"
$env:Path = (
    $env:Path.Split(";") 
    | Where-Object -FilterScript { $_ -ne $vscodePath }
) -join ";"