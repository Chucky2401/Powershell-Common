function Set-CustomAliases {
    <#
        .SYNOPSIS
            Summary of the script
        .DESCRIPTION
            Script description
        .PARAMETER param1
            Parameter description
        .INPUTS
            Pipeline input data
        .OUTPUTS
            Output data
        .EXAMPLE
            .\template.ps1 param1
        .NOTES
            Name           : Script-Name
            Version        : 1.0.0
            Created by     : {YOUR NAME}
            Date Created   : 04/01/2023
            Modify by      : {YOUR NAME}
            Date modified  : 04/01/2023
            Change         : Creation
        .LINK
            http://github.com/UserName/RepoName
    #>

    #---------------------------------------------------------[Script Parameters]------------------------------------------------------
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', 'ls', Justification = 'Avoid analyzer warning for custom function call')]
    [CmdletBinding()]
    Param (
        #Script parameters go here
    )

    #---------------------------------------------------------[Initialisations]--------------------------------------------------------

    #-----------------------------------------------------------[Functions]------------------------------------------------------------

    # Function only needed in this script!
    # If your function need to be use on several scripts standalone, use a file in .\inc\functions\ and dot-sourced it
    # If your function need to be used in several scripts and used sub-functions, use module instead in .\inc\modules

    #----------------------------------------------------------[Declarations]----------------------------------------------------------

    # Put your local variables here

    #-----------------------------------------------------------[Execution]------------------------------------------------------------

    If (Get-Alias -Name ls) {
      Remove-Alias -Name ls -Scope Global -Force
    }

    function global:ls {
        Update-Eza

        & 'C:\Program Files\eza\eza.exe' $(Set-Arguments -BaseArguments @("--group-directories-first", "-l", "--no-filesize", "--icons=always", "--no-time", "--no-user", "--no-permissions") -OtherArguments $args)
    }

    function global:ll {
        Update-Eza

        & 'C:\Program Files\eza\eza.exe'  $(Set-Arguments -BaseArguments @("--group-directories-first","--git", "-lgh", "--icons=always") -OtherArguments $args)
    }

    function global:la {
        ll $(Set-Arguments -BaseArguments @("-a") -OtherArguments $args)
    }

    Set-Alias -Name lg -Value lazygit -Scope Global

    # Yazi
    function global:y {
        $tmp = [System.IO.Path]::GetTempFileName()
        yazi $args --cwd-file="$tmp"
        $cwd = Get-Content -Path $tmp -Encoding UTF8
        if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
            Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
        }
        Remove-Item -Path $tmp
    }

    #PSReadLine
    Set-PSReadLineKeyHandler -Chord Ctrl+l -ScriptBlock {
        [Microsoft.PowerShell.PSConsoleReadLine]::CancelLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert('cls')
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}
