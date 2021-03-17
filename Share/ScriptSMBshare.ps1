
param(
    [parameter(mandatory=$true)]
    [string] $file
)

#inslall module on srv1
Install-WindowsFeature -Name FS-DFS-Namespace,FS-DFS-Replication,RSAT-DFS-Mgmt-Con -IncludeManagementTools
Import-Module dfsn


#henter ut "folders" fra medsendt fil
$folders = get-content($file)
#go to c:\
cd c:\
mkdir -path $folders

$folders | ForEach-Object {$GroupName = (Get-Item $_).name;} | select -Skip 1
$folders | ForEach-Object {$sharename = (Get-Item $_).name; New-SMBShare -Name $shareName -Path $_ -FullAccess "G_$GroupName"}

New-DfsnRoot -TargetPath \\srv1\files -Path \\sec.core\files -Type DomainV2

$folders | Where-Object {$_ -like "*shares*"} | ForEach-Object {$name = (Get-Item $_).name; $DfsPath = (‘\\sec.core\files\’ + $name); $targetPath = (‘\\srv1\’ + $name);New-DfsnFolderTarget -Path $dfsPath -TargetPath $targetPath}


