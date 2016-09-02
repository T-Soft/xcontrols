#===================================================================================================SELECT xCONTROLS MODULE
#===================================================================================================db enabled
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================FORMAT
@format_select[hData;tDataRow;sFormat]
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
