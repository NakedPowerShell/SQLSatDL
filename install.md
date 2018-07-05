# Installing SQLSatDL

Download the code from <https://github.com/NakedPowerShell/SQLSatDL>
and put it in a local folder like C:\SQLSatDL

## Run PowerShell command line or PowerShell ISE

From within PowerShell type this:

Import-Module C:\SQLSatDL\SQLSatDL.psm1

`# To see a few examples for this module run this`

Get-Help Get-SQLSatDL -Examples

## To download SQL Saturday Event #696 content Redmond WA

`# Decide where you want to store the content downloaded like K:\SQLSat_DL`

Get-SQLSatDL "K:\SQLSat_DL" 696 -Uz $true

## To download SQL Saturday Event #696 Redmond WA content with Verbose

Get-SQLSatDL "K:\SQLSat_DL" 696 -Uz $true -verbose

`# To see all the comment based help`

Get-Help Get-SQLSatDL -All
