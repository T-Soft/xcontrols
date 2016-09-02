#===================================================================================================OGRN xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================CREATE OGRN
@xcreate_ogrn[hData][sControl_sublabel]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_ogrn[$hData]
	}{
# 		$sControl_sublabel[$hData.sublabel]
# 		^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 		}
#	<td class="align_right">${hData.label}</td> <td><input type="$hData.type" id="$hData.id" name="$hData.name" value="$hData.value" ^if(def $hData.classes ){class="xc__ogrn $hJquery_ui_style.[$hData.group] $classes"}{class="xc__ogrn $hJquery_ui_style.[$hData.group]"} $hData.properties $hData.required maxlength="250" size="$group_input_size" data-type="ogrn"/></td>
# 		<td class="align_right">${hData.label}${sControl_sublabel}</td>
		^printLabel[$hData]
		<td>
			
			<input
				type="text"
				id="$hData.id"
				name="$hData.name"
				value="$hData.value"
				data-default-value="$hData.defaultValue"
				class="xc__ogrn $hJquery_ui_style.[$hData.group] $hData.classes"
		
				$hData.properties
				$hData.required
		
				maxlength="15"
#			15 + 1 для хорошего визуального отображения инпута
				size="16"
				style='width:auto'
				
				data-type="ogrn"
			/>
# 			<button style="height: 25px^; width : 25px^; " type="button" id="${hData.id}_clear" class="xc_ogrn_btn_clear"></button>
		</td>
	}
#===================================================================================================CREATE OGRN
@create_ogrn[hData][sControl_sublabel]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_ogrn[$hData]
	}{
# 		$sControl_sublabel[$hData.sublabel]
# 		^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 		}
#	<td class="align_right">${hData.label}</td> <td><input type="$hData.type" id="$hData.id" name="$hData.name" value="$hData.value" ^if(def $hData.classes ){class="xc__ogrn $hJquery_ui_style.[$hData.group] $classes"}{class="xc__ogrn $hJquery_ui_style.[$hData.group]"} $hData.properties $hData.required maxlength="250" size="$group_input_size" data-type="ogrn"/></td>
# 		<td class="align_right">${hData.label}${sControl_sublabel}</td>
		^printLabel[$hData]
		<td>
			
			<input
				type="text"
				id="$hData.id"
				name="$hData.name"
				value="$hData.value"
				data-default-value="$hData.defaultValue"
				class="xc__ogrn $hJquery_ui_style.[$hData.group] $hData.classes"
		
				$hData.properties
				$hData.required
		
				maxlength="15"
#			15 + 1 для хорошего визуального отображения инпута
				size="16"
				style='width:auto'
				
				data-type="ogrn"
			/>
# 			<button style="height: 25px^; width : 25px^; " type="button" id="${hData.id}_clear" class="xc_ogrn_btn_clear"></button>
		</td>
	}
#===================================================================================================READONLY OGRN
@readonly_ogrn[hData][sControl_sublabel]
# 	$sControl_sublabel[$hData.sublabel]
# 	^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 		$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 	}
# 	<td class="align_right">${hData.label}${sControl_sublabel}</td>
	^printLabel[$hData]
	<td>
		<span id="$hData.id">
			$hData.value
		</span>
	
	</td>
#===================================================================================================GET FIELDNAMES
@fieldnames_table_ogrn[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]
	^tFieldnames.append{$name}
	
	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_ogrn[value][hRet]
#	$result[$value]
	$hRet[
		$.value[^value.trim[]]
#		$.error[^hash::create[]]
	]
	
	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_ogrn[init;hParsed_xml]
	$value[$init.[$hParsed_xml.name]]
	$result[$value]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_ogrn[fieldName;tDataRow][hRet]
	$hRet[^hash::create[]]
	$hRet[$._value[$tDataRow.$fieldName]]
	
	$result[$hRet]