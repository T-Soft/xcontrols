#===================================================================================================INPUT xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================CREATE BUTTON
@xcreate_button_clear[hData][sCaption;sUri]
	$sCaption[Очистить]
	^if(def $hData.value || $hData.value ne ""){
		$sCaption[$hData.value]
	}
# 	$sUri[]
# 	^if(def $form:uuid && $form:uuid ne ""){
# 		^if(^sFormTarget.pos[?] != -1){
# 			$sUri[${sFormTarget}&uuid=$form:uuid]
# 		}{
# 			$sUri[${sFormTarget}?uuid=$form:uuid]
# 		}
# 	}{
# 		$sUri[$sFormTarget]	
# 	}
	<td></td>
	<td>
	<input
# 		data-target="$sUri"
		type="button"
		id="$hData.id"
		value="$sCaption"
		class="$hJquery_ui_style.[$hData.type] $hData.classes xc_button_clear"
		$hData.properties
	 />
	</td>
#===================================================================================================CREATE BUTTON
@create_button_clear[hData][sCaption;sUri]
	$sCaption[Очистить]
	^if(def $hData.value || $hData.value ne ""){
		$sCaption[$hData.value]
	}
# 	$sUri[]
# 	^if(def $form:uuid && $form:uuid ne ""){
# 		^if(^sFormTarget.pos[?] != -1){
# 			$sUri[${sFormTarget}&uuid=$form:uuid]
# 		}{
# 			$sUri[${sFormTarget}?uuid=$form:uuid]
# 		}
# 	}{
# 		$sUri[$sFormTarget]	
# 	}
	<td></td>
	<td>
	<input
# 		data-target="$sUri"
		type="button"
		id="$hData.id"
		value="$sCaption"
		class="$hJquery_ui_style.[$hData.type] $hData.classes xc_button_clear"
		$hData.properties
	 />
	</td>