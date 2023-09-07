param ([switch] $Code, [switch] $Clean)

$isAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
if( -Not $isAdmin )
{
    Write-Error "Script needs to be ran with administrator priviledges!"
    exit
}

$soft_list = @(
    "Python.Python.3.11", 
    "Mozilla.Firefox", 
    "Git.Git", 
    "Microsoft.WindowsTerminal"
)

if ( $Clean )
{
    Write-Output "Cleaning up..."
    . $PSScriptRoot\clean_path.ps1

    if ( $Code )
    {
        Write-Output "Removing vscode installation"
        Remove-Item -LiteralPath $PSScriptRoot\VSCode -Force -Recurse
    }

    foreach( $soft in $soft_list )
    {
        winget uninstall --silent $soft
        Write-Output "$soft uninstalled"
    }
}
else
{
    Write-Output "Setting up..."
    if ( $Code )
    {
        Write-Output "Installing VSCode on a pendrive..."
        . $PSScriptRoot\setup_code.ps1

        Write-Output "Adding VSCode to the path"
        . $PSScriptRoot\setup_path.ps1
    }

    Write-Output "Setting up winget..."
    if (Get-Command "winget" -errorAction SilentlyContinue)
    {
        Write-Output "Winget already installed"
    }
    else 
    {
        Write-Output "Installing winget..."
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
        Write-Output "Winget installed"
    }

    foreach( $soft in $soft_list )
    {
        winget install --accept-source-agreements --accept-package-agreements --silent $soft
        Write-Output "$soft installed"
    }
}

Write-Output "Success!"