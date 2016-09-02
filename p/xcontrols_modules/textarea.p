#===================================================================================================TEXTAREA xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================TEXTAREA TEXT
@xcreate_textarea[hData][sControl_sublabel]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_textarea[$hData]
	}{
# 		$sControl_sublabel[$hData.sublabel]
# 		^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 		}
# 		<td class="align_right">${hData.label}${sControl_sublabel}</td>
		^printLabel[$hData]
		<td><textarea
			id="$hData.id"
			name="$hData.name"
	
			class="$hJquery_ui_style.[$hData.group] $hData.classes"
	
			$hData.properties
			$hData.required
			cols="$group_input_size"
			rows="5"
		>^taint[html][$hData.value]</textarea></td>
	}
#===================================================================================================TEXTAREA TEXT
@create_textarea[hData][sControl_sublabel]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_textarea[$hData]
	}{
# 		$sControl_sublabel[$hData.sublabel]
# 		^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 		}
# 		<td class="align_right">${hData.label}${sControl_sublabel}</td>
		^printLabel[$hData]
		<td><textarea
			id="$hData.id"
			name="$hData.name"
			data-default-value="^taint[html][$hData.defaultValue]"
			class="$hJquery_ui_style.[$hData.group] $hData.classes"
	
			$hData.properties
			$hData.required
			cols="$group_input_size"
			rows="5"
		>^taint[html][$hData.value]</textarea></td>
	}
#===================================================================================================READONLY TEXTAREA
@readonly_textarea[hData][sControl_sublabel]
# 	$sControl_sublabel[$hData.sublabel]
# 	^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 		$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 	}
# 	<td class="align_right">${hData.label}${sControl_sublabel}</td>
	^printLabel[$hData]
	<td>
		<span id="$hData.id">
			<span style='white-space:pre-wrap'>^taint[html][$hData.value]</span>
		</span>
	
	</td>
#===================================================================================================GET FIELDNAMES
@fieldnames_table_textarea[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]
	^tFieldnames.append{$name}
	
	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_textarea[value][hRet]
#	$result[$value]
	$hRet[
		$.value[^value.trim[]]
#		$.error[^hash::create[]]
	]
	
	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_textarea[init;hParsed_xml]
	$value[$init.[$hParsed_xml.name]]
	$result[$value]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_textarea[fieldName;tDataRow][hRet]
	$hRet[^hash::create[]]
	$hRet[$._value[$tDataRow.$fieldName]]
	
	$result[$hRet]