#===================================================================================================ADDRESS xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================CREATE ADDRESS
@xcreate_address[hData][sBase_class;sXML_path]
	
	$sBase_class[$hJquery_ui_style.text]
	$sXML_path[address.xml]
	^if(def $hData.value){
		^create_controls[$sXML_path;$hData.name;$sBase_class;$hData.value]
	}{
		^create_controls[$sXML_path;$hData.name;$sBase_class]
	}

#===================================================================================================CREATE ADDRESS
@create_address[hData][sBase_class;sXML_path]
	
	$sBase_class[$hJquery_ui_style.text]
	$sXML_path[address.xml]
	^if(def $hData.value){
		^create_controls[$sXML_path;$hData.name;$sBase_class;$hData.value]
	}{
		^create_controls[$sXML_path;$hData.name;$sBase_class]
	}
	

#===================================================================================================GET FIELDNAMES
@fieldnames_table_address[name][tFieldnames;tField_suffixes;sXML_path;tControls]

^rem{
============ADDRESS FIELD SUFFIXES
_region
_id_city
_id_street
_id_house
_d_apartment
}

	$sXML_path[address.xml]
	$tControls[^parse_XML[$sXML_path;recursive]]

	$tFieldnames[^table::create{fieldname}]
	^tControls.menu{
		^tFieldnames.append{${name}_$tControls.name}
	}
	
	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_address[value][hRet]

	$hRet[
		$.value[$value]
#		$.error[^hash::create[]]
	]
	
	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_address[init;hParsed_xml][tKeys;hValues;key;val]
	$hValues[^hash::create[]]

	^init.foreach[key;val]{
		^if(^key.match[${hParsed_xml.name}_(.+)]){
			$hValues.[$key][$val]
		}
	}

	$result[$hValues]