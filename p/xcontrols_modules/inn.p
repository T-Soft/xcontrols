#===================================================================================================INN xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================CREATE INN
@xcreate_inn[hData][sControl_sublabel]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_inn[$hData]
	}{
# 		$sControl_sublabel[$hData.sublabel]
# 		^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 		}
#	<td class="align_right">${hData.label}</td> <td><input type="$hData.type" id="$hData.id" name="$hData.name" value="$hData.value" ^if(def $hData.classes ){class="xc__inn $hJquery_ui_style.[$hData.group] $classes"}{class="xc__inn $hJquery_ui_style.[$hData.group]"} $hData.properties size="$group_input_size" $hData.required data-type="inn"/></td>
# 		<td class="align_right">${hData.label}${sControl_sublabel}</td>
		^printLabel[$hData]
		<td>
			
			<input 
				type="text" 
				id="$hData.id" 
				name="$hData.name" 
				value="$hData.value" 
		
				class="xc__inn $hJquery_ui_style.[$hData.group] $hData.classes"
		
				$hData.properties 
				
				maxlength="12"
#			12 + 1 для хорошего визуального отображения инпута
				size="13"
				style='width:auto'
				
				$hData.required
				data-type="inn"
			/>
			<button style="height: 25px^; width : 25px^; " type="button" id="${hData.id}_clear" class="xc_inn_btn_clear"></button>
		</td>
	}

#===================================================================================================CREATE INN
@create_inn[hData][sControl_sublabel]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_inn[$hData]
	}{
# 		$sControl_sublabel[$hData.sublabel]
# 		^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 		}
#	<td class="align_right">${hData.label}</td> <td><input type="$hData.type" id="$hData.id" name="$hData.name" value="$hData.value" ^if(def $hData.classes ){class="xc__inn $hJquery_ui_style.[$hData.group] $classes"}{class="xc__inn $hJquery_ui_style.[$hData.group]"} $hData.properties size="$group_input_size" $hData.required data-type="inn"/></td>
		^printLabel[$hData]
		<td>
			
			<input 
				type="text" 
				id="$hData.id" 
				name="$hData.name" 
				value="$hData.value" 
				data-default-value="$hData.defaultValue"
				class="xc__inn $hJquery_ui_style.[$hData.group] $hData.classes"
		
				$hData.properties 
				
				maxlength="12"
#			12 + 1 для хорошего визуального отображения инпута
				size="13"
				style='width:auto'
				
				$hData.required
				data-type="inn"
			/>
# 			<button style="height: 25px^; width : 25px^; " type="button" id="${hData.id}_clear" class="xc_inn_btn_clear"></button>
		</td>
	}
#===================================================================================================READONLY INN
@readonly_inn[hData][sControl_sublabel]
# 	$sControl_sublabel[$hData.sublabel]
# 	^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 		$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 	}
	^printLabel[$hData]
	<td>
		<span id="$hData.id">
			$hData.value
		</span>
	
	</td>
#===================================================================================================GET FIELDNAMES
@fieldnames_table_inn[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]
	^tFieldnames.append{$name}
	
	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_inn[value][hRet]
#	$result[$value]
	$hRet[
		$.value[^value.trim[]]
#		$.error[^hash::create[]]
	]
	
	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_inn[init;hParsed_xml]
	$value[$init.[$hParsed_xml.name]]
	$result[$value]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_inn[fieldName;tDataRow][hRet]
	$hRet[^hash::create[]]
	$hRet[$._value[$tDataRow.$fieldName]]
	
	$result[$hRet]