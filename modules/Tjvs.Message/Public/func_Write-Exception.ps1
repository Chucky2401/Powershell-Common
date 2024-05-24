function Write-Exception {
    <#
        .SYNOPSIS
            Displays a message
        .DESCRIPTION
            This function displays a message with a different colour depending on the type of message, and let you log it to a file.
            It also displays the date and time at the beginning of the line, followed by the type of message in brackets.
        .PARAMETER Type
            Type de message :
                INFO    : Informative message in blue
                WARNING : Warning message in yellow
                ERROR   : Error message in red
                SUCCESS : Success message in green
                DEBUG   : Debugging message in blue on black background
                OTHER   : Informative message in blue but without the date and type at the beginning of the line
        .PARAMETER Message
            Message to be displayed
        .PARAMETER Variables
            If you message contains some placeholders (like: {0}, {1}, etc.) put in this parameter the variable to replace them
        .PARAMETER LogFile
            String or variable reference indicating the location of the log file.
            It is possible to send a variable of type Array() so that the function returns the string. See Example 3 for usage in this case.
        .EXAMPLE
            Write-Message "INFO" "File recovery..." ([ref]"C:\Temp\trace.log")

            Show to the console "[19/04/2023 - 10:35:46] (INFO)    File recovery..."
        .EXAMPLE
            Write-Message "WARNING" "Process not found" -Logging -LogFile ([ref]"C:\Temp\trace.log")

            Show to the console "[19/04/2023 - 10:35:46] (WARNING) Process not found" and write it to the file 'C:\Temp\trace.log'
        .EXAMPLE
            $bufferLog = @()
            Write-Message "WARNING" "Processus introuvable" ([ref]bufferLog)

            Show to the console "[19/04/2023 - 10:35:46] (WARNING) Processus introuvable" and store it to the array $bufferLog
        .NOTES
            Name           : Write-Message
            Created by     : Chucky2401
            Date created   : 18/04/2023
            Modified by    : Chucky2401
            Date modified  : 18/04/2023
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
