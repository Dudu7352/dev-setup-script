$vsCodeUrl = "https://az764295.vo.msecnd.net/stable/6c3e3dba23e8fadc360aed75ce363ba185c49794/VSCode-win32-x64-1.81.1.zip"
$vsCodeZip = $PSScriptRoot + "\vscode-install.zip"
$vsCodePath = $PSScriptRoot + "\VSCode"
Import-Module BitsTransfer

if(-not(Test-Path $PSScriptRoot\VSCode)) 
{
    Write-Output "Downloading VSCode zip file..."
    Start-BitsTransfer -Source $vsCodeUrl -Destination $vsCodeZip
    Expand-Archive -LiteralPath $vsCodeZip -DestinationPath $vsCodePath
    Write-Output "Adding data folder..."
    New-Item $vsCodePath\data -ItemType Directory
    Write-Output "Removing temporary files..."
    Remove-Item $vsCodeZip
    Write-Output "VSCode install complete"
}
else {
    Write-Output "VSCode seems to be already present. Omitting vscode install"
}