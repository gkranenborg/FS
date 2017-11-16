@echo off
setlocal enabledelayedexpansion

set JCRbackupdir=E:\dailytransfers\FeinSuch
set JCRdir=E:\FeinSuch\jcr\jackrabbit
set JCRbackup=E:\JCRbackup
IF NOT EXIST %JCRbackupdir%\backupfailure GOTO STARTRESTORE
del %JCRbackupdir%\backupfailure
:STARTRESTORE
set yyyy=

set $tok=1-3
for /f "tokens=1 delims=.:/-, " %%u in ('date /t') do set $d1=%%u
if "%$d1:~0,1%" GTR "9" set $tok=2-4
for /f "tokens=%$tok% delims=.:/-, " %%u in ('date /t') do (
 for /f "skip=1 tokens=2-4 delims=/-,()." %%x in ('echo.^|date') do (
    set %%x=%%u
    set %%y=%%v
    set %%z=%%w
    set $d1=
    set $tok=))

if "%yyyy%"=="" set yyyy=%yy%
if /I %yyyy% LSS 100 set /A yyyy=2000 + 1%yyyy% - 100

set CurDate=%mm%%dd%%yyyy%
set JCRcompressfile=JCRBackup%CurDate%-1.7z.*

IF NOT EXIST %JCRbackupdir%\JCRBackup%CurDate%-1.7z.001 GOTO JCRBCK
"C:\Program Files\7-Zip\7z" x %JCRbackupdir%\%JCRcompressfile% -aot -o%JCRdir% -r
xcopy %JCRdir%\*_1* %JCRbackup%\%CurDate% /Y /C /v /k /o /i /s
del /S %JCRdir%\*_1*
GOTO ENDJCRBCK
:JCRBCK
echo "JCR Backup failure" > %JCRbackupdir%\backupfailure
:ENDJCRBCK