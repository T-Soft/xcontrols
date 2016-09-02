@auto[][nick;buff;dt_first_caller]

$MAIN:XC_JQUERY_CURRDIR[jquery-1.11.2]
$MAIN:XC_JQUERY_UI_CURRDIR[jquery-ui-1.11.2]
$MAIN:XC_UI_CURRDIR[ui-1]

$MAIN:XC_JQUERY_MOUSEWHEEL_CURRDIR[jquery-mousewheel-3.1.13]
$MAIN:XC_JQUERY_FANCYBOX_CURRDIR[jquery-fancybox-2.1.5]

^use[p/xcontrols_main.p]

#--- блок для контроля: кто вызывает библиотеку (складывается всё в ./.caller/)

$nick[${xcontrols:sSystem_lib_path}.caller_list/^request:uri.match[^^\/([^^\/]+).*^$][]{$match.1}.caller]
^if(!-f '$nick'){

	$dt_first_caller[^date::now[]]
	$buff[
dt	^dt_first_caller.sql-string[]

server	$env:SERVER_NAME

uri	$request:uri

ip	$env:REMOTE_ADDR

prdm.login	$cookie:[prdm.login]

id_user		$xAuth.user.id

id_org		$xAuth.user.id_org

code_region	$xAuth.org.code_region


]
	^buff.save[$nick]
}

#--- /блок для контроля: кто вызывает библиотеку
