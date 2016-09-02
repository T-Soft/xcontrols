#===================================================================================================OGRN xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================format OGRN
@format_ogrn[hData;tDataRow;sFormat]
	^if(!def $sFormat || $sFormat eq ""){
		$sFormat[null]
	}
	^switch[$sFormat]{
		^case[null]{
			$result[$hData._value]
		}
		^case[DEFAULT]{
			^if(!def $sFormat){
				$result[null]	
			}{
				^throw[system.viewer;$sFormat;xControls viewer module -> Unknown formatter name ${sFormat}.]
			}
		}
	}