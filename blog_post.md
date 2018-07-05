# Blog Post for Get-SQLSatDL

Blog: Get-SQLSat

Get-SQLSatDL : Release Date - 07/05/2018 Version 1.0

In February 2018 I went to my third SQL Saturday in Redmond WA, held on the campus of Microsoft.

I had an awesome time and got to reconnect with many SQL friends and met plenty of new ones.

I always learn so much from the session speakers and I look forward to seeing what kind of content they post on the SQL Saturday website a few days later.
A few days after the event, I went to the schedule web page:

 <http://www.sqlsaturday.com/696/Sessions/Schedule.aspx>

And then proceeded to click on each download icon under the sessions that did have content.

I had to click the download button 27 times.

I could hear Jeffery Snover’s (Microsoft Fellow and Inventor of PowerShell) voice in my head, “don’t be a click next person, automate”.

I was also looking at a few other past events from around the country that I was interested in downloading.

That would be a lot of clicking download.

I created a PowerShell function to automate the downloading of all the content posted to the schedule page of the SQL Saturday event.

I call it Get-SQLSatDL that has only 3 parameters, the first is the local drive and path where you want the downloads to be stored, second is the SQL Saturday event # and then lastly if you want any zip files to be automatically expanded.

For example:

Get-SQLSatDL "K:\SQLSat_DL" 696 -Uz $true

`Get-SQLSatDL [-Tpath] <String> [-Evt] <Int32> [-Uz] <bool> [<CommonParameters>]`

    First parameter [TPath]: Local target path string where to download content to
    Second parameter[Evt]: SQL Saturday event # (an integer between 500-1000)
    Third parameter [Uz]: $true/$false to unzip zip files

You can find my code on GitHub:

<https://github.com/NakedPowerShell/SQLSatDL>

## Installing SQLSatDL

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

If you have any questions, you can find me on Twitter @NakedPowerShell
 or send me an email at `NakedPowerShell at gmail.com`

## Future Ideas

Ideas for extending the output of this function:

    - Merge all the CSV log_SQLSAT.txt files in each sub-folder into a SQL table for searching and sorting
    - Use a search tool to scan all the Schedule_[Event#].html files in each sub-folder for keywords / authors