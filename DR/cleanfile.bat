REM Version 1.0
REM Script written by Gerben Kranenborg 02/09/2016

REM This script creates determines the difference between the Production and DR JCR repository 
REM based on the filelist input files.
REM All empty lines and other none essential lines are removed from the list, which is sorted by filename.

fc /L E:\dailytransfers\filelistPROD.txt E:\dailytransfers\filelistDR.txt > E:\dailytransfers\filecompareDRPROD.txt
type E:\dailytransfers\filecompareDRPROD.txt | findstr /v "^$" | findstr /v ***** | findstr /v Comparing > E:\dailytransfers\filenospaceDRPROD.txt
sort E:\dailytransfers\filenospaceDRPROD.txt > E:\dailytransfers\sortedcompareDRPROD.txt