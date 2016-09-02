function date_init(){
	$(function() {
		
//==================================================================================================FUNCTIONS
		
//==================================================================================================INTERFACE
//==============================================================================CREATE TODAY AND CLEAR BUTTONS
		$( ".xc_date_btn_today" ).button({
			icons: {
				primary: "ui-icon-calendar"
				},
				text:true,
				label: "Сегодня"
		}).on("click",function(event){
			if($(this).siblings().hasClass("add-clear-span")){
				$(this).siblings().children(".xc__date").datepicker( "setDate", "+0" );	
			}else{
				$(this).siblings(".xc__date").datepicker( "setDate", "+0" );	
			}
			
			//event.preventDefault();
		});

		// $( ".xc_date_btn_clear" ).button({
		// 	icons: {
		// 		primary: "ui-icon-closethick"
		// 		},
		// 		text:true,
		// 		label: "Очистить"
		// }).on("click",function(event){
		// 	$(this).siblings(".xc_date").datepicker( "setDate", null );
		// 	//event.preventDefault();
		// });	
	});

};