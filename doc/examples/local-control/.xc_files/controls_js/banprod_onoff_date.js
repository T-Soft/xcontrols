function banprod_onoff_date_init(){
	$(function() {

		var	NICK_CONTROL		= 'banprod_onoff_date';
		var	NICK_MAIN_CHECKBOX	= 'is_check';

		function readonlyElement(me){
			var 	parentId = me.attr("id"),
				dateId = parentId+"_date";

			var	dateBlockId = dateId+"_BLOCK";

				if(!me.prop("checked")){
					$("#"+dateBlockId).addClass("display_none");

					$("#"+dateId).addClass("readonly_blur");
//											$("#"+dateId).prop("disabled", true);
					$("#"+dateId).val("");
					$("#"+dateId).attr("data-required","false");
				}else{
					$("#"+dateBlockId).removeClass("display_none");

					$("#"+dateId).removeClass("readonly_blur");
//											$("#"+dateId).prop("disabled", false);
					$("#"+dateId).attr("data-required","true");
				}
		}

//==================================================================================================FUNCTIONS
		$( ".xc_"+NICK_CONTROL+"_"+NICK_MAIN_CHECKBOX ).each(function(){
			readonlyElement($(this));
		});

//==================================================================================================INTERFACE
//==============================================================================SWITCH TEXTAREAS ON AND OFF
		$( ".xc_"+NICK_CONTROL+"_"+NICK_MAIN_CHECKBOX ).click(
			function(){
				readonlyElement($(this));
			}
		);
	});

};