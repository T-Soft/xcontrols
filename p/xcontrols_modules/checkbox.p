#utf8 абв

#=======================================================================================================================CHECKBOX CONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================CHECKBOX
@xcreate_checkbox[hData][isReadonly;sControl_sublabel;hData2]
	$isReadonly(false)
	^if(def $hData.readonly || $hData.readonly eq "true"){
		$isReadonly(true)
	}

#	$sControl_sublabel[$hData.sublabel]
#	^if($sControl_sublabel ne "" || def $sControl_sublabel){
#		$sControl_sublabel[<br><small>$sControl_sublabel</small>]
#	}

	$hData2[^hash::create[$hData]]

	<td></td>
	<td>
		^if($isReadonly){
			^if($hData.value eq 'on'){
				<tt style='border:1px solid #000^;font-family:monospace^;font-size:1.5em^;padding:0 5px^;font-weight:bold'>&times^;</tt>
				$hData2.label[$hData.label]
			}{
				<tt style='border:1px solid #bbb^;font-family:monospace^;font-size:1.5em^;padding:0 5px'>-</tt>
				$hData2.label[<span style='color:#bbb'>$hData.label</span>]
			}

#			${sControl_sublabel}

			^printLabel_content[$hData2]

		}{
			<span id="chk_${hData.id}" >
				<input
					type="checkbox"
					id="$hData.id"
					name="$hData.name"
					^if($hData.value eq 'on'){checked="checked"}
					$hData.required
					$sReadonly
#				><label for="$hData.id">${hData.label}${sControl_sublabel}</label>
				><label for="$hData.id">^printLabel_content[$hData2]</label>
		    	</span>
	    	}
	</td>

#===================================================================================================CHECKBOX
@create_checkbox[hData][isReadonly;sControl_sublabel;hData2]

	$isReadonly(false)
	^if(def $hData.readonly || $hData.readonly eq "true"){
		$isReadonly(true)
	}

	$hData2[^hash::create[$hData]]

	<td></td>
	<td>
		^if($isReadonly){
			^if($hData.value eq 'on'){
				<tt style='border:1px solid #000^;font-family:monospace^;font-size:1.5em^;padding:0 5px^;font-weight:bold'>&times^;</tt>
				$hData2.label[$hData.label]
			}{
				<tt style='border:1px solid #bbb^;font-family:monospace^;font-size:1.5em^;padding:0 5px'>-</tt>
				$hData2.label[<span style='color:#bbb'>$hData.label</span>]
			}

#			${sControl_sublabel}

			^printLabel_content[$hData2]
		}{
			<span id="chk_${hData.id}" >
				<input
					type="checkbox"
					id="$hData.id"
					name="$hData.name"

					^if($hData.value eq 'on' || $hData.value eq '1'){
						checked="checked"
						data-default-value="1"
					}

					$hData.required
					$sReadonly
#				><label for="$hData.id">${hData.label}${sControl_sublabel}</label>
				><label for="$hData.id">^printLabel_content[$hData2]</label>
		    	</span>
	    	}
	</td>
#===================================================================================================GET FIELDNAMES
@fieldnames_table_checkbox[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]
	^tFieldnames.append{$name}

	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_checkbox[value][val;hRet]

	^if(($value eq 'on') || ($value eq '1')){
		$val[1]
	}{
		$val[0]
	}

	$hRet[
		$.value[$val]
#		$.error[^hash::create[]]
	]

	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_checkbox[init;hParsed_xml]

	$value[$init.[$hParsed_xml.name]]
	^if(($value eq '1') || ($value eq 'on')){
		$result[on]
	}{
		$result[]
	}
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_checkbox[fieldName;tDataRow][hRet]
	$hRet[^hash::create[]]
	$hRet[$._value[$tDataRow.$fieldName]]

	$result[$hRet]