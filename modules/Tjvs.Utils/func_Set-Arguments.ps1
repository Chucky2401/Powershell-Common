function Set-Arguments {
    <#
        .SYNOPSIS
            Temporaries folder
        .DESCRIPTION
            Remove temporary folders
        .OUTPUTS
            N/A
        .NOTES
            Name           : Set-Arguments
            Version        : 1.0.0
            Created by     : Chucky2401
            Date Created   : 22/05/2024
            Modify by      : Chucky2401
            Date modified  : 22/05/2024
            Change         : Creation
        .LINK
            https://github.com/
    #>

    #------------------------------------------------------------ [Parameters] ------------------------------------------------------------

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $False)]
        [System.Object[]]$BaseArguments,
        [Parameter(Mandatory = $False)]
        [System.Object[]]$OtherArguments
    )

    #---------------------------------------------------------- [Initialisation] ----------------------------------------------------------

    #----------------------------------------------------------- [Declaration] ------------------------------------------------------------

    #------------------------------------------------------------ [Execution] -------------------------------------------------------------

    If ([String]::IsNullOrEmpty($OtherArguments)) {
        return $BaseArguments
    }

    foreach ($argument in $OtherArguments) {
        Try {
            $BaseArguments += $argument
        } Catch {
            return $BaseArguments
        }
    }

    return $BaseArguments
}
