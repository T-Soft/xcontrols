#utf8 абв

# 2015-10-09
#
# временно? позволяет использовать параметры из URL - через псевдо макрос %FORM{<имя параметра>}%
# вообщем затычка, т.к. по идее тут должны отрабатывать и макросы и парсеры - имею в виду <control_sql>

#===================================================================================================SELECT xCONTROLS MODULE
#===================================================================================================db enabled
@CLASS
xcontrols

@OPTIONS
static
partial

@__replace_FORM_select[sql]

$result[^sql.match[%FORM^{([^^^}]+)^}%][g]{$form:[^match.1.trim[]]}]


#===================================================================================================CREATE SELECT
@xcreate_select[hData][CONST_STR_NO_CHOICE;CONST_VALUE_NO_CHOICE;sControl_sublabel;tLabelSub;wasMatch;isReadonly;sLabels_field_name;sValues_field_name;tQuery_vars;sValues;sLabels;tData;isDb;tLabels;tValues;tProps;sControl_label;tDefault_value;sDefault_value]

$CONST_VALUE_NO_CHOICE[0]
$CONST_STR_NO_CHOICE[* не указано *]

	$isReadonly(false)
	^if(def $hData.readonly || $hData.readonly eq "true"){
		$isReadonly(true)
	}

	$isDb(false)
#=========if there is a <control_sql> element
	^if(def $hData.sql_query){$isDb(true)}
#===============================================================================query data
	^if($isDb){
		^try{
			^connect[$MAIN:CS]{
				$tData[^table::sql{
					^taint[as-is][^__replace_FORM_select[$hData.sql_query]]
				}]
			}
#			$tQuery_vars[^hData.sql_query.match[`(.+)`,`(.+)`][U]]
#			$sLabels_field_name[$tQuery_vars.1]
#			$sValues_field_name[$tQuery_vars.2]

			$sLabels_field_name[label]
			$sValues_field_name[value]
#==========================================================================form select labels/values
			^if(!def $hData.required){
				$sValues[|@|$CONST_VALUE_NO_CHOICE]
				$sLabels[|@|$CONST_STR_NO_CHOICE]
			}
			^tData.menu{
				$sValues[$sValues|@|]
				$sValues[${sValues}$tData.$sValues_field_name]
				$sLabels[$sLabels|@|]
				$sLabels[${sLabels}$tData.$sLabels_field_name]
			}
			$hData.value[${hData.value}~^sValues.trim[left;|@|]]
			$hData.label[${hData.label}~^sLabels.trim[left;|@|]]
		}{
#			$exception.handled(true)
			^ErrorList_select[SQL_ERROR]
		}
	}
#===================================================================================================CREATE SELECT
@create_select[hData][hData2;CONST_STR_NO_CHOICE;CONST_VALUE_NO_CHOICE;sControl_sublabel;tLabelSub;wasMatch;isReadonly;sLabels_field_name;sValues_field_name;tQuery_vars;sValues;sLabels;tData;isDb;tLabels;tValues;tProps;sControl_label;tDefault_value;sDefault_value]

$CONST_VALUE_NO_CHOICE[0]
$CONST_STR_NO_CHOICE[* не указано *]

#^dstop[$hData]

	$isReadonly(false)
	^if(def $hData.readonly || $hData.readonly eq "true"){
		$isReadonly(true)
	}

	$isDb(false)
#=========if there is a <control_sql> element
	^if(def $hData.sql_query){$isDb(true)}
#===============================================================================query data
	^if($isDb){
		^try{
			^connect[$MAIN:CS]{
				$tData[^table::sql{
					^taint[as-is][^__replace_FORM_select[$hData.sql_query]]
				}]
			}
#			$tQuery_vars[^hData.sql_query.match[`(.+)`,`(.+)`][U]]
#			$sLabels_field_name[$tQuery_vars.1]
#			$sValues_field_name[$tQuery_vars.2]

			$sLabels_field_name[label]
			$sValues_field_name[value]
#==========================================================================form select labels/values
			^if(!def $hData.required){
				$sValues[|@|$CONST_VALUE_NO_CHOICE]
				$sLabels[|@|$CONST_STR_NO_CHOICE]
			}
			^tData.menu{
				$sValues[$sValues|@|]
				$sValues[${sValues}$tData.$sValues_field_name]
				$sLabels[$sLabels|@|]
				$sLabels[${sLabels}$tData.$sLabels_field_name]
			}

#		так нельзхя стало -- т.к. пустой value показывает что этот элемент нельзя выбрать ("разделитель")
#			$hData.value[${hData.value}~^sValues.trim[left;|@|]]
#			$hData.label[${hData.label}~^sLabels.trim[left;|@|]]
#		/так нельзхя стало -- т.к. пустой value показывает что этот элемент нельзя выбрать ("разделитель")
			$hData.value[${hData.value}~^sValues.mid(3)]
			$hData.label[${hData.label}~^sLabels.mid(3)]
		}{
#			$exception.handled(true)
			^ErrorList_select[SQL_ERROR]
		}
	}{
#		добавлено для решения проблемы: при редактировании хард-кодного select -- value содержал "чистое" значение, без ~****|@|***...
		^if(!^hData.value.match[~][]){
			$hData.value[${hData.value}^hData.defaultValue.match[^^([^^~])+][]{}]
		}
	}
#===============================================================================
#^dstop[$tData]
#^dstop[$hData]

	$tLabels[^hData.label.split[~;lh]]

	$tLabelSub[^tLabels.0.split[||;lh]]
	$sControl_label[$tLabelSub.0]
	$sControl_sublabel[$tLabelSub.1]

# 	^if($hData.sublabel ne ""){
# 		$sControl_sublabel[$hData.sublabel]
# 	}

# 	^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 		$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 	}

	$hData2[^hash::create[$hData]]
	$hData2.label[$sControl_label]

	$tLabels[^tLabels.1.split[|@|;lh]]

	$tDefault_value[^hData.value.split[~;lh]]
 	$sDefault_value[$tDefault_value.0]
	$hData.value[$tDefault_value.1]

  	$tValues[^hData.value.split[|@|;lh]]
  	$tProps[^hData.properties.split[|@|;lh]]


# 	<td class="align_right">${sControl_label}${sControl_sublabel}</td>
	^printLabel[$hData2]

	<td>

		^if($isReadonly == true){
			<span>
				$wasMatch(false)
				^for[i](0;^tLabels.count[cells] - 1){
					^if($tValues.$i eq $sDefault_value){
						$tLabels.$i
						$wasMatch(true)
					}
				}
				^if(!$wasMatch){
					$CONST_STR_NO_CHOICE
				}
			</span>
		}{
			<select
				id="$hData.id"
				class="$hJquery_ui_style.select $hData.classes"
				style="width:580px^;"
				name="$hData.name"
				$hData.required
#				data-default-value="$hData.defaultValue"
				data-default-value="$sDefault_value"
			>
				^for[i](0;^tLabels.count[cells] - 1){
#					<option value="$tValues.$i" ^if($tValues.$i eq $sDefault_value){selected="selected"}{}>^taint[as-is][$tLabels.$i]</option>

#					если значение пусто - считается что это "разделитель"
					<option
						^if($tValues.$i ne ''){
							value="$tValues.$i"
							^if($tValues.$i eq $sDefault_value){selected="selected"}{}
						}{
							disabled
							style='font-weight:bold^;background:#f0f0f0'
						}
					>^tLabels.$i.match[(&#{0,1}[0-9a-z]+^;)][giU]{^taint[as-is][$match.1]}</option>
				}
			</select>
		}

	</td>
#===================================================================================================GET FIELDNAMES
@fieldnames_table_select[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]
	^tFieldnames.append{$name}

	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_select[value][hRet]
#	$result[$value]
	$hRet[
		$.value[$value]
#		$.error[^hash::create[]]
	]

	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_select[init;hParsed_xml]
	$value[$init.[$hParsed_xml.name]]
	$result[$value]
#===================================================================================================GET POSSIBLE ERROR LIST
@ErrorList_select[invoke][hErrList]
	$hErrList[^hash::create[]]

	$hErrList[
		$.SQL_ERROR[Ошибка SQL. SQL запрос завершился с ошибкой. Проверьте наличие указанной в нем таблицы]
	]

	^if(def $invoke && ^hErrList.contains[$invoke]){
		$result[$hErrList.$invoke]
	}{
		$result[$hErrList]
	}

	$result[$hErrList]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_select[fieldName;tDataRow][hRet]
	$hRet[^hash::create[]]
	$hRet[$._value[$tDataRow.$fieldName]]

	$result[$hRet]