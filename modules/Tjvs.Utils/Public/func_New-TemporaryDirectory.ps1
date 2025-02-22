function New-TemporaryDirectory {
    <#
        .SYNOPSIS
            Temporary folder
        .DESCRIPTION
            Create temporary folder
        .PARAMETER Folder
            Custom root folder for the new temporary directory
        .PARAMETER Name
            Custom folder name
        .OUTPUTS
            Path to the new folder
        .EXAMPLE
            New-TemporaryDirectory

            Create folder: C:\Users\tbrejon\AppData\Local\Temp\e1cdu1u3.zab\
            The last folder is random
        .EXAMPLE
            New-TemporaryDirectory -Folder C:\Temp

            Create folder: C:\Temp\cmb42ejj.qpx\
            The last folder is random
        .EXAMPLE
            New-TemporaryDirectory -Folder C:\Temp -Name $([System.Guid]::NewGuid())

            C:\Temp\0b92143d-3762-457d-bb53-06c3f6d3d3fc\
            The last folder is random
        .NOTES
            Name           : New-TemporaryDirectory
            Version        : 1.0.0
            Created by     : Chucky2401
            Date Created   : 05/08/2022
            Modify by      : Chucky2401
            Date modified  : 22/05/2024
            Change         : Add to module
        .LINK
            https://github.com/
    #>

    #------------------------------------------------------------ [Parameters] ------------------------------------------------------------

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Low")]
    param(
        [Parameter(Mandatory = $False)]
        [String]$Folder = [System.IO.Path]::GetTempPath(),
        [Parameter(Mandatory = $False)]
        [String]$Name = [System.IO.Path]::GetRandomFileName()
    )

    #---------------------------------------------------------- [Initialisation] ----------------------------------------------------------

    #----------------------------------------------------------- [Declaration] ------------------------------------------------------------

    $sTempFolder = Join-Path $Folder $Name

    #------------------------------------------------------------ [Execution] -------------------------------------------------------------

    Try {
        New-Item -ItemType Directory -Path $sTempFolder -ErrorAction Stop | Out-Null
        $script:tempDirs += $sTempFolder
    } Catch {
        Throw "Temporary directory has not been created"
    }

    Write-Debug "sTempFolder = $sTempFolder"
    Write-Debug "tempDirs    = $([String]::Join(" / ", $script:tempDirs))"

    return $sTempFolder
}
