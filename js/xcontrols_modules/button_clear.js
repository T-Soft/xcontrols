function button_clear_init(){
	$(function() {
		
//==================================================================================================FUNCTIONS
		function getDefault(obj){
			var def = obj.data('default-value');
			
			if(!def){
				def="";
			}

			return def;

		}
		function clearInput(obj){
			var 	type = obj.attr('type'),
				def = getDefault(obj);		
				
			switch(type){
				case 'text' :
					obj.val(def);
					break;
				case 'checkbox' :
					obj.prop('checked',def);
					break;
				case 'file' :
					obj.val(def);
					break;
			}
			
		}
		
		function clearSelect(obj){
			obj.val(getDefault(obj));			
		}

		function clearTextarea(obj){
			obj.val(getDefault(obj));
		}		

		function clearControls() {
            		var	inputs = $("input, textarea, select"),
				clear = {
					'BUTTON' : function(obj){return},
					'SUBMIT' : function(obj){return},
					'INPUT' : function(obj){return clearInput(obj)},
					'TEXTAREA' : function(obj){return clearTextarea(obj)},
					'SELECT' : function(obj){return clearSelect(obj)},
					'RADIO' : function(obj){return}
				};

			inputs.each(function(){
				clear[$(this).prop('nodeName')]($(this));
			})
        	}
//==================================================================================================INTERFACE
//==============================================================================CREATE CLOSE BUTTON
		$(".xc_button_clear").button().on( "click", function() {
			clearControls();
		});
	});
};
