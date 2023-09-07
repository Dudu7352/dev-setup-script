param ([switch] $NoCode, [switch] $Clean)

if ( $Clean )
{
    Write-Output "Cleaning up..."
    . $PSScriptRoot\clean.ps1
}
else
{
    Write-Output "Setting up..."
    if ( -Not $NoCode )
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
}

Write-Output "Success!"