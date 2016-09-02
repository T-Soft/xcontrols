#=======================================================================================================================CHECKBOX CONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================FORMAT
@format_checkbox[hData;tDataRow;sFormat]
	^if(!def $sFormat || $sFormat eq ""){
		$sFormat[null]
	}
	^switch[$sFormat]{
		^case[null]{
			^switch[$hData._value]{
				^case[0]{
					$result[]
				}
				^case[1]{
					$result[on]
				}
			}
#				$result[$hData._value]
		}
		^case[DEFAULT]{
			^if(!def $sFormat){
				$result[null]	
			}{
				^throw[system.viewer;$sFormat;xControls viewer module -> Unknown formatter name ${sFormat}.]
			}
		}
	}
