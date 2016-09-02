#===================================================================================================PERSON xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================CREATE PERSON
@xcreate_person[hData][sBase_class]

	$sBase_class[$hJquery_ui_style.text]
	$sXML_path[person.xml]
	
#	^create_controls[$sXML_path;$hData.name;$sBase_class]
	^if(def $hData.value){
		^create_controls[$sXML_path;$hData.name;$sBase_class;$hData.value]
	}{
		^create_controls[$sXML_path;$hData.name;$sBase_class]
	}
#===================================================================================================CREATE PERSON
@create_person[hData][sBase_class]

	$sBase_class[$hJquery_ui_style.text]
	$sXML_path[person.xml]
	
#	^create_controls[$sXML_path;$hData.name;$sBase_class]
	^if(def $hData.value){
		^create_controls[$sXML_path;$hData.name;$sBase_class;$hData.value]
	}{
		^create_controls[$sXML_path;$hData.name;$sBase_class]
	}
#===================================================================================================GET FIELDNAMES
@fieldnames_table_person[name][tFieldnames;tField_suffixes;sXML_path;tControls]

^rem{	
============PERSON FIELD SIFFIXES
_name
_id_type
_id_number
_id_issuer
_d_issue
_tel
_postal_addr
_email

}
	
	$sXML_path[person.xml]
	$tControls[^parse_XML[$sXML_path;recursive]]

	$tFieldnames[^table::create{fieldname}]
	^tControls.menu{
		^tFieldnames.append{${name}_$tControls.name}
	}
	
	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_person[value][hRet]
#	$result[$value]
	$hRet[
		$.value[$value]
#		$.error[^hash::create[]]
	]
	
	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_person[init;hParsed_xml]
	$hValues[^hash::create[]]

	^init.foreach[key;val]{
		^if(^key.match[${hParsed_xml.name}_(.+)]){
			$hValues.[$key][$val]
		}
	}

	$result[$hValues]