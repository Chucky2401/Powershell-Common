$ErrorActionPreference  = "Stop"
$global:DebugPreference = "Continue"

Import-Module -Name ".\powershell-common\modules\Tjvs.Utils"

$dir1 = New-TemporaryDirectory

Write-Host "dir1     : $dir1"

$dir2 = New-TemporaryDirectory

Write-Host "dir2     : $dir2"

Remove-Module -Name Tjvs.Utils
