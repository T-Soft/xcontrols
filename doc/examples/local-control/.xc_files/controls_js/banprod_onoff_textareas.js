function banprod_onoff_textareas_init(){
	$(function() {

		function readonlyTextarea(me){
			var 	parentId = me.attr("id"),
				foundId = parentId+"_found",
				documentsId = parentId+"_norm";

				$("#"+foundId).prop("readonly",! me.prop("checked"));
				$("#"+documentsId).prop("readonly",! me.prop("checked"));

				if(!me.prop("checked")){
					$("#"+foundId).addClass("readonly_blur");
//					$("#"+foundId).prop("disabled", true);
					$("#"+foundId).val("");
					$("#"+foundId).attr("data-required","false");

					$("#"+documentsId).addClass("readonly_blur");
//					$("#"+documentsId).prop("disabled", true);
					$("#"+documentsId).val("");
				}else{
					$("#"+foundId).removeClass("readonly_blur");
//					$("#"+foundId).prop("disabled", false);
					$("#"+foundId).attr("data-required","true");

					$("#"+documentsId).removeClass("readonly_blur");
//					$("#"+documentsId).prop("disabled", false);
				}
		}

//==================================================================================================FUNCTIONS
		$( ".xc_banprod_onoff_textareas_is_found" ).each(function(){
			readonlyTextarea($(this));
		});

//==================================================================================================INTERFACE
//==============================================================================SWITCH TEXTAREAS ON AND OFF
		$( ".xc_banprod_onoff_textareas_is_found" ).click(
			function(){
				readonlyTextarea($(this));
			}
		);
	});

};