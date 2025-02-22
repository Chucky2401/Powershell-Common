function Remove-TemporaryDirectories {
    <#
        .SYNOPSIS
            Temporaries folder
        .DESCRIPTION
            Remove temporary folders
        .OUTPUTS
            N/A
        .NOTES
            Name           : Remove-TemporaryDirectories
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

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Low")]
    param(
        [Parameter(Mandatory = $False)]
        [String[]]$Folders
    )

    #---------------------------------------------------------- [Initialisation] ----------------------------------------------------------

    #----------------------------------------------------------- [Declaration] ------------------------------------------------------------

    #------------------------------------------------------------ [Execution] -------------------------------------------------------------

    If ([String]::IsNullOrEmpty($Folders)) {
        $Folders = $script:tempDirs
    }

    foreach ($directory in $Folders) {
        Try {
            Remove-Item -Path $directory -Recurse -Force
            $script:tempDirs = $script:tempDirs | Where-Object { $PSItem -ne $directory }
        } Catch {
            Throw "Temporary directory has not been removed"
        }

        Write-Debug "tempDirs = $([String]::Join(" / ", $Folders))"
    }
}
