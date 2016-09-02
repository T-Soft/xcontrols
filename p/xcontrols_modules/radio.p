#===================================================================================================RADIO xCONTROLS MODULE
#===================================================================================================db enabled
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================CREATE RADIO
@xcreate_radio[hData][hData2;sControl_sublabel;tLabelSub;sControl_sublabel;isReadonly;sLabels_field_name;sValues_field_name;tQuery_vars;sValues;sLabels;tData;isDb;tLabels;tValues;tProps;sControl_label;tDefault_value;sDefault_value]
	$isReadonly(false)
	^if(def $hData.readonly || $hData.readonly eq "true"){
		$isReadonly(true)
	}
#	<script>
#  		^$(function() {
#    			^$( "#$hData.id" ).buttonset()^;
#  		});
#  	</script>

  	$isDb(false)
#=========if there is a <control_sql> element
	^if(def $hData.sql_query){$isDb(true)}
#===============================================================================query data
	^if($isDb){
		^connect[$MAIN:CS]{
			$tData[^table::sql{
				$hData.sql_query
			}]
		}
		$tQuery_vars[^hData.sql_query.match[`(.+)`,`(.+)`][U]]
		$sLabels_field_name[$tQuery_vars.1]
		$sValues_field_name[$tQuery_vars.2]
#===========================================================================form radio labels/values
		^tData.menu{
			$sValues[$sValues|@|]
			$sValues[${sValues}$tData.$sValues_field_name]
			$sLabels[$sLabels|@|]
			$sLabels[${sLabels}$tData.$sLabels_field_name]
		}
		$hData.value[${hData.value}~^sValues.trim[left;|@|]]
		$hData.label[${hData.label}~^sLabels.trim[left;|@|]]
	}
#===============================================================================

  	$tLabels[^hData.label.split[~;lh]]

	$tLabelSub[^tLabels.0.split[||;lh]]
	$sControl_label[$tLabelSub.0]
	$sControl_sublabel[$tLabelSub.1]

# 	^if($hData.sublabel ne ""){
# 		$sControl_sublabel[$hData.sublabel]
# 	}

# 	^if($sControl_sublabel ne "" || def $sControl_sublabel){
# 		$sControl_sublabel[<br><small>$sControl_sublabel</small>]
# 	}
	$hData2[^hash::create[$hData]]
	$hData2.label[$sControl_label]

	$tLabels[^tLabels.1.split[|@|;lh]]

	$tDefault_value[^hData.value.split[~;lh]]
 	$sDefault_value[$tDefault_value.0]
 	$hData.value[$tDefault_value.1]

  	$tValues[^hData.value.split[|@|;lh]]
  	$tProps[^hData.properties.split[|@|;lh]]

#    	<td class="align_right">${sControl_label}${sControl_sublabel}</td>
	^printLabel[$hData2]
	<td>
		<span id="$hData.id" >
			^if($isReadonly){
				^for[i](0;^tLabels.count[cells] - 1){
					^if($tValues.[$i] eq $sDefault_value){
						$tLabels.[$i]
					}
				}
			}{
				^for[i](0;^tLabels.count[cells] - 1){
					<input
						type="radio"
						id="${hData.id}_${i}"
						name="$hData.name"
						value="$tValues.[$i]"
						^if($tValues.[$i] eq $sDefault_value){checked="checked"}
						$hData.required
					><label for="${hData.id}_${i}">$tLabels.[$i]</label><br>
				}
			}
	    	</span>
	</td>
#===================================================================================================CREATE RADIO
@create_radio[hData][sControl_sublabel;tLabelSub;sControl_sublabel;isReadonly;sLabels_field_name;sValues_field_name;tQuery_vars;sValues;sLabels;tData;isDb;tLabels;tValues;tProps;sControl_label;tDefault_value;sDefault_value]
	$isReadonly(false)
	^if(def $hData.readonly || $hData.readonly eq "true"){
		$isReadonly(true)
	}
#	<script>
#  		^$(function() {
#    			^$( "#$hData.id" ).buttonset()^;
#  		});
#  	</script>

  	$isDb(false)
#=========if there is a <control_sql> element
	^if(def $hData.sql_query){$isDb(true)}
#===============================================================================query data
	^if($isDb){
		^connect[$MAIN:CS]{
			$tData[^table::sql{
				$hData.sql_query
			}]
		}
		$tQuery_vars[^hData.sql_query.match[`(.+)`,`(.+)`][U]]
		$sLabels_field_name[$tQuery_vars.1]
		$sValues_field_name[$tQuery_vars.2]
#===========================================================================form radio labels/values
		^tData.menu{
			$sValues[$sValues|@|]
			$sValues[${sValues}$tData.$sValues_field_name]
			$sLabels[$sLabels|@|]
			$sLabels[${sLabels}$tData.$sLabels_field_name]
		}
		$hData.value[${hData.value}~^sValues.trim[left;|@|]]
		$hData.label[${hData.label}~^sLabels.trim[left;|@|]]
	}
#===============================================================================

  	$tLabels[^hData.label.split[~;lh]]

	$tLabelSub[^tLabels.0.split[||;lh]]
	$sControl_label[$tLabelSub.0]
	$sControl_sublabel[$tLabelSub.1]

	^if($hData.sublabel ne ""){
		$sControl_sublabel[$hData.sublabel]
	}

	^if($sControl_sublabel ne "" || def $sControl_sublabel){
		$sControl_sublabel[<br><small>$sControl_sublabel</small>]
	}

	$tLabels[^tLabels.1.split[|@|;lh]]

	$tDefault_value[^hData.value.split[~;lh]]
 	$sDefault_value[$tDefault_value.0]
 	$hData.value[$tDefault_value.1]

  	$tValues[^hData.value.split[|@|;lh]]
  	$tProps[^hData.properties.split[|@|;lh]]

   	<td class="align_right">${sControl_label}${sControl_sublabel}</td>
# 	^printLabel[$hData]
	<td>
		<span id="$hData.id" >
			^if($isReadonly){
				^for[i](0;^tLabels.count[cells] - 1){
					^if($tValues.[$i] eq $sDefault_value){
						$tLabels.[$i]
					}
				}
			}{
				^for[i](0;^tLabels.count[cells] - 1){
					<input
						type="radio"
						id="${hData.id}_${i}"
						name="$hData.name"
						value="$tValues.[$i]"
						^if($tValues.[$i] eq $sDefault_value){checked="checked"}
						$hData.required
					><label
						for="${hData.id}_${i}"
#						class="ui-corner-all"
					>$tLabels.[$i]</label><br>
				}
			}
	    	</span>
	</td>
#===================================================================================================GET FIELDNAMES
@fieldnames_table_radio[name][tFieldnames]
	$tFieldnames[^table::create{fieldname}]
	^tFieldnames.append{$name}

	$result[$tFieldnames]
#===================================================================================================PREPROCESS FOR DB
@db_preprocess_radio[value][hRet]
#	$result[$value]
	$hRet[
		$.value[$value]
#		$.error[^hash::create[]]
	]

	$result[$hRet]
#===================================================================================================PREPROCESS FOR EDIT
@edit_preprocess_radio[init;hParsed_xml][sNew_default_value;tSplit]
	$value[$init.[$hParsed_xml.name]]
	$sNew_default_value[$hParsed_xml.value]
	$tSplit[^sNew_default_value.split[~;lh]]
	$sNew_default_value[${value}~${tSplit.1}]
	$result[$sNew_default_value]
#===================================================================================================GET RAW DATA FOR VIEW
@raw_data_radio[fieldName;tDataRow][hRet]
	$hRet[^hash::create[]]
	$hRet[$._value[$tDataRow.$fieldName]]

	$result[$hRet]