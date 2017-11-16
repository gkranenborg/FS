# Version 1.0
# Script written by Gerben Kranenborg 02/09/2016
#

# This script creates a complete list of all files in the JCR repository,
# and adds the Full Path and the Last Modified Date of the file to each line.

$files = Get-ChildItem "E:\FeinSuch\jcr\jackrabbit\repository" -Recurse | % { $_.Fullname }

If (Test-Path E:\dailytransfers\filelistDR.txt) 
    { 
        Remove-Item E:\dailytransfers\filelistDR.txt 
    }

foreach ($i in $files) {
     $details = Get-ItemProperty $i
     $filelength = $details.Length;
     If ( $filelength -gt 1 ) {
        $filename = $details.Fullname;
        $datarow = "$filename, $filelength";
        Add-Content E:\dailytransfers\filelistDR.txt $datarow;
     }
}