
<#
.SYNOPSIS
    This PowerShell script ensures that Windows 10 account lockout duration is configured to 15 minutes.

.NOTES
    Author          : Aduragbemi Oladapo
    LinkedIn        : linkedin.com/in/aduragbemioladapo/
    GitHub          : github.com/aduragbemioo
    Date Created    : 2025-06-17
    Last Modified   : 2025-06-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AC-000005

.TESTED ON
    Date(s) Tested  : 2025-06-17
    Tested By       : Aduragbemi
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1.19041.5965

.USAGE
    PS C:\> .\WN10-AC-000005.ps1 
#>





# Define temp file for exporting and importing security settings
$tempFile = "$env:TEMP\secpol.cfg"

# Export current security settings
secedit /export /cfg $tempFile | Out-Null

# Read current config
$settings = Get-Content $tempFile

# Find the LockoutDuration setting
$lockoutDurationLine = $settings | Where-Object { $_ -match '^LockoutDuration\s*=' }

if ($lockoutDurationLine) {
    $lockoutDuration = [int]($lockoutDurationLine -replace 'LockoutDuration\s*=\s*', '')

    Write-Host "Current Account Lockout Duration: $lockoutDuration minute(s)"

    if ($lockoutDuration -ne 0 -and $lockoutDuration -lt 15) {
        Write-Warning "Finding: Account lockout duration is less than 15 minutes. Remediating to 15..."

        # Modify the line in memory
        $updatedSettings = $settings -replace '^LockoutDuration\s*=\s*\d+', 'LockoutDuration = 15'

        # Save the updated config back to the file
        $updatedSettings | Set-Content $tempFile -Encoding Unicode

        # Apply the new setting
        secedit /configure /db secedit.sdb /cfg $tempFile /areas SECURITYPOLICY | Out-Null

        Write-Host "Account lockout duration successfully set to 15 minutes."
    } else {
        Write-Host "Compliant: No changes needed."
    }
} else {
    Write-Error "Could not find LockoutDuration setting in the exported security policy."
}

# Cleanup
Remove-Item $tempFile -ErrorAction SilentlyContinue
