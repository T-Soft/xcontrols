# utf-8 абв
#===================================================================================================DATEPICKER xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================FORMAT
@format_date[hData;tDataRow;sFormat][dt;bNull]
	$dt[]
	$bNull(false)
	^if($hData._value ne "" || def $hData._value){
		^try{
			$dt[^date::create[$hData._value]]
		}{
			$exception.handled(true)
			$bNull(true)
		}
	}{
		$result[]
	}

	^if(!def $sFormat || $sFormat eq ""){
		$sFormat[null]
	}

	^switch[$sFormat]{
		^case[null;sql]{
			$result[$hData._value]
		}
		^case[gmt;g]{
			^if(!$bNull){
				$result[^dt.gmt-string[]]
			}{
				$result[$hData._value]
			}
		}
		^case[DEFAULT]{
			^if(!def $sFormat){
				$result[null]
			}{
				^throw[system.viewer;$sFormat;xControls viewer module -> Unknown formatter name ${sFormat}.]
			}
		}
	}
