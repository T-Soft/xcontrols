#===================================================================================================FILE xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================FORMAT
@format_file[hData;tDataRow;sFormat][bExists;hFileInfo;bFex;res]

	^if(!def $sFormat || $sFormat eq ""){
		$sFormat[null]
	}

$res[]
	
^if(^hData._value.trim[] ne ''){
	
	$hFileInfo[^file_info[$hData._value]]
	$bFex(false)
	
	^if(^hFileInfo.contains[exists]){
		$bFex(true)
	}
	
	^rem{
		$.filename[Служебка-РКПО.docx]
		$.size[793 Байт]
		$.dt_upload[2015-07-16 16:49:43]
		$.filepath[/binary_data/file_test/2015/07/16/D69EB534-C276-4E8D-B6DA-DD99F450A174.file]
		$.content-type[application/octet-stream]
		$._label[
			$.filename[Загруженный файл]
			$.size[Размер]
			$.dt_upload[Дата загрузки]
		]
		$.exists(true)
	}

# антон! просьба, если нигде не использовано -- выбросить все сокращенные формы форматов, а так же url - т.к. он в 99% случаев корп-портала не будет работать
# т.к. у нас файлы вне веб-пространства

# давай введем формат as-is - данные как есть вообще без любых конвертаций
# в формат null - т.е. без указанеия формата -- это самое распространненный и типовой показ данных


	^if($bFex){
		^switch[$sFormat]{
			^case[null]{
				$res[$hFileInfo.filename]
			}
			^case[as-is]{
				$res[$hData._value]
			}
			
			^case[name_size]{
				$res[
					Файл: "$hFileInfo.filename"<br>
					Размер: $hFileInfo.size
				]
			}
			^case[name_size_dt]{
				$res[
					Файл: "$hFileInfo.filename"<br>
					Размер: $hFileInfo.size<br>
					Дата загрузки: $hFileInfo.dt_upload
				]
			}
			^case[DEFAULT]{
				^if(!def $sFormat){
					$result[null]	
				}{
					^throw[system.viewer;$sFormat;xControls viewer module -> Unknown format-name "${sFormat}".]
				}
			}
		}
	}{
		$res[Файл "${hData._value}" не найден.]
	}
}

$result[$res]
