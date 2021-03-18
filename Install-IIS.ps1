$choco,$zip = Get-Command -Name choco.exe, 7z.exe -ErrorAction SilentlyContinue

if ( -Not $choco ){
        # Code about choco install is copy pasted from "https://gitlab.com/erikhje/dcsg1005/-/blob/master/powershell.md"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

if ( -Not $zip ){
    choco install 7zip.install
}

$url = 'https://www.free-css.com/assets/files/free-css-templates/download/page265/confer.zip'
$destination = "C:\Users\$env:domain.$env:UserDomain" 