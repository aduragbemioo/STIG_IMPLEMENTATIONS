<#
.SYNOPSIS
    This PowerShell Script checks and set the ConsentPromptBehaviorUser registry setting to
    deny elevation requests for standard users.


.NOTES
    Author          : Aduragbemi Oladapo
    LinkedIn        : linkedin.com/in/aduragbemioladapo/
    GitHub          : github.com/aduragbemioo
    Date Created    : 2025-06-18
    Last Modified   : 2025-06-18
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000255

.TESTED ON
    Date(s) Tested  : 2025-06-18
    Tested By       : Aduragbemi
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1.19041.5965

.USAGE
    PS C:\> .\WN10-SO-000255.ps1 
#>




# Define registry path and expected values
$regPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$valueName = 'ConsentPromptBehaviorUser'
$expectedValue = 0

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    Write-Host "Registry path '$regPath' does not exist. Creating..."
    New-Item -Path $regPath -Force | Out-Null
}

# Check current value and correct it if necessary
try {
    $currentValue = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop | Select-Object -ExpandProperty $valueName
    if ($currentValue -ne $expectedValue) {
        Write-Host "'$valueName' is set to $currentValue. Updating to $expectedValue..."
        Set-ItemProperty -Path $regPath -Name $valueName -Value $expectedValue -Type DWord
    } else {
        Write-Host "'$valueName' is already correctly set to $expectedValue."
    }
} catch {
    Write-Host "'$valueName' does not exist. Creating and setting it to $expectedValue..."
    New-ItemProperty -Path $regPath -Name $valueName -Value $expectedValue -PropertyType DWord -Force | Out-Null
}

Write-Host "Check and correction completed."

