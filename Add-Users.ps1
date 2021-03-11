#File is sent as a parameter
param(
    [parameter(mandatory=$true)][string] $file
)
#Check if the parameter is a file. 
if (Test-Path $file -PathType Leaf){

    #################### Important declarations  #################
    $totalEmployees = @{}
    $defaultPassword = ConvertTo-SecureString "DefaultPassword@98" -AsPlainText -Force                       # LAG ET STERKERE PASSORD   ///   DefaultPassword@98    ////
    $Domain = "OU=Ansatt,DC=sec,DC=core"
    ##############################################################


    #Extracting info from file, and adding to hashtable
    Get-Content $file | ForEach-Object {
        $tempArray = ($_).split(',')
        $totalEmployees[$tempArray[0]] = $tempArray[1]
    }

    #Iterating through every user and adds them to the AD structure
    foreach ($employee in $totalEmployees.keys) {

        #Checking which department every user belongs to and sets the right path
        if ($totalEmployees[$employee] -eq 'D'){                            # D --> Developers
            $Path = "OU=Developers," + $Domain
            $ValidPath = $true
        } elseif ($totalEmployees[$employee] -eq 'H') {                     # H --> HR
            $Path = "OU=HR," + $Domain
            $ValidPath = $true
        } elseif ($totalEmployees[$employee] -eq 'I') {                     # I --> IT admins
            $Path = "OU=IT-admin," + $Domain
            $ValidPath = $true
        } elseif ($totalEmployees[$employee] -eq 'R') {                     # R --> Regnskap
            $Path = "OU=Regnskap," + $Domain
            $ValidPath = $true
        } elseif ($totalEmployees[$employee] -eq 'V') {                     # V = Vask --> Renhold. Had to differ between Regnskap og Renhold 
            $Path = "OU=Renhold," + $Domain
            $ValidPath = $true
        } else {
            write-output "Dette er feil!" #SKRIV ERROR TIL FIL + TELL OPP
            $ValidPath = $false
        }

            # Adds user to an Organizational Unit if the path is correct
        if ($ValidPath ){

            $Name = $employee.split(' ')
                                # Setting a username based on 3 chars from firstname and surname. Only lowercase letters
            $username = $Name[0].substring(0,3).toLower() + $Name[1].substring(0,3).toLower()

            #SJEKK AT VIKTIG INFO IKKE ER BRUKT FRA FØR, SOM FEKS "NAME" OG "SAMACCOUNTNAME", FINN UT LØSNING FOR HVORDAND DETTE EVT SKAL LØSES

            $employeeInfo = @{
               Name                = $employee
               GivenName           = $Name[0]
               Surname             = $Name[1]
               SamAccountName      = $username
               UserprincipalName   = $Name[0] + "@sec.core"
               Path                = $Path
               AccountPassword     = $defaultPassword
               Enabled             = $true
            }

            new-aduser @employeeInfo
            Write-host "User is added!"
        }
    }

    # The file does not exist
} else{
    write-host "Dette er ikke en fil"!      # SKRIV EN PASSENDE MELDING TIL FIL. TELL OPP ERRORTELLEREN
}