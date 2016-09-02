#===================================================================================================FILE xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================GET FILETYPE & MIME
@get_tm[type][hType;hRet]
	$hType[
		$.images[
			$.regex[(\.jpg^$)|(\.jpeg^$)|(\.tiff^$)|(\.tif^$)|(\.png^$)]
			$.mime[image/*]
		]
		$.jpeg[
			$.regex[(\.jpg^$)|(\.jpeg^$)]
			$.mime[image/jpeg,image/pjpeg]
		]
		$.jpg[
			$.regex[(\.jpg^$)|(\.jpeg^$)]
			$.mime[image/jpeg,image/pjpeg]
		]
		$.tiff[
			$.regex[(\.tiff^$)|(\.tif^$)]
			$.mime[image/tiff,image/tif]
		]
		$.word[
			$.regex[(\.doc^$)|(\.docx^$)]
			$.mime[application/msword]
		]
		$.excel[
			$.regex[(\.xls^$)|(\.xlsx^$)]
			$.mime[application/vnd.ms-excel,application/x-excel,application/x-msexcel,application/excel]
		]
		$.csv[
			$.regex[\.csv^$]
			$.mime[]
			$.locale[Файлы с разделителями "^;"]
		]
		$.text[
			$.regex[\.txt^$]
			$.mime[text/plain]
			$.locale[Текстовые файлы]
		]
		$.archive[
			$.regex[(\.rar^$)|(\.zip^$)|(\.add^$)|(\.7z^$)]
			$.mime[application/x-rar-compressed,application/octet-stream,application/zip]
			$.locale[Архивы]
		]
		$.rar[
			$.regex[\.rar^$]
			$.mime[application/x-rar-compressed,application/octet-stream]
		]
		$.add[
			$.regex[\.add^$]
			$.mime[]
		]
		$.zip[
			$.regex[\.zip^$]
			$.mime[application/zip,application/octet-stream]
		]
		$.xml[
			$.regex[\.xml^$]
			$.mime[application/xml]
		]
		$.sig[
			$.regex[(\.sig^$)|(\.sgn^$)]
			$.mime[]
			$.locale[Файлы отсоединенных цифровых подписей]
		]
	]

	$hRet[
		$.regex[$hType.[$type].regex]
		$.mime[$hType.[$type].mime]
	]

	$result[$hRet]

#===================================================================================================PRINT FILES INFO
@printFileInfo[sFile_path;hData;isReadonly;fileId][tFiles;tSplit;sExt;sPath;f;sOrigName;iCounter;sFilePath;hFiles;i;fi;isSingle]

	$dataStorage[$hData.dataStorage]
#	<table ^if(!$isReadonly){class="uploaded_file_props_table"}>
	<table class="uploaded_file_props_table">

	$hFiles[^getFileParts[^sFile_path.trim[]]]
	$isSingle(^hFiles._count[] == 1)
	$iCounter(0)

	^hFiles.foreach[i;fi]{

		$sFilePath[${fi.path}.xcfile.${fi.ext}]
		^if(-f "${dataStorage}$sFilePath"){

			$f[^file::stat[${dataStorage}${fi.path}.xcfile.${fi.ext}]]
			<tr>
				<td>Загруженный файл:</td>

#				в конце ссылки "?@" ставится для отключения антикэша корп-портала
				<td><a href='${BP}${sFilePath}?filename=^taint[uri][$fi.origName]?@' target='_blank'>$fi.origName</a></td>

			</tr>
			<tr>
				<td>Размер:</td>
				<td>^printSizeof[$f.size]</td>
			</tr>
			<tr>
				<td>Дата загрузки:</td>
				<td>^f.mdate.sql-string[]</td>
			</tr>

		}{
			<tr>
				<td>Ошибка! Файл не найден:</td>
				<td>${sFilePath}</td>
			</tr>
		}

		^if((!def $hData.required && !$isReadonly) || (def $hData.required && !$isSingle)){
			<tr>
				^if(-f "${dataStorage}$sFilePath"){
					<td>Удалить файл</td>
				}{
					<td>Удалить упоминание о файле</td>
				}
				<td><input type="checkbox" class="xc__xfile_del_checkbox" data-file_input_id="${fileId}" data-file_del_id="${fileId}_del" value="${iCounter}" /></td>
			</tr>
		}

		^iCounter.inc[]
	}{<tr><td><hr></td><td><hr></td></tr>}
	</table>
#===================================================================================================CREATE FILE
@create_xfile[hData][hJquery_ui_style;sControl_sublabel;reStored_filename;sStored_filename;sOrig_filename;fFilename;f;sFile_path;sFilename;sAccept_ext;f;sMaxSize;iMaxSize]

	$hJquery_ui_style[
		$.xfile[ui-widget ui-widget-content ui-corner-all]
	]

	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_xfile[$hData]
	}{
		^switch[$hData.multy]{
			^case[true]{
				$hData.multy(0)
			}
			^case[false;1]{
				^hData.delete[multy]
			}
# 			^case[]{

# 			}
		}
		$iMaxSize(^eval($MAIN:LIMITS.post_max_size * (2/3)))
		$sMaxSize[^printSizeof[$iMaxSize]]
		$sFile_path[$hData.value]

		^if(def $hData.file_ext){
			$sAccept[Допустимые расширения: ]
			$sAccept[${sAccept} ${hData.file_ext},]
			$sAccept[^sAccept.trim[both;,]]
		}

		<td class="align_right">
			^printLabel_content[$hData]<br><small>$sAccept</small><br><small>^if(def $hData.multy){Суммарный размер файлов до $sMaxSize}{Размер файла до $sMaxSize}</small>
		</td>
		<td>
			<input
				type="file"
				data-type="xfile"
				data-max-post-size="$iMaxSize"
				id="$hData.id"
				name="$hData.name"
				^if(def $hData.classes ){
					class="xc__xfile $hJquery_ui_style.[$hData.group] $classes"
				}{
						class="xc__xfile $hJquery_ui_style.[$hData.group]"
				}
				$hData.properties
				$hData.allowMulty
				^if(def $hData.multy){
					multiple
					data-max_files="$hData.multy"
				}
				^if(!def $sFile_path){
					$hData.required
				}
				size="$group_input_size"
			/>
			<div class="file_info"></div>
			^if(def $sFile_path){
				^printFileInfo[$sFile_path;$hData;;$hData.id]
			}

			^if((!def $hData.required && !$isReadonly) || def $hData.multy){
				<input type="hidden" name="delFile" id="${hData.id}_del" ^if(def $hData.required){data-file_required="true"} value="">
			}
		</td>
	}

#===================================================================================================CREATE READONLY FILE
@readonly_xfile[hData][sControl_sublabel;isReadonly]
	$sFile_path[$hData.value]
#	<td class="align_right">^printLabel[$hData]</td>
	^printLabel[$hData]
	<td>
		$isReadonly(true)
		^printFileInfo[$sFile_path;$hData;$isReadonly]
	</td>

#===================================================================================================GET FIELDNAMES
@fieldnames_table_xfile[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]
	^tFieldnames.append{$name}

	$result[$tFieldnames]
#===================================================================================================GET FILE PARTS FROM DB ENTRY
@getFileParts[sFiles][tSplit;tPieces;hRet;hFile;i]

	$tPieces[^sFiles.split[^#0A]]
	$hRet[^hash::create[]]
	$i(0)

	^tPieces.menu{
		$tSplit[^tPieces.piece.split[|][lh]]

		$hFile[^hash::create[
			$.path[$tSplit.0]
			$.ext[$tSplit.1]
			$.origName[$tSplit.2]
		]]
		$hRet.$i[$hFile]
		^i.inc[]
	}

	$result[$hRet]
#===================================================================================================CREATE FILE DB STRING FROM HASH
@getFileDbString[hFile][s;k;v]

	^hFile.foreach[k;v]{
		$s[$s^#0A${v.path}|${v.ext}|${v.origName}]
	}
	$s[^s.trim[both;^#0A]]

	$result[$s]
#===================================================================================================DEL FILENAMES FROM DISK & INDEX
@UpdateFiles[sDbFiles;fieldname;dataStorage;mode][hFiles;hFileStats;tStoredUUID;sFilePath;sFileUUID;sArchivePath;sArchiveFile;tSplit;i;fi;sFile]

	$hFiles[^getFileParts[$sDbFiles]]

	^hFiles.foreach[i;fi]{
		$sFilePath[${dataStorage}${fi.path}]
		$sFile[${sFilePath}.xcfile.${fi.ext}]

		$sArchivePath[^sFilePath.replace[^dataStorage.trim[right;/];^dataStorage.trim[right;/]${sArchivePostfix}]]
		$sArchiveFile[${sArchivePath}.xcfile.${fi.ext}]

		^if(-f "${sFile}"){
			^switch[$mode]{
				^case[del]{
					^file:delete[${sFile}]
				}
				^case[mov]{
# 					if file not yet archived
					^if(!-f "${sArchiveFile}"){
					 	^file:move[${sFile};${sArchiveFile}]
					}{
# 						if already archived
						^file:delete[${sFile}]
					}
				}
#===============================TO DO! SMART COPY (what the fuck?)
				^case[cpy]{
					^file:copy[${sFile};${sArchiveFile}]
				}
			}
		}
	}
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_xfile[fieldname;value;filetype;ext;table;uuid;isDel;isArchive;dataStorage;isMultiple][bIgnoreDel;hFilesLeft;hFilesToDel;s;tParts;h;sDbFiles;fake;sExtension;sUploadedFiles;sFileSize;sFilePath;sFileName;tMatch;tNewIndex;tOldIndex;sStoredUUID;bOverwrite;bNosave;tUploaded_files;sModule_name;sErr_type;hRet;sErrMessage;sStore_path;tFdata;isErr;sIndex_file;tIndex;sNew_fname;sOrig_fname;i;f;sStored_filenames;isCorrect;hType;tFiletypes;re;now;sFoldername;tPieces;sYear;sMonth;sDay;isExt]
#========================================================================================^^^^^^^^^^ - for multiple files adding
#=================================================^^^^^^^^^^ - for file existence check on update.
#============================================================^^^^^ - if need to delete file. passed the 1-based number of file in table
#======================================================uuid - for the entry we update

	$sModule_name[XFILE]

	$now[^date::now[]]
	$sFoldername[^now.sql-string[date]]
	$tPieces[^sFoldername.split[-;lh]]

	$sYear[$tPieces.0]
	$sMonth[$tPieces.1]
	$sDay[$tPieces.2]

	$isExt(false)
	$re[]

	$sStored_filenames[]
	$isErr(false)
	$bNosave(false)
	$bOverwrite(false)
	$bAddFiles(false)
	$bIgnoreDel(false)

	$sErr_type[]
	$tUploaded_files[]
	$sUploadedFiles[]
	$sDbFiles[]

#=======means we are updating entry

	^if(def $table && def $uuid){
		^connect[$MAIN:CS]{
			$sDbFiles[
				^string:sql{
					SELECT `$fieldname`
						FROM `$table`
							WHERE `uuid`="$uuid"
				}[$.default{}]
			]
		}
		$sDbFiles[^sDbFiles.trim[]]
# 		^tUploaded_files.menu{
# 			$sUploadedFiles[${sUploadedFiles}^#0A$[$tUploaded_files.$fieldname]]
# 		}
	}

#=======means file already uploaded
	^if(!def $value && def $sDbFiles){
		$bNosave(true)
	}
#^ret[$isDel]
	^if(def $value && def $sDbFiles && !^isMultiple.bool(false)){
		$bOverwrite(true)
	}

	^if(def $value && def $isDel){
		$bIgnoreDel(true)
	}

	$hRet[
		$.value[]
#		$.error[^hash::create[]]
	]

#===========================================================if new file uploaded or update neded
	^if(($value && !$bNosave && $isDel eq "") || (($value && !$bNosave && $bIgnoreDel)) ){

#============= - custom groups
		$tFiletypes[^filetype.split[,]]
#============= - ext - exact extensions without "*."
		$tExt[^ext.split[,]]

#===============if mask specified
		^if($tFiletypes || $tExt){
			^tFiletypes.menu{
				$hType[^get_tm[^tFiletypes.piece.trim[]]]
				^if($hType){
					$re[${re}|${hType.regex}]
				}{
					^throw[file.wrong_type;^tFiletypes.piece.trim[];file.p -> "^tFiletypes.piece.trim[]" неизвестный тип файла. ^#0A Проверьте правильность выбора пользовательского типа загружаемого файла.]
				}
			}
			^tExt.menu{
				$re[${re}|(\.^tExt.piece.trim[]^$)]
			}

			$re[^re.trim[both;|]]
		}
#===============================================================================check files & store
		^value.foreach[i;f]{
			^if(def $re){
				^if(!^f.name.match[$re][iU]){
					$sErr_type[TYPE_MISMATCH]
					$isErr(true)
					^break[]
				}
			}

			$sOrig_fname[${f.name}]

			$sExtension[]
			$fake[^f.name.match[\.([a-zA-Z]+)^$][]{
				$sExtension[$match.1]
			}]

			$sNew_fname[^math:uuid[]]

			$sStore_path[/${fieldname}/${sYear}/${sMonth}/${sDay}]
			$sStored_filenames[${sStored_filenames}^#0A^sStore_path.trim[left;/]/${sNew_fname}|${sExtension}|$f.name]

			$sPath[${dataStorage}${fieldname}/${sYear}/${sMonth}/${sDay}/${sNew_fname}.xcfile.${sExtension}]

			^f.save[binary;$sPath]
		}
# ============== here we have fully formed $sStored_filenames string to put into the database
		$sStored_filenames[^sStored_filenames.trim[]]
		^if(!$isErr){
#=======================if overwrite file
			^if($bOverwrite && !$bIgnoreDel){
				^if($isArchive){
# 					if archivation is neded - move old file to archive
					^UpdateFiles[$sDbFiles;$fieldname;$dataStorage;mov]
				}{
# 					if no need to archive
					^UpdateFiles[$sDbFiles;$fieldname;$dataStorage;del]
				}

			}{
# 				means we are appending files
				$sStored_filenames[$sDbFiles^#0A$sStored_filenames]
			}

			$hRet[
				$.value[$sStored_filenames]
			]
		}{
			$hRet.error[^hash::create[]]
			$hRet[
				$.value[^sStored_filenames.trim[both;^#0A]]
				$.error[
					$.err_fieldname[$fieldname]
					$.message[FILE VALUE TYPE OR EXTENSION MISMATCH]
					$.err_module[${sModule_name}.${sErr_type}]
				]
			]
		}
	}

#===================================if form is updated without updating the file
	^if($bNosave && $isDel eq ""){
		^if($isArchive){
			^UpdateFiles[$sDbFiles;$fieldname;$dataStorage;cpy]
		}

		$hRet[
			$.value[$sDbFiles]
		]
	}
#=========================================================if need to delete file
#  is del - 0-based integer string indexes to del
	^if($isDel ne "" && !$value){

		$hFilesLeft[^getFileParts[$sDbFiles]]
		$hFilesToDel[^hash::create[$hFilesLeft]]
		$tParts[^isDel.split[,;l]]

		^tParts.menu{
			^hFilesLeft.delete[$tParts.piece]
		}

		^hFilesToDel.sub[$hFilesLeft]

		$sDbFiles[^getFileDbString[$hFilesToDel]]

		$hRet[
			$.value[^getFileDbString[$hFilesLeft]]
		]


		^if($isArchive){
# 			if need to archive
			^UpdateFiles[$sDbFiles;$fieldname;$dataStorage;mov]
		}{
# 			if no need to archive
			^UpdateFiles[$sDbFiles;$fieldname;$dataStorage;del]
		}
	}

	$result[$hRet]

#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_xfile[init;hParsed_xml]

#^cmCreate[append;file_history_anton_debug_del;edit_existing_file]

	$value[$init.[$hParsed_xml.name]]
	$result[$value]

#===================================================================================================MOVE FILE TO ARCHIVE FOLDER
@archive_xfile[fieldname;table;uuid]

#^cmCreate[append;file_history_anton_debug_del;archive_old_files]

	^connect[$MAIN:CS]{
		$tUploaded_files[
			^table::sql{
				SELECT `$fieldname`
					FROM `$table`
						WHERE `uuid`="$uuid"
			}
		]
	}
#===================================================================================================GET POSSIBLE ERROR LIST
@ErrorList_xfile[invoke][hErrList]
	$hErrList[^hash::create[]]

	$hErrList[
		$.TYPE_MISMATCH[Неверный тип данных загружаемого файла]
	]

	^if(def $invoke && ^hErrList.contains[$invoke]){
		$result[$hErrList.$invoke]
	}{
		$result[$hErrList]
	}

	$result[$hErrList]
#===================================================================================================GET FIELD INFO
@getFileParts_and_Stats[sEntry][hFiles;sTestPath;fi;i;f]

	$hFiles[^getFileParts[^sEntry.trim[]]]

	^hFiles.foreach[i;f]{

		$hFiles.$i.path_src[$hFiles.$i.path]

		^hDataStorages.foreach[di;ds]{
			$sTestPath[${ds}${f.path}.xcfile.${f.ext}]
			^if(-f "${sTestPath}"){
				$hFiles.$i.path[$sTestPath]
				$fi[^file::stat[$sTestPath]]
				$hFiles.$i.filesize[^printSizeof[$fi.size]]
				$hFiles.$i.dt_upload[^fi.mdate.sql-string[]]
			}
		}
	}
$result[$hFiles]

@get_info_xfile[table;uuid;fieldname][sOrig_filename;reStored_filename;f;sFilename;fFilename;sEntry;tTableStatus;hFiles;i;fi;di;ds;sTestPath]
	$sEntry[]
	$hRet[^hash::create[]]
	^connect[$MAIN:CS]{
		$sEntry[
			^string:sql{
				SELECT `$fieldname`
					FROM `$table`
						WHERE `uuid`="$uuid"
			}[$.default{}]
		]
	}

	^if(def $sEntry){

#		$hFiles[^getFileParts[^sEntry.trim[]]]
#
#		^hFiles.foreach[i;f]{
#			^hDataStorages.foreach[di;ds]{
#				$sTestPath[${ds}${f.path}.xcfile.${f.ext}]
#				^if(-f "${sTestPath}"){
#					$hFiles.$i.path[$sTestPath]
#					$fi[^file::stat[$sTestPath]]
#					$hFiles.$i.filesize[^printSizeof[$fi.size]]
#					$hFiles.$i.dt_upload[^fi.mdate.sql-string[]]
#				}
#			}
#		}
		$hFiles[^getFileParts_and_Stats[$sEntry]]

		$hRet[
			$.files[$hFiles]
			$._label[
				$.path[Путь до файла]
				$.ext[Расширение]
				$.origName[Оригинальное имя]
				$.filesize[Размер]
				$.dt_upload[Дата загрузки]
			]
		]
	}

	$result[$hRet]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_xfile[fieldName;tDataRow][hRet]
	$hRet[^hash::create[^getFileParts_and_Stats[$tDataRow.[$fieldName]]]]
#	$hRet[$._value[$tDataRow.$fieldName]]


	$result[$hRet]

#===================================================================================================GET RAW DATA FOR VIEW
@xfile_info[rawData][sFilename;sFilePath;fFilename;f;sFilenameFile]
	$hRet[^hash::create[
		$.filename[]
		$.filesize[]
		$.dt_upload[]
		$.filepath[]
		$.content_type[]
	]]

	$sFilenameFile[${sBinaryPath}${rawData}.filename]
	$sFilePath[${sBinaryPath}${rawData}.file]

	^if(-f $sFilenameFile && -f $sFilePath){


		$fFilename[^file::load[text;$sFilenameFile]]
		$sFilename[$fFilename.text]

		$f[^file::load[binary;$sFilePath]]

		$hRet[
			$.filename[$sFilename]
			$.size[^printSizeof[$f.size]]
			$.dt_upload[^f.cdate.sql-string[]]
			$.filepath[${sBinaryPath}${rawData}.file]
			$.content_type[$f.content-type]
			$._label[
				$.filename[Загруженный файл]
				$.size[Размер]
				$.dt_upload[Дата загрузки]
			]
			$.exists(true)
		]
	}
	$result[$hRet]