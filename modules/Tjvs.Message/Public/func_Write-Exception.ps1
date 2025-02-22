function Write-Exception {
    <#
        .SYNOPSIS
            Print an formatted exception
        .DESCRIPTION
            Pass an exception to this function to print it formatted. You can also send the exception to a LogFile
            but you need to pass a ref to the file path.
            If youre DebugPreference variable is set to Continue or Verbose is used, you will have
            the StackTrace and the InvocationLine in the print.
            If you use the LogOnly switch, nothing will be print to the screen.
        .PARAMETER Exception
            Exception to format
        .PARAMETER LogFile
            Reference to the log file path.
            The reference must be a path as a string.
        .PARAMETER LogOnly
            Send message only to log file and does not print anything to screen.
        .EXAMPLE
            Write-Exception -Exception $PSItem -LogFile ([ref]"path\to\file.log")
        .NOTES
            Name           : Write-Exception
            Created by     : Chucky2401
            Date created   : 22/02/2025
            Modified by    : Chucky2401
            Date modified  : 22/02/2025
            Change         : Creation
    #>

    [CmdletBinding(DefaultParameterSetName = "Show")]
    Param (
        [Parameter(Mandatory = $True, ParameterSetName = "Show", Position = 0)]
        [Parameter(Mandatory = $True, ParameterSetName = "Log", Position = 0)]
        [AllowEmptyString()]
        [Alias("m")]
        [Object]$Exception,
        [Parameter(Mandatory = $True, ParameterSetName = "Log", Position = 1)]
        [Alias("f")]
        [ref]$LogFile,
        [Parameter(Mandatory = $False, ParameterSetName = "Log", Position = 1)]
        [Alias("l")]
        [Switch]$LogOnly
    )

    If ($PsCmdlet.ParameterSetName -eq "Show") {
        $LogFile = ([ref]$null)
    }

    $sErrorMessage   = $Exception.Exception.Message
    $sStackTrace     = $Exception.ScriptStackTrace -replace "`r`n", "`r`n`t"
    $sInvocationLine = $Exception.InvocationInfo.Line

    Write-Message -Type "ERROR" -Message "Error: $($sErrorMessage)" -LogFile $LogFile
    Write-Message -Type "DEBUG" -Message "Details:" -LogFile $LogFile
    If ($DebugPreference -eq "Continue" -or $PSBoundParameters['Verbose']) {
        Write-Message -Type "OTHER" -Message "`t$($sStackTrace)" -LogFile $LogFile
        Write-Message -Type "OTHER" -Message "`t$($sInvocationLine)" -LogFile $LogFile
    }
}
