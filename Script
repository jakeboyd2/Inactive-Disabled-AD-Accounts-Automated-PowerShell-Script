# variable declarations
$daysinactive = 90
$cutoffdate = (get-date).adddays(-$daysinactive)
$outputfile = "inactive_users.txt"


"" | out-file -filepath $outputfile

# finds disabled accounts
$disabledusers = get-aduser -filter 'enabled -eq $false' -properties name, enabled, distinguishedname |
    select-object name, enabled, distinguishedname

add-content $outputfile "--- disabled accounts ---"
$disabledusers | foreach-object {
    add-content $outputfile "$($_.name) [dn: $($_.distinguishedname)]"
}

# finds accounts inactive 90+ days
$inactiveusers = get-aduser -filter {lastlogondate -lt $cutoffdate -and enabled -eq $true} -properties name, lastlogondate |
    select-object name, lastlogondate

add-content $outputfile "`n--- inactive accounts (no login in $daysinactive+ days) ---"
$inactiveusers | foreach-object {
    add-content $outputfile "$($_.name) - lastlogon: $($_.lastlogondate)"
}

write-host "combined results written to $outputfile"
