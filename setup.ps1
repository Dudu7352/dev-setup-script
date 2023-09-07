
Write-Output "Adding code to path"

$vscode_path = "${(get-location).Drive.Name}\VSCode\bin"
$env:Path = "$env:Path;$vscode_path"

Write-Output "Installing essentials ..."

if (Get-Command "winget" -errorAction SilentlyContinue)
{
    Write-Output "winget installed"
}
else 
{
    Write-Output "installing winget"
    # get latest download url
    $URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    $URL = (Invoke-WebRequest -Uri $URL).Content | ConvertFrom-Json |
            Select-Object -ExpandProperty "assets" |
            Where-Object "browser_download_url" -Match '.msixbundle' |
            Select-Object -ExpandProperty "browser_download_url"

    # download
    Invoke-WebRequest -Uri $URL -OutFile "Setup.msix" -UseBasicParsing

    # install
    Add-AppxPackage -Path "Setup.msix"

    # delete file
    Remove-Item "Setup.msix"
}

$soft_list = @(
    "Python.Python.3.11", 
    "Mozilla.Firefox", 
    "Git.Git", 
    "Microsoft.WindowsTerminal"
)

foreach( $soft in $soft_list )
{
    winget install --accept-source-agreements --accept-package-agreements --silent $soft
    Write-Output "$soft installed"
}