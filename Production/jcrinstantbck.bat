@echo off
set SOURCEDIR=E:\FeinSuch\jcr\jackrabbit
set TARGETDIR=E:\jcrbackup
(for /f "tokens=4,* delims=\" %%a in (copyfromprod.txt) do echo %%b) > output.txt
TIMEOUT /T 10 /NOBREAK
(for /f %%A in (output.txt) do echo f | xcopy /f /y %SOURCEDIR%\%%A %TARGETDIR%\%%A)