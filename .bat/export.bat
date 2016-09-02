@echo off
echo SVN EXPORT script v 1.0.
echo.

pause

setlocal enabledelayedexpansion



::write_p
call set script_dir=%cd%
call set script_path=%cd%

if "%1"=="" (goto ex) 
	
	call make_ver_p.bat

cd ..	
call set exp_path=%1xc_%ver%.%rev%
mkdir %exp_path%

TortoiseProc.exe /command:dropexport /path:"%cd%" /droptarget:"%exp_path%" /overwrite /closeonend:3

for /D %%i in (%exp_path%\*.*) do (
	call set exported_dir=%%i
)

xcopy %exported_dir%\*.* %exp_path%\*.* /E /H /Y /C

rmdir /s /Q %exported_dir%
rmdir /s /Q %exp_path%\.bat

::echo %cd%
::pause

::copy %script_path%\ver.p %exp_path%
copy ver.p %exp_path%

exit

:ex	
	echo Error! No EXPORT path passed
	echo Usage example: export C:\foo\bar
	echo.
	pause
