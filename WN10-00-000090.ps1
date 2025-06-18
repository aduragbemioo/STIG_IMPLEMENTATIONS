<#
.SYNOPSIS
    This Powershell script Filters enabled (active) users and Checks if PasswordNeverExpires is set, If true, 
    it resets the flag to expire the password and Outputs a message for each user, indicating the status.

.NOTES
    Author          : Aduragbemi Oladapo
    LinkedIn        : linkedin.com/in/aduragbemioladapo/
    GitHub          : github.com/aduragbemioo
    Date Created    : 2025-06-18
    Last Modified   : 2025-06-18
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000090

.TESTED ON
    Date(s) Tested  : 2025-06-18
    Tested By       : Aduragbemi
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1.19041.5965

.USAGE
    PS C:\> .\WN10-00-000090.ps1 
#>


# Get all enabled local users
$users = Get-LocalUser | Where-Object { $_.Enabled -eq $true }

foreach ($user in $users) {
    # Skip built-in Administrator and Guest if needed
    if ($user.Name -ne "Administrator" -and $user.Name -ne "Guest") {
        # Use WMIC to explicitly disable 'Password never expires'
        Write-Output "Forcing: $($user.Name) - setting password to expire..."
        wmic useraccount where "name='$($user.Name)'" set PasswordExpires=TRUE
    } else {
        Write-Output "Skipping system account: $($user.Name)"
    }
}
