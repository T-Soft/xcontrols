#utf-8 / абв
#=======================================================================================================================xCONTROLS ERROR HANDLING

@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================ERROR LIST
@ErrorList_main[invoke]
	$hErrList[^hash::create[]]	
	
	$hErrList[
		$.INVALID_VALUE[Неверный тип или значение в поле ввода или загрузки файла]
		$.SIGNING_ERROR[Ошибка подписания документа]
		$.UNKNOWN_ERROR[Неизвестная ошибка ядра xControls]
		$.UNKNOWN_FIELD[Неизвестное системе поле ввода]
		$.UNKNOWN_INITFILE_FIELD[Неизвестное системе поле ввода в инициализирующем файле]
		$.INVALID_INITFILE_FORMAT[Недопустимый формат инициализирующего файла]
		$.JAVASCRIPT_ERROR[Ошибка выполнения сценария на стороне клиента - попробуйте отправить форму повторно.]
		$.SYSTEM_CRASH[
			^^throw[xcontrols.crash^;xControls_main^;xControls core module -> system crashed ]
		]
		$.CRASH_EDIT_ENTRY[
			^^throw[xcontrols.crash_edit^;xControls_main^;xControls core module -> editting non existing entry ]
		]
		$.CRASH_UPDATE_ENTRY[
			^^throw[xcontrols.crash_update^;xControls_main^;xControls core module -> updating non existing entry ]
		]
		$.CRASH_INVALID_INVOKE[
			^^throw[xcontrols.crash_invoke^;xControls_main^;xControls core module -> invoking non existing error ]
		]
		$.CRASH_NO_FAILED_ID[
			^^throw[xcontrols.crash_deserialize^;xControls_main^;xControls core module -> deserializing non existing file ]
		]
		$.CRASH_UNKNOWN_FIELD_INFO[
			^^throw[xcontrols.crash_invalid_field^;xControls_main^;xControls core module -> getting unknown field info ]
		]
		$.CRASH_UNKNOWN_FORM_CONTENTS[
			^^throw[xcontrols.crash_unknown_form_contents^;xControls_main.database^;xControls core module -> contents of the form is damaged, unknown or missing ]
		]
		$.CRASH_INCLUDE_FILE_NOT_FOUND[
			^^throw[xcontrols.crash_include_file_not_found^;xControls_main.include^;xControls core module -> file to include not found within specified path ]
		]
	]
	
	^if((def $invoke) && (^hErrList.contains[$invoke])){
		$result[^process{$hErrList.$invoke}]
	}
	
	^if(def $invoke && !(^hErrList.contains[$invoke])){
		$result[^ErrorList_main[CRASH_INVALID_INVOKE]]
	}
	
	^if(!def $invoke){
		$result[$hErrList]
	}	
#===================================================================================================RETURN ERROR
@ReturnOnError[error;hFiles;hFields;hRet]
	
	^if(! ($hRet is hash)){
		$hRet[^hash::create[]]
	}
	^if(!($hRet.err is hash)){
		$hRet.err[^hash::create[]]
		$hRet.err.cnt_err(0)
	}
	^if(!($hFields is hash)){
		$hFields[$form:tables]
	}
	^if(!($hFiles is hash)){
		$hFiles[$form:files]
	}

	$hRet.err.failed_id[^math:uuid[]]	
	^serialize[$hFields;$hFiles;$hRet.err]
	^if($bErr_redirect){
		$response:refresh[ 
			$.value(0) 
			$.url[${sShow_form_document}?failed_id=$hRet.err.failed_id^if(def $form:uuid){&uuid=${form:uuid}}] 
		]	
	}
#===================================================================================================ANALYSE ERROR
@AnalyseError[sForm_id;hError][tControls;hRet;tErrorModule;sErrorModule;hErrList;sErrorType]
	$hRet[^hash::create[]]
	$hErrList[]
	
	$tControls[^parse_XML[$sForm_id]]
	^if(^tControls.locate[name;$hError.err_fieldname]){
		$hRet.fieldname[$tControls.label]
	}{
# 		support fo javascript errors
		^if($hError.err_fieldname eq $sJavascriptErrorField){
			$hRet.fieldname[$sJavascriptErrorField]
		}{
			$hRet.fieldname[^ErrorList_main[UNKNOWN_FIELD]]
		}
	}
	
	$tErrorModule[^hError.err_module.match[^^(.+)\.(.+)]]
	$sErrorModule[^tErrorModule.1.lower[]]
	$sErrorType[$tErrorModule.2]

	^if(def $sErrorModule && $sErrorModule ne "main"){
		^use[xcontrols_modules/${sErrorModule}.p]
		$hErrList[^xcontrols:ErrorList_$sErrorModule[]]
	}{
		$hErrList[^xcontrols:ErrorList_main[]]
	}
	
	^if(^hErrList.contains[$sErrorType]){
		$hRet.message[$hErrList.$sErrorType]
	}{
		$hRet.message[^xcontrols:ErrorList_main[UNKNOWN_ERROR]]
	}

	$result[$hRet]
#===========================================================================================================ERROR REPORT
@error_to_hash[hError][hRet]
	$hRet[^hash::create[$hError]]	
	$hRet.err_main[MAIN.INVALID_VALUE]	
	
	$result[$hRet]