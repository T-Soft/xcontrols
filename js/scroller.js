//==================================================================================================BROWSER TEST
//==================================================================================================INITIALIZE jQuery
function scroller_handler(){
	document.onkeydown = NavigateThrough;
	function NavigateThrough (event){
		if (!document.getElementById) return;
		if (window.event) event = window.event;
		if (event.ctrlKey)
			{
				var link = null;
				var href = null;
				switch (event.keyCode ? event.keyCode : event.which ? event.which : null)
					{
						case 0x27: link = document.getElementById ('next_link'); break;
						case 0x25: link = document.getElementById ('prev_link'); break;
					}
				if (link && link.href) document.location = link.href;
				if (href) document.location = href;

			}
	}
};
/*	if there is a need for a js function call from parser3

function verify_data(e){
	alert("Foo");
	e.preventDefault();
};
*/
