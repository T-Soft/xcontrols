@echo off
echo SVN UPDATE script v 1.0.
echo.

call set script_dir=%cd%
cd ..

SET TORTOISE_PROC_x64=c:\Program Files(x86)\TortoiseSVN\bin\TortoiseProc.exe
SET TORTOISE_PROC_x32=c:\Program Files\TortoiseSVN\bin\TortoiseProc.exe

@echo on
TortoiseProc.exe /command:update /path:"%cd%" /closeonend:0

IF '%COMPUTERNAME%'=='MAJOR' COPY .\doc\xcontrols.chm d:\

::write_p
cd .\.bat
make_ver_p.bat
