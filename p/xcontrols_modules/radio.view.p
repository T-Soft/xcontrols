#===================================================================================================RADIO xCONTROLS MODULE
#===================================================================================================db enabled
@CLASS
xcontrols

@OPTIONS
static
partial

@format_radio[hData;tDataRow;sFormat]
^throw[system.NOT_IMPLEMENTED;$sFormat;xControls viewer module -> Radio view not implemented yet ((]
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