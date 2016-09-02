function button_close_init(){
	$(function() {
		
//==================================================================================================FUNCTIONS
		function redirect(url) {
            		if(url != "") {
                		window.location.href = url;
            		}
        }
//==================================================================================================INTERFACE
//==============================================================================CREATE CLOSE BUTTON
		$(".xc_button_close").button().on( "click", function() {
			redirect($(this).data("target"));
		});
	});
};
