#Requires -Modules @{ ModuleName = "Tjvs.Message"; ModuleVersion = "1.2.0" }

function Update-Eza {
    <#
        .SYNOPSIS
            Install or Update Eza
        .DESCRIPTION
            Let you install or update Eza in the Programs directory from GitHub only if new version
        .INPUTS
            N/A
        .OUTPUTS
            N/A
        .EXAMPLE
            Update-Eza
        .NOTES
            Name           : Update-Eza
            Version        : 1.0.0
            Created by     : Chucky2401
            Date Created   : 04/01/2023
            Modify by      : Chucky2401
            Date modified  : 22/02/2025
            Change         : Fix error if install for the first time
    #>
    
    #---------------------------------------------------------[Script Parameters]------------------------------------------------------
    
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Low")]
    Param (
        #Script parameters go here
    )
    
    #---------------------------------------------------------[Initialisations]--------------------------------------------------------

    $latestCheck = Get-Date

    if ((Test-Path env:EZA_LATEST_CHECK)) {
      $latestCheck = [datetime]::Parse([System.Environment]::GetEnvironmentVariable("EZA_LATEST_CHECK", [System.EnvironmentVariableTarget]::User))
    }

    If ($latestCheck.AddDays(7) -gt (Get-Date)) {
        return
    }

    #-----------------------------------------------------------[Functions]------------------------------------------------------------
    
    # Function only needed in this script!
    # If your function need to be use on several scripts standalone, use a file in .\inc\functions\ and dot-sourced it
    # If your function need to be used in several scripts and used sub-functions, use module instead in .\inc\modules
    
    #----------------------------------------------------------[Declarations]----------------------------------------------------------
    
    # Put your local variables here
    $ezaExeFolder       = "C:\Program Files\eza\"
    $currentVersion     = [Semver]"0.0.0"
    $currentFileVersion = (Get-ChildItem -Path $ezaExeFolder | Where-Object { $PSItem.Name -Match "^v" })

    if ($null -ne $currentFileVersion) {
      $currentFileVersionPath = $currentFileVersion.FullName
      $currentVersion         = [Semver]($currentFileVersion.Name -replace "v", "")
    }

    $tempDirectory        = New-TemporaryDirectory
    # Eza from GitHub
    $ezaRelease           = Invoke-WebRequest -Method Get -Uri "https://api.github.com/repos/eza-community/eza/releases/latest"
    $ezaReleaseContent    = ($ezaRelease.Content | ConvertFrom-Json)
    $ezaLatestVersion     = [Semver]($ezaReleaseContent.tag_name -replace "v", "")
    $ezaFileLatestVersion = "v$($ezaLatestVersion.ToString())"
    $ezaLatestAssets      = $ezaReleaseContent.assets
    $ezaLatestWindows     = $ezaLatestAssets | Where-Object { $PSItem.name -match "pc-windows-gnu\.zip$" }
    $ezaLatestWindowsUrl  = $ezaLatestWindows.browser_download_url
    $ezaLatestWindowsName = $ezaLatestWindows.name
    $ezaTempArchiveFile   = "$tempDirectory\$ezaLatestWindowsName"
    
    #-----------------------------------------------------------[Execution]------------------------------------------------------------
    
    If ($currentVersion -eq $ezaLatestVersion) {
        return
    }
    
    Write-Message -Type "INFO" -Message "Update eza from {0} to {1}..." -Variables $currentVersion, $ezaLatestVersion
    
    if ($currentVersion -ne [Semver]"0.0.0") {
      Remove-Item -Path $currentFileVersionPath
    }
    
    Invoke-WebRequest -Uri $ezaLatestWindowsUrl -OutFile $ezaTempArchiveFile
    
    Expand-Archive -Path $ezaTempArchiveFile -DestinationPath $ezaExeFolder -Force
    New-Item -Path $ezaExeFolder -Name $ezaFileLatestVersion | Out-Null
    
    [System.Environment]::SetEnvironmentVariable("EZA_LATEST_CHECK", (Get-Date).ToString(), [System.EnvironmentVariableTarget]::User)
    
    Remove-TemporaryDirectories -Folders $tempDirectory

    Write-Message -Type "SUCCESS" -Message "Eza has been updated to {0} successfully" -Variables $ezaLatestVersion
}
