@ECHO OFF
REM Batch file to copy files and folders to a specific folder on the same server for backup purposes.
REM Version 5.3
REM Written by Gerben Kranenborg September 24, 2015

REM Set all variables.

set BACKUP_DIR=E:\dailytransfers
set INSTANCE_NAME=Production
set BDB_DIR=%BACKUP_DIR%\bdb
set CLASSPATH=%CORDYS_BASE_DIR%\%INSTANCE_NAME%\cordyscp.jar;%CLASSPATH%

set year=%date:~10,4%
set month=%date:~4,2%
set day=%date:~7,2%

set LOGFILE=%BACKUP_DIR%\LOG%month%%day%%year%.txt

REM (Re)create backup folders.

IF NOT EXIST %BACKUP_DIR%\FeinSuch GOTO MAILBCK
del %BACKUP_DIR%\FeinSuch /s /q
GOTO ENDMAILBCK
:MAILBCK
md %BACKUP_DIR%\FeinSuch
:ENDMAILBCK

IF NOT EXIST E:\jcrbackup\repository GOTO JCRBCK
del E:\jcrbackup\repository /s /q
GOTO ENDJCRBCK
:JCRBCK
md E:\jcrbackup\repository
:ENDJCRBCK

REM Determine yesterdays date

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

set CurDate=%mm%/%dd%/%yyyy%

set dayCnt=%1

if "%dayCnt%"=="" set dayCnt=1

REM Substract your days here
set /A dd=1%dd% - 100 - %dayCnt%
set /A mm=1%mm% - 100

:CHKDAY

if /I %dd% GTR 0 goto DONE

set /A mm=%mm% - 1

if /I %mm% GTR 0 goto ADJUSTDAY

set /A mm=12
set /A yyyy=%yyyy% - 1

:ADJUSTDAY

if %mm%==1 goto SET31
if %mm%==2 goto LEAPCHK
if %mm%==3 goto SET31
if %mm%==4 goto SET30
if %mm%==5 goto SET31
if %mm%==6 goto SET30
if %mm%==7 goto SET31
if %mm%==8 goto SET31
if %mm%==9 goto SET30
if %mm%==10 goto SET31
if %mm%==11 goto SET30
REM ** Month 12 falls through

:SET31

set /A dd=31 + %dd%

goto CHKDAY

:SET30

set /A dd=30 + %dd%

goto CHKDAY

:LEAPCHK

set /A tt=%yyyy% %% 4

if not %tt%==0 goto SET28

set /A tt=%yyyy% %% 100

if not %tt%==0 goto SET29

set /A tt=%yyyy% %% 400

if %tt%==0 goto SET29

:SET28

set /A dd=28 + %dd%

goto CHKDAY

:SET29

set /A dd=29 + %dd%

goto CHKDAY

:DONE

if /I %mm% LSS 10 set mm=0%mm%
if /I %dd% LSS 10 set dd=0%dd%

REM Backup the JackRabbit documents modified over the last 24 hours. Compress them into one file to be transferred to the DR server daily.

xcopy E:\FeinSuch\jcr\jackrabbit\repository E:\jcrbackup\repository /Y /C /v /d:%mm%-%dd%-%yyyy% /k /o /i /s
"C:\Program Files\7-Zip\7z" a -t7z -mx1 -mmt=on -v5000M %BACKUP_DIR%\FeinSuch\JCRBackup%month%%day%%year%-1.7z "E:\jcrbackup\repository"

REM Send out an E-mail indicating all backups have been completed and to check the proper working of the system.

powershell E:\backupscripts\JCRBackupEmail.ps1