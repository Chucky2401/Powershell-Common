function Test-WingetInstalled {
    <#
        .SYNOPSIS
            Test if winget is installed
        .DESCRIPTION
            Test if Microsoft.Winget.Client is installed and call function to install it if not
        .INPUTS
            N/A
        .OUTPUTS
            N/A
        .EXAMPLE
            Test-WingetInstalled
        .NOTES
            Name           : Test-WingetInstalled
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

    $wingetIsInstalled = Get-Module -Name Microsoft.Winget.Client -ListAvailable

    if ($null -ne $wingetIsInstalled) {
      $hasWingetClient = $True
      return
    }

    Write-Message -Type "WARNING" -Message "Installing module Microsoft.Winget.Client..."
    Try {
      Add-WingetClient
      $hasWingetClient = $True
    } Catch {
      return
    }

    return
}
