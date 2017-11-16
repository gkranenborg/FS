# Version 1.0
#
# Written by Gerben Kanenborg 02/13/2017
# This script will find files by name system wide and Email a report if any files have been found.
#
$users = "gerben.kranenborg@us.fujitsu.com"
$drives = ('C:\', 'D:\', 'E:\')
$errorfile = "C:\errorfile"

If (Test-Path $errorfile) 
    { 
        Remove-Item $errorfile 
    }
	
foreach ($i in $drives) {

$files = Get-ChildItem -Path $i -Filter Photo.scr -Recurse -ErrorAction SilentlyContinue -Force | % { $_.Fullname }
Add-Content $errorfile $files;

}

# If (Test-Path $errorfile) 
#    {
#		if ((Get-Item $errorfile).length -gt 0kb) {
#$body=@"
#Check the file C:\errorfile on the FS DR server showing the file location of potential virus files.
#"@
#		  Send-MailMessage -To $users -Body $body -Subject 'Action required : FS DR server !!!' -from 'mail@bop.feinsuch.com' -smtpServer '127.0.0.1'
#		}
#	}