@echo off

call set script_dir=%cd%

echo SVN current dir COMMIT script v 1.0.
echo Keep in SVN repo root directory!
setlocal enabledelayedexpansion

cd ..
TortoiseProc.exe /command:update /path:"%cd%" /closeonend:0

::set /a nextrev=%rev%+1
::echo Next revision: %nextrev%

set /p ver=<.version

if EXIST %cd%\logmsg.txt (goto commit_wlog) else (goto commit_wolog)

:commit_wlog
	echo Log message file exists. Reading...
	TortoiseProc.exe /command:commit /path:"%cd%" /logmsgfile:"%cd%\logmsg.txt" /closeonend:3
	goto write_p
	exit

:commit_wolog
	echo No log message file detected
	TortoiseProc.exe /command:commit /path:"%cd%" /closeonend:3
	goto write_p

:write_p
	cd .\.bat
	make_ver_p.bat
	
	