#File is sent as a parameter
param(
    [parameter(mandatory=$true)][string] $file
)

############################### IMPORTANT DECLARATIONS  ###########################
$totalEmployees = @{}
$defaultPassword = ConvertTo-SecureString "DefaultPassword@98" -AsPlainText -Force                       # LAG ET STERKERE PASSORD   ///   DefaultPassword@98    ////
$Domain = "OU=Ansatt,DC=sec,DC=core"
$ErrorFileName = "\Errors_Add-Users_Script.txt"
$ErrorCounter = 0

############################### FUNCTIONS  #########################################

#Get-Username checks if the desired username is taken. If so, a new username will be generated
function Get-Username {
    param (
        [Parameter(mandatory)]
        [Array] $Name
    )
    $counterName1 = 3           #Counter for first name
    $counterName2 = 3           #Counter for last name
    $LastResortCounter = 0      #Counter for last resort option

    # Generate a username based on 3 chars from firstname and surname. Only lowercase letters
    $username = $Name[0].substring(0,$counterName1).toLower() + $Name[1].substring(0,$counterName2).toLower()

    #Checks if the desired username is available, if not, a new username will be generated and checked
    while( [bool](Get-ADUser -Filter {SamAccountName -eq $username}) ) {
            #Takes more chars from first name
        if( $counterName1 -lt $Name[0].length){
            $counterName1++
            $username = $Name[0].substring(0,$counterName1).toLower() + $Name[1].substring(0,3).toLower()

             #Takes more chars from last name
        } elseif ($counterName2 -lt $Name[1].length) {
            $counterName2++
            $username = $Name[0].substring(0,3).toLower() + $Name[1].substring(0,$counterName2).toLower()

            #Uses 3+3 char username, but a number is added
        }else {
            while ([bool](Get-ADUser -Filter {SamAccountName -eq $username})) {
                $LastResortCounter++
                $username = $Name[0].substring(0,3).toLower() + $Name[1].substring(0,3).toLower() + $LastResortCounter
            } 
        }
    }
    return $username   
}

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

############################### ADD USERS  #############################################

#Check if the parameter is a file. 
if (Test-Path $file -PathType Leaf){

    #Extracting info from file, and adding to hashtable
    Get-Content $file | ForEach-Object {
        $tempArray = ($_).split(',')
        if (-not $totalEmployees[$tempArray[0]]){
            $totalEmployees[$tempArray[0]] = $tempArray[1]
            #If there are duplicate names, add the department to value
        } else{
            $totalEmployees[$tempArray[0]] += $tempArray[1]
        }
    }

    #Iterating through every user and adds them to the AD structure
    foreach ($employee in $totalEmployees.keys) {
        for ($i = 0; $i -lt $totalEmployees[$employee].length; $i++){

            #Checking which department every user belongs to and sets the right path
            if ($totalEmployees[$employee][$i] -eq 'D'){                            # D --> Developers
                $Path = "OU=U_Developers," + $Domain
                $ValidPath = $true
            } elseif ($totalEmployees[$employee][$i] -eq 'H') {                     # H --> HR
                $Path = "OU=U_HR," + $Domain
                $ValidPath = $true
            } elseif ($totalEmployees[$employee][$i] -eq 'I') {                     # I --> IT admins
                $Path = "OU=U_IT-admin," + $Domain
                $ValidPath = $true
            } elseif ($totalEmployees[$employee][$i] -eq 'R') {                     # R --> Regnskap
                $Path = "OU=U_Regnskap," + $Domain
                $ValidPath = $true
            } elseif ($totalEmployees[$employee][$i] -eq 'V') {                     # V = Vask --> Renhold. Had to differ between Regnskap and Renhold 
                $Path = "OU=U_Renhold," + $Domain
                $ValidPath = $true
            } else {
                Write-ErrorToFile -Type "OU" -File $file -Counter (++$ErrorCounter) -ErrorFileName $ErrorFileName
                $ValidPath = $false
            }

                # Adds user to an Organizational Unit if the path is correct
            if ($ValidPath ){
                
                $Name = $employee.split(' ')              

                $username= Get-Username -Name $Name

                $employeeInfo = @{
                    Name                = $username
                    DisplayName         = $employee
                    GivenName           = $Name[0]
                    Surname             = $Name[1]
                    SamAccountName      = $username
                    UserprincipalName   = $username + "@sec.core"
                    Path                = $Path
                    AccountPassword     = $defaultPassword
                    Enabled             = $true
                }

                new-aduser @employeeInfo
                Write-host "User is added!"
            }
        }
    }

    # The file does not exist
} else{
    Write-ErrorToFile -Type "File" -File $file -Counter (++$ErrorCounter) -ErrorFileName $ErrorFileName
}
    #Write info about errors to user
if ($ErrorCounter){
    Write-Output "`n#####  This script generated $ErrorCounter ERRORS. Read generated file '$ErrorFileName' for information  #####"
}