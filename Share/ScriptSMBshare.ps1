
param(
    [parameter(mandatory=$true)]
    [string] $file
)

Enter-PSSession srv1
#inslall module on srv1
Install-WindowsFeature -Name FS-DFS-Namespace,FS-DFS-Replication,RSAT-DFS-Mgmt-Con -IncludeManagementTools
Import-Module dfsn


#henter ut "folders" fra medsendt fil
$folders = get-content($file)
mkdir -path $folders

## Dfsroot skal ha fullaccess everyone. skal være G_

$folders | ForEach-Object {
    $GroupName = (Get-Item $_).name
    $path = $_
    if ($GroupName -eq 'files'){
        New-SMBShare -Name $GroupName -Path $path -FullAccess "Everyone"
    } else {
        $access = "sec\G_" + $GroupName
        #New-SMBShare -Name $GroupName -Path $path -FullAccess $access
        New-SMBShare -Name $GroupName -Path $path -FullAccess "Everyone"
    }
}


New-DfsnRoot -TargetPath "\\srv1\files" -Path \\sec.core\files -Type DomainV2

$folders | Where-Object {$_ -like "*shares*"} | ForEach-Object {
    $name = (Get-Item $_).name
    $DfsPath = (‘\\sec.core\files\’ + $name)
    $targetPath = (‘\\srv1\’ + $name)
    New-DfsnFolderTarget -Path $dfsPath -TargetPath $targetPath
}