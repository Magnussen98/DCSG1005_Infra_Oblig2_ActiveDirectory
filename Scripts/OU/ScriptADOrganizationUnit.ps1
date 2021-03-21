#Sender med fil som parameter
param(
    [parameter(mandatory=$true)]
    [string] $file
)

#Sjekker om filen er en '.csv' fil
if ( (Get-Item $file).Extension -eq ".csv"){

    #Filen "OUstructure.csv inneholder OU strukturen, og kan enkelt endres"
    $fileContent = Get-Content $file

    $scriptBlock = {
        param(
            $content
        )
        $content | ForEach-Object{
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
        $newOUName = split-path $_ -Leaf

          ##oppreter OUer 
        New-ADOrganizationalUnit -Name $newOUName -Path $ouPath 
        }
    }

    Invoke-Command -ComputerName dc1 -ScriptBlock $scriptBlock  -ArgumentList (,$fileContent)

    
} else {
    Write-Output "Filen er ikke en '.csv' fil"
}
