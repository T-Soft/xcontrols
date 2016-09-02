#utf-8 / абв
#=======================================================================================================================xCONTROLS DATABASE UNIT

@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================CHECK DATABASE UPDATE
@check_db[hAdd][sXQuery;fXml;sXml;cntAdd;bNo_archive;tArchive_db_fields;hReturn;tControl_fields_total;nlControl_groups;nlControl_names;sValue;sName;tControl_fields;sValues;sFields;sValue;sNew_db_fields;sDb_fields;sLog;bNo_table;fXML;sXML_dt_last_edit;sFlag_dt_last_edit;fFlag;bFlag;sContructor_xml_path;nlDb_info;sTable_name;nlFields;tDb_name_re;sDb_name;tTable_status;sTable_dt_last_edit]
	$sConstructor_xml_path[${sXml_folder_path}${sProject_nick}/]

	$fXml[^file::load[text;${sConstructor_xml_path}${sConstructor_xml_name}]]
	$sXml[^preprocess[$fXml]]

	$xdConstructor[^xdoc::create{^taint[as-is][$sXml]}]

	$sXML_dt_last_edit[$fXml.mdate]

	$bNo_table(false)
	$bNo_archive(true)
#=====================================================================CHECK IF THE TABLE IS OBSOLETE
#==========================================================================flag file existence check
	^if(-f "${sConstructor_xml_path}$sFlag_filename"){
		$bFlag(true)
	}{
		$bFlag(false)
	}
#=========================================================================get DB info from XML & $CS
	$nlDb_info[^xdConstructor.select[.//form/database]]
	$sTable_name[^nlDb_info.0.selectString[string(child::table_name)]]
	$tDb_name_re[^MAIN:CS.match[[0-9a-zA-Z]\/(.+)\?]]
	$sDb_name[$tDb_name_re.1]
#========================================get flag creation date and compare it to table_dt_last_edit
	^if($bFlag){
		$fFlag[^file::load[text;${sConstructor_xml_path}${sFlag_filename}]]
		$sFlag_dt_last_edit[$fFlag.mdate]
	}{
		$sFlag_dt_last_edit[]
		$fFlag[^file::create[${sConstructor_xml_path}${sFlag_filename}]]
	}

	^connect[$MAIN:CS]{
		$tTable_status[^table::sql{
						SHOW TABLE STATUS
							FROM
								`$sDb_name`
		}]

		^if(^tTable_status.locate[Name;$sTable_name]){
			$sTable_dt_last_edit[$tTable_status.Update_time]
		}{
#===============means there is no table
			$bNo_table(true)
		}
	}
#==========get control nodes and their names from XML (nodes with HR or PLAIN TEXT or BUTTONS are not selected)
	$sXQuery[]
	^tValueless_groups.menu{
		$sXQuery[${sXQuery}not(text()='$tValueless_groups.group') and ]
	}

	$sXQuery[^sXQuery.trim[right; and]]

# 	$nlControl_groups[^xdConstructor.select[.//form/control/control_group[not(text()='hr') and (not(text()='text')) and not(text()='button') and not(text()='button_close') and not(text()='button_clear') and not(text()='submit')]]]
	$nlControl_groups[^xdConstructor.select[.//form/control/control_group[$sXQuery]]]
# 	$nlControl_names[^xdConstructor.select[.//form/control/control_name[preceding-sibling::control_group[not(text()='hr') and (not(text()='text')) and not(text()='button') and not(text()='button_close') and not(text()='button_clear') and not(text()='submit')] | following-sibling::control_group[not(text()='hr') and (not(text()='text')) and not(text()='button') and not(text()='button_close') and not(text()='button_clear') and not(text()='submit')]]]]
	$nlControl_names[^xdConstructor.select[.//form/control/control_name[preceding-sibling::control_group[$sXQuery] | following-sibling::control_group[$sXQuery]]]]

#	$nlControl_names[^xdConstructor.select[.//form/control/control_name]]
	$tControl_fields_total[^table::create{field}]
#================================================get total form fieldnames table
	^nlControl_groups.foreach[id;value]{
		$sValue[^value.selectString[string(text())]]
		^try{
			^use[xcontrols_modules/${sValue}.p]
		}{
			$exception.handled(true)
			^use[${sUser_xcontrols_files}controls_p/${sValue}.p]
		}

		$sName[^nlControl_names.[$id].selectString[string(text())]]
		$tControl_fields[^xcontrols:fieldnames_table_$sValue[$sName]]
		^tControl_fields.menu{
			^tControl_fields_total.append[$tControl_fields.fieldname]
		}
	}
#=========================add hidden additional fields to total fieldnames table
	$cntAdd(0)
	$tDb_fields[^table::create{Field}]
	^if(!$bNo_table){
		^connect[$MAIN:CS]{
			$tDb_fields[^table::sql{
						SHOW COLUMNS FROM `$sTable_name`
			}]
		}
	}
	^if($hAdd is hash){
		^hAdd.foreach[id;value]{
			^if(!(^tDb_fields.locate[Field;$id])){
				^cntAdd.inc[]
			}
			^tControl_fields_total.append[$id]
		}
	}
	^if($bNo_table){
#=========================================get field names from XML nodes
		$sDb_fields[	 `id`		INT		NOT NULL AUTO_INCREMENT PRIMARY KEY
				,`timestamp`	TIMESTAMP	ON UPDATE CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
				,`dt_create`	DATETIME	NOT NULL
				,`dt_update`	DATETIME
#				,`dt_update`	TIMESTAMP on update CURRENT_TIMESTAMP NOT NULL
				,`uuid`		VARCHAR(36)	NOT NULL, UNIQUE (`uuid`)
		]
		^tControl_fields_total.menu{
			$sDb_fields[$sDb_fields,`$tControl_fields_total.field` VARCHAR(255) DEFAULT NULL ]
		}
#==========================================================================create table and log file
		^connect[$MAIN:CS]{
			^void:sql{
				CREATE TABLE IF NOT EXISTS `$sTable_name` (
					$sDb_fields
				)ENGINE = MyISAM CHARACTER SET $hTableCharset.charset COLLATE $hTableCharset.collate
			}
		}
		$sLog[
			^now.sql-string[] - new table '$sTable_name' created]
		^sLog.save[append;${sConstructro_xml_path}$sFlag_filename]
		$bNo_table(false)
	}
#=============if table exists but XML is newer then a flag or flag is missing - update its structure
	^if((($sXML_dt_last_edit > $sFlag_dt_last_edit) && !$bNo_table) || !$bFlag || $cntAdd > 0){
#=====================================================================================detect changes
		^connect[$MAIN:CS]{
			$tDb_fields[^table::sql{
				SHOW COLUMNS FROM `$sTable_name`
			}]
			^try{
				$tArchive_db_fields[^table::sql{
					SHOW COLUMNS FROM `${sTable_name}${sArchive_db_postfix}`
				}]
			}{
				$exception.handled(true)
				$bNo_archive(false)
			}
		}

		$sNew_db_fields[]

		^tControl_fields_total.menu{
			^if(^tDb_fields.locate[Field;$tControl_fields_total.field]){
				^continue[]
			}{
				$sNew_db_fields[$sNew_db_fields, `$tControl_fields_total.field` VARCHAR(255) DEFAULT NULL ]
			}
		}

		$sNew_db_fields[^sNew_db_fields.trim[left;,]]
#===============================================================================if there are changes
		^if(def $sNew_db_fields){
			^connect[$MAIN:CS]{
				^void:sql{
					ALTER IGNORE TABLE `$sTable_name` ADD (
						$sNew_db_fields
					)
				}
#===============================if there is an archive table -> update it
				^if(!def $bNo_archive){
					^void:sql{
						ALTER IGNORE TABLE `${sTable_name}${sArchive_db_postfix}` ADD (
							$sNew_db_fields
						)
					}
				}
			}
			$sLog[
				^now.sql-string[] - Table '$sTable_name' structure altered.]
		}{
			$sLog[
				^now.sql-string[] - Table '$sTable_name' stucture intact.]
		}
		^sLog.save[append;${sConstructor_xml_path}$sFlag_filename]
	}
	$hReturn[
		$.table_name[$sTable_name]
	]
	$result[$hReturn]

#=============================================================================================CREATE SQL QUERY ARGUMENTS
@check_and_create_query[mode;hFields;hFiles;sTablename;isArchive][sControlDataStorage;sLog;sdbUUID;sEntryUUID;hProcessed;iErr;hRet;tControls;sFields;sValues;isUpdate;isDelFile]
#==========================================^^^^^^^^^^^ - for file archivation

	$isDelFile[]
	^if($hFields.delFile){
		$isDelFile[$hFields.delFile.field]
	}

	$hRet[
		$.query[
			$.fields[]
			$.values[]
			$.uuid[]
		]
		$.err[
			$.cnt_err(0)
			$.hErr[^hash::create[]]
		]
	]

	^if(^hFields.contains[$sJavascriptErrorField]){
		^if($hFields.$sJavascriptErrorField.field eq "1"){
#=======================================log this
$sLog[
server	$env:SERVER_NAME

uri	$request:uri

ip	$env:REMOTE_ADDR

prdm.login	$cookie:[prdm.login]

id_user		$xAuth.user.id

id_org		$xAuth.user.id_org

code_region	$xAuth.org.code_region
]
^exLog[js;$sLog]
#=======================================log this


			^hRet.err.cnt_err.inc[]
			$hRet.err.hErr.[$hRet.err.cnt_err][
				$.err_fieldname[xcvar__javascript_error]
				$.message[JAVASCRIPT ERROR]
				$.err_module[MAIN.JAVASCRIPT_ERROR]
			]
		}{
			^hFields.delete[$sJavascriptErrorField]
		}
	}

	$isUpdate(false)

	$sFields[]
	$sValues[]
	$sdbUUID[]
	^connect[$MAIN:CS]{
		$sdbUUID[^string:sql{SELECT UUID()}]
	}
	^if(def $sdbUUID){
		$sEntryUUID[$sdbUUID]
	}{
		$sEntryUUID[^math:uuid[]]
	}

	$tControls[^parse_XML[$sProject_nick]]
	^switch[$mode]{
		^case[store]{
			$sFields[`dt_create`,`uuid`]
			$sValues['^now.sql-string[]','$sEntryUUID']
			$hFields.uuid[^table::create{field}]
			^hFields.uuid.append[$sEntryUUID]
		}
		^case[update]{
			$isUpdate(true)
			$sFields[`dt_update`,`uuid`,`id`]
			$sValues[`dt_update`='^now.sql-string[]']
		}
	}

	$tControls[^parse_XML[$sProject_nick]]

	^tControls.menu{
		$sControl_group[$tControls.group]
		$sControlDataStorage[$tControls.data_storage]
		^if(^tValueless_groups.locate[group;$sControl_group]){
			^continue[]
		}
		^if($mode eq "update" && $tControls.readonly ne ""){
			^continue[]
		}

		^use[xcontrols_modules/${sControl_group}.p]

		$tFieldnames[^xcontrols:fieldnames_table_$sControl_group[$tControls.name]]
		^if(^tFieldnames.count[] > 1){
			^tFieldnames.menu{
				$sFields[$sFields,`${tFieldnames.fieldname}`]
				^if($sControl_group eq "file" || $sControl_group eq "xfile"){
					$hProcessed[^xcontrols:db_preprocess_$sControl_group[${tFieldnames.fieldname};$hFiles.[${tFieldnames.fieldname}];$tControls.file_type;$tControls.file_ext;$sTablename;$hFields.uuid.field;$isDelFile;$isArchive;$sControlDataStorage;$tControls.multy]]
				}{
					$hProcessed[^xcontrols:db_preprocess_$sControl_group[$hFields.[${tFieldnames.fieldname}].field]]
				}

				$sProcessed_value[$hProcessed.value]
#=======================================================================================================================TODO ADD ERROR HANDLER
#===============================if error of any type
				^if($hProcessed.error is hash){
						^hRet.err.cnt_err.inc[]
						$hRet.err.hErr.[$hRet.err.cnt_err][^error_to_hash[$hProcessed.error]]
				}

				^if($sProcessed_value eq 'NULL'){
					$gl_sProcessed_value_null[$sProcessed_value]
				}{
					$gl_sProcessed_value_null['$sProcessed_value']
				}

				^if($isUpdate){
					$sValues[$sValues,`$tFieldnames.fieldname`=$gl_sProcessed_value_null]
				}{
					$sValues[$sValues,$gl_sProcessed_value_null]
				}

			}
		}{
			$sFields[$sFields,`$tControls.name`]
			^if($sControl_group eq "file" || $sControl_group eq "xfile"){
				$hProcessed[^xcontrols:db_preprocess_$sControl_group[$tControls.name;$hFiles.[$tControls.name];$tControls.file_type;$tControls.file_ext;$sTablename;$hFields.uuid.field;$isDelFile;$isArchive;$sControlDataStorage;$tControls.multy]]
#^ret[$hProcessed]
			}{
				$hProcessed[^xcontrols:db_preprocess_$sControl_group[$hFields.[$tControls.name].field]]
			}

			$sProcessed_value[$hProcessed.value]
#=======================if error of any type
			^if($hProcessed.error is hash){
				^hRet.err.cnt_err.inc[]
				$hRet.err.hErr.[$hRet.err.cnt_err][^error_to_hash[$hProcessed.error]]
			}

			^if($sProcessed_value eq 'NULL'){
				$gl_sProcessed_value_null[$sProcessed_value]
			}{
				$gl_sProcessed_value_null['$sProcessed_value']
			}
			^if($isUpdate){
				$sValues[$sValues,`$tFieldnames.fieldname`=$gl_sProcessed_value_null]
			}{
				$sValues[$sValues,$gl_sProcessed_value_null]
			}
		}
	}

	^if($hRet.err.cnt_err == 0){
		$hRet.query.fields[$sFields]
		$hRet.query.values[$sValues]
		$hRet.query.uuid[$sEntryUUID]
	}{
		$hRet.err.failed_id[^math:uuid[]]
		^serialize[$hFields;$hFiles;$hRet.err;$sTablename]
#======================================================^^^^^^^^^^^ - for file init
		^if($bErr_redirect){
			$response:refresh[
				$.value(0)
				$.url[${sShow_form_document}?failed_id=$hRet.err.failed_id^if(def $form:uuid){&uuid=${form:uuid}}]
			]
		}
	}

	$result[$hRet]
#===================================================================================================STORE DATA TO DB
@store_data[hAdditional][tField;url;sUuid;sInsertQuery;sLogEntry;iLastInsert;hQuery;tLast_insert;hProcessed;hRet;tFieldnames;sControl_group;sProcessed_value;hCheck_db;sFields;sValues;id;value;sTable_name;tControls;hFiles]
#^ret[$form:fields]
	$sTable_name[]

	$hFields[$form:tables]
	$hFiles[$form:files]

#=======place where fields frim hAdditional replace existing in case of match
	^hAdditional.foreach[id;value]{
		^if(^hFields.contains[$id]){
			$tField[^table::create{field}]
			^tField.append{$value}
			$hFields.$id[$tField]
		}
	}
#=======return hash
	$hRet[^hash::create[]]

#=========================================================if form fields present
	^if($hFields is hash || $hFiles is hash){
#====================================================================check db for structural changes
		$hCheck_db[^check_db[$hAdditional]]
		$sTable_name[$hCheck_db.table_name]
#===============create query parts
		$hQuery[^check_and_create_query[store;$hFields;$hFiles;$sTable_name]]
	}{
		^ErrorListMain[CRASH_UNKNOWN_FORM_CONTENTS]
	}
	$sFields[$hQuery.query.fields]
	$sValues[$hQuery.query.values]
	$sUuid[$hQuery.query.uuid]

	$hRet[$hQuery.err]

#=======if no errors during storage
	^if($hRet.cnt_err == 0){
#================================================if additional db fields present
		^if($hAdditional is hash){
			^hAdditional.foreach[id;value]{
				^if(^sFields.pos[$id] != -1){
					^continue[]
				}{
					$sFields[$sFields,`$id`]
					$sValues[$sValues,'$value']
				}
			}
		}

		$sFields[^sFields.trim[left;,]]
		$sValues[^sValues.trim[left;,]]
#=====================================================================================store the data
		^try{
			^connect[$MAIN:CS]{
				$sInsertQuery[INSERT INTO `$sTable_name` ($sFields) VALUES ($sValues)]

				^void:sql{
					$sInsertQuery
				}
##==============================================================================POSSIBLE ERROR LOCATION
				$iLastInsert(
					^int:sql{
						SELECT LAST_INSERT_ID()
					}
				)
				$tLast_insert[^table::sql{
					SELECT	`uuid`
						FROM `$sTable_name`
					WHERE
						`id` = $iLastInsert
				}]
				$hRet.id($iLastInsert)
				$hRet.uuid[$tLast_insert.uuid]
			}
		}{
#=======================added for further debug
			$sLogEntry[
				^now.sql-string[]. ERROR in SQL query. Query:
				$sInsertQuery
			]
			^sLogEntry.save[append;$xcLogPath]
		}
	}

	$result[$hRet]

	^if($hRet.cnt_err == 0 && $bErr_redirect){
		$url[$sFormTarget]
		^if(^sFormTarget.pos[?] != -1){
			$url[${url}&uuid=$sUuid]
		}{
			$url[${url}?uuid=$sUuid]
		}

		$response:refresh[
			$.value(0)
#			$.url[${sFormTarget}?uuid=$sUuid]
			$.url[$url]
		]
	}


@__get_str_FIELDNAME_FIELDTYPE_DEFAULT_NULL[fieldname;type][res]

$res[]

	^switch[^type.match[\(.*\)^$][]{}]{
		^case[timestamp]{
			$res[`$fieldname` DATETIME DEFAULT NULL]
		}
		^case[enum]{
			$res[`$fieldname` VARCHAR(255) DEFAULT NULL]
		}
		^case[set]{
			$res[`$fieldname` VARCHAR(1024) DEFAULT NULL]
		}
		^case[DEFAULT]{
			^switch[$fieldname]{

				^case[dt_create;dt_update]{
					$res[`$fieldname` DATETIME DEFAULT NULL]
				}
				^case[DEFAULT]{
					$res[`$fieldname` $type DEFAULT NULL]
				}

			}
		}
	}

$result[$res]

#===================================================================================================UPDATE ENTRY FUNCTION
@update_entry[hAdditional;hParam][url;sLogEntry;sArchiveQuery;sUpdateQuery;sAdditional;tAdditional;tSplit;iEntryCount;hQuery;tablename;uuid;hRet;hProcessed;tFieldnames;hFields;hCheck_db;sNew_fieldname;sNew_field_type;sAdd_fields;bNo_table;tArchive_fields;sArch_fields;bArchive;tControls;sControl_group;sProcessed_value;sUpdate_query;id;value;sCreate_db_fields;tDb_fields]
#=======pass $hParam.archive(true) option to make an archive

	$bArchive(false)
	$bNo_table(false)

	^if(def $hParam.is_archive){
		$bArchive(true)
	}

	$hFields[$form:tables]
	$hFiles[$form:files]

	$hCheck_db[^check_db[$hAdditional]]

	$tablename[$hCheck_db.table_name]

#========================================================================SESSION CHECK HERE

#=======got from hidden fields
	$uuid[$form:uuid]
#=======return hash
	$hRet[^hash::create[]]

#=======check if such entry exists
	^connect[$MAIN:CS]{
		$iEntryCount(^int:sql{
			SELECT COUNT(*)
			FROM
				`$tablename`
			WHERE
				`uuid` = '$uuid'
		})

		^if($iEntryCount < 1){
			^ErrorList_main[CRASH_UPDATE_ENTRY]
		}
	}
#=======create query parts
	$hQuery[^check_and_create_query[update;$hFields;$hFiles;$tablename;$bArchive]]
#^ret[$hQuery]
	$hRet[$hQuery.err]

	$sArch_fields[$hQuery.query.fields]
	$sUpdate_query[$hQuery.query.values]

#=======if no errors during query formation

	^if($hRet.cnt_err == 0){
		^if($hAdditional is hash){
			^hAdditional.foreach[id;value]{
				^if($id eq 'is_archive'){
					^continue[]
				}
#=======place where fields frim hAdditional replace existing in case of match
				^if(^sUpdate_query.pos[`$id`] != -1){
					$sUpdate_query[^sUpdate_query.match[`$id`='(.*)'][U]{`$id`='$value'}]
				}{
					$sUpdate_query[$sUpdate_query,`$id`='$value']
					$sArch_fields[$sArch_fields,`$id`]
				}

			}
		}

		$sUpdate_query[^sUpdate_query.trim[left;,]]
		$sArch_fields[^sArch_fields.trim[left;,]]
		$sArch_fields[$sArch_fields,`dt_create`]

		^try{
			^connect[$MAIN:CS]{
#===============================if archive option is set
				^if($bArchive){

					$tDb_fields[^table::sql{
						SHOW COLUMNS FROM `$tablename`
					}]
#=======================================check if archive table exists
					^try{
						$tArchive_fields[^table::sql{
							SHOW COLUMNS FROM `${tablename}${sArchive_db_postfix}`
						}]
					}{
#===============================================if not - create it
						$exception.handled(true)

						$sCreate_db_fields[`_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
							`_dt_create` DATETIME NOT NULL,
							`_timestamp` TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
						]

						^tDb_fields.menu{
							$sCreate_db_fields[$sCreate_db_fields,^__get_str_FIELDNAME_FIELDTYPE_DEFAULT_NULL[$tDb_fields.Field;$tDb_fields.Type]]

#							^if($tDb_fields.Field eq 'dt_update'){
#								$sNew_field_type[datetime]
#								$sCreate_db_fields[$sCreate_db_fields,`${tDb_fields.Field}` $sNew_field_type DEFAULT NULL]
#							}{
#								^if($tDb_fields.Field eq 'timestamp'){
#									$sCreate_db_fields[$sCreate_db_fields,`${tDb_fields.Field}` ${tDb_fields.Type}]
#								}{
#									$sCreate_db_fields[$sCreate_db_fields,`${tDb_fields.Field}` ${tDb_fields.Type} DEFAULT NULL]
#								}
#							}

						}

						^void:sql{
							CREATE TABLE IF NOT EXISTS `${tablename}${sArchive_db_postfix}` (
								$sCreate_db_fields
							)ENGINE = MyISAM CHARACTER SET $hTableCharset.charset COLLATE $hTableCharset.collate
						}

					}
#=======================================if table existed -> check if it's up to date
					^if(def $tArchive_fields){
						$sAdd_fields[]
						^tDb_fields.menu{
							^if(^tArchive_fields.locate[Field;$tDb_fields.Field]){
								^continue[]
							}{
#								$sAdd_fields[$sAdd_fields `${tDb_fields.Field}` ${tDb_fields.Type},]
								$sAdd_fields[$sAdd_fields ^__get_str_FIELDNAME_FIELDTYPE_DEFAULT_NULL[$tDb_fields.Field;$tDb_fields.Type],]

							}
						}
						$sAdd_fields[^sAdd_fields.trim[right;,]]
					}
					^if(def $sAdd_fields){
						^void:sql{
							ALTER TABLE `${tablename}${sArchive_db_postfix}` ADD (
								$sAdd_fields
							)
						}
					}
#=======================================add non-form fields to SELECT
					$tSplit[^sArch_fields.split[,]]
					$sAdditional[]

					^tDb_fields.menu{
						^if(! ^tSplit.locate[piece;`${tDb_fields.Field}`]){
							$sAdditional[${sAdditional},`${tDb_fields.Field}`]
						}
					}
					$sAdditional[^sAdditional.trim[both;,]]

#=======================================archive entry
					$sArchiveQuery[INSERT INTO `${tablename}${sArchive_db_postfix}`
							($sArch_fields,$sAdditional,`_dt_create`)
						SELECT
							$sArch_fields ,$sAdditional ,'^now.sql-string[]' AS `_dt_create`
						FROM
							`$tablename`
						WHERE
							`uuid` = '$uuid']
					^void:sql{
						$sArchiveQuery
					}
				}
#===============================update main table entry
				$sUpdateQuery[UPDATE `$tablename`
						SET
							$sUpdate_query
						WHERE `uuid` = '$uuid']
				^void:sql{$sUpdateQuery}

				$hRet.id(^int:sql{SELECT `id` FROM `$tablename` WHERE `uuid`='$uuid' })
				$hRet.uuid[$uuid]
			}
		}{
			$sLogEntry[
				^now.sql-string[]. ERROR in SQL query for entry : '$uuid'. Query:
				$sArchiveQuery
				$sUpdateQuery
			]
			^sLogEntry.save[append;$xcLogPath]
#			$exception.handled(true)
		}
	}

	$result[$hRet]
	^if($hRet.cnt_err == 0 && $bErr_redirect){
		$url[$sFormTarget]
		^if(^sFormTarget.pos[?] != -1){
			$url[${url}&uuid=$uuid]
		}{
			$url[${url}?uuid=$uuid]
		}

		$response:refresh[
	  		$.value(0)
#	  		$.url[$sFormTarget]
	  		$.url[$url]
		]
	}
