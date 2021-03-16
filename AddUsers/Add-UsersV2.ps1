#File is sent as a parameter
param(
    [parameter(mandatory=$true)][string] $file
)

############################### IMPORTANT DECLARATIONS  ###########################
$totalEmployees = @{}
$Domain = "OU=Ansatt,DC=sec,DC=core"
$ErrorFileName = "\Errors_Add-Users_Script.txt"
$ErrorCounter = 0
$StartDateLog = Get-Date

############################### FUNCTIONS  #########################################

#Get-Username checks if the desired username is taken. If so, a new username will be generated
function Get-Username {
    param (
        [Parameter(mandatory)]
        [String] $Name
    )
    $counterName1 = 3           #Counter for first name
    $counterName2 = 3           #Counter for last name
    $LastResortCounter = 0      #Counter for last resort option

    $NewName = $Name.split(" ")

    # Generate a username based on 3 chars from firstname and surname. Only lowercase letters
    $username = $NewName[0].substring(0,$counterName1).toLower() + $NewName[1].substring(0,$counterName2).toLower()

    #Checks if the desired username is available, if not, a new username will be generated and checked
    while( [bool](Get-ADUser -Filter {SamAccountName -eq $username}) ) {
            #Takes more chars from first name
        if( $counterName1 -lt $NewName[0].length){
            $counterName1++
            $username = $NewName[0].substring(0,$counterName1).toLower() + $NewName[1].substring(0,3).toLower()

             #Takes more chars from last name
        } elseif ($counterName2 -lt $NewName[1].length) {
            $counterName2++
            $username = $NewName[0].substring(0,3).toLower() + $NewName[1].substring(0,$counterName2).toLower()

            #Uses 3+3 char username, but a number is added
        }else {
            while ([bool](Get-ADUser -Filter {SamAccountName -eq $username})) {
                $LastResortCounter++
                $username = $NewName[0].substring(0,3).toLower() + $NewName[1].substring(0,3).toLower() + $LastResortCounter
            } 
        }
    }
    return $username   
}   
# Generate a random password            UNCOMMENT
#function Get-Password {
#    $password = -join `
#    ('abcdefghkmnrstuvwxyzABCDEFGHKLMNPRSTUVWXYZ23456789 !"#$%&()*+,-./:;<=>?@[\]^_`{|}~'.ToCharArray() | 
#     Get-Random -Count 16)
#
#     return $password
#    
#}

#Write-ErrorToFile writes error to a specific file to provide information about the problems
function Write-ErrorToFile {
    param (
       [Parameter(Mandatory)]
       [ValidateSet("OU", "File")]
       [String] $Type,

       [Parameter(Mandatory)]
       [String] $File,
       
       [Parameter(Mandatory)]
       [String] $ErrorFileName,
       
       [Parameter(Mandatory)]
       [Int] $Counter
    )

    $CurrentPath = (Get-Location).ToString()
    $FullPath = $CurrentPath + $ErrorFileName


        #Test if the file exist
    if ( -Not (Test-Path $FullPath) ){
        New-Item -Path $FullPath -ItemType "File"
    } else {
        Set-ItemProperty $FullPath -Name IsReadOnly -Value $false
    }
        #Writes to file
    if ($Type -eq "OU"){
        Write-Output "$Counter. The '$File' file contains an unknowned character, which do not represent any valid department" | Out-File -FilePath $FullPath -Append
    } else {
        Write-Output "$Counter. The '$File' is not a file" | Out-File -FilePath $FullPath -Append
    }

    Set-ItemProperty $FullPath -Name IsReadOnly -Value $true
}

function Test-Name {
    param (
        [Parameter(mandatory)]
        [String] $Name
    )

    $NameLower = $Name.toLower()
    $IllegalChar = @('æ','ø','å')

    foreach ($Char in $IllegalChar) {
        if ($char -eq 'æ'){
            $nameLower = $NameLower.replace("æ", "ae")
        } elseif ($char -eq 'ø'){
            $nameLower = $NameLower.replace("ø", "ou")
        } elseif ($char -eq 'å'){
            $nameLower = $NameLower.replace("å", "aa")
        }
    }
    
    return $nameLower
}

# Save user credentitals to a file and limit the access to read only
function Save-UserCredentials {
    param (
        [Parameter(Mandatory)]
        [String] $username,
        
        [Parameter(Mandatory)]
        [String] $password
    )

    $passwordPath = (Get-Location).toString() + "\PasswordManager.txt"
            
    if (-Not (Test-Path $passwordPath) ){
        New-Item -Path $passwordPath -ItemType "File"
    } else{
        Set-ItemProperty $passwordPath -Name IsReadOnly -Value $false     # Give write access
    }

    Write-Output "$username     -     $password" | Out-File -FilePath $passwordPath -Append
    Set-ItemProperty $passwordPath -Name IsReadOnly -Value $true     # Limit the access back to read-only  
}

############################### ADD USERS  #############################################

#Check if the parameter is a csv file. 
if ( (Get-Item $file).Extension -eq ".csv"){

    $totalEmployees = Import-Csv $File -delimiter ";"

    #Iterating through every user and adds them to the AD structure
    foreach ($employee in $totalEmployees) {

        #Checking which department every user belongs to and sets the right path
        if ($employee.Department -eq 'Developers'){                            # D --> Developers
            $Path = "OU=U_Developers," + $Domain
            $ValidPath = $true
        } elseif ($employee.Department -eq 'HR') {                     # H --> HR
            $Path = "OU=U_HR," + $Domain
            $ValidPath = $true
        } elseif ($employee.Department -eq 'IT-Admin') {                     # I --> IT admins
            $Path = "OU=U_IT-admin," + $Domain
            $ValidPath = $true
        } elseif ($employee.Department -eq 'Regnskap') {                     # R --> Regnskap
            $Path = "OU=U_Regnskap," + $Domain
            $ValidPath = $true
        } elseif ($employee.Department -eq 'Renhold') {                     # V = Vask --> Renhold. Had to differ between Regnskap and Renhold 
            $Path = "OU=U_Renhold," + $Domain
            $ValidPath = $true
        } else {
            Write-ErrorToFile -Type "OU" -File $file -Counter (++$ErrorCounter) -ErrorFileName $ErrorFileName
            $ValidPath = $false
        }

            # Adds user to an Organizational Unit if the path is correct
        if ($ValidPath ){ 

            $ValidName = Test-Name -Name $employee.name     # Call function to check the name for illegal char
            
            $username = Get-Username -Name $ValidName   # Call function to generate a username
            $Name = ($employee.Name).split(" ")

            #$password =  Get-Password           # Call function to genereate a password    UNCOMMENT
            $password = "PassPhrase98-"
            
            Save-UserCredentials -Username $username -Password $password     # Call function to store credentials

            $password =  ConvertTo-SecureString $password -AsPlainText -Force   #Converting the password to a secure string
            Write-progress "Adding users...."
            $employeeInfo = @{
                Name                    = $username
                DisplayName             = $employee.Name
                GivenName               = $Name[0]
                Surname                 = $Name[1]
                SamAccountName          = $username
                UserprincipalName       = $username + "@sec.core"
                Path                    = $Path
                AccountPassword         = $password
                Enabled                 = $true
                ChangePasswordAtLogon   = $true
                Department              = $employee.Department
            }

            new-aduser @employeeInfo
        }
        
    }

    # The file does not exist
} else{
    Write-ErrorToFile -Type "File" -File $file -Counter (++$ErrorCounter) -ErrorFileName $ErrorFileName
}


############################################################

.\Check-UserCreation.ps1 -Date $StartDateLog -NumberOfCreations ($totalEmployees.length)


#Write info about errors to user
if ($ErrorCounter){
    Write-Error "`n#####  This script generated $ErrorCounter ERRORS. Read generated file '$ErrorFileName' for information  #####`n"
}