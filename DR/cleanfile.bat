REM Version 2.0
REM Script written by Gerben Kranenborg 02/09/2016

REM This script creates determines the difference between the Production and DR JCR repository 
REM based on the filelist input files.
REM All empty lines and other none essential lines are removed from the list, which is sorted by filename.

fc /L G:\dailytransfers\filelistPROD.txt G:\dailytransfers\filelistDR.txt > G:\dailytransfers\filecompareDRPROD.txt
type G:\dailytransfers\filecompareDRPROD.txt | findstr /v "^$" | findstr /v ***** | findstr /v Comparing > G:\dailytransfers\filenospaceDRPROD.txt
sort G:\dailytransfers\filenospaceDRPROD.txt > G:\dailytransfers\sortedcompareDRPROD.txt