#===================================================================================================INPUT xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial


#===================================================================================================CREATE BUTTON
@xcreate_button[hData]
	^switch[$hData.type]{
		^case[submit]{^case_submit[$hData]}
		^case[DEFAULT]{^case_button[$hData]}
	}

#===================================================================================================BUILD SIMPLE BUTTON
@case_button[hData]
	<script>
  		^$(function() {
    			^$( "#${hData.id}" ).button()^;
  		})^;
  	</script>
	<td colspan="2"><input
		type="button"
		id="$hData.id"
		value="$hData.value" 
		class="$hJquery_ui_style.[$hData.type] $hData.classes"
		$hData.properties
	 />
	</td>
#===================================================================================================BUILD SUBMIT
@case_submit[hData]
	<script>
		^$(function() {
    			^$( "#${hData.id}" ).button()^;
  
 		})^;
  	</script>
	<td></td>
	<td>
		<input type="submit" id="$hData.id" value="$hData.value" 

		class="submit $hJquery_ui_style.[$hData.type] $hData.classes"

		$hData.properties
	 />
	</td>
#===================================================================================================CREATE BUTTON
@create_button[hData]
	^switch[$hData.type]{
		^case[submit]{^case_submit[$hData]}
		^case[DEFAULT]{^case_button[$hData]}
	}