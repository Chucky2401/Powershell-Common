<#
.SYNOPSIS
    Stop EGS Service
.DESCRIPTION
    Function to stop the EGS Service
.INPUTS
    N/A
.OUTPUTS
    N/A
.EXAMPLE
    .\Stop-EGSService.ps1
.NOTES
    Name           : Stop-EGSService
    Version        : 1.0.0
    Created by     : Chucky2401
    Date Created   : 22/02/2025
    Modify by      : Chucky2401
    Date modified  : 22/02/2025
    Change         : Creation
#>

#------------------------------------------------------------ [Parameters] ------------------------------------------------------------

[CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Low")]
Param (
)

#---------------------------------------------------------- [Initialisation] ----------------------------------------------------------

$scriptFilePath = $Script:MyInvocation.MyCommand.Path
$scriptRoot = Split-Path $Script:MyInvocation.MyCommand.Path

$isAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

$powershellExe = "powershell.exe"
If ($PSVersionTable.PSVersion.Major -gt 5) {
    $powershellExe = "pwsh.exe"
}
$powershellFilePath = "$($PSHOME)\$powershellExe"

If (-not $isAdmin) {
    Write-Output "Run with Admin privileges..."
    Start-Process -FilePath $powershellFilePath -ArgumentList $scriptFilePath -Verb RunAs
    exit
}

#------------------------------------------------------------ [Functions] -------------------------------------------------------------

#----------------------------------------------------------- [Declaration] ------------------------------------------------------------

$servicesToStop = @('EpicOnlineServices')

#------------------------------------------------------------ [Execution] -------------------------------------------------------------

Stop-Service -Name $servicesToStop -PassThru

