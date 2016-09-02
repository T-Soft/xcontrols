IF "%1" == "" GOTO End

cd ..

set /p xc_ver=<.\.version
set /p xc_rev=<.\.revision

set path_to=%1xc_%xc_ver%.%xc_rev%\

xcopy . "%path_to%" /EXCLUDE:.\.bat\exclude_copy.list /E /I

del "%path_to%.caller_list\*.caller~"
del ".\.caller_list\*.caller~"

ren "%path_to%.caller_list\*.caller"	"*.caller~"
ren ".\.caller_list\*.caller"		"*.caller~"

del .\log\*.txt~
del .\log\*.log~

ren .\log\*.txt				"*.txt~"
ren .\log\*.log				"*.log~"

del "%path_to%.bat\commit.bat"
del "%path_to%.bat\exclude_copy.list"
del "%path_to%.bat\export.bat"
del "%path_to%.bat\export_curren_ver.bat"
del "%path_to%.bat\make_ver_p.bat"
del "%path_to%.bat\update.bat"
rmdir  "%path_to%.bat"

cd %path_to%

:End