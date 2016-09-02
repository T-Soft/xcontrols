#utf-8 / абв
#=======================================================================================================================xCONTROLS SERIALIZATION UNIT

@CLASS
xcontrols

@OPTIONS
static
partial

#==============================================================================SERIALIZE FIELDS FILES AND ERRORS TO FILE
@serialize[hFields;hFiles;hErr;sTablename][fk;fv;k;v;sSerial_path;hSerial;hData;sSerial;hFileData;sFilepath]

	$sSerial_path[${sTemp_path}${sSerial_prefix}${hErr.failed_id}]

	$hSerial[
		$.fields[^hash::create[]]
		$.files[^hash::create[]]
		$.err[^hash::create[]]
	]
	$hData[^hash::create[]]
			
	^hFields.foreach[k;v]{
		$hData.$k[$v.field]
	}		

	$hSerial.fields[$hData]
	$hSerial.fields.uuid[$form:uuid]
#=============================================ToDo: вносить информацию о загруженных файлах
	^connect[$MAIN:CS]{
		^hFiles.foreach[fk;fv]{
			$sFilepath[^string:sql{
				SELECT
					`$fk`
				FROM
					`$sTablename`
				WHERE
					`uuid`='$form:uuid'
			}[$.default[]]]
			^if(def $sFilepath){
				$hSerial.fields.$fk[$sFilepath]
			}{
				$hSerial.fields.$fk[$sFilepath]
			}
			
		}
	}

	$hSerial.err[$hErr]

	$sSerial[^json:string[$hSerial;
		$.skip-unknown(true)
		$.indent(true)
		$.file[stat]
		$.string[$string_processor]
	]]
	
	^sSerial.save[$sSerial_path]
	
@string_processor[key;value;params]
	$result[^if($value eq ""){null}{"$value"}]
#=============================================================================================DESERIALIZE DATA FROM FILE	
@deserialize[failed_id][fSerial;sSerial;hData]

	^if(!-f "${sTemp_path}${sSerial_prefix}${failed_id}"){
		^ErrorList_main[CRASH_NO_FAILED_ID]
	}{
		$fSerial[^file::load[text;${sTemp_path}${sSerial_prefix}${failed_id}]]
	}
	
	$sSerial[$fSerial.text]

	$hData[^json:parse[^taint[as-is][$sSerial];
		$.double(true)
		$.distinct[all]
	]]

	^if($hData is hash){
		^if(-f "${sTemp_path}${sSerial_prefix}${failed_id}"){
			^file:delete[${sTemp_path}${sSerial_prefix}${form:failed_id}]
		}
	}
	
	$result[$hData]