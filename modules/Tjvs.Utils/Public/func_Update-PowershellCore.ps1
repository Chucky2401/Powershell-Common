function Update-PowerShellCore {
    <#
        .SYNOPSIS
            Update PowerShell
        .DESCRIPTION
            Use the microsoft 'install-powershell.ps1' script to update PowerShell
        .INPUTS
            N/A
        .OUTPUTS
            N/A
        .EXAMPLE
            Update-PowerShellCore
        .NOTES
            Name           : Update-PowerShellCore
            Version        : 1.0.0
            Created by     : Chucky2401
            Date Created   : 23/02/2025
            Modify by      : Chucky2401
            Date modified  : 23/02/2025
            Change         : Creation
        .LINK
            https://github.com/
    #>

    #------------------------------------------------------------ [Parameters] ------------------------------------------------------------

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Low")]
    param(
    )

    #---------------------------------------------------------- [Initialisation] ----------------------------------------------------------

    $majorVersion = $PSVersionTable.Major

    #----------------------------------------------------------- [Declaration] ------------------------------------------------------------

    #------------------------------------------------------------ [Execution] -------------------------------------------------------------

    if ($majorVersion -gt 5) {
      Write-Message -Type "WARNING" -Message "You're using PowerShell $marjoVersion,`nyou'll have to restart your shell after update."
    }

    Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"

}
