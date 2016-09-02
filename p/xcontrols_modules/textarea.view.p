#===================================================================================================TEXTAREA xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================FORMAT
@format_textarea[hData;tDataRow;sFormat][acc]
	^if(!def $sFormat || $sFormat eq ""){
		$sFormat[null]
	}
	^switch[$sFormat]{
		^case[null]{
			$result[<span style='white-space:pre-wrap'>^taint[html][$hData._value]</span>]
		}
		^case[DEFAULT]{
			^if(!def $sFormat){
				$result[null]	
			}{
				^throw[system.viewer;$sFormat;xControls viewer module -> Unknown formatter name ${sFormat}.]
			}
		}
	}
