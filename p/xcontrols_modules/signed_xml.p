#===================================================================================================INPUT xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================INPUT TEXT
@xcreate_signed_xml[hData][fText_document;sDocUID;f;s;f_doc]

^if(($hData.type ne "detached") && ($hData.type ne "enveloped")){
	$result[^ErrorList_signed_xml[WRONG_SIGNATURE_TYPE]]
}
<div name="$hData.name">	
	<h3>$hData.label</h3>
	<hr>
	$sDocUID[^math:uid64[]]
	$fDocument[]
	^switch[$hData.value.CLASS_NAME]{
		^case[file]{
			$fDocument[$hData.value]
			^fDocument.save[binary;${sTemp_path}xcontrols_xml_to_sign_${sDocUID}.xml]
			$fText_document[$hData.value.text]
		}
		^case[string]{
			$fInput[^file::create[binary;xcontrols_xml_to_sign_${sDocUID}.xml;$hData.value]]
			^fInput.save[binary;${sTemp_path}xcontrols_xml_to_sign_${sDocUID}.xml]
			$fDocument[^file::load[binary;${sTemp_path}xcontrols_xml_to_sign_${sDocUID}.xml]]
		}
		^case[DEFAULT]{
			$result[^ErrorList_signed_xml[WRONG_INPUT_DATA_TYPE]]
		}
	}
	<div class="hiddenObjectsContainer">
		<object id="cadesplugin" type="application/x-cades" class="hiddenObject" ></object>
#		<object id="certEnrollClassFactory" classid="clsid:884e2049-217d-11da-b2a4-000e7bbb2b09" class="hiddenObject"></object>
	</div>
#	<p>
#		Заполненные поля:
#		<br>
#			^hFields.foreach[field;value]{ 
#				^if($field eq oper){^continue[]}
#  				<b>$hLocal.$field</b> - $value 
#			}[<br />] 
#	</p>
^rem{
	<p>

		<b>Тип подписи:</b>
		<select id="signature_type">
			<option value="detached"></option>
			<option value="enveloped"></option>
		</select>

	</p>
}	
	<P>
	    <b><u>Подписываемый документ:</u></b>
	</p>
	<p>
		^switch[$hData.type]{
			^case[detached]{
				<textarea id="tar_doc_to_sign">^fDocument.base64[]</textarea>
#				<textarea id="tar_doc_to_sign">$fDocument.text</textarea>
			}
			^case[enveloped]{
				<textarea id="tar_doc_to_sign">$fDocument.text</textarea>
			}
		}
	    
	</p>
	<p>
	
	</p>
		<textarea id="tar_view" readonly class="ui-widget-content">$fDocument.text</textarea>
	<p>
	
	<p>
		<span id="cert_store">
			Поиск сертификатов в хранилище:
			<input type="radio" name="certificate_storage" id="current_user" value="current_user" checked="checked" >
				<label for="current_user">Текущего пользователя</label>
			<input type="radio" name="certificate_storage" id="local_machine" value="local_machine">
				<label for="local_machine">Локальной машины</label>
		</span>
	</p>
	<p>
		Доступные сертификаты:
		<span id="сertificates">
			<select id='sel_certificate' class='ui-widget ui-widget-content ui-corner-all'>
			
			</select>
		<span>
	</p>
	<p>
	<div id="thumbprint_div" class="sha_thumbprint">
	    SHA1 Отперчаток сертификата:
	    <input type="text" value="" id="inp_cert_thumb" class="ui-widget ui-widget-content ui-corner-all" readonly >
	</div>	 
	    <input type="submit" id="sbmt_sign" value="Подписать" />
	</p>
	
	<textarea id="signature" style="display: none" name="signed_xml_signature" ></textarea>
	<input type="hidden" name="signed_xml_doc_uid" value="$sDocUID" />
	<input type="hidden" name="signature_type" id="signature_type" value="$hData.type" />
    <hr>
</div>	

#===================================================================================================INPUT TEXT
@create_signed_xml[hData][fText_document;sDocUID;f;s;f_doc]

^if(($hData.type ne "detached") && ($hData.type ne "enveloped")){
	$result[^ErrorList_signed_xml[WRONG_SIGNATURE_TYPE]]
}
<div name="$hData.name">	
	<h3>$hData.label</h3>
	<hr>
	$sDocUID[^math:uid64[]]
	$fDocument[]
	^switch[$hData.value.CLASS_NAME]{
		^case[file]{
			$fDocument[$hData.value]
			^fDocument.save[binary;${sTemp_path}xcontrols_xml_to_sign_${sDocUID}.xml]
			$fText_document[$hData.value.text]
		}
		^case[string]{
			$fInput[^file::create[binary;xcontrols_xml_to_sign_${sDocUID}.xml;$hData.value]]
			^fInput.save[binary;${sTemp_path}xcontrols_xml_to_sign_${sDocUID}.xml]
			$fDocument[^file::load[binary;${sTemp_path}xcontrols_xml_to_sign_${sDocUID}.xml]]
		}
		^case[DEFAULT]{
			$result[^ErrorList_signed_xml[WRONG_INPUT_DATA_TYPE]]
		}
	}
	<div class="hiddenObjectsContainer">
		<object id="cadesplugin" type="application/x-cades" class="hiddenObject" ></object>
#		<object id="certEnrollClassFactory" classid="clsid:884e2049-217d-11da-b2a4-000e7bbb2b09" class="hiddenObject"></object>
	</div>
#	<p>
#		Заполненные поля:
#		<br>
#			^hFields.foreach[field;value]{ 
#				^if($field eq oper){^continue[]}
#  				<b>$hLocal.$field</b> - $value 
#			}[<br />] 
#	</p>
^rem{
	<p>

		<b>Тип подписи:</b>
		<select id="signature_type">
			<option value="detached"></option>
			<option value="enveloped"></option>
		</select>

	</p>
}	
	<P>
	    <b><u>Подписываемый документ:</u></b>
	</p>
	<p>
		^switch[$hData.type]{
			^case[detached]{
				<textarea id="tar_doc_to_sign">^fDocument.base64[]</textarea>
#				<textarea id="tar_doc_to_sign">$fDocument.text</textarea>
			}
			^case[enveloped]{
				<textarea id="tar_doc_to_sign">$fDocument.text</textarea>
			}
		}
	    
	</p>
	<p>
	
	</p>
		<textarea id="tar_view" readonly class="ui-widget-content">$fDocument.text</textarea>
	<p>
	
	<p>
		<span id="cert_store">
			Поиск сертификатов в хранилище:
			<input type="radio" name="certificate_storage" id="current_user" value="current_user" checked="checked" >
				<label for="current_user">Текущего пользователя</label>
			<input type="radio" name="certificate_storage" id="local_machine" value="local_machine">
				<label for="local_machine">Локальной машины</label>
		</span>
	</p>
	<p>
		Доступные сертификаты:
		<span id="сertificates">
			<select id='sel_certificate' class='ui-widget ui-widget-content ui-corner-all'>
			
			</select>
		<span>
	</p>
	<p>
	<div id="thumbprint_div" class="sha_thumbprint">
	    SHA1 Отперчаток сертификата:
	    <input type="text" value="" id="inp_cert_thumb" class="ui-widget ui-widget-content ui-corner-all" readonly >
	</div>	 
	    <input type="submit" id="sbmt_sign" value="Подписать" />
	</p>
	
	<textarea id="signature" style="display: none" name="signed_xml_signature" ></textarea>
	<input type="hidden" name="signed_xml_doc_uid" value="$sDocUID" />
	<input type="hidden" name="signature_type" id="signature_type" value="$hData.type" />
    <hr>
</div>	
#===================================================================================================CHECK SIGNED XML
@check_signed_xml[fieldname;value;checkerPath;hRet][sCheck_result;fSgn;fSigned;sSignedFileName;sShortFname;sSignedFilePath;sFileUID;sSignature;fVerification;sVerification_result;sSgnFilePath;sSignatureType;sSignatureDecoded]
^rem{
$hRet[
   $.cnt_err(0)
   $.hErr[]
]

$h[
   $.cnt_err(1)
	$.hErr[
		$.1[
			$.err_fieldname[xml_to_sign]
			$.message[ERROR CREATING DIGITAL SIGNATURE]
			$.err_module[SIGNED_XML.SIGNING_ERROR]
			$.err_main[MAIN.SIGNING_ERROR]
		]
	]
	$.failed_id[0CCC2932-50F5-4206-977C-22E13E549B16]
]
}

$fTemp[^file::base64[binary;signed.txt;$form:signed_xml_signature]]
^fTemp.save[binary;signed.txt]

	$sSignatureType[$value.signature_type]
	$sFileUID[^math:uid64[]]
	
	$sSignature[$value.signed_xml_signature]
	$sFilename[xcontrols_xml_to_sign_${value.signed_xml_doc_uid}.xml]
	
	$sSgnFilePath[${sTemp_path}${sFilename}.sgn]
	
	$sShortFname[^sFilename.trim[right;.xml]]
	
	$sSignedFileName[${sShortFname}_signed.xml]
	$sSignedFilePath[${sTemp_path}${sSignedFileName}]
	
	$sCheck_result[]
	
	^if(!-f "${sTemp_path}cryptcp.exe"){
		^file:copy[cryptcp.exe;${sTemp_path}cryptcp.exe]
	}
	
	^switch[$sSignatureType]{
		^case[detached]{
#			^sSignature.save[$sSgnFilePath]
			$fSgn[^file::base64[$sSignature]]
			^fSgn.save[binary;$sSgnFilePath]
											
	$tArgv[^table::create{arg
-vsignf
$sFilename
}]			
			$fVerification[^file::exec[${sTemp_path}${checkerPath};$.charset[windows-1251];$tArgv]]		
			$sVerification_result[$fVerification.text]
			
			^if(^sVerification_result.match[Подпись проверена][i]){	
				$sCheck_result[DSIG_OK]
			}{
				^hRet.cnt_err.inc[]
				$hRet.hErr.[$hRet.cnt_err][^hash::create[
					$.err_fieldname[$fieldname]
					$.message[INVALID SIGNATURE]
         				$.err_module[SIGNED_XML.INVALID_SIGNATURE]
         				$.err_main[MAIN.SIGNING_ERROR]
				]]	
				$sCheck_result[DSIG_ERROR]
			}
			
		}
		^case[enveloped]{
			$fSigned[^file::base64[$sSignature]]
			^fSigned.save[binary;$sSignedFilePath]
			
			$sCheck_result[^checkXmlIntegrity[$sFilename;$fSigned]]		
		}
	}
	
	$hRet.check_result[$sCheck_result]
^ret[$hRet]
	$result[$hRet]
#===================================================================================================CHECK XML	
@checkXmlIntegrity[originalXmlName;fSignedXml][fOriginal;sOriginal;sResult;re;sSignatureBlock;sCut;sXmlDeclaration;sCut;fOriginalCut;fCut]

	$sResult[DSIG_XML_MODIFIED]

	$fOriginal[^file::load[binary;${sTemp_path}${originalXmlName}]]
	$sOriginal[$fOriginal.text]
	$sOriginal[^sOriginal.replace[^#09;]]
	$sOriginal[^sOriginal.replace[^#0D;]]
	
	^sOriginal.save[${sTemp_path}${originalXmlName}_original.xml]
	$fOriginalCut[^file::load[binary;${sTemp_path}${originalXmlName}_original.xml]]
	$xOriginal[^xdoc::create[$fOriginalCut]]
	^file:delete[${sTemp_path}${originalXmlName}_original.xml]
	
	$sSigned[$fSignedXml.text]	
	$sSignatureBlock[^sSigned.match[(<Signature.+<\/Signature>)][s]]
	
	$sCut[^sSigned.replace[$sSignatureBlock.1;]]
	^sCut.save[${sTemp_path}${originalXmlName}_recieved.xml]
	$fCut[^file::load[binary;${sTemp_path}${originalXmlName}_recieved.xml]]
	$xCut[^xdoc::create[$fCut]]
	^file:delete[${sTemp_path}${originalXmlName}_recieved.xml]

	^if(
		^xOriginal.string[
			$.method[xml] 
	   		$.indent[no] 
	   		$.omit-xml-declaration[yes] 
	   		
   		] 
   		eq 
   		^xCut.string[
   			$.method[xml] 
   			$.indent[no] 
   			$.omit-xml-declaration[yes] 
   			
   		]
   	){
		$sResult[DSIG_XML_OK]
	}

	$result[$sResult]
	
#===================================================================================================GET FIELDNAMES
@fieldnames_table_signed_xml[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]
	^tFieldnames.append{$name}
	
	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_signed_xml[value][hRet]
#	$result[$value]
	$hRet[
		$.value[$value]
#		$.error[^hash::create[]]
	]
	
	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_signed_xml[init;hParsed_xml]
#
	$value[$init.[$hParsed_xml.name]]
	$result[$value]
#===================================================================================================ERRORLIST SIGNED XML	
@ErrorList_signed_xml[invoke][hErrList]
	$hErrList[^hash::create[]]	
	
	$hErrList[
		$.INVALID_SIGNATURE[Подпись не прошла проверку на сервере. Возможно повреждение подписи.]
		$.WRONG_SIGNATURE_TYPE[Неверный тип подписи]
		$.WRONG_INPUT_DATA_TYPE[Неверный тип входных данных]
	]
	
	^if(def $invoke && ^hErrList.contains[$invoke]){
		$result[$hErrList.$invoke]
	}{
		$result[$hErrList]
	}