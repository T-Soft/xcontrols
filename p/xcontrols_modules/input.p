#utf8 абв

#===================================================================================================INPUT xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial


#===================================================================================================INPUT TEXT
@xcreate_input[hData][sControl_sublabel]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_input[$hData]
	}{
		

#		$sControl_sublabel[$hData.sublabel]
#		^if($sControl_sublabel ne "" || def $sControl_sublabel){
#			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
#		}
##	<td class="align_right">${hData.label}</td><td><input type="$hData.type" id="$hData.id" name="$hData.name" value="$hData.value" ^if(def $hData.classes ){class="$hJquery_ui_style.[$hData.type] $classes"}{class="$hJquery_ui_style.[$hData.type]"} $hData.properties $hData.required  maxlength="250" size="$group_input_size" /></td>
##	убрал maxlength="250"
#		<td class="align_right">${hData.label}${sControl_sublabel}</td>
		
		^printLabel[$hData]
		<td>

			<input
				type="$hData.type"
				id="$hData.id"
				name="$hData.name"
				value="$hData.value"

				class="xc__string $hJquery_ui_style.[$hData.type] $hData.classes"

				$hData.properties
				$hData.required
				size="$group_input_size"
			/>
# 			<button style="height: 25px^; width : 25px^; " type="button" id="${hData.id}_clear" class="xc_string_btn_clear"></button>
		</td>
	}
#===================================================================================================INPUT TEXT
@create_input[hData][sControl_sublabel]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_input[$hData]
	}{
#		$sControl_sublabel[$hData.sublabel]
#		^if($sControl_sublabel ne "" || def $sControl_sublabel){
#			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
#		}
##	<td class="align_right">${hData.label}</td><td><input type="$hData.type" id="$hData.id" name="$hData.name" value="$hData.value" ^if(def $hData.classes ){class="$hJquery_ui_style.[$hData.type] $classes"}{class="$hJquery_ui_style.[$hData.type]"} $hData.properties $hData.required  maxlength="250" size="$group_input_size" /></td>
##	убрал maxlength="250"
#		<td class="align_right">${hData.label}${sControl_sublabel}</td>

		^printLabel[$hData]
		<td>



			<input
				type="$hData.type"
				id="$hData.id"
				name="$hData.name"
				value="$hData.value"
				data-default-value="$hData.defaultValue"
				class="xc__string $hJquery_ui_style.[$hData.type] $hData.classes"
				
				$hData.properties
				$hData.required
				size="$group_input_size"
			/>
# 			<button style="height: 25px^; width : 25px^; " type="button" id="${hData.id}_clear" class="xc_string_btn_clear"></button>
		</td>
	}
#===================================================================================================READONLY INPUT
@readonly_input[hData][sControl_sublabel]

	

#	$sControl_sublabel[$hData.sublabel]
#	^if($sControl_sublabel ne "" || def $sControl_sublabel){
#		$sControl_sublabel[<br><small>$sControl_sublabel</small>]
#	}
#	<td class="align_right">${hData.label}${sControl_sublabel}</td>

	^printLabel[$hData]
	<td>
		<span id="$hData.id">
			$hData.value
		</span>

	</td>
#===================================================================================================GET FIELDNAMES
@fieldnames_table_input[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]
	^tFieldnames.append{$name}

	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_input[value][hRet]
#	$result[$value]
	$hRet[
		$.value[^value.trim[]]
#		$.error[^hash::create[]]
	]

	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_input[init;hParsed_xml]
#
	$value[$init.[$hParsed_xml.name]]
	$result[$value]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_input[fieldName;tDataRow][hRet]
	$hRet[^hash::create[]]
	$hRet._value[$tDataRow.$fieldName]

	$result[$hRet]