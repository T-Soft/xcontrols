#===================================================================================================FILE xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================CREATE FILE
@xcreate_file[hData][sControl_sublabel;reStored_filename;sStored_filename;sOrig_filename;fFilename;f;sFile_path;sFilename;sAccept_ext;f;sMaxSize;iMaxSize]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_file[$hData]
	}{
		$iMaxSize(^eval($MAIN:LIMITS.post_max_size * (2/3)))
		$sMaxSize[^printSizeof[$iMaxSize]]
	
		$sFile_path[$hData.value]
	
		^if(def $hData.file_ext){
			$sAccept[Допустимые расширения: ]
			$sAccept[${sAccept} ${hData.file_ext},]
			$sAccept[^sAccept.trim[both;,]]
		}
		
		$sControl_sublabel[$hData.sublabel]
		^if($sControl_sublabel ne "" || def $sControl_sublabel){
			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
		}
#===============means file already uploaded
	
		<td class="align_right">^printLabel_content[$hData]<br><small>$sAccept</small><br><small>Размер файла до $sMaxSize</small></td><td><input type="file" data-type="file" data-max-post-size="$iMaxSize" id="$hData.id" name="$hData.name" ^if(def $hData.classes ){class="xc__file $hJquery_ui_style.[$hData.group] $classes"}{class="xc__file $hJquery_ui_style.[$hData.group]"} $hData.properties ^if(!def $sFile_path){$hData.required}  size="$group_input_size" /><div class="file_info"></div>
			^if(def $sFile_path){
#^cmCreate[append;file_history_anton_debug_del;edit_existing_files]
	
				^if(-f "${sBinary_path}${sFile_path}.filename"){
					$fFilename[^file::load[text;${sBinary_path}${sFile_path}.filename]]
					$sFilename[$fFilename.text]
					$f[^file::load[binary;${sBinary_path}${sFile_path}.file]]
					$reStored_filename[^sFile_path.match[([0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12})^$][i]]
					$sOrig_filename[^sFile_path.match[([0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12})^$][i][$sFilename]]
					<table class="uploaded_file_props_table">
						<tr>
							<td>Загруженный файл:</td>
							<td>${sFilename}</td>
						</tr>
						<tr>
							<td>Размер:</td>
							<td>^printSizeof[$f.size]</td>
						</tr>
						<tr>
							<td>Дата загрузки:</td>
							<td>^f.cdate.sql-string[]</td>
						</tr>
						^if(!def $hData.required){
							<tr>
								<td>Удалить файл</td>
								<td><input type="checkbox" name="delFile" value=""/></td>
							</tr>
						}	
					</table>
				}{
#========================================== put entry in the log
#^cmCreate[new;file_history_anton_exception_del;trying to open ${sBinary_path}${sFile_path}.filename]
				}			
			}
		</td>
	}

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
#===================================================================================================PRINT SIZEOF
@print_sizeof_old[raw_size][iFile_size_mb]
	
	$iFile_size_mb(^eval($raw_size / (1024*1024)))
	
	^if($iFile_size_mb >= 1){
		$result[^iFile_size_mb.format[%.0f] МБайт]
	}
	
	^if($iFile_size_mb < 1 ){	
		^if($iFile_size_mb <= 0.0009){
			$result[^eval($iFile_size_mb * 1024 * 1024)[%.0f] Байт]
		}{
			$result[^eval($iFile_size_mb * 1024)[%.0f] кБайт]
		}
	}
#===================================================================================================CREATE FILE
@create_file[hData][sControl_sublabel;reStored_filename;sStored_filename;sOrig_filename;fFilename;f;sFile_path;sFilename;sAccept_ext;f;sMaxSize;iMaxSize]
	^if(def $hData.readonly || $hData.readonly eq "true"){
		^readonly_file[$hData]
	}{
		$iMaxSize(^eval($MAIN:LIMITS.post_max_size * (2/3)))
		$sMaxSize[^printSizeof[$iMaxSize]]
	
		$sFile_path[$hData.value]
	
		^if(def $hData.file_ext){
			$sAccept[Допустимые расширения: ]
			$sAccept[${sAccept} ${hData.file_ext},]
			$sAccept[^sAccept.trim[both;,]]
		}
		
		$sControl_sublabel[$hData.sublabel]
		^if($sControl_sublabel ne "" || def $sControl_sublabel){
			$sControl_sublabel[<br><small>$sControl_sublabel</small>]
		}
#===============means file already uploaded
	
		<td class="align_right">^printLabel_content[$hData]<br><small>$sAccept</small><br><small>Размер файла до $sMaxSize</small></td><td><input type="file" data-type="file" data-max-post-size="$iMaxSize" id="$hData.id" name="$hData.name" ^if(def $hData.classes ){class="xc__file $hJquery_ui_style.[$hData.group] $classes"}{class="xc__file $hJquery_ui_style.[$hData.group]"} $hData.properties ^if(!def $sFile_path){$hData.required}  size="$group_input_size" /><div class="file_info"></div>
			^if(def $sFile_path){
#^cmCreate[append;file_history_anton_debug_del;edit_existing_files]
	
				^if(-f "${sBinary_path}${sFile_path}.filename"){
					$fFilename[^file::load[text;${sBinary_path}${sFile_path}.filename]]
					$sFilename[$fFilename.text]
					$f[^file::load[binary;${sBinary_path}${sFile_path}.file]]
					$reStored_filename[^sFile_path.match[([0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12})^$][i]]
					$sOrig_filename[^sFile_path.match[([0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12})^$][i][$sFilename]]
					<table class="uploaded_file_props_table">
						<tr>
							<td>Загруженный файл:</td>
							<td>${sFilename}</td>
						</tr>
						<tr>
							<td>Размер:</td>
							<td>^printSizeof[$f.size]</td>
						</tr>
						<tr>
							<td>Дата загрузки:</td>
							<td>^f.cdate.sql-string[]</td>
						</tr>
						^if(!def $hData.required){
							<tr>
								<td>Удалить файл</td>
								<td><input type="checkbox" name="delFile" value=""/></td>
							</tr>
						}	
					</table>
				}{
#========================================== put entry in the log
#^cmCreate[new;file_history_anton_exception_del;trying to open ${sBinary_path}${sFile_path}.filename]
				}			
			}
		</td>
	}
#===================================================================================================CREATE READONLY FILE
@readonly_file[hData][sControl_sublabel]
# 	$sControl_sublabel[$hData.sublabel]
# 	^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 		$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 	}
	$sFile_path[$hData.value]
	<td class="align_right">^printLabel[$hData]</td>
	<td>
		^if(-f "${sBinary_path}${sFile_path}.filename"){
			$fFilename[^file::load[text;${sBinary_path}${sFile_path}.filename]]
			$sFilename[$fFilename.text]
			$f[^file::load[binary;${sBinary_path}${sFile_path}.file]]
			$reStored_filename[^sFile_path.match[([0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12})^$][i]]
			$sOrig_filename[^sFile_path.match[([0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12})^$][i][$sFilename]]
			<table class="uploaded_file_props_table">
				<tr>
					<td>Загруженный файл:</td>
					<td>${sFilename}</td>
				</tr>
				<tr>
					<td>Размер:</td>
					<td>^printSizeof[$f.size]</td>
				</tr>
				<tr>
					<td>Дата загрузки:</td>
					<td>^f.cdate.sql-string[]</td>
				</tr>
				^if(!def $hData.required){
					<tr>
						<td>Удалить файл</td>
						<td><input type="checkbox" name="delFile" value=""/></td>
					</tr>
				}	
			</table>
		}{

		}
	
	</td>

#===================================================================================================GET FIELDNAMES
@fieldnames_table_file[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]
	^tFieldnames.append{$name}
	
	$result[$tFieldnames]
#===================================================================================================DEL FILENAMES FROM DISK & INDEX
@UpdateFiles[tUploaded_files;fieldname;sIndex_file;mode][hFileStats;tStoredUUID;sFilePath;sFileUUID;sArchivePath;sFilepath]

#^cmCreate[append;file_history_anton_debug_del;update_files]

	$sFilepath[${sBinary_path}${tUploaded_files.$fieldname}]
	$sArchivePath[^sFilepath.replace[^sBinary_path.trim[right;/];^sBinary_path.trim[right;/]${sArchivePostfix}]]

	^switch[$mode]{
		^case[del]{	
			^if(-f "${sFilepath}.file"){
				^file:delete[${sFilepath}.file]
				^file:delete[${sFilepath}.filename]
			}
		}
		^case[mov]{
			^if(-f "${sFilepath}.file" && !-f "${sArchivePath}.filename"){
			 	^file:move[${sFilepath}.file;${sArchivePath}.file]
				^file:move[${sFilepath}.filename;${sArchivePath}.filename]
			}
#========================if file is already archived
			^if(-f "${sFilepath}.file" && -f "${sArchivePath}.filename"){
				^file:delete[${sFilepath}.file]
				^file:delete[${sFilepath}.filename]
			}
		}
#===============================================================================================================================TO DO! SMART COPY
		^case[cpy]{
			^if(-f "${sFilepath}.file"){
#				^if(!-f "${sArchivePath}.file"){
			 		^file:copy[${sFilepath}.file;${sArchivePath}.file]
					^file:copy[${sFilepath}.filename;${sArchivePath}.filename]
#				}
			}
		}		
	}
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_file[fieldname;value;filetype;ext;table;uuid;isDel;isArchive][sUploadedFiles;sFileSize;sFilePath;sFileName;tMatch;tNewIndex;tOldIndex;sStoredUUID;bOverwrite;bNosave;tUploaded_files;sModule_name;sErr_type;hRet;sErrMessage;sStore_path;tFdata;isErr;sIndex_file;tIndex;sNew_fname;sOrig_fname;i;f;sStored_filenames;isCorrect;hType;tFiletypes;re;now;sFoldername;tPieces;sYear;sMonth;sDay;isExt]
#================================================^^^^^^^^^^ - for file existence check on update. 
#===========================================================^^^^^ - if need to delete file. 
#======================================================uuid - for the entry we update

#^cmCreate[new;file_history_anton_debug_del;preprocess_for_db_save]

	$sModule_name[FILE]

	$sIndex_file[${sBinary_path}${fieldname}/index.cfg]

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
	
	$sErr_type[]
	$tUploaded_files[]
	$sUploadedFiles[]
	
	
#=======means we are updating entry	
	^if(def $table && def $uuid){
		^connect[$MAIN:CS]{
			$tUploaded_files[
				^table::sql{
					SELECT `$fieldname` 
						FROM `$table`
							WHERE `uuid`="$uuid"
				}
			]
		}
		^tUploaded_files.menu{
			$sUploadedFiles[${sUploadedFiles}^#0A$[$tUploaded_files.$fieldname]]
		}
	}	
#=======means file already uploaded

	^if(!def $value && def $tUploaded_files.$fieldname){
		$bNosave(true)
	}
	
	^if(def $value && def $tUploaded_files.$fieldname){
		$bOverwrite(true)
	}
	
	$hRet[
		$.value[]
#		$.error[^hash::create[]]
	]
#===========================================================if new file uploaded	
	^if($value && !$bNosave && !$isDel){

		$tFiletypes[^filetype.split[,]]		# - custom groups
		$tExt[^ext.split[,]]			# - ext - exact extensions without "*."
		
		^if(!-f "${sIndex_file}"){
			$tIndex[^table::create{oper	dt	uuid	uid_file	path	size	filename}]
			^tIndex.save[$sIndex_file]
		}
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
			$sNew_fname[^math:uuid[]]
#			$sStore_path[${sBinary_path}${fieldname}/${sYear}/${sMonth}/${sDay}]
			$sStore_path[/${fieldname}/${sYear}/${sMonth}/${sDay}]
			$sStored_filenames[${sStored_filenames}^#0A${sStore_path}/${sNew_fname}]

			$sPath[${sBinary_path}${fieldname}/${sYear}/${sMonth}/${sDay}/${sNew_fname}.file]

			^f.save[binary;${sBinary_path}${fieldname}/${sYear}/${sMonth}/${sDay}/${sNew_fname}.file]
			^sOrig_fname.save[${sBinary_path}${fieldname}/${sYear}/${sMonth}/${sDay}/${sNew_fname}.filename]
			
			^file:lock[${sIndex_file}.lock]{		
			
				^if($bOverwrite){
					$tFdata[^#0A*	^now.sql-string[]	$uuid	$sNew_fname	^sStore_path.replace[${sBinary_path}/;]	$f.size	$sOrig_fname]
					^tFdata.save[append;$sIndex_file]
				}
			
#=======================================dt uid path size filename
				^if(!$isDel && !$bOverwrite){
					$tFdata[^#0A+	^now.sql-string[]	$uuid	$sNew_fname	^sStore_path.replace[${sBinary_path}/;]	$f.size	$sOrig_fname]
					^tFdata.save[append;$sIndex_file]
				}
			}
		}

		^if(!$isErr){
#=======================if overwrite file
			^if($bOverwrite){
				^if($isArchive){
					^UpdateFiles[$tUploaded_files;$fieldname;$sIndex_file;mov]
				}{
					^UpdateFiles[$tUploaded_files;$fieldname;$sIndex_file;del]
				}
				
			}
			$sNewStoredFilename[^sStored_filenames.trim[both;^#0A]]
			$sNewStoredFilename[^sNewStoredFilename.trim[left;/]]
			$hRet[
				$.value[$sNewStoredFilename]
			]
		}{
			$hRet.error[^hash::create[]]
			$hRet[
				$.value[^sUploadedFiles.trim[both;^#0A]]
				$.error[
					$.err_fieldname[$fieldname]
					$.message[FILE VALUE TYPE OR EXTENSION MISMATCH]
					$.err_module[${sModule_name}.${sErr_type}]
				]
			]			
		}
	}

#===================================if form is updated without updating the file
	^if($bNosave && !$isDel){
		^if($isArchive){
			^UpdateFiles[$tUploaded_files;$fieldname;$sIndex_file;cpy]
		}
		
		$hRet[
			$.value[$tUploaded_files.$fieldname]
		]
	}
#=========================================================if need to delete file
	^if($isDel && !$value){

		^tUploaded_files.menu{
			$tMatch[^tUploaded_files.$fieldname.match[^^(.+\/)([0-9-A-Z]+)^$][U]]
			$sFilePath[^tMatch.1.replace[$sBinary_path;]]
			$sFilename[$tMatch.2]

			$f[^file::load[binary;${sBinary_path}${tUploaded_files.$fieldname}.file]]

			$sFileSize[$f.size]
			$f[^file::load[text;${sBinary_path}${tUploaded_files.$fieldname}.filename]]
			$sOrig_filename[$f.text]
				
			^file:lock[${sIndex_file}.lock]{
				$tFdata[^#0A-	^now.sql-string[]	$uuid	$sFilename	^sFilePath.trim[right;/]	$sFileSize	$sOrig_filename]
				^tFdata.save[append;$sIndex_file]
			}
		}			
	
		^if($isArchive){
			^UpdateFiles[$tUploaded_files;$fieldname;$sIndex_file;mov]
		}{
			^UpdateFiles[$tUploaded_files;$fieldname;$sIndex_file;del]
		}
		
		$hRet[
			$.value[]
		]
	}	

	$result[$hRet]

#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_file[init;hParsed_xml]

#^cmCreate[append;file_history_anton_debug_del;edit_existing_file]

	$value[$init.[$hParsed_xml.name]]
	$result[$value]

#===================================================================================================MOVE FILE TO ARCHIVE FOLDER
@archive_file[fieldname;table;uuid]

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
@ErrorList_file[invoke][hErrList]
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
@get_info_file[table;uuid;fieldname][sOrig_filename;reStored_filename;f;sFilename;fFilename;sEntry;tTableStatus]	
	$sEntry[]
	$hRet[^hash::create[]]
	^connect[$MAIN:CS]{
		$sEntry[
			^string:sql{
				SELECT `$fieldname`
					FROM `$table`
						WHERE `uuid`="$uuid"
			}
		]
	}

	^if(def $sEntry){
		$sEntry[^sEntry.trim[]]
		$fFilename[^file::load[text;${sBinary_path}${sEntry}.filename]]
		$sFilename[$fFilename.text]
		$f[^file::load[binary;${sBinary_path}${sEntry}.file]]
		$reStored_filename[^sFile_path.match[([0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12})^$][i]]
		$sOrig_filename[^sFile_path.match[([0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12})^$][i][$sFilename]]
		
		$hRet[
			$.filename[$sFilename]
			$.size[^printSizeof[$f.size]]
			$.dt_upload[^f.cdate.sql-string[]]
			$._label[
				$.filename[Загруженный файл]
				$.size[Размер]
				$.dt_upload[Дата загрузки]
			]
		]
	}
		
	$result[$hRet]	
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_file[fieldName;tDataRow][hRet]
	$hRet[^hash::create[]]
	$hRet[$._value[$tDataRow.$fieldName]]
	
	$result[$hRet]
#===================================================================================================GET RAW DATA FOR VIEW
@file_info[rawData][sFilename;sFilePath;fFilename;f;sFilenameFile]
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