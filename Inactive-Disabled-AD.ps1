# Author: Jake Boyd
# Date: 9/2/2025



# Check for AD module
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Error "ActiveDirectory module not found. Please install RSAT: Active Directory tools before running this script."
    exit 1
}
Import-Module ActiveDirectory -ErrorAction Stop

# Variable declarations
$daysinactive = 90
$cutoffdate = (get-date).adddays(-$daysinactive)
$outputfile = "Inactive_Users.txt"


"" | out-file -filepath $outputfile

# Find disabled accounts
$disabledusers = get-aduser -filter 'enabled -eq $false' -properties name, enabled, distinguishedname |
    select-object name, enabled, distinguishedname

add-content $outputfile "--- Disabled Accounts ---"
$disabledusers | foreach-object {
    add-content $outputfile "$($_.name) [dn: $($_.distinguishedname)]"
}

# Find accounts inactive 90+ days
$inactiveusers = get-aduser -filter {lastlogondate -lt $cutoffdate -and enabled -eq $true} -properties name, lastlogondate |
    select-object name, lastlogondate

add-content $outputfile "`n--- Inactive Accounts (no login in $daysinactive+ days) ---"
$inactiveusers | foreach-object {
    add-content $outputfile "$($_.name) - Last Logon: $($_.lastlogondate)"
}

write-host "Combined results written to: $outputfile"
