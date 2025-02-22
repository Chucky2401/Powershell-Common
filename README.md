# Powershell Common

My PowerShell modules or functions I used day-to-day.

## Modules

<details>
<summary>Tjvs.Message</summary>

Modules with functions related to text.

### Send-Email

Send an email using .NET assembly, as the Send-MailMessage is deprecated.

**Parameters**:

- From
- DisplayName
- ReturnPath
- To
- CarbonCopy
- BlindCarbonCopy
- Server (default: smtp.google.com)
- Port (default 587)
- EnableSSL
- Authentication
- Object
- Body
- Html
- Low
- High
- Attachments
- ReplyTo

---

### Write-CenterText

Print a message at the center of the current shell and write to a file if LogFile parameter is used.

**Parameters**:

- String
- LogFile

---

### Write-Exception

Print an formatted exception

**Parameters**:

- Exception
- LogFile
- LogOnly

---

### Write-Message

Display a formatted message on screen.

Except with the 'OTHER' message type, the format will always be:

**[dd.MM.yyyy - HH:mm:ss] (TYPE) Message**

Between *(TYPE)* and *Message* the space will adapt to always have the start of the message at the same position.

**Parameters**:

- Type
  - INFO
  - WARNING
  - ERROR
  - SUCCESS
  - DEBUG
  - OTHER
- Message
- Variables
- LogFile
- LogOnly

</details>

<details>
<summary>Tjvs.Utils</summary>

Modules with useful functions.

### New-TemporaryDirectory

This function is related to a Windows lacking. Natively we have `New-TemporaryFile` but not for a directory.
Here it is !

Plus, when you remove the modules from your shell, all temporary directory created will be removed.

**Parameters**:

- Folder (default: $env:TEMP)
- Name (default: Random)

---

### Set-CustomAliases

Function call in my PowerShell profile file to create some "aliases". I use double-quotes 'cause for
some of them, this is a function.

**Aliases**:

- ls: Using `eza` to display files and folder with Unix-style on one column
- ll: Same as `ls` but closer to the Unix-style with Git information
- la: `ll` with hidden files and directories
- y: Shell wrapper for **Yazi**, take from official documentation
- Ctrl+l: Shortcut set with `Set-PSReadLineKeyHandler` to erase screen quickly

---

### Update-Eza

Install or update your eza executable in Programs directory.

The update function is called everytime you use one of the aliases above, but only if the last
check has been done 7 days ago.

The script will use the environment variable `EZA_LATEST_CHECK` in the current user scope.
You will need to create the folder `C:\Program Files\eza` before using this script.

</details>

## Functions

Actually just one function, but maybe more later!

### Stop-EGSService

I had an issue with my computer, random freeze, but strange freeze. The windows only freeze after usage of 
the mouse or the keyboard. Until I tried to do something, the windows will keep working fine.

I suspect the EGS to be the problem, so I decided to have something to stop the EGS service, at least, after
each time I stopped to play. As I use Playnite, it was easy to have this scheduled.

But, to stop a service, you need admin rights. So I create this function to do it, but before it check if
it starts with admin rights, otherwise restart itself with admin rights.

I wrapped this function in a scheduled task, set to start interactive with admin rights, and with Playnite
I start the scheduled task.
