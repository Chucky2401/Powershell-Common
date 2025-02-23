function Add-WingetClient {
    <#
        .SYNOPSIS
            Install winget client
        .DESCRIPTION
            Install Microsoft.Winget.Client moduel
        .INPUTS
            N/A
        .OUTPUTS
            N/A
        .EXAMPLE
            Add-WingetClient
        .NOTES
            Name           : Add-WingetClient
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

    #----------------------------------------------------------- [Declaration] ------------------------------------------------------------

    #------------------------------------------------------------ [Execution] -------------------------------------------------------------

    Try {
      Install-Module -Name Microsoft.Winget.Client -Scope CurrentUser -Force -AcceptLicense -WarningAction SilentlyContinue -ErrorAction Stop | Out-Null
    } Catch {
      Write-Exception -Exception $PSItem
      return
    }
    
    Write-Message -Type "SUCCES" -Message "Microsoft.Winget.Client has been installed successfully!"
    $hasWingetClient = $True
    return
}
