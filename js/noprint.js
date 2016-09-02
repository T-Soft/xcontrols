//==================================================================================================PRINT VIA JQUERY PLUG-in
//==================================================================================================

$(function() {

	function xc_noprint(elem){
		if(elem == undefined){
			elem=$('body')
		}

		elem.contents().each(function(){
			if($(this).children().length != 0){
	//			if(!$(this).hasClass("printable") || !$(this).hasClass("noscreen") || !$(this).hasClass("noprint")){
				if(!$(this).hasClass("printable")){
					$(this).addClass("noprint");

					xc_noprint($(this));
				}
			}
			if(!($(this).hasClass("printable") || $(this).hasClass("noprint"))){
				$(this).addClass("noprint");
			}
		})

	};

	xc_noprint();

	$("[class=printable]").parents().removeClass('noprint');

});
