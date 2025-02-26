function Install-Modules {
    <#
    .SYNOPSIS
        Install modules
    .DESCRIPTION
        Check if the modules sent in parameter are present, otherwise install them.
        Finally, if the module is present, but not the right version, update it
    .PARAMETER Modules
        Array of modules object to install.
        This format:
        [PSCustomObject]@{
            Name    = "posh-git"
            Version = [version]"1.1.0"
        }
        If you don't care about version, set it to '0.0.0'
    .PARAMETER AllUsers
        If you want to install the module for all users, set this switch.
        Caution: You must have the admin rights to install modules for all users.
    .INPUTS
        None
    .OUTPUTS
        None
    .EXAMPLE
        Install-Modules [PSCustomObject]@{Name = "posh-git"; Version = [version]"1.1.0"}, [PSCustomObject]@{Name = "PSFzF"; Version = [version]"2.6.7"}

        Install or update modules posh-git (1.1.0) and PSFzF (2.6.7)
    .EXAMPLE
        $requiredModules = @([PSCustomObject]@{Name = "posh-git"; Version = [version]"1.1.0"}, [PSCustomObject]@{Name = "PSFzF"; Version = [version]"2.6.7"})
        Install-Modules $requiredModules

        Install or update modules, same as above but with a var
    .NOTES
        Name           : Install-Modules
        Version        : 1.0.0
        Created by     : Chucky2401
        Date Created   : 30/09/2024
        Modify by      : Chucky2401
        Date modified  : 26/02/2025
        Change         : Creation
    #>

    #---------------------------------------------------------[Script Parameters]------------------------------------------------------

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Low", DefaultParameterSetName = "Object")]
    Param (
        [Parameter(Mandatory = $True, ParameterSetName = "Object")]
        [PSCustomObject[]]$Modules,
        [Parameter(Mandatory = $True, ParameterSetName = "Array")]
        [String[]]$Names,
        [Parameter(Mandatory = $False)]
        [Switch]$AllUsers
    )

    #---------------------------------------------------------[Initialisations]--------------------------------------------------------

    $securityProtocol = [Net.ServicePointManager]::SecurityProtocol

    If ($securityProtocol.ToString() -notmatch "Tls12") {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }

    $Scope = "CurrentUser"
    If ($AllUsers) {
        $Scope = "AllUsers"
    }

    If ($PSCmdlet.ParameterSetName -eq "Array") {
      $Modules = $Names
    }

    #-----------------------------------------------------------[Functions]------------------------------------------------------------

    function HasProperty() {
        Param(
            [Parameter(Mandatory = $True)]
            [Object]$Object,
            [Parameter(Mandatory = $True)]
            [String]$PropertyName
        )

        [bool]($Object.PSobject.Properties.name -match $PropertyName)
    }

    #----------------------------------------------------------[Declarations]----------------------------------------------------------

    # Package Provider
    $providerName        = "NuGet"
    $providerVersionMini = "2.8.5.201"

    $fallbackVersion = [version]"0.0.0"

    # Filter
    [ScriptBlock]$filterPath = { $PSItem.Path -match ".+" }

    If ($Scope -eq "CurrentUser") {
        [ScriptBlock]$filterPath = { $PSItem.Path -match "^$([Regex]::Escape([System.Environment]::GetFolderPath("MyDocuments")))" }
    }

    #-----------------------------------------------------------[Execution]------------------------------------------------------------

    If (-not (Get-PackageProvider -Name $providerName -ListAvailable -ErrorAction SilentlyContinue)) {
        Install-PackageProvider -Name $providerName -MinimumVersion $providerVersionMini -Force | Out-Null
    }

    foreach ($module in $Modules) {
        $currentModule = $module

        If ($module.GetType().Name -eq "String") {
          $currentModule = [PSCustomObject]@{
            Name    = $module
            Version = [version]"0.0.0"
          }
        }

        If (-not (HasProperty $currentModule "Name")) {
            Write-Host "The module object must have a 'Name' property" -ForegroundColor Yellow
            Continue
        }

        If (-not (HasProperty $currentModule "Version")) {
            $currentModule | Add-Member -MemberType NoteProperty -Name Version -Value $fallbackVersion
        }

        $installParameters = @{
            Name  = $currentModule.Name
            Scope = $Scope
        }

        If ($currentModule.Version -ne $fallbackVersion) {
            $installParameters.Add("RequiredVersion", [version]$currentModule.Version)
        }

        $infoLocalModule = Get-Module -Name $currentModule.Name -ListAvailable | Where-Object $filterPath

        If (-not $infoLocalModule) {
            Try {
                Install-Module @installParameters
            } Catch {
                Install-Module @installParameters -AllowClobber
            }
            Continue
        }

        If ($currentModule.Version -eq $fallbackVersion) {
          $currentVersion = [version]($infoLocalModule | Sort-Object Version -Descending | Select-Object -First 1).Version
          $cloudVersion = [version](Find-Module -Name $infoLocalModule.Name -WarningAction SilentlyContinue).Version

          if ($currentVersion -lt $cloudVersion) {
            Try {
              Update-Module @installParameters
            } Catch {
              Update-Module @installParameters -AllowClobber
            }
          }
          continue
        }

        If ($infoLocalModule.Count -eq 1) {
            If ($infoLocalModule.Version -lt $currentModule.Version) {
                Update-Module @installParameters
                Continue
            }

            If ($infoLocalModule.Version -gt $currentModule.Version) {
                Try {
                    Install-Module @installParameters
                } Catch {
                    Install-Module @installParameters -AllowClobber
                }
            }
        }

        If ($infoLocalModule.Count -gt 1) {
            If (-not $infoLocalModule.Version.Contains($currentModule.Version)) {
                Try {
                    Install-Module @installParameters
                } Catch {
                    Install-Module @installParameters -AllowClobber
                }
            }
        }

    }
}
