#===================================================================================================TNVED xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================CREATE TNVED
@xcreate_tnved[hData][sControl_sublabel]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_tnved[$hData]
	}{
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
				class="xc__tnved $hJquery_ui_style.[$hData.group] $hData.classes"
		
				$hData.properties
				$hData.required
				$hData.bounds
		
				maxlength="10"
#			10 + 1 для хорошего визуального отображения контрола
				size="11"
				style='width:auto'
				
				data-type="tnved"
			/>
# 			<button style="height: 25px^; width : 25px^; " type="button" id="${hData.id}_clear" class="xc_tnved_btn_clear"></button>
		</td>
	}
#===================================================================================================CREATE TNVED
@create_tnved[hData][sControl_sublabel]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_tnved[$hData]
	}{
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
				class="xc__tnved $hJquery_ui_style.[$hData.group] $hData.classes"
		
				$hData.properties
				$hData.required
				$hData.bounds
		
				maxlength="10"
#			10 + 1 для хорошего визуального отображения контрола
				size="11"
				style='width:auto'
				
				data-type="tnved"
			/>
# 			<button style="height: 25px^; width : 25px^; " type="button" id="${hData.id}_clear" class="xc_tnved_btn_clear"></button>
		</td>
	}
#===================================================================================================READONLY OGRN
@readonly_tnved[hData][sControl_sublabel]
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
@fieldnames_table_tnved[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]
	^tFieldnames.append{$name}
	
	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_tnved[value][hRet]
#	$result[$value]
	$hRet[
		$.value[^value.trim[]]
#		$.error[^hash::create[]]
	]
	
	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_tnved[init;hParsed_xml]
	$value[$init.[$hParsed_xml.name]]
	$result[$value]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_tnved[fieldName;tDataRow][hRet]
	$hRet[^hash::create[]]
	$hRet[$._value[$tDataRow.$fieldName]]
	
	$result[$hRet]