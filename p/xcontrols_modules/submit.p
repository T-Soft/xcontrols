#===================================================================================================INPUT xCONTROL MODULE
@CLASS
xcontrols

@OPTIONS
static
partial

#===================================================================================================CREATE SUBMIT
@xcreate_submit[hData]
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
#===================================================================================================CREATE SUBMIT
@create_submit[hData]
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