$vscodeURI = "https://az764295.vo.msecnd.net/stable/6c3e3dba23e8fadc360aed75ce363ba185c49794/VSCode-win32-x64-1.81.1.zip"

if(-not(Test-Path $PSScriptRoot\VSCode)) 
{
    Write-Output (Invoke-WebRequest -URI $vscodeURI).Content -OutFile $PSScriptRoot\vscode-install.zip
}