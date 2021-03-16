#Sender med fil som parameter
param(
    [parameter(mandatory=$true)]
    [string] $file
)

#Sjekker om filen er en '.csv' fil
if ( (Get-Item $file).Extension -eq ".csv"){

    #Filen "OUstructure.csv inneholder OU strukturen, og kan enkelt endres"
    Get-Content $file | ForEach-Object{
        $domainName = 'DC=sec,DC=core'
        $ouPath = ''
            #OU(Organizational Unit) og lager et reversjert array, slik at det leses fra toppen
        $ou = (Split-Path $_ -Parent).Split('\')
        [array]::Reverse($ou)
        $ou | ForEach-Object{
            if ($_.Length -eq 0){
                return
            }
            $ouPath = $ouPath + 'OU=' + $_ + ','
        }
        $ouPath += $domainName
    #echo $ouPath
        $newOUName = split-path $_ -Leaf    
    #echo $newOUName
            #protect from accidential deletion kun i testing, fernes når produkt skal realiseres
        New-ADOrganizationalUnit -Name $newOUName -Path $ouPath -ProtectedFromAccidentalDeletion $false
    }
} else {
    Write-Output "Filen er ikke en '.csv' fil"
}
