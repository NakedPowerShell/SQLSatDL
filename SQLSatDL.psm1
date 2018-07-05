Function Get-SQLSatDL
{
<#
.SYNOPSIS
    Find all download-able content from a SQL Saturday event and download it to a local drive

.DESCRIPTION
    Based upon the SQL Saturday event # passed in, search the SQL Saturday schedule for download-able content
    and then download each file found.

    If the content is a zip file, the optional switch parameter allows the zip to be unarchived

    This is the schedule file searched: http://www.sqlsaturday.com/[Event#]/Sessions/Schedule.aspx

    Output to the target folder/sub-folder:

    Schedule_[Event#].html : Is the download of the Conference Schedule: http://www.sqlsaturday.com/[Event#]/Sessions/Schedule.aspx
    log_SQLSAT.txt : Is a CSV text log of all the files for this event downloaded
    If you said True to unzip files: Sub-folders for all the zip files expanded will exist
    Content files downloaded: PDF, PPTX, ZIP, SQL, and other file extensions from SQL Saturday content authors

.PARAMETER Tpath
    The complete local target download path like "K:\SQLSat_DL"

.PARAMETER Evt
    SQL Saturday event # like 696

.PARAMETER Uz
    Bool parameter to Unzip downloaded content if it is in a ZIP format or not unzip

.EXAMPLE
    Get-SQLSatDL "K:\SQLSat_DL" 696 -Uz $true

    Get-SQLSatDL [-Tpath] <String> [-Evt] <Int32> [-Uz] <bool> [<CommonParameters>]

    First parameter [TPath]: Local target path string where to download content to
    Second parameter[Evt]: SQL Saturday event # (an integer between 500-1000)
    Third parameter [Uz]: $true/$false to unzip zip files

    This will download all the content from SQL Saturday #696 Redmond WA Feb 10 2018

    FYI: Not all the download-able content is available immediately after an event.
    You might want to wait a few days to a week to run this download
    This function can be run as many times as you desire, so you can get the content that arrived after your last scan

.EXAMPLE
    Get-SQLSatDL "K:\SQLSat_DL" 696 -Uz $true -verbose

    Get-SQLSatDL [-Tpath] <String> [-Evt] <Int32> [-Uz] <bool> [<CommonParameters>]

    First parameter [TPath]: Local target path string where to download content to
    Second parameter[Evt]: SQL Saturday event # (an integer between 500-1000)
    Third parameter [Uz]: $true/$false to unzip zip files

    This will download all the content from SQL Saturday #696 Redmond WA Feb 10 2018

    The verbose option will allow you see more details of the inner workings of this function

.NOTES
    Function:
    Get-SQLSatDL : Search event schedule and download content

    List of Upcoming and Past Events: http://www.sqlsaturday.com/

    Session Glimpse: http://www.sqlsaturday.com/696/eventhome.aspx

    Saturday, Feb 10, 2018 Conference Schedule: http://www.sqlsaturday.com/696/Sessions/Schedule.aspx

    This function automates the download of all content for an event where you do not have to
    click on the Download button for each available content in the detailed schedule

    If the function encounters an error, it will write the error message(s) to the screen and
    to the file log_SQLSAT.txt in the proper target folder/sub-folder

    If you rerun this function multiple times, it will check for an existing target folder/sub-folder and skip
    creating a new sub-folder as needed. It will also not download content that already exists in the target folder/sub-folder

    Ideas for extending the output of this function:
    Merge all the CSV log_SQLSAT.txt files in each sub-folder into a SQL table for searching and sorting
    Use a search tool to scan all the Schedule_[Event#].html files in each sub-folder for keywords / authors

Version History
    v1.0  -  [Twitter: @NakedPowerShell] [Blog: https://nakedpowershell.blogspot.com/ ] - Initial Release: 07/05/2018
#>
    [CmdletBinding()]
    param(

        [Parameter(ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
        [string]$TPath,

        [Parameter(ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
        [ValidateRange(300, 1000)]
        [int]$Evt,

        [Parameter(ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
        [bool] $Uz

    )


Clear-Host

[int]$EventNum = $Evt

$tday = Get-Date -Format yyyy-MM-dd-HH-mm-ss
Write-Output "BEGIN Get-SQLSatDL: $tday "
Write-Output "START At Event -> $Evt"
Write-Verbose "Parameters: Tpath: $TPath Evt: $Evt Uz: $Uz"

# simple calculation to keep sub-folders in clusters of 100 SQLSaturday events
# I hate cluttered folders with 100's of sub-folders and files. I prefer a more organized folder / sub-folder structure
# Under the parent folder will be sub-folders like 600_Range, 700_Range, etc based upon the event #
[decimal]$diff = $EventNum / 100
$diffa = [math]::floor($diff)
[string]$strPath = [string]$diffa + "00_Range"
Write-Verbose "strPath: $strPath"

[string]$strEvent = $EventNum

[string]$URI = "http://www.sqlsaturday.com/$strEvent/Sessions/Schedule.aspx"

[string]$DLPath = $TPath + "\$strPath\$strEvent\"
[string]$LogFile = $TPath + "\$strPath\$strEvent\log_SQLSAT.txt"
[string]$ErrFile = $TPath + "\$strPath\$strEvent\err_SQLSAT.txt"

Write-Output "Evt: $Evt URI: $URI"
Write-Verbose "Evt: $Evt URI: $URI LogFile: $LogFile ErrFile: $ErrFile"

if([IO.Directory]::Exists($DLPath))
{
    #Do Nothing
    Write-Output "Path already exists -> $DLPath "
}
else
{
    New-Item -ItemType directory -Path $DLPath
} # end of if directory exists

[string]$Sch = "$DLPath" + "\Schedule_" + "$strEvent" + ".html"
    Write-Verbose "Sch: $Sch"

try
{
$SQLSat = Invoke-WebRequest –Uri $URI -OutFile $Sch -PassThru
}
catch
{
   $line = [pscustomobject]@{
		'DateTime' = (Get-Date)
		'Event' = $strEvent
		'Ext' = 'Empty'
        'DL' = 'Empty'
        'URI' = $URI
        'ErrType' = 'Schedule'
        'Error' = $_.Exception.Message
    }

	$line | Export-Csv -Path $ErrFile -Append -NoTypeInformation -Force

    Write-Error "Fatal Error: $URI retrieve failed. Error message: $($PSItem.ToString())  See $ErrFile for more info"

}

$SQLSat.links |  Where-Object { $_.href -like "*SessionDownload*" }  |
 Select-object @{Name="Article";Expression={"$DLPath"+$_.InnerText}},@{Name="Link";Expression={"http://www.sqlsaturday.com"+$_.href}},@{Name="Filename";Expression={$_.InnerText}} |
  ForEach-Object {
   $DL,$URL,$FN = $_.Article,$_.Link, $_.Filename
   $Ext = [System.IO.Path]::GetExtension("$FN")
   Write-Verbose "`#-$strEvent EXT: $Ext  FN: $FN  URL: $URL DL: $DL "
   Write-Output "`#-$strEvent EXT: $Ext  FN: $FN  URL: $URL "

   $line = [pscustomobject]@{
		'DateTime' = (Get-Date)
		'Event' = $strEvent
		'Ext' = $Ext
        'DL' = $DL
        'URL' = $URL
    }

    $line | Export-Csv -Path $LogFile -Append -NoTypeInformation -Force

    [string]$Tfile = $DLPath + $FN

   if (Test-Path $Tfile) {

   # exists
   Write-Output "File name already downloaded-> FN: $Tfile"

}Else{

 invoke-webrequest -Uri $URL -OutFile $DL

    if (($Uz) -and ($Ext -eq ".zip")) {
        Write-Output "Zip Name-> $Ext -> $fn -> $DL"
        [string]$DLUz = $DL -replace (".zip","_UZ")
        Write-Output "New Folder Name From ZIP-> $DLUz"
        try{
            Expand-Archive -LiteralPath "$DL" -DestinationPath "$DLUz" -Force
        }
        catch
        {
            $line = [pscustomobject]@{
		    'DateTime' = (Get-Date)
		    'Event' = $strEvent
		    'Ext' = 'Empty'
            'DL' = $DL
            'URI' = $DLUz
            'ErrType' = 'Expand'
            'Error' = $_.Exception.Message
        }

	$line | Export-Csv -Path $ErrFile -Append -NoTypeInformation -Force
    Write-Error "Fatal Error: $DLUz expand failed. Error message: $($PSItem.ToString())  See $ErrFile for more info"

        }

    } # end of if unzip

} # end of processing links

}

Write-Output "END At Event -> $Evt"
$tday = Get-Date -Format yyyy-MM-dd-HH-mm-ss
Write-Output "COMPLETE Get-SQLSatDL: $tday "

} # end of function Get-SQLSatDL

##############
# Test Cases #
##############

#Clear-host
#Get-SQLSatDL "K:\SQLSat_DL" 696 Y

#Clear-host
#Get-SQLSatDL "K:\SQLSat_DL" 599 -Uz $true -Verbose

#Clear-host
#Get-SQLSatDL "K:\SQLSat_DL" 599 -Uz $true

#Clear-host
#Get-SQLSatDL "K:\SQLSat_DL" 599 -Uz $false -Verbose

#Clear-host
#Get-SQLSatDL "K:\SQLSat_DL" 599 -Uz $false

#Clear-host
#Get-SQLSatDL "K:\SQLSat_DL" 332 -Uz $true


#Clear-Host
#get-help Get-SQLSatDL -Full
