#===================================================================================================TEXT xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================CREATE TEXT
@xcreate_text[hData][sControl_sublabel]
	<tr>
		$sControl_sublabel[$hData.sublabel]
		^if($sControl_sublabel ne "" || def $sControl_sublabel){
			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
		}
		^switch[$hData.type]{
			^case[left]{
				<td ^if(def $hData.classes ){ class="$hData.classes" }>${hData.label}${sControl_sublabel}</td><td></td>
			}
			^case[right]{
				<td></td><td ^if(def $hData.classes ){ class="$hData.classes" }>${hData.label}${sControl_sublabel}</td>
			}
			^case[;both]{
				<td colspan="2" ^if(def $hData.classes ){ class="$hData.classes" }>
					${hData.label}${sControl_sublabel}
				</td>
			}
			^case[split]{
				<td ^if(def $hData.classes ){ class="$hData.classes" }>${hData.label}${sControl_sublabel}</td><td>${hData.value}</td>
			}
			^case[DEFAULT]{
				^ErrorList_text[INVALID_TEXT_ALIGN_TYPE]
			}
		}		
	</tr>
#===================================================================================================CREATE TEXT
@create_text[hData][sControl_sublabel]
	<tr>
		$sControl_sublabel[$hData.sublabel]
		^if($sControl_sublabel ne "" || def $sControl_sublabel){
			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
		}
		^switch[$hData.type]{
			^case[left]{
				<td ^if(def $hData.classes ){ class="$hData.classes" }>${hData.label}${sControl_sublabel}</td><td></td>
			}
			^case[right]{
				<td></td><td ^if(def $hData.classes ){ class="$hData.classes" }>${hData.label}${sControl_sublabel}</td>
			}
			^case[;both]{
				<td colspan="2" ^if(def $hData.classes ){ class="$hData.classes" }>
					${hData.label}${sControl_sublabel}
				</td>
			}
			^case[split]{
				<td ^if(def $hData.classes ){ class="$hData.classes" }>${hData.label}${sControl_sublabel}</td><td>${hData.value}</td>
			}
			^case[DEFAULT]{
				^ErrorList_text[INVALID_TEXT_ALIGN_TYPE]
			}
		}		
	</tr>
	
#===================================================================================================GET POSSIBLE ERROR LIST
@ErrorList_text[invoke][hErrList]
	$hErrList[^hash::create[]]	
	
	$hErrList[
		$.INVALID_TEXT_ALIGN_TYPE[Неверное значение в поле выравнивания текста. Допустимые значения: left, right, both]		
	]
	
	^if(def $invoke && ^hErrList.contains[$invoke]){
		^throw[xcontrols.unknown_text_align;xControls_text;xControls text module -> unknown text align type. Неверное значения в поле выравнивания текста. Допустимые значения: left, right, both]
		$result[$hErrList.$invoke]
	}{
		$result[$hErrList]
	}
	
	$result[$hErrList]
#===================================================================================================PREPROCESS FOR DB
#@db_preprocess_text[value]
#	$result[$value]
#===================================================================================================PREPROCESS FOR EDIT
#@edit_preprocess_date[value]
#	$result[$value]