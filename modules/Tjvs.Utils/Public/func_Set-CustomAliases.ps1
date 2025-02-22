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

    Remove-Alias -Name ls -Scope Global -Force

    function global:ls {
        Update-Eza

        & 'C:\Program Files\eza\eza.exe' $(Set-Arguments -BaseArguments @("--group-directories-first") -OtherArguments $args)
    }

    function global:ll {
        ls $(Set-Arguments -BaseArguments @("--git", "-lh", "-g") -OtherArguments $args)
    }
    
    function global:la {
        ll $(Set-Arguments -BaseArguments @("-a") -OtherArguments $args)
    }

    Set-Alias -Name lg -Value lazygit -Scope Global
}
