#===================================================================================================DATEPICKER xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

@USE
date.p

# на полной основе "date" !

#===================================================================================================NEW CREATE DATE
@xcreate_date_null[hData]
$result[^xcreate_date[$hData]]
#===================================================================================================CREATE DATEPICKER
@create_date_null[hData]
$result[^create_date[$hData]]
#===================================================================================================CREATE READONLY DATEPICKER
@readonly_date_null[hData]
$result[^readonly_date[$hData]]
#===================================================================================================GET FIELDNAMES
@fieldnames_table_date_null[name]
$result[^fieldnames_table_date[$name]]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_date_null[value][hRet;acc]

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
@edit_preprocess_date_null[init;hParsed_xml]
$result[^edit_preprocess_date[$init;$hParsed_xml]]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_date_null[fieldName;tDataRow]
$result[^raw_data_date[$fieldName;$tDataRow]]
