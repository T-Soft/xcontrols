#===================================================================================================DATEPICKER xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

# используется â "date_null"

#===================================================================================================NEW CREATE DATE
@xcreate_date[hData]

	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_date[$hData]
	}{
#	<script src="/egov-skk/js/datepicker_locale/datepicker-ru.js"></script>
		<script>
			^$(function() {
				^$( "#$hData.id" ).datepicker(^$.datepicker.regional['ru'] )^;
				^$( "#$hData.id" ).datepicker( "option", "dateFormat",	"yy-mm-dd"	)^;
				^$( "#$hData.id" ).datepicker( "option", "changeMonth",	true		)^;
				^$( "#$hData.id" ).datepicker( "option", "changeYear",	true		)^;
			})^;
		</script>

		^printLabel[$hData]

		<td>
			<input type="text" id="$hData.id" size="30" style='width:auto' name="$hData.name" value="$hData.value" class="xc_date $hJquery_ui_style.[$hData.group] $hData.classes" readonly $hData.required >

# 			<button type="button" id="${hData.id}_clear" class="xc_date_btn_clear"/>
			<button type="button" id="${hData.id}_today" class="xc_date_btn_today"/>

		</td>
		<script>
			^$(function() {
				^$( "#$hData.id" ).val("$hData.value")^;
			})^;
		</script>
	}

#===================================================================================================CREATE DATEPICKER
@create_date[hData][sControl_sublabel;dt_now]

#	------------
#	обрабатываем ситуацию с отсутствием даты - если ее нет - пусть будет пусто! а не 0000-00-00
	^if($hData.value eq '0000-00-00'){
		$hData.value[]
	}
#	/обрабатываем ситуацию с отсутствием даты
#	------------

	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_date[$hData]
	}{
#	<script src="/egov-skk/js/datepicker_locale/datepicker-ru.js"></script>
		<script>
			^$(function() {
				^$( "#$hData.id" ).datepicker(^$.datepicker.regional['ru'] )^;
				^$( "#$hData.id" ).datepicker( "option", "dateFormat",	"yy-mm-dd"	)^;
				^$( "#$hData.id" ).datepicker( "option", "changeMonth",	true		)^;
				^$( "#$hData.id" ).datepicker( "option", "changeYear",	true		)^;
			})^;
		</script>

		^printLabel[$hData]

#		$sControl_sublabel[$hData.sublabel]
#		^if($sControl_sublabel ne "" || def $sControl_sublabel){
#			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
#		}
#		<td class="align_right">${hData.label}${sControl_sublabel}</td>

		<td>
			<input
				type="text"
				id="$hData.id"
				size="30"
				style='width:auto'
				name="$hData.name"
				value="$hData.value"
				data-default-value="$hData.defaultValue"
# 			класс xc_date оставлен для обратной совместимости. когда будем готовы перейти на xc__date -
# 			удалить его
# 				class="xc_date xc__date $hJquery_ui_style.[$hData.group] $hData.classes"

				class="xc__date $hJquery_ui_style.[$hData.group] $hData.classes"
				data-type="date"
				align="center"
				$hData.required
			>

# 			<button type="button" id="${hData.id}_clear" class="xc_date_btn_clear"/>
			<button type="button" id="${hData.id}_today" class="xc_date_btn_today"/>

		</td>
		<script>
			^$(function() {
				^$( "#$hData.id" ).val("$hData.value")^;
			})^;
		</script>
	}
#===================================================================================================CREATE READONLY DATEPICKER
@readonly_date[hData][sControl_sublabel]

	^printLabel[$hData]

	<td>
		<span id="$hData.id">$hData.value</span>
	</td>

#===================================================================================================GET FIELDNAMES
@fieldnames_table_date[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]
	^tFieldnames.append{$name}

	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_date[value][hRet]
#	$result[$value]

	$hRet[
		$.value[^value.trim[]]
#		$.error[^hash::create[]]
	]

	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_date[init;hParsed_xml]
	$value[$init.[$hParsed_xml.name]]
	$result[$value]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_date[fieldName;tDataRow][hRet]
	$hRet[^hash::create[]]
	$hRet[$._value[$tDataRow.$fieldName]]

	$result[$hRet]
