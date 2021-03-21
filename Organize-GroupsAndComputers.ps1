#Gives the user a chance to only orgnaize groups or computers
param(
    [ValidateSet("Groups", "Computers")]
    [string] $option
)

########################### IMPORTANT DECLARATIONS  ###########################

$parentGroup = ("G_Ansatt", "G_On-prem")
$isParam = [bool]($option)      #Check if a parameter is sent or not

########################### FUNCTIONS   ######################################
# Get the correct distinguished name for either a specific group or OU
function Get-DistinguishedName{
    param (
        [parameter(mandatory=$true)]
        [ValidateSet("OU", "Group")]
        [string] $type,

        [string] $department
    )
    #Find OU distinguished name
    if ($type -eq "OU"){
        $distinguishedName = (Get-ADOrganizationalUnit -Filter * | Where-Object{$_.name -match $department}).distinguishedName
    #Find Group distinguished name
    } else{
        $distinguishedName = (get-ADGroup -Filter * | Where-Object {$_.name -match $department}).distinguishedname

    }
    return $distinguishedName
}

######################## ORGANIZE GROUPS AND EMPLOYEES ######################################
if ( $option -eq "Groups" -or (-not $isParam) ){
    Write-Progress "Moving child groups into parent group"

    foreach ($group in $parentGroup) {
        $Department = $group.replace("G_","")
        # Get all the groups within parent OU except parent group
        $allGroups = Get-ADGroup -Filter {name -notlike $group} -SearchBase `
                    (Get-DistinguishedName -type "OU" -department $department)

        # Add all the child groups to parent group
        Add-ADGroupMember -Members $allGroups -Identity (Get-DistinguishedName -type "Group" -department $department)

        # Retrieve all the groupmembers of parent group
        $allGroups = Get-ADGroupMember $group

        Write-Progress "Adding users to groups"
        # Iterates through every child group and adds its users
        foreach ( $childGroup in $allGroups ){
            $name = $childGroup.name.replace("G", "U")
            $searchBase = Get-DistinguishedName -type "OU" -department $name
            if ($searchBase){
                $users = Get-ADUser -Filter * -SearchBase $searchBase
            } else {
                $users = 0
            }
            # If users exist
            if ($users){
                Add-ADGroupMember -Members $users -Identity (Get-DistinguishedName -type "Group" -department ($childGroup.name))
            }
        }
    }
}

######################################## MOVE COMPUTERS ################################################
if ( $option -eq "Computers" -or (-not $isParam) ){
    Write-Progress "Moving computers to OUs"

    #Get all computers inside "Computers" container
    $allComputers = Get-ADComputer -filter * -SearchBase "CN=Computers,DC=sec,DC=core"

    #Move the computers to the correct OUs if there are any
    if ($allComputers) {
        $computers = ("CL", "SRV")   #Client and Server
        foreach ($computer in $computers) {
            $everyComputer = Get-ADComputer -filter * -SearchBase "CN=Computers,DC=sec,DC=core" | Where-Object{$_.name -match $computer}
            if ($everyComputer){
                if ($computer -eq "CL"){
                    $OU = "PC"
                } else {
                    $OU = "Server"
                }
                $everyComputer | Move-ADObject -TargetPath (Get-DistinguishedName -type "OU" -department $ou)
            }
        }
    }
}