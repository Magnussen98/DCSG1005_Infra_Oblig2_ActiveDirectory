#File is sent as a parameter
param(
    [parameter(mandatory=$true)]
    [datetime] $Date,

    [Int] $NumberOfCreations
)

Write-Output "`nChecking Log files...`n"

Start-Sleep -Seconds 1  #Wait 1 sec. Takes time to write to log


$LogInfo = @{
    StartTime   = $Date
    EndTime     = Get-Date
    LogName     = 'Security'    #Security Log
    ID          = 4720          #User creation ID
}

$EmployeesAdded = (Get-WinEvent -FilterHashtable $LogInfo).count

if ($NumberOfCreations){
    if ($EmployeesAdded -eq $NumberOfCreations){
        Write-Output "`nAll employees have been added`n"
    } elseif ($EmployeesAdded -lt $NumberOfCreations) {
        $total = $NumberOfCreations - $EmployeesAdded
        Write-Output "`nWARNING: Failed to add some eployees. Tried adding: $NumberOfCreations. Employees Added: $EmployeesAdded. Employees Failed: $total`n"
    } else {
        $total =  $EmployeesAdded - $NumberOfCreations
        Write-Output "`nWARNING: Employees added was more than expected. Tried adding: $NumberOfCreations. Employees Added: $EmployeesAdded. More than expected: ${$EmployeesAdded - $NumberOfCreations}`n"
    }
} else {
    Write-Output "`nFound $EmployeesAdded usercreations`n"
}