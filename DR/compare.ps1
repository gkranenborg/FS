# Version 2.0
# Script written by Gerben Kranenborg 03/01/2016
#

# This script creates a complete list of all files in the Production JCR repository
# that are not present in the DR JCR repository. This file will then serve as the input to transfer these missing files
# to DR as needed.

$difffile = "E:\dailytransfers\sortedcompareDRPROD.txt"
$dirtyfile = "E:\dailytransfers\filenamesDRPROD.txt"
$resultfile = "E:\dailytransfers\tempfile.txt"
$copyfromprod = "E:\dailytransfers\copyfromprod.txt"
$filenamefile = "E:\dailytransfers\filenamefile.txt"
$removefromDR = "E:\dailytransfers\removefromDR.txt"

$data = Get-Content $difffile

# If the same filename AND the same filesize exist more then once, it does not need to be copied or removed, therefore it will NOT be added to the resultfile.

foreach ( $line in $data) {
$pattern = [regex]::Escape($line)
If (((Select-String -Pattern $pattern -Path $difffile).length) -ne 2 ) {
    Add-Content $resultfile $line
  }
}

# The following command will strip the filesize from the resultfile created before and add the filenames only to filenamefile.

Import-Csv -Delimiter "," -Header a,b $resultfile | foreach{ $cleanline = $_.a; Add-Content $filenamefile $cleanline }

$data = Get-Content $filenamefile

# If the same filename exists more then one, that file needs to be copied from production to DR.
# If the filename only exists once, we test if that file exists on the DR server. If so, it needs to be removed from the DR server, if not, it needs to be copied from the production 
# server to the DR server.

foreach ( $line in $data) {
$pattern = [regex]::Escape($line)
If (((Select-String -Pattern $pattern -Path $filenamefile).length) -eq 2 ) { Add-Content $copyfromprod $line }
  
If (Test-Path $line) 
    { Add-Content $removefromDR $line } Else
    { Add-Content $copyfromprod $line }

}
