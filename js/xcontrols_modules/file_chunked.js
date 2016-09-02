function file_chunked_init(){
	var
		dialog,
		form;
			
	$(function() {
		
		/*
		function Signature(type,certThumbprint,dataToSign){
			this.type = type;
			this.certThumb = certThumbprint;
			this.data=dataToSign;

			this.Sign=function(){

			}
		}
		*/
//==================================================================================================FUNCTIONS

//==================================================================================================INTERFACE
//==============================================================================DIALOG
		
		dialog = $(".xcontrols-dialog-form").dialog({
			autoOpen: false,
			height: 500,
			width: 600,
			modal: true,
			show: {
				effect: "blind",
				duration: 300
			},
			hide: {
				effect: "explode",
				duration: 300
			},
			buttons: {
				//"Create an account": addUser,
				"Закрыть": function() {
					dialog.dialog( "close" );
				}
			},
			//----------------что творим по закрытию диалога
			close: function() {
								
			}
		});
		
		form = dialog.find( "form" ).on( "submit", function( event ) {
			event.preventDefault();
			//addUser();
		});
		
//==============================================================================CREATE LOAD FILE BUTTON		
		$(".btn_load_file").button().on( "click", function() {
			$(".xcontrols-dialog-form").dialog( "open" );
    		});


	});
};