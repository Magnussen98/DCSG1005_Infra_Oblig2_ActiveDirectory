#Sender med fil som parameter
param(
    [parameter(mandatory=$true)]
    [string] $file
)

#Sjekker om filen er en '.csv' fil
if ( (Get-Item $file).Extension -eq ".csv"){

    Get-Content $file | ForEach-Object{
    $domainName = 'DC=sec,DC=core'
    $GroupPath = ''
    $Group = (Split-Path $_ -Parent).Split('\')
    [array]::Reverse($Group)
     $group | ForEach-Object{
            if ($_.Length -eq 0){
                return
            }
            $GroupPath = $GroupPath + 'OU=' + $_ + ','
        }
        $GroupPath += $domainName

    #echo $GroupPath
        $newGroupName = split-path $_ -Leaf  
    #echo "G_$newGroupName"
        New-ADGroup -GroupCategory Security -GroupScope Global -Name  "G_$newGroupName" -Path $GroupPath
    }
} else {
    Write-Output "Filen er ikke en '.csv' fil"
}