function float_init(){
	$(function() {
		
//==================================================================================================FUNCTIONS
		
//==================================================================================================INTERFACE
//==============================================================================CREATE TODAY AND CLEAR BUTTONS
		
		$( ".xc_float_btn_clear" ).button({
			icons: {
				height: "20",
				width: "20",
				primary: "ui-icon-closethick"
				},
			text:false
		}).on("click",function(event){
			$(this).siblings(".xc__float").val("");
			//event.preventDefault();
		});	
	});

};