#Sender med fil som parameter
param(
    [parameter(mandatory=$true)]
    [string] $file
)
if ( (Get-Item $file).Extension -eq ".csv"){

     #Filen "GroupStructure.csv inneholder Gruppestrukturen, og kan enkelt endres"
    $fileContent = Get-Content $file

    $scriptBlock = {
        param(
            $content
        )

        $content| ForEach-Object{
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

            $newGroupName = split-path $_ -Leaf

        if($GroupPath -like "OU=R_*"){
             New-ADGroup -GroupCategory Security -GroupScope DomainLocal -Name  "G_$newGroupName" -Path $GroupPath
        }
        else{
            New-ADGroup -GroupCategory Security -GroupScope Global -Name  "G_$newGroupName" -Path $GroupPath
        }
        }
    }
    Invoke-Command -ComputerName dc1 -ScriptBlock $scriptBlock -ArgumentList (,$fileContent)
}