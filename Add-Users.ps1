#File is sent as a parameter
param(
    [parameter(mandatory=$true)][string] $file
)
#Check if the parameter is a file. 
if (Test-Path $file -PathType Leaf){

    #################### Important declarations  #################
    $totalEmployees = @{}
    $defaultPassword = ConvertTo-SecureString "DefaultPassword@98" -AsPlainText -Force                       # LAG ET STERKERE PASSORD   ///   DefaultPassword@98    ////
    $Domain = "DC=sec,DC=core"
    ##############################################################


    #Extracting info from file, and adding to hashtable
    Get-Content $file | ForEach-Object {
        $tempArray = ($_).split(',')
        $totalEmployees[$tempArray[0]] = $tempArray[1]
    }

    #Iterating through every user and adds them to the AD structure
    foreach ($employee in $totalEmployees.keys) {

        #Checking which department every user belongs to and sets the right path
        if ($totalEmployees[$employee] -eq 'I'){
            $Path = "OU=IT Admins," + $Domain
        } elseif ($totalEmployees[$employee] -eq 'S') {                 # SETT PÅ EN FEILSØKING OG GJØR FERDIG BASERT PÅ FLERE BOKSTAVER
            $Path = "OU=Sales," + $Domain
        }

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
    }
    # The file does not exist
} else{
    write-host "Dette er ikke en fil"!      # SKRIV EN PASSENDE MELDING TIL FIL. TELL OPP ERRORTELLEREN
}