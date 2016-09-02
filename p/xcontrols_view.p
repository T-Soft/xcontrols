#utf-8 / абв
#=======================================================================================================================xCONTROLS VIEW UNIT
@CLASS
xcontrols

@OPTIONS
static
partial

@auto[filespec]

#===============================================================================INIT VIEWER
@view_init[hArgs][form_rpp]

#gleb
#	признак, что хотим визуально отлаживать xml для формы:
	$bDebugViewXml(^if($hArgs.is_debug_view_xml){1}{0})
#/gleb

	$sBinaryPath[$hArgs.binary_path]

	$RPP($hArgs.rpp)
#	для оперативной возможности "перезаписать" rpp
	$form_rpp(^form:xcrpp.int(0))
	^if($form_rpp>0){
		$RPP[$form_rpp]
	}

	$sUser_xcontrols_files[^hArgs.user_view_folder_path.left(^hArgs.user_view_folder_path.length[]-5)]

	$tValuelessElements[^table::create{element
<hr/>
<hr>
<br/>
<br>
}]
#===============================================================================INSERT LAYOUT ELEMENT INTO HTML
@insertLayout[sLayoutType;sLayoutTemplate]
	^switch[$sLayoutType]{
		^case[hr]{
#			$result[^applyTemplate[<hr/>;$sLayoutTemplate]]
			$result[<hr/>]
		}
		^case[br]{
#			$result[^applyTemplate[<br/>;$sLayoutTemplate]]
			$result[<br/>]
		}

	}
#===============================================================================PARSE FORMALIZED DECOR STRING(S)
@buildDecor[sDecor][decor;tDecor;sDec]

	$decor[^sDecor.trim[]]
	$tDecor[^table::create{piece}]

	$sDec[]
	^if($decor ne "" || def $decor){
		^if(^decor.pos[ ] != -1){
			$tDecor[^decor.split[ ;]]
		}{
			^tDecor.append[$decor]
		}

		^tDecor.menu{
			^switch[$tDecor.piece]{
				^case[lighter]{
					$sDec[$sDec font-weight:lighter^;]
				}
				^case[bold;b]{
					$sDec[$sDec font-weight:bold^;]
				}

				^case[italic;i]{
					$sDec[$sDec font-style:italic^;]
				}

				^case[small_caps]{
					$sDec[$sDec font-variant:small-caps^;]
				}
				^case[capitalize;caps]{
					$sDec[$sDec text-transform:capitalize^;]
				}
				^case[lowercase]{
					$sDec[$sDec text-transform:lowercase^;]
				}
				^case[uppercase]{
					$sDec[$sDec text-transform:uppercase^;]
				}


				^case[overlined;overline]{
					$sDec[$sDec text-decoration:overline^;]
				}
				^case[underlined;underline;u]{
					$sDec[$sDec text-decoration:underline^;]
				}

				^case[center]{
					$sDec[$sDec text-align:center^;]
				}

				^case[small]{
					$sDec[$sDec font-size:80%^;]
				}

				^case[nobr;nowrap]{
					$sDec[$sDec white-space:nowrap^;]
				}

				^case[error]{
					$sDec[$sDec color:#b00^;]
				}
				^case[warning;warrning;warn]{
					$sDec[$sDec color:#e73^;]
				}
				^case[ok]{
					$sDec[$sDec color:#090^;]
				}

				^case[id]{ ^rem{ +small +nobr}
					$sDec[$sDec color:#aaa^; font-size:80%^; white-space:nowrap^;]
				}


				^case[DEFAULT]{
					^throw[system.viewer;$tDecor.piece;xControls viewer module -> Unknown decor to apply. Check view.xml and the documentation]
				}
			}
		}

	}{
#=========means no decor
	}
	$result[^sDec.trim[]]

#===============================================================================COMPILE INLINE STYLE STRING FROM NL
@compileStyle[nlStyle][sDecor;sStyle;hStrings;sClass;sInlineStyle]
	$sStyle[]

	$hStrings[^hash::create[]]
	^try{
		$hStrings[
			$.decor[^nlStyle.0.selectString[string(decor)]]
			$.inline[^nlStyle.0.selectString[string(inline)]]
			$.class[^nlStyle.0.selectString[string(class)]]
		]
	}{
		$exception.handled(true)
	}

	$sInlineStyle[]
	$sClass[]

	^if(($hStrings.inline ne "" || def $hStrings.inline) || ( $hStrings.decor ne "" || def $hStrings.decor)){
		$sDecor[^buildDecor[$hStrings.decor]]
		$sInlineStyle[style="$sDecor ^hStrings.inline.trim[]"]
	}

	^if($hStrings.class ne "" || def $hStrings.class){
		$sClass[class="^hStrings.class.trim[]"]
	}

	$sStyle[^sInlineStyle.trim[] ^sClass.trim[]]
	$sStyle[^sStyle.trim[]]

	$result[$sStyle]
#===============================================================================CREATE FOOTER
@createFooter[viewX]
	$result[^parseViewX[$viewX;footer_row]]

#===============================================================================CREATE HEADER
@createHeader[viewX]
	$result[^parseViewX[$viewX;header_row]]


#===============================================================================PROCESS OUTER TABLE TEXT
@processOuterTableText[nlText][nlStyle;sStyle;sTemplate;hRet]

	$nlStyle[^nlText.select[child::style]]
	$sStyle[^compileStyle[$nlStyle]]
	$sTemplate[^nlText.selectString[string(child::template)]]

	$hRet[^hash::create[
		$.style[$sStyle]
		$.template[$sTemplate]
	]]

	$result[$hRet]
#===============================================================================PARSE WIEWX
@parseViewX[viewX;row_node][sOuterTableText;tk;tv;bNoheader;hNoheader;sRowspan;sColspan;tAdditionalFields;sAdditionalFieldname;adk;adv;nlAdditionalFields;iNodataCnt;sLabel;sBlockStyle;sRowStyle;sCellStyle;nlRowStyle;sRowInline;sRowClass;sRowDecor;nlTableStyle;sHeader;hRet;nlDbInfo;sTableName;sHtml;nlRows;nlCells;row;rval;cell;cval;cellCount;sHtml;nlBlocks;block;bval;sType;sLabel;sFormat;sStyle;sTemplate;sControlGroup;sBlockType;sFieldname;rowCount;blockCount;sLayoutTemplate;sLayoutType;sFieldsSql]
	$hRet[^hash::create[
		$.table[]
		$.tableStyleString[]
		$.header[]
		$.fields[^hash::create[]]
		$.fields-sql[]
		$.row[]
		$.rowCount[]
		$.cellCount[]
		$.blockCount[]
		$.text_before[^hash::create[]]
		$.text_after[^hash::create[]]
	]]
	$cellCount(0)
	$rowCount(0)
	$blockCount(0)

	$nlDbInfo[^viewX.select[.//view/database]]
	$hRet.table[^nlDbInfo.0.selectString[string(child::table_name)]]

	$nlTableStyle[^viewX.select[.//view/table/style]]

	$hRet.tableStyleString[^compileStyle[$nlTableStyle]]
#=======text before and after process
	$nlTexts[^viewX.select[.//view/textblock]]
	^nlTexts.foreach[tk;tv]{
		$sOuterTableText[^processOuterTableText[$tv]]
		^switch[^tv.selectString[string(@type)]]{
			^case[before]{
				$hRet.text_before[$sOuterTableText]
			}
			^case[after]{
				$hRet.text_after[$sOuterTableText]
			}
		}
	}
#=======additional fields_process
# 	$tAdditionalFields[^table::create{field}]

	$nlAdditionalFields[^viewX.select[.//view/table/additional/field]]

	^nlAdditionalFields.foreach[adk;adv]{
		$sAdditionalFieldname[^adv.selectString[string(source_name)]]
		$hRet.fields-sql[$hRet.fields-sql,`$sAdditionalFieldname`]
# 		^tAdditionalFields.append[$sAdditionalFieldname]
	}

	^if(def $row_node){
		$nlRows[^viewX.select[.//view/${row_node}/row]]
	}{
		$nlRows[^viewX.select[.//view/data_row/row]]
	}

	$fieldsSql[]
	$sHtml[]
	$sHeader[]
	$iNodataCnt(0)
#=======table rows

	^nlRows.foreach[row;rval]{

		$sRowStyle[^compileStyle[^rval.select[style]]]
		$sHtml[$sHtml <tr $sRowStyle >]
		$sHeader[$sHeader <tr>]

		$nlCells[^rval.select[cell]]
#===============table cells

#^if($row_node eq header_row){^dstop[$nlCells]}

		^nlCells.foreach[cell;cval]{
			$sCellStyle[^compileStyle[^cval.select[style]]]
			$sHtml[$sHtml <td $sCellStyle>]
#=======================add colspan & rowspan & noheader
			$sColspan[^cval.selectString[string(@colspan)]]
			$sRowspan[^cval.selectString[string(@rowspan)]]
			$hNoheader[^cval.select[(noheader)]]

			$bNoheader(false)
			^if(def $hNoheader){
				$bNoheader(true)
			}

			^if(!$bNoheader){
				^if(def $sColspan){
					^if(def $sRowspan){
						$sHeader[$sHeader <td colspan="$sColspan" rowspan="$sRowspan">]
					}{
						$sHeader[$sHeader <td colspan="$sColspan">]
					}
				}{
					^if(def $sRowspan){
						$sHeader[$sHeader <td rowspan="$sRowspan">]
					}{
						$sHeader[$sHeader <td>]
					}
				}
			}
#=======================add header & noheader
# 			$sHeader[$sHeader <td>]
			$nlBlocks[^cval.select[block]]

			$sLabelOverride[^cval.selectString[string(header)]]

			^if(def $sLabelOverride && !$bNoheader){
				$sHeader[$sHeader $sLabelOverride <br/>]
			}
#=======================blocks in the cell
			^nlBlocks.foreach[block;bval]{
#===============================database data block
				$sBlockStyle[^compileStyle[^bval.select[style]]]
				$sBlockType[^bval.selectString[string(^@type)]]
				^if($sBlockType eq "data"){
					$sFieldname[^bval.selectString[string(source_name)]]
					$sFieldname[^sFieldname.trim[]]
					$sFieldname_original[$sFieldname]
					^if(^hRet.fields.contains[$sFieldname]){
						$sFieldname[${sFieldname}_xc_^math:uid64[]_xc]
					}{
# 						^if(! ^tAdditionalFields.locate[field;$sFieldname]){
							$sFieldsSql[${sFieldsSql}`${sFieldname}`,]
# 						}
					}
					$hRet.fields.$sFieldname[
						$gleb_group[^bval.selectString[string(control_group)]]
						$.group[$gleb_group]
						$.label[^bval.selectString[string(label)]]
						$gleb_format[^bval.selectString[string(format)]]
						$.format[$gleb_format]

#						$.template[^bval.selectString[string(template)]]
						$gleb_template[^bval.selectString[string(template)]]
						^if(!$bDebugViewXml){
							$.template[$gleb_template]
						}{
							$gleb_buff[<br><span style='background:#cfa'>^if(def $gleb_format){^[ $gleb_format ^]}{$gleb_group :} $sFieldname_original</span>]
							^if(def $gleb_template){
								$.template[${gleb_buff}$gleb_template]
							}{
								$.template[${gleb_buff}%VALUE^[^]%]
							}
						}
					]
					^if(!def $sLabelOverride){
						^if((def $hRet.fields.$sFieldname.label || $hRet.fields.$sFieldname.label ne "") && !$bNoheader){
							$sHeader[$sHeader $hRet.fields.$sFieldname.label <br/>]
						}
					}
#					$sHtml[$sHtml ^applyTemplate[%${sFieldname}%;$hRet.fields.$sFieldname.template]]
					^if($sBlockStyle ne ""){
						$sHtml[${sHtml}<span $sBlockStyle>%${sFieldname}%</span>]
					}{
						$sHtml[${sHtml}%${sFieldname}%]
					}
				}
#===============================layout data and formatting
				^if($sBlockType eq "layout"){
					$sLayoutType[^bval.selectString[string(layout_type)]]
					$sLayoutTemplate[^bval.selectString[string(layout_template)]]
					$sHtml[$sHtml ^insertLayout[$sLayoutType;$sLayoutTemplate]]
				}
#===============================short formatting aliases
				^if($sBlockType eq "hr" || $sBlockType eq "br"){
					$sHtml[${sHtml} <${sBlockType}/>]
				}
#===============================nodata block for row id and such
				^if($sBlockType eq "nodata"){
					$sNodataFieldname[~%NODATA_${iNodataCnt}%~]
					$sLabel[^bval.selectString[string(label)]]
					^if(def $sLabel || $sLabel ne ""){
						$sHeader[$sHeader $sLabel <br/>]
					}
					$sBlockStyle[^compileStyle[^bval.select[style]]]
					$sLayoutTemplate[^bval.selectString[string(template)]]
					$hRet.fields.$sNodataFieldname[
						$.group[~%NODATA%~]
						$.label[^bval.selectString[string(label)]]
						$.template[^bval.selectString[string(template)]]
					]
					^if($sBlockStyle ne ""){
						$sHtml[${sHtml}<span $sBlockStyle >%${sNodataFieldname}%</span>]
					}{
						$sHtml[${sHtml}%${sNodataFieldname}%]
					}
					^iNodataCnt.inc[]
				}
				^blockCount.inc[]
			}
			^if(!$bNoheader){
				$sHeader[$sHeader </td>]
			}
			$sHtml[$sHtml </td>]
			^cellCount.inc[]
		}

		$sHtml[$sHtml </tr>]
		$sHeader[$sHeader </tr>]
		^rowCount.inc[]
	}

#	$sHtml[<table> <tr>${sHeader}</tr> ${sHtml} </table>]
	$sFieldsSql[^sFieldsSql.trim[both;,]]
	$sFieldsSql[^hRet.fields-sql.trim[left;,],${sFieldsSql}]

#	$hRet.header[<tr>${sHeader}</tr>]
	$hRet.header[$sHeader]
	$hRet.row[$sHtml]
	$hRet.rowCount[$rowCount]
	$hRet.cellCount[$cellCount]
	$hRet.blockCount[$blockCount]
	$hRet.fields-sql[^sFieldsSql.trim[both;,]]

	$result[$hRet]

#===============================================================================PROCESS NODATA FIELDS
@processNodata[tablename;dataRow;template]
	$template[^template.match[%(PARSER|MACRO){(.+)}%][mg]{^ExecuteMacros[$match]}]
	$result[$template]

# =========== test function for PRSER in template tests
@testFunc[val]
	$result[^val.mid(0;5)]
#===============================================================================APPLY TEMPLATE
@applyTemplate[data;template][sRet;sValueRef;sValueRe;tDefaultValue;sDefaultValue;val]
	^if(def $template){
		$template[^untab[$template]]

		$val[]
		$sValueRe[%VALUE\[(.*)\]%]
		$sDefaultValue[]
		^if(^template.match[$sValueRe]){
			$tDefaultValue[^template.match[$sValueRe]]
			$sDefaultValue[$tDefaultValue.1]
		}

		^if((def $data) && (^data.trim[] ne "")){
			$sRet[$data]
			^if(^tValuelessElements.locate[element;$data]){
#===============================template to type="layout" element
			}{
#===============================template to type="data" element
				$sRet[^template.match[$sValueRe][]{$data}]
			}
			$val[$sRet]
# 			$result[$sRet]
		}{
#=======================return default value + template
			^if(def $sDefaultValue){
				$val[^template.match[$sValueRe][]{$sDefaultValue}]
# 				$result[^template.match[$sValueRe][]{$sDefaultValue}]
			}{
#===============================return as is
				$val[$data]
# 				$result[$data]
			}
		}
# ==============process macros
		$val[^val.match[%(PARSER|MACRO){(.+)}%][mg]{^ExecuteMacros[$match]}]
		$result[$val]
	}{
		$result[$data]
	}
#===============================================================================FORMAT DATA
@formatData[fieldName;data;fieldGroup;format;tDataRow][sFormatted;bSystem;hRawControlData;viewersPath;hData;userViewersPath;bUserDefined;hRawData]

	$format[^format.trim[]]
	$hData[
		$.$fieldName[$data]
		$.data[$data]
		$.format[$format]
	]
	$viewersPath[${sSystem_lib_path}p/xcontrols_modules/]
	$userViewersPath[${sUser_xcontrols_files}format/]
# /.xcontrols_files/format/

	$bUserDefined(false)
	$bSystem(false)

	$sFormatted[]

	^if(-f "${viewersPath}${fieldGroup}.p"){
		^use[${viewersPath}${fieldGroup}.p]
		^try{
			$hRawControlData[^raw_data_$fieldGroup[$fieldName;$tDataRow]]
		}{
			$exception.handled(true)
			^throw[system.viewer;$fieldGroup;xControls viewer module -> raw_data_ method not implemented. Check ${fieldGroup}.p]
		}

		$hRawControlData._uuid[$tDataRow.uuid]

		^if(-f "${viewersPath}${fieldGroup}.viewer.p"){
#=======================use system group viewer file
			$bSystem(true)
		}{
#=======================if not found -> find user defined viewer
			^if(-f "${userViewersPath}${format}.p"){
				$bUserDefined(true)
			}{
#=======================================if no format passed
				$result[^defaultFormatter[$data]]
			}
		}
	}{
		^throw[system.viewer;$fieldGroup;xControls viewer module -> Unknown control group detected. Check view.xml]
	}

	^if($bUserDefined){
		^use[${userViewersPath}${format}.p]
		$sFormatted[^format_$format[$hRawControlData;$fieldGroup;$tDataRow;$format]]
	}{
		^use[${viewersPath}${fieldGroup}.view.p]
		$sFormatted[^format_$fieldGroup[$hRawControlData;$tDataRow;$format]]

		^if($sFormatted eq "null"){
			^if(-f "${userViewersPath}${format}.p"){
				^use[${userViewersPath}${format}.p]
				$sFormatted[^format_$format[$hRawControlData;$fieldGroup;$tDataRow;$format]]
			}{
				$sFormatted[^defaultFormatter[$data]]
			}
		}
	}

	$result[$sFormatted]
#===============================================================================DEFAULT FORMATTER
@defaultFormatter[data]
	^if($data eq ""){
		$result[[нет данных]<small>-default</small>]
	}{
		$result[[${data}]<small>-default</small>]
	}
#===============================================================================DEFAULT FORMATTER
@get_value[uuid;fieldname][sRet]
	^try{
		^connect[$MAIN:CS]{
			$sRet[^string:sql{
				SELECT
					`$fieldname`
				FROM
					$sViewTableName
				WHERE
					`uuid`='$uuid'
			}]
		}
		$result[$sRet]
	}{
		$exception.handled(true)
		^throw[system.viewer;$fieldname;xControls viewer module -> Unknown database field detected. Check call syntax]
	}
#===============================================================================CONSUME XML TO VIEWX
@consumeXmlViewX[text;xmlPath][fText;tMatches;tSubst;tPrefix;tFile;sPrefix;sFile]

	$tMatches[^text.match[(<include_xml>.+<\/include_xml>)][sUg]]

	$tSubst[^table::create{from	to}]

	^tMatches.menu{
		$sPrefix[]
		$sFile[]

		$sTag[$tMatches.1]
		$tPrefix[^sTag.match[<prefix>(.+)<\/prefix>][sU]]
		$tFile[^sTag.match[<file>(.+)<\/file>][sU]]

		$sPrefix[^tPrefix.1.trim[]]
		$sFile[^tFile.1.trim[]]

		$bNoFile(false)

		^try{
			$sFilepath[^xmlPath.left(^eval(^xmlPath.length[]-8))]
			$sFilepath[${sFilepath}${sFile}]
			$f[^file::load[text;$sFilepath]]
		}{
			$exception.handled(true)
			$bNoFile(true)
			^ErrorList_main[CRASH_CONSUME_FILE_NOT_FOUND]
		}

		^if(def $sPrefix || $sPrefix ne ""){
			$sPrefix[${sPrefix}_]
		}{
			$sPrefix[]
		}

		^if(!$bNoFile){
			$fText[$f.text]
			$sContent[^fText.match[(<!--.+-->)][isUg][]]
			$sContent[^sContent.match[<source_name>(.+)<\/source_name>][sUg]{<source_name>${sPrefix}$match.1</source_name>}]
			^tSubst.append[$tMatches.1	$sContent]
		}
	}
	$text[^text.replace[$tSubst]]
	^while(^text.match[(<include_xml>.+<\/include_xml>)][sUg]){
		$text[^consumeXmlViewX[$text;$xmlPath]]
	}

	$result[$text]
#===============================================================================PREPROCESS VIEWX TEXT
@preprocessViewX[xmlPath][fViewX;sDocument]

	$fViewX[^file::load[text;$xmlPath]]
	$sDocument[$fViewX.text]

	$sDocument[^sDocument.match[(<!--.+-->)][isUg][]]
	$sDocument[^consumeXmlViewX[$sDocument;$xmlPath]]

# 	$sDocument[^sDocument.match[%(PARSER|MACRO){(.+)}%][mg]{^ExecuteMacros[$match]}]
	$sDocument[^ExecuteSubst[$sDocument]]
	$sDocument[^sDocument.match[\s+][g][ ]]

	$result[$sDocument]
#===============================================================================GET FIELDS REALNAMES
@realnames[hFields][k;v;tRet]

	$tRet[^table::create{id	real}]
	^hFields.foreach[k;v]{
		$s[$k	^k.match[(_xc_.+_xc)][][]]
		^tRet.append[$s]
	}
	$result[$tRet]

#===============================================================================VIEW SELECTED DATABASE
#@view[xmlViewerNick;whereStatement;orderByStatement;tDt;tDtRowCount][isExtShort;sXcName;tRealNames;sFormatData;sViewX;sProcessedData;sFormattedStyledData;sData;sDataRowHeader;tDataRow;hTableStyle;tSubst;sCurrentRow;sData;sStyle;sFormattedData;sFormat;sFieldGroup;viewX;sXml;sParsed;hFields;sRow;sSql;iOffset;tDataCols;VIEW;sDataField;isExtLong]
@view[xmlViewerNick;hArg][sTableFooter;sTableHeader;hTableFooter;hTableHeader;sLogEntry;tDtRowCount;tDt;orderByStatement;whereStatement;xmlViewerNick;isExtShort;sXcName;tRealNames;sFormatData;sViewX;sProcessedData;sFormattedStyledData;sData;sDataRowHeader;tDataRow;hTableStyle;tSubst;sCurrentRow;sData;sStyle;sFormattedData;sFormat;sFieldGroup;viewX;sXml;sParsed;hFields;sRow;sSql;iOffset;tDataCols;VIEW;sDataField;isExtLong;hDont_set_tag]

	$xcLogPath[${sSystem_lib_path}log/${xcLogName}]

	$whereStatement[$hArg.where]
	$orderByStatement[$hArg.order_by]
	$tDt[$hArg.data_table]
	$tDtRowCount[$hArg.row_count]

	$hDont_set_tag[
		$.open(^hArg.table_dont_open.int(0))
		$.close(^hArg.table_dont_close.int(0))
	]
	$is_dont_close_table(^hArg.is_dont_close_table.int(0))

	$VIEW[]
	$sCurrentRow[]
	$xmlPath[${sUser_xcontrols_files}view/${xmlViewerNick}/]

	$whereStatement[^whereStatement.trim[]]
	$orderByStatement[^orderByStatement.trim[]]

	$sXml[${xmlPath}view.xml]

	$sViewX[^preprocessViewX[$sXml]]

#	$viewX[^xdoc::load[$sXml]]
	$viewX[^xdoc::create{^taint[as-is][$sViewX]}]
	$hParsed[^parseViewX[$viewX]]

#=======header & footer
	$hTableHeader[^createHeader[$viewX]]
	$sTableHeader[$hTableHeader.header]

	$hTableFooter[^createFooter[$viewX]]
	$sTableFooter[$hTableFooter.header]
#==========================================
	$hFields[$hParsed.fields]
	$tRealNames[^realnames[$hFields]]

	$sViewTableName[$hParsed.table]
#	варианты:
#		table_name
#		db_name.table_name
#	исходя из чего расставляем грамотно "`"
	$sViewTableName[`^sViewTableName.match[`][g]{}`]
	$sViewTableName[^sViewTableName.match[\.][g]{`.`}]
#		`table_name`
#		`db_name`.`table_name`

	$iViewTotalRows(0)

	$isExtShort(false)
	$isExtLong(false)
#=======add lister here
	^if(def $form:[xc.page]){
		$iOffset($form:[xc.page])
	}
	^if(!def $tDtRowCount){
		^if(!def $tDt){
#=======================means we are showing our table
			^connect[$MAIN:CS]{
				$iViewTotalRows(^int:sql{
					SELECT
						COUNT(*)
					FROM
						$sViewTableName

					^if(def $whereStatement){
						WHERE
							$whereStatement
					}
				})
			}
		}{
#===============means we are showing external short table :
#===============no scroller needed
			$isExtShort(true)
		}
	}{
#===============means we are showing external long table
		$iViewTotalRows($tDtRowCount)
		^if($iViewTotalRows < $RPP){
			$isExtShort(true)
		}{
			$isExtLong(true)
		}

	}

	^if($isScroller && !$isExtShort){

		$xScroll[^scroller::create[
			$.sKeyName[xcpage]
			$.iRowsAll($iViewTotalRows)
			$.sClass[scroller]
			$.iRowsPerPage($RPP)

			^if($iViewTotalRows/$RPP < 100){
				$.sGroupsType[both]
			}{
				$.sGroupsType[left]
			}

			$.hQuery[$form:fields]
			$.sPath[./]
		]]
	}

	$iOffset(^eval(^eval($RPP)*^eval($form:[xcpage] - 1)))
	^if($iOffset<0){
		$iOffset(0)
	}


	$tData[]

	^if(!def $tDt){
#===============get our own table
		$sSql[
			SELECT
				${hParsed.fields-sql},`uuid`
			FROM
				$sViewTableName
#				${hParsed.table}

			^if(def $whereStatement){
				WHERE $whereStatement
			}

			^if(def $orderByStatement){
				ORDER BY $orderByStatement
			}
		]

		^try{
			^connect[$MAIN:CS]{
				$tData[^table::sql{$sSql}[$.limit($RPP) $.offset($iOffset)]]
			}
		}{
			^exLog[sql;$sSql;$exception]
			^throw[xControls fatal error;xControls.view;Sql error: $exception.comment . See more info in ${xcLogName}]
		}

	}{
#===============got external table
		$tData[$tDt]
	}

	$tDataCols[^tData.columns[field]]


	$sDataRowHeader[]
	^tDataCols.menu{
		$sDataRowHeader[${sDataRowHeader}	$tDataCols.field]
	}
	$sDataRowHeader[^sDataRowHeader.trim[both]]

	$iViewCurrentRow(0)
#=======for every database entry
	^tData.menu{

		^iViewCurrentRow.inc[]
		$tDataRow[^table::create{$sDataRowHeader}]
		$sData[]
		^tDataCols.menu{
			$sAppend[$tData.[$tDataCols.field]]

			^if(def $tData.[$tDataCols.field]){
				$sData[${sData}	^tData.[$tDataCols.field].trim[]]
			}{
				$sData[${sData}	NO~DA~TA]
			}
		}
#===============При отсутствии данных пустота оттримливается
		$sData[^sData.trim[left]]
		$sData[^sData.replace[NO~DA~TA;]]
		^tDataRow.append[$sData]

		$sCurrentRow[$hParsed.row]

# 		$tSubst[^table::create{from	to}]

#===============for every column in fields from view.xml
		^tRealNames.menu{
			$sDataField[$tRealNames.real]
			$sXcName[$tRealNames.id]
			^if($hFields.$sXcName.group ne "~%NODATA%~"){
#===============================if it's a DATA field
				^if(^tDataCols.locate[field;$sDataField]){
					$sData[$tData.$sDataField]
					$sFieldGroup[$hFields.$sXcName.group]
					$sFormat[$hFields.$sXcName.format]
					$sStyle[$hFields.$sXcName.style]
					$sTemplate[$hFields.$sXcName.template]
#===============================format data
					$sFormatData[^formatData[$sDataField;$sData;$sFieldGroup;$sFormat;$tDataRow]]
#===============================then apply template
					$sProcessedData[^applyTemplate[$sFormatData;$sTemplate]]
					$sCurrentRow[^sCurrentRow.replace[%${sXcName}%;$sProcessedData]]
#					^tSubst.append[%${sXcName}%	$sProcessedData]
				}
			}{
#===============================means it's NODATA field
				$sTemplate[$hFields.$sXcName.template]
				$sProcessedData[^processNodata[$hParsed.table;$tDataRow;$sTemplate]]
# 				^tSubst.append[%${sDataField}%	$sProcessedData]
				$sCurrentRow[^sCurrentRow.replace[%${sDataField}%;$sProcessedData]]
			}
		}
#		$sCurrentRow[^sCurrentRow.replace[$tSubst]]

		$VIEW[${VIEW}${sCurrentRow}]
	}


	$hTableStyle[$hParsed.tableStyle]
	$sTableStyleString[$hParsed.tableStyleString]

	^if($sTableStyleString ne ""){
		$sTableStyleString[^sTableStyleString.replace[class="";class="xc_table_view_default"]]
	}{
		$sTableStyleString[class="xc_table_view_default"]
	}
# ^ret[$hParsed]

#	если было указано что нужен плавающий заголовок
	^if($isFloatingHeader){
		$sTableStyleString[^sTableStyleString.trim[right;"] xc_floating_this_header"]
	}

#=========== insert before table text
	^if(def $hParsed.text_before){
		<div $hParsed.text_before.style>
			^processNodata[;;$hParsed.text_before.template]
# 			^applyTemplate[fake_value;$hParsed.text_before.template]
		</div>
	}

	^if(def $xScroll && !$isExtShort){
		<center>^xScroll.print[]</center>
	}

	^if(!$hDont_set_tag.open){
		<table  $sTableStyleString >
	}

	<thead>${sTableHeader}$hParsed.header</thead>
	<tbody>$VIEW</tbody>

	^if(!$hDont_set_tag.close){
		</table>
	}

#=========== insert after table text
	^if(def $hParsed.text_after){
		<div $hParsed.text_after.style>
			^processNodata[;;$hParsed.text_after.template]

		</div>
	}

	^if(def $xScroll  && !$isExtShort){
		<center>^xScroll.print[]</center>
	}