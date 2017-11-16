@ECHO OFF

set year=%date:~10,4%
set month=%date:~4,2%
set day=%date:~7,2%
IF EXIST "E:\SQL Full Backup\backupcomplete.txt" (
del /Q "E:\SQL Full Backup\backupcomplete.txt"
)
IF EXIST "E:\SQL Full Backup\backuperror.txt" (
del /Q "E:\SQL Full Backup\backuperror.txt"
)
IF EXIST "E:\SQL Full Backup\Full backup\CordysBusiness\CordysBusiness*.bak" (
del /Q "E:\SQL Full Backup\Full backup\CordysBusiness\CordysBusiness*.bak"
)
powershell E:\backupscripts\cordysbusdbstart.ps1
SqlCmd -E -S localhost -Q "BACKUP DATABASE [CordysBusiness] TO DISK='E:\SQL Full Backup\Full backup\CordysBusiness\CordysBusiness%month%%day%%year%.bak'"
if %ERRORLEVEL% neq 0 (
echo %ERRORLEVEL% >>"E:\SQL Full Backup\Full backup\backuperror.txt"
goto CORDYSBUSDBERR
)
IF EXIST "E:\SQL Full Backup\Full backup\Cordys\Cordys*.bak" (
del /Q "E:\SQL Full Backup\Full backup\Cordys\Cordys*.bak"
)
powershell E:\backupscripts\cordysdbstart.ps1
SqlCmd -E -S localhost -Q "BACKUP DATABASE [Cordys] TO DISK ='E:\SQL Full Backup\Full backup\Cordys\Cordys%month%%day%%year%.bak' WITH NOFORMAT, NOINIT,  NAME = 'Cordys-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, BUFFERCOUNT = 2200, BLOCKSIZE = 65536, MAXTRANSFERSIZE=2097152"
if %ERRORLEVEL% neq 0 (
echo %ERRORLEVEL% >>"E:\SQL Full Backup\Full backup\backuperror.txt"
goto CORDYSDBERR
)
powershell E:\backupscripts\compressstart.ps1
"C:\Program Files\7-Zip\7z" a -t7z -mx1 -mmt=on -v5000M CordysFullBackup%month%%day%%year%.7z "E:\SQL Full Backup\Full backup\Cordys\Cordys*"
if %ERRORLEVEL% neq 0 (
echo %ERRORLEVEL% >>"E:\SQL Full Backup\Full backup\backuperror.txt"
goto COMPRESSERR
)
powershell E:\backupscripts\backupcomplete.ps1
type NUL > "E:\SQL Full Backup\Full backup\backupcomplete.txt"
goto END

:CORDYSDBERR
powershell E:\backupscripts\cordysdberr.ps1
goto END

:CORDYSBUSDBERR
powershell E:\backupscripts\cordysbusdberr.ps1
goto END

:COMPRESSERR
powershell E:\backupscripts\compresserr.ps1
goto END

:END