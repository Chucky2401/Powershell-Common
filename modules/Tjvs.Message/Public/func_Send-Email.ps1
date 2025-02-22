function Send-Email {
    <#
        .SYNOPSIS
            Send an email
        .DESCRIPTION
            Send an email with .NET classes
        .PARAMETER From
            Sender of the email
        .PARAMETER To
            Recipient of the email
        .PARAMETER CarbonCopy
            Recipient in copy
        .PARAMETER BlindCarbonCopy
            Recipient in blind copy
        .PARAMETER Server
            SMTP Server
        .PARAMETER Object
            Subject of the email
        .PARAMETER Body
            Body of the email
        .PARAMETER Html
            To set the body as HTML
        .PARAMETER Low
            To set the email as a Low priority
        .PARAMETER High
            To set the email as a High priority
        .PARAMETER Attachments
            Attachments of the email
        .PARAMETER ReplyTo
            Who will received the answer to the email
        .EXAMPLE
            Send-Email -To "myemail@gmail.com" -Object "Automatic download" -Body "Everything was fine" -Html -Attachments "C:\Temp\download_auto.log"
        .EXAMPLE
            Send-Email -From "mysender@gmail.com" -To "myemail@gmail.com" -Server "smtp.google.com" -Object "Alert on Zabbix Server!" -Body "Zabbix server is unreachable" -High
        .NOTES
            Name           : Send-Email
            Version        : 1.2
            Created by     : Chucky2401
            Date Created   : 05/08/2022
            Modify by      : Chucky2401
            Date modified  : 26/04/2023
            Change         : Add Low/High parameters. And define To and Server parameter as optional
        .LINK
            http://github.com
    #>
    [cmdletbinding(DefaultParameterSetName = "Normal")]
    Param (
        [Parameter(Mandatory = $False, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("f")]
        [string]$From = "",
        [Parameter(Mandatory = $False, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("d")]
        [string]$DisplayName = "",
        [Parameter(Mandatory = $False, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("e")]
        [string]$ReturnPath = "",
        [Parameter(Mandatory = $True, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $True, ParameterSetName = "Low")]
        [Parameter(Mandatory = $True, ParameterSetName = "High")]
        [Alias("t")]
        [string]$To,
        [Parameter(Mandatory = $False, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("cc")]
        [string[]]$CarbonCopy,
        [Parameter(Mandatory = $False, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("bcc")]
        [string[]]$BlindCarbonCopy,
        [Parameter(Mandatory = $False, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("s")]
        [string]$Server = "smtp.google.com",
        [Parameter(Mandatory = $False, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("p")]
        [int]$Port = 587,
        [Parameter(Mandatory = $False, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("k")]
        [Switch]$EnableSSL,
        [Parameter(Mandatory = $False, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("u")]
        [String]$Authentication = "",
        [Parameter(Mandatory = $False, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("o")]
        [string]$Object,
        [Parameter(Mandatory = $True, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $True, ParameterSetName = "Low")]
        [Parameter(Mandatory = $True, ParameterSetName = "High")]
        [Alias("b")]
        [string]$Body,
        [Parameter(Mandatory = $False, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("h")]
        [Switch]$Html,
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Alias("l")]
        [Switch]$Low,
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("g")]
        [Switch]$High,
        [Parameter(Mandatory = $False, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("a")]
        [string[]]$Attachments,
        [Parameter(Mandatory = $False, ParameterSetName = "Normal")]
        [Parameter(Mandatory = $False, ParameterSetName = "Low")]
        [Parameter(Mandatory = $False, ParameterSetName = "High")]
        [Alias("r")]
        [string]$ReplyTo = ""
    )

    $aAttachments = @()

    Try {
        $oSmtp               = New-Object System.Net.Mail.SmtpClient $Server
        $oSmtp.Port          = $Port
        If ($EnableSSL) {
            $oSmtp.EnableSsl = $True
        }

        If ([String]::IsNullOrEmpty($Authentication)) {
            $oSmtp.Credentials = New-Object System.Net.NetworkCredential("", "")
        }

        If (-not [String]::IsNullOrEmpty($Authentication)) {
            $oSmtp.DeliveryMethod = 0 #Network
            $oSmtp.UseDefaultCredentials = $False
            $oSmtp.Credentials = New-Object System.Net.NetworkCredential($From, $Authentication)
        }
    
        $mailAddressSender   = New-Object System.Net.Mail.MailAddress($From, $DisplayName)
        $oMessage            = New-Object System.Net.Mail.MailMessage($mailAddressSender, $To)

        $CarbonCopy | ForEach-Object {
            If (-not [String]::IsNullOrEmpty($PSItem)) { $oMessage.CC.Add($PSItem) }
        }

        $BlindCarbonCopy | ForEach-Object {
            If (-not [String]::IsNullOrEmpty($PSItem)) { $oMessage.Bcc.Add($PSItem) }
        }

        $oMessage.Subject                     = $Object
        $oMessage.Body                        = $Body
        $oMessage.IsBodyHtml                  = $Html
        $oMessage.ReplyTo                     = $ReplyTo
        $oMessage.DeliveryNotificationOptions = "OnFailure, Delay"
        $oMessage.Headers.Add("Return-Path", $ReturnPath)
        If ($Low) {
            $oMessage.Priority = 1
        }

        If ($High) {
            $oMessage.Priority = 2
        }
    
        foreach ($attachment in $Attachments) {
            $aAttachments += New-Object System.Net.Mail.Attachment $attachment
        }
    
        $aAttachments | ForEach-Object {
            $oMessage.Attachments.Add($PSItem)
        }
    
        $oSmtp.Send($oMessage)
    } Catch {
        $sErrorMessage = $_.Exception.Message
        Throw "$($sErrorMessage)"
    } Finally {
        If ($aAttachments.Length -ge 1) {
            $aAttachments.Dispose()
        }
        $oMessage.Dispose()
    }
}
