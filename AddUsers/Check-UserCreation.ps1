#File is sent as a parameter
param(
    [parameter(mandatory=$true)]
    [datetime] $Date,

    [Int] $NumberOfCreations
)

Write-progress "Checking Log files..."

Start-Sleep -Seconds 1  #Wait 1 sec. Takes time to write to log


$LogInfo = @{
    StartTime   = $Date
    EndTime     = Get-Date
    LogName     = 'Security'    #Security Log
    ID          = 4720          #User creation ID
}

$EmployeesAdded = (Get-WinEvent -FilterHashtable $LogInfo).count

if ($NumberOfCreations){
    if ($EmployeesAdded -lt $NumberOfCreations) {
        $total = $NumberOfCreations - $EmployeesAdded
        Write-Warning "`nFailed to add some eployees. Tried adding: $NumberOfCreations. Employees Added: $EmployeesAdded. Employees Failed: $total`n"
    } elseif ($EmployeesAdded -gt $NumberOfCreations) {
        $total =  $EmployeesAdded - $NumberOfCreations
        Write-Warning "`nWARNING: Employees added was more than expected. Tried adding: $NumberOfCreations. Employees Added: $EmployeesAdded. More than expected: ${$EmployeesAdded - $NumberOfCreations}`n"
    }
} else {
    Write-Verbose "`nFound $EmployeesAdded usercreations`n"
}