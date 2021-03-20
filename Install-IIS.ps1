$choco,$zip = Get-Command -Name choco.exe, 7z.exe -ErrorAction SilentlyContinue

if ( -Not $choco ){
        # Code about choco install is copy pasted from "https://gitlab.com/erikhje/dcsg1005/-/blob/master/powershell.md"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

if ( -Not $zip ){
    choco install -y 7zip.install
}

$url = 'https://www.free-css.com/assets/files/free-css-templates/download/page265/confer.zip'
$destination = "$HOME\Downloads\confer.zip"

Invoke-WebRequest -Uri $url -OutFile $destination
7z x $destination -ofolder

Copy-Item -Path "$home\Downloads\folder" -Destination "\\sec.core\files\Public\webpage" -Recurse -force

$scriptBlock = {
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools
    Copy-Item -Path "\\sec.core\files\Public\webpage\*" -Destination "C:\inetpub\wwwroot" -Recurse -Force
}

Invoke-Command -ComputerName "srv1" -ScriptBlock $scriptBlock
