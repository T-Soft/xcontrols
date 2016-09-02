#utf-8 / абв
#=======================================================================================================================xCONTROLS SEARCH UNIT
@CLASS
xcontrols

@OPTIONS
static
partial

@auto[filespec]

#===============================================================================INIT SEARCH
@search_init[hArgs]
	$sUser_xcontrols_files[^hArgs.user_search_folder_path.left(^hArgs.user_search_folder_path.length[]-7)]

#===============================================================================INCLUDE XML
@consumeXmlSearchX[]

#===============================================================================PREPROCESS SEARCH.XML
@preprocessSearchX[xmlPath][fSearchX;sDocument]
	$fSearchX[^file::load[text;$xmlPath]]
	$sDocument[$fSearchX.text]
	
	$sDocument[^sDocument.match[(<!--.+-->)][isUg][]]
#	$sDocument[^consumeXmlViewX[$sDocument;$xmlPath]]
#	$sDocument[^sDocument.match[%(PARSER|MACRO){(.+)}%][mg]{^ExecuteMacros[$match]}]
	$sDocument[^sDocument.match[\s+][g][ ]]
	
	$result[$sDocument]
#===============================================================================CREATE QUERY FROM PARSE
@createQuery[hParsed]
	
#===============================================================================GET ADDITIONAL FIELDS FROM XML	
@getAdditionalFields[nlAdditional][hRet;f;v;fname;nlSql;select;from;where]
	$hRet[^hash::create[]]

	^nlAdditional.foreach[f;v]{

		$fname[^v.selectString[string(name)]]
		$nlSql[^v.select[sql]]

		^if(def $nlSql){
			$fInfo[^hash::create[
				$.select[^nlSql.0.selectString[string(select)]]
				$.from[^nlSql.0.selectString[string(child::from)]]
				$.where[^nlSql.0.selectString[string(child::where)]]
			]]
			$hRet.$fname[$fInfo]
		}{
			$hRet.$fname[]
		}
	}
	$result[$hRet]
#===============================================================================PARSE SEARCH.XML
@parseSearchX[searchX][nlDbInfo;hRet;nlSearchFields;i;f;v]
	$hRet[^hash::create[
		$.table[]
		$.additional[^hash::create[]]
		$.fields[^hash::create[]]
	]]

	$nlDbInfo[^searchX.select[.//search/database]]
	$hRet.table[^nlDbInfo.0.selectString[string(child::table_name)]]
	$hRet.additional[^getAdditionalFields[^searchX.select[.//search/database/extended_field_list/field]]]

	$nlSearchFields[^searchX.select[.//search/search_field_list/field]]
	
	$i(0)
	^nlSearchFields.foreach[f;v]{
		$fInfo[^hash::create[
			$.name[^v.selectString[string(source_name)]]
			$.value[^v.selectString[string(default_value)]]
			$.group[^v.selectString[string(control_group)]]
			$.method[^v.selectString[string(method)]]
			$.label[^v.selectString[string(label)]]
			$.sublabel[^v.selectString[string(sublabel)]]
			$.tag[^v.selectString[string(tag)]]
#=======================for xcontrols : create form javascript connection
			$.id[^v.selectString[string(source_name)]_^math:uid64[]]
		]]
		$hRet.fields.$i[$fInfo]
		^i.inc[]
	}
	$result[$hRet]

#===============================================================================CREATE SEARCH FORM
@createSearchForm[hParsed][id;field]
	<form method="POST" action="${sSave_data_document}" class="xform" enctype="multipart/form-data">
		<table cellpadding="10" class="xcontrols_main_table">
			$fieldCount(^hParsed.fields._count[])
			$hParsed.fields.$fieldCount[
				$.name[btn_search]
				$.value[]
				$.group[submit]
				$.label[Поиск]
				$.id[btn_search_^math:uid64[]]
			]
			^hParsed.fields.foreach[id;field]{
				$sControl[$field.group]
				^use[${sSystem_lib_path}p/xcontrols_modules/${field.group}.p]
				<tr>
					^try{
						^includeJs[$field.group]
						^xcontrols:xcreate_$sControl[$field]					
					}{
#						$exception.handled(true)
					}
				</tr>	
			}

		</table>
	</form>
#===============================================================================SEARCH MAIN FUNCTION
@search[xmlSearchNick;hArgs]
	$xcLogPath[${sSystem_lib_path}log/${xcLogName}]
	$xmlPath[${sUser_xcontrols_files}search/${xmlSearchNick}/]

	$sXml[${xmlPath}search.xml]
	$sSearchX[^preprocessSearchX[$sXml]]
	$searchX[^xdoc::create{^taint[as-is][$sSearchX]}]

	$hParsed[^parseSearchX[$searchX]]
	^createSearchForm[$hParsed]


	