#===================================================================================================TEXTAREA xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================TEXTAREA TEXT
@bbbbbbbbbbbbb[]
^rem{

	@xc_classname[nick_control;nick_input]
	$result[xc_${nick_control}^if(def $nick_input){_${nick_input}}]

	@xc_inputname[name;nick_input]
	$result[${name}_${nick_input}]

	@xc_idname[id;nick_input]
	$result[${id}_${nick_input}]

	@xc_is_field_readonly[hData]
	^if(def $hData.readonly){
		$result(true)
	}{
		$result(false)
	}

}

#===================================================================================================TEXTAREA TEXT
@create_banprod_onoff_textareas[hData][sControl_sublabel;bWasInit;NICK_CONTROL;nick_input;isReadonly;is_check]

	$NICK_CONTROL[banprod_onoff_textareas]

	$hJquery_ui_style.[$NICK_CONTROL][ui-widget-content ui-corner-all]

	^printLabel[$hData]

	$isReadonly(^xc_is_field_readonly[$hData])

	$bWasInit(false)
	^if($hData.value is hash){$bWasInit(true)}

#===============

	$nick_input[is_found]

	<td>

		$is_check($hData.value.[^xc_inputname[$hData.name;$nick_input]] eq '1')

		^if($isReadonly){
			^if($is_check){
				<tt style='border:1px solid #000^;font-family:monospace^;font-size:1.5em^;padding:0 5px^;font-weight:bold'>&times^;</tt>
				Выявлены нарушения
			}{
				<tt style='border:1px solid #bbb^;font-family:monospace^;font-size:1.5em^;padding:0 5px'>-</tt>
				<span style='color:#bbb'>Выявлены нарушения</span>
			}

		}{
	 		<span id="chk_${hData.id}" >
				<input
					type="checkbox"
					id="$hData.id"
					class="^xc_classname[$NICK_CONTROL;$nick_input]"
					name="^xc_inputname[$hData.name;$nick_input]"
					value="1"
					^if($bWasInit){
						^if($is_check){
							checked="checked"
							data-default-value="1"
						}
					}
					$sReadonly
				><label for="$hData.id">Выявлены нарушения</label>
	 	    	</span>
		}

	</td>
	</tr>

#===============

	$nick_input[found]

	^if(
		!$isReadonly
		||
		(
			$isReadonly
			&&
		 	$is_check
		 )
	){
		<tr>
			<td class="align_right">Выявлено</td>
			<td>
				^if($isReadonly){
					<span
						id		= "^xc_idname[$hData.id;$nick_input]"
					>
						<span style='white-space:pre-wrap'>^taint[html][$hData.value.[^xc_inputname[$hData.name;$nick_input]]]</span>
					</span>
				}{
					<textarea
						id		= "^xc_idname[$hData.id;$nick_input]"
						name		= "^xc_inputname[$hData.name;$nick_input]"
#						readonly	= ""
#						class		= "^xc_classname[$NICK_CONTROL] $hJquery_ui_style.[$hData.group] $hData.classes"
						class		= "				$hJquery_ui_style.[$hData.group] $hData.classes"

						$hData.properties
#						$hData.required
						cols="$group_input_size"
						rows="5"
						data-default-value="^taint[html][$hData.value.[^xc_inputname[$hData.name;$nick_input]]]"
#					>^if($bWasInit){$hData.value.[^xc_inputname[$hData.name;$nick_input]]}</textarea>
					>^if($bWasInit){^taint[html][$hData.value.[^xc_inputname[$hData.name;$nick_input]]]}</textarea>
				}
			</td>
		</tr>
	}

#===============

	$nick_input[norm]

	^if(
		!$isReadonly
		||
		(
			$isReadonly
			&&
		 	$is_check
		 )
	){
		<tr>
			<td class="align_right">Гигиенический норматив</td>
			<td>
				^if($isReadonly){
					<span
						id		= "^xc_idname[$hData.id;$nick_input]"
					>
						<span style='white-space:pre-wrap'>^taint[html][$hData.value.[^xc_inputname[$hData.name;$nick_input]]]</span>
					</span>
				}{
					<textarea
						id		= "^xc_idname[$hData.id;$nick_input]"
						name		= "^xc_inputname[$hData.name;$nick_input]"
#						readonly	= ""
#						class		= "^xc_classname[$NICK_CONTROL] $hJquery_ui_style.[$hData.group] $hData.classes"
						class		= "				$hJquery_ui_style.[$hData.group] $hData.classes"

						$hData.properties
#						$hData.required
						cols="$group_input_size"
						rows="5"
						data-default-value="^taint[html][$hData.value.[^xc_inputname[$hData.name;$nick_input]]]"
#					>^if($bWasInit){$hData.value.[^xc_inputname[$hData.name;$nick_input]]}</textarea>
					>^if($bWasInit){^taint[html][$hData.value.[^xc_inputname[$hData.name;$nick_input]]]}</textarea>
				}
			</td>
	}
#===================================================================================================GET FIELDNAMES
@fieldnames_table_banprod_onoff_textareas[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]

#	имена всех полей из контрола:
	^tFieldnames.append{${name}_is_found}
	^tFieldnames.append{${name}_found}
	^tFieldnames.append{${name}_norm}

	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_banprod_onoff_textareas[value][hRet;acc]
	$acc[^value.trim[]]
	$hRet[
		$.value[$acc]

#		$.error[^hash::create[]]
	]

	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_banprod_onoff_textareas[init;hParsed_xml]
	$hValues[^hash::create[]]

	^init.foreach[key;val]{
		^if(^key.match[${hParsed_xml.name}_(.+)]){
			$hValues.[$key][$val]
		}
	}

	$result[$hValues]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_banprod_onoff_textareas[fieldName;tDataRow][hRet]
	$hRet[^hash::create[]]
	$hRet[$._value[$tDataRow.$fieldName]]

	$result[$hRet]