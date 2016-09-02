#===================================================================================================INT xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================INT
@xcreate_int[hData][sControl_sublabel]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_int[$hData]
	}{
#	<td class="align_right">${hData.label}</td><td><input type="$hData.type" id="$hData.id" name="$hData.name" value="$hData.value" ^if(def $hData.classes ){class="xc__int $hJquery_ui_style.[$hData.group] $classes"}{class="xc__int $hJquery_ui_style.[$hData.group]"} $hData.properties $hData.required  $hData.bounds maxlength="250" size="$group_input_size" data-type="int" /></td>
# 		$sControl_sublabel[$hData.sublabel]
# 		^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 		}
# 		<td class="align_right">${hData.label}${sControl_sublabel}</td>
		^printLabel[$hData]
		<td>
		
			<input 
				type="text" 
				id="$hData.id" 
				name="$hData.name" 
				value="$hData.value" 
				data-default-value="$hData.defaultValue"
				class="xc__int $hJquery_ui_style.[$hData.group] $hData.classes"
				
				$hData.properties
				$hData.required
				$hData.bounds
				
				size="$group_input_size"
				
				data-type="int" 
			/>
# 			<button style="height: 25px^; width : 25px^; " type="button" id="${hData.id}_clear" class="xc_int_btn_clear"></button>
		</td>
	}
#===================================================================================================INT
@create_int[hData][sControl_sublabel]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_int[$hData]
	}{
#	<td class="align_right">${hData.label}</td><td><input type="$hData.type" id="$hData.id" name="$hData.name" value="$hData.value" ^if(def $hData.classes ){class="xc__int $hJquery_ui_style.[$hData.group] $classes"}{class="xc__int $hJquery_ui_style.[$hData.group]"} $hData.properties $hData.required  $hData.bounds maxlength="250" size="$group_input_size" data-type="int" /></td>
# 		$sControl_sublabel[$hData.sublabel]
# 		^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 		}
# 		<td class="align_right">${hData.label}${sControl_sublabel}</td>
		^printLabel[$hData]
		<td>
			
			<input 
				type="text" 
				id="$hData.id" 
				name="$hData.name" 
				value="$hData.value" 
				data-default-value="$hData.defaultValue"
				class="xc__int $hJquery_ui_style.[$hData.group] $hData.classes"
				
				$hData.properties
				$hData.required
				$hData.bounds
				
				size="$group_input_size"
				
				data-type="int" 
			/>
# 			<button style="height: 25px^; width : 25px^; " type="button" id="${hData.id}_clear" class="xc_int_btn_clear"></button>
		</td>
	}
#===================================================================================================READONLY INT
@readonly_int[hData][sControl_sublabel]
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
@fieldnames_table_int[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]
	^tFieldnames.append{$name}
	
	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_int[value][hRet]
#	$result[$value]
	$hRet[
		$.value[^value.trim[]]
#		$.error[^hash::create[]]
	]
	
	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_int[init;hParsed_xml]
	$value[$init.[$hParsed_xml.name]]
	$result[$value]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_int[fieldName;tDataRow][hRet]
	$hRet[^hash::create[]]
	$hRet[$._value[$tDataRow.$fieldName]]
	
	$result[$hRet]