# Get-SQLSatDL

## Function

`Get-SQLSatDL [-Tpath] <String> [-Evt] <Int32> [-Uz] <String> [<CommonParameters>]`

## Description

Find all download-able content from a SQL Saturday event and download it to a local drive

Authored by @NakedPowerShell

    Based upon the SQL Saturday event # passed in, search the SQL Saturday schedule for download-able content and then download each file found.

    If the content is a zip file, the optional switch parameter allows the zip to be unarchived.

    This is the schedule file searched: http://www.sqlsaturday.com/[Event#]/Sessions/Schedule.aspx

    Output to the target folder/sub-folder:

    - Schedule_[Event#].html : Is the download of the Conference Schedule: http://www.sqlsaturday.com/[Event#]/Sessions/Schedule.aspx
    - log_SQLSAT.txt : Is a CSV text log of all the files for this event downloaded
    - If you said True to unzip files: Sub-folders for all the zip files expanded will exist. Content files downloaded: PDF, PPTX, ZIP, SQL, and other file extensions from SQL Saturday content authors

## Parameters

- PARAMETER Tpath : The complete local target download path like "K:\SQLSat_DL"  
- PARAMETER Evt : SQL Saturday event # like 696
- PARAMETER Uz : Switch parameter to Unzip downloaded content if it is in a ZIP format or not unzip

## Example

`Get-SQLSatDL "K:\SQLSat_DL" 696 Y`

`Get-SQLSatDL [-Tpath] <String> [-Evt] <Int32> [-Uz] <String> [<CommonParameters>]`

    First parameter [TPath]: Local target path string where to download content to
    Second parameter[Evt]: SQL Saturday event # (an integer between 500-1000)
    Third parameter [Uz]: Y/N to unzip zip files

    This will download all the content from SQL Saturday #696 Redmond WA Feb 10 2018

    FYI: Not all the download-able content is available immediately after an event.
    You might want to wait a few days to a week to run this download
    This function can be run as many times as you desire, so you can get the content that arrived after your last scan

## Notes

    Function:
    Get-SQLSatDL : Search event schedule and download content

    List of Upcoming and Past Events: http://www.sqlsaturday.com/

    Session Glimpse: http://www.sqlsaturday.com/696/eventhome.aspx

    Saturday, Feb 10, 2018 Conference Schedule: http://www.sqlsaturday.com/696/Sessions/Schedule.aspx

    This function automates the download of all content for an event where you do not have to click on the Download button for each available content in the detailed schedule

    If the function encounters an error, it will write the error message(s) to the screen and to the file log_SQLSAT.txt in the proper target folder/sub-folder

    If you rerun this function multiple times, it will check for an existing target folder/sub-folder and skip creating a new sub-folder as needed. It will also not download content that already exists in the target folder/sub-folder

    Ideas for extending the output of this function:
    Merge all the CSV log_SQLSAT.txt files in each sub-folder into a SQL table for searching and sorting
    Use a search tool to scan all the Schedule_[Event#].html files in each sub-folder for keywords / authors
  
## Version History

    v1.0  -  [Twitter: @NakedPowerShell] [Blog: <https://nakedpowershell.blogspot.com/> ] - Initial Release
