#Get-Content 'C:\Users\Admin\Desktop\albegra-a2\GroupStructure.csv' | ForEach-Object{
#Sender med fil som parameter
param(
    [parameter(mandatory=$true)]
    [string] $file
)
if ( (Get-Item $file).Extension -eq ".csv"){
     #Filen "OUstructure.csv inneholder OU strukturen, og kan enkelt endres"
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
}