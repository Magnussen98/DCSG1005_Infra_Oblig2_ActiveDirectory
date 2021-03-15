    #Filen "OUstructure.csv inneholder OU strukturen, og kan enkelt endres"
Get-Content 'C:\Users\Admin\Desktop\albegra-a2\OUStructure.csv' | ForEach-Object{
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
