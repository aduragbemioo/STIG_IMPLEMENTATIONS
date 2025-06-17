<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Aduragbemi Oladapo
    LinkedIn        : linkedin.com/in/aduragbemioladapo/
    GitHub          : github.com/aduragbemioo
    Date Created    : 2025-06-17
    Last Modified   : 2025-06-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000510

.TESTED ON
    Date(s) Tested  : 2025-06-17
    Tested By       : Aduragbemi
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1.19041.5965

.USAGE
    PS C:\> .\WN10-AU-000510.ps1 
#>


# Define the registry path
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System"

# Check if the registry key exists, create it if not
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the MaxSize value to 0x00008000 (which is 32768 in decimal)
New-ItemProperty -Path $regPath -Name "MaxSize" -Value 32768 -PropertyType DWord -Force
