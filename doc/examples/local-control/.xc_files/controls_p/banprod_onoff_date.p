#===================================================================================================TEXTAREA xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

# НЕ ЗАБЫТЬ СДЕЛАТЬ АНАЛОГИЧНЫЙ КЛОН ДЛЯ JS !!


#===================================================================================================TEXTAREA TEXT
@aaaaaaaaaaaaaa[]
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
@create_banprod_onoff_date[hData][sControl_sublabel;bWasInit;NICK_CONTROL;nick_input;isReadonly;is_check]

	$NICK_CONTROL[banprod_onoff_date]

	$hJquery_ui_style.[$NICK_CONTROL][ui-widget-content ui-corner-all]

#	^printLabel[$hData]
	<td></td>

	$isReadonly(^xc_is_field_readonly[$hData])

	$bWasInit(false)
	^if($hData.value is hash){$bWasInit(true)}

#===============

#	имена в составных контролах ДОЛЖНЫ быть!
	$nick_input[is_check]

	<td>

		$is_check($hData.value.[^xc_inputname[$hData.name;$nick_input]] eq '1')

		^if($isReadonly){
			^if($is_check){
				<tt style='border:1px solid #000^;font-family:monospace^;font-size:1.5em^;padding:0 5px^;font-weight:bold'>&times^;</tt>
				^printLabel_content[$hData]
			}{
				<tt style='border:1px solid #bbb^;font-family:monospace^;font-size:1.5em^;padding:0 5px'>-</tt>
				<span style='color:#bbb'>^printLabel_content[$hData]</span>
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
				><label for="$hData.id">^printLabel_content[$hData]</label>
	 	    	</span>
		}

#	</td>
#	</tr>

#===============

	$nick_input[date]

	^if(
		!$isReadonly
		||
		(
			$isReadonly
			&&
		 	$is_check
		 )
	){
#		<tr>
#			<td class="align_right">Дата</td>
#			<td>

				^if($isReadonly){
					<br>
					<div style='padding-left:26px'>
						Дата:
						<span
							id		= "^xc_idname[$hData.id;$nick_input]"
						>
							$hData.value.[^xc_inputname[$hData.name;$nick_input]]
						</span>
					</div>
				}{
					<script>
						^$(function() {
							^$( "#^xc_idname[$hData.id;$nick_input]" ).datepicker(^$.datepicker.regional['ru'] )^;
							^$( "#^xc_idname[$hData.id;$nick_input]" ).datepicker( "option", "dateFormat", "yy-mm-dd")^;
#							^$( "#^xc_idname[$hData.id;$nick_input]" ).datepicker( "option", "constrainInput" , true )^;
							^$( "#^xc_idname[$hData.id;$nick_input]" ).datepicker( "option", "changeMonth" , true )^;
							^$( "#^xc_idname[$hData.id;$nick_input]" ).datepicker( "option", "changeYear" , true )^;
						})^;
					</script>
					<div id="^xc_idname[$hData.id;$nick_input]_BLOCK" style='margin-top:10px'>
						<input
							type="text"
							id="^xc_idname[$hData.id;$nick_input]"
							size="30"
							style='width:auto'
							name="^xc_inputname[$hData.name;$nick_input]"
							value="^if($bWasInit){$hData.value.[^xc_inputname[$hData.name;$nick_input]]}"
							data-default-value="^if($bWasInit){$hData.value.[^xc_inputname[$hData.name;$nick_input]]}"

#							xc__date указывает на элемент, который будет обрабатываться js'ом
							class="xc__date $hJquery_ui_style.date $hData.classes"

#							эта позиция для указания типа данных, на который нужно проверить:
							data-type="date"

#							readonly
#							$hData.required
						>
						<button type="button" id="^xc_idname[$hData.id;$nick_input]_today" class="xc_date_btn_today"/>
					</div>

					<script>
						^$(function() {
							^$( "#^xc_idname[$hData.id;$nick_input]" ).val("^if($bWasInit){$hData.value.[^xc_inputname[$hData.name;$nick_input]]}")^;
						})^;
					</script>


#					<textarea
#						id		= "^xc_idname[$hData.id;$nick_input]"
#						name		= "^xc_inputname[$hData.name;$nick_input]"
#						readonly	= ""
#						class="^xc_classname[$NICK_CONTROL] $hJquery_ui_style.[$hData.group] $hData.classes"
#
#						$hData.properties
#						$hData.required
#						cols="$group_input_size"
#						rows="5"
#					>^if($bWasInit){$hData.value.[^xc_inputname[$hData.name;$nick_input]]}</textarea>
				}
#			</td>
#		</tr>
	}
	</td>

#===================================================================================================GET FIELDNAMES
@fieldnames_table_banprod_onoff_date[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]

#	имена всех полей из контрола:
	^tFieldnames.append{${name}_is_check}
	^tFieldnames.append{${name}_date}

	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_banprod_onoff_date[value][hRet;acc]
	$acc[^value.trim[]]
	$hRet[

		$.value[^if(
				(!def $acc)
				||
				($acc eq '0000-00-00')
			){NULL}{$acc}]

#		$.error[^hash::create[]]
	]

	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_banprod_onoff_date[init;hParsed_xml]
	$hValues[^hash::create[]]

	^init.foreach[key;val]{
		^if(^key.match[${hParsed_xml.name}_(.+)]){
			$hValues.[$key][$val]
		}
	}

	$result[$hValues]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_banprod_onoff_date[fieldName;tDataRow][hRet]
	$hRet[^hash::create[]]
	$hRet[$._value[$tDataRow.$fieldName]]

	$result[$hRet]