#===================================================================================================INT xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

@USE
int.p

#===================================================================================================INT
@create_int_null[hData]
$result[^create_int[$hData]]
#===================================================================================================READONLY INT
@readonly_int_null[hData]
$result[^readonly_int[$hData]]
#===================================================================================================GET FIELDNAMES
@fieldnames_table_int_null[name]
$result[^fieldnames_table_int[$name]]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_int_null[value][hRet;acc]

	$acc[^value.trim[]]
	$hRet[
		$.value[^if(!def $acc){NULL}{$acc}]
#		$.error[^hash::create[]]
	]

	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_int_null[init;hParsed_xml]
$result[^edit_preprocess_int[$init;$hParsed_xml]]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_int_null[fieldName;tDataRow]
$result[^raw_data_int[$fieldName;$tDataRow]]
