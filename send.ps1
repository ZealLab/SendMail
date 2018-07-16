#requires -version 2
<#
.SYNOPSIS
  Send is a command that is used to quickly send an email to a recipiant.
.DESCRIPTION
  Send an email to anyone!
.PARAMETER <Parameter_Name>
    -u User   The E-Mail Recipiant
    -a Attachment   Attachment is optional
    -s Subject The E-Mail Subject
    -b Body   The E-Mail Body

.INPUTS
  None
.OUTPUTS
  Log file stored in C:\Windows\Temp\send.log
.NOTES
  Version:        1.0
  Author:         Ryan Bowen
  Creation Date:  07/14/2018
  Purpose/Change: Initial script development
.EXAMPLE
  .\send.ps1 -u zeallab813@gmail.com -s Hi -b "How are you today" -a .\test.txt
#>

##################
# Initialisation #
##################

Param(
    [Parameter(Mandatory=$true)][string]$Recipient,
    [Parameter(Mandatory=$true)][string]$Subject,
    [Parameter(Mandatory=$true)][string]$Body,
    [Parameter(Mandatory=$false)][string]$Attachment
    )

$ErrorActionPreference = "Continue"


################
# Declarations #
################

$dat = $(Get-Date -Format MM-dd-yyyy)
if ($(Test-Path -Path $PSScriptRoot\sendCfg.psd1) -eq ($false))
{
[string]$a1 = $(Read-Host -Prompt "Please enter the SMTP Server")
[string]$b1 = $(Read-Host -Prompt "Please enter the SMTP User")
$c1 = $(Read-Host -Prompt "Please enter the SMTP Password" -AsSecureString | ConvertFrom-SecureString)
@"
@{
Server = "$a1"
User = "$b1"
Password = "$c1"
}
"@ | Out-File -FilePath $PSScriptRoot\sendCfg.psd1
}
Import-LocalizedData -BindingVariable "Smtp" -BaseDirectory $PSScriptRoot -FileName sendCfg.psd1

#############
# Execution #
#############

$Password = $Smtp.Password | ConvertTo-SecureString
$Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $Smtp.User, $Password
$MailtTo = 'zeallab813@gmail.com'  
$MailFrom = "$env:ComputerName <botmailer813@gmail.com>"  
if ($Attachment)
    {
    Send-MailMessage -To "$Recipient" -from "$MailFrom" -Subject $Subject -Body $Body -SmtpServer $Smtp.Server -UseSsl -Attachments $Attachment -Credential $Credentials
    }
else
    {
    Send-MailMessage -To "$Recipient" -from "$MailFrom" -Subject $Subject -Body $Body -SmtpServer $Smtp.Server -UseSsl -Credential $Credentials
    }