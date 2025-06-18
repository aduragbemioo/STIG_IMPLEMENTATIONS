
<#
.SYNOPSIS
    PowerShell script that checks whether the registry value 
    DisableHTTPPrinting is configured correctly under the specified path and creates or corrects it if necessary

.NOTES
    Author          : Aduragbemi Oladapo
    LinkedIn        : linkedin.com/in/aduragbemioladapo/
    GitHub          : github.com/aduragbemioo
    Date Created    : 2025-06-18
    Last Modified   : 2025-06-18
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000110

.TESTED ON
    Date(s) Tested  : 2025-06-18
    Tested By       : Aduragbemi
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1.19041.5965

.USAGE
    PS C:\> .\WN10-CC-000110.ps1 
#>


# Define registry path and value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$valueName = "DisableHTTPPrinting"
$desiredValue = 1

# Check if the registry path exists
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path does not exist. Creating path..."
    New-Item -Path $registryPath -Force | Out-Null
}

# Check if the value exists and is set to the correct value
$currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

if ($null -eq $currentValue) {
    Write-Host "$valueName not found. Creating it with value $desiredValue..."
    New-ItemProperty -Path $registryPath -Name $valueName -Value $desiredValue -PropertyType DWORD -Force | Out-Null
} elseif ($currentValue.$valueName -ne $desiredValue) {
    Write-Host "$valueName is set to $($currentValue.$valueName). Updating to $desiredValue..."
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $desiredValue
} else {
    Write-Host "$valueName is already set correctly to $desiredValue."
}

Write-Host "Registry check and remediation complete."
