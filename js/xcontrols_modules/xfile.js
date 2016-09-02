function xfile_init(){
	var
		fileWindowDisabled = false;
			
	$(function() {
//====================================================================================ADD/REMOVE INDEXES TO HIDDEN FIELD
		function toggleDel(field,index,mode){
			var v = field.val();

			switch(mode){
				case "add":
					if(v ==""){
						// if only one index specified
						v = index;
					}else{
						if(v.indexOf(",")!=-1){
							var p = v.split(",");
							var newV=[]
							if(!(index in p)){
								for(var i=0;i<p.length;i++){
									newV.push(p[i]);
								}
							}
							newV.push(index)
							v = newV.join();
						}else{
							if(v != index){
								v += ","+index;
							}
						}	
					}
					break;
				case "del":
					if(v == index){
						// if only one index specified
						v = "";
					}else{
						if(v.indexOf(",")!=-1){
							var p = v.split(",");
							var newV=[];
							for (var i = 0; i<p.length;i++){
								if(eval(p[i]) == index){
									continue;
								}
								newV.push(p[i]);
							}							
							return newV.join();
						}else{
							v="";
						}
					}
					break;
			}
			return v;
		}
//==================================================================================================PROCESS DELETE
		function processDel(me){
			var 	delFieldId = me.data("file_del_id"),
				delFileField = $("#"+delFieldId),
				fileIndex = me.val(),
				fileInputId= me.data("file_input_id"),
				checkboxSelector="[data-file_input_id="+fileInputId+"]";

			if(me.prop("checked") == true){
				delFileField.val(toggleDel(delFileField,fileIndex,"add"));
			}else{
				delFileField.val(toggleDel(delFileField,fileIndex,"del"));
			}

			var 	delCheckboxes = $("[data-file_input_id="+fileInputId+"]"),
				anyChecked = false,
				filesCount = delCheckboxes.length,
				isRequired = delFileField.data("file_required") ? true : false,
				checkedCount = 0,
				nocheck=false;

			delCheckboxes.each(function(){
					if($(this).prop("checked")){
						anyChecked = true;
						checkedCount++;
						if(isRequired){
							if(checkedCount == filesCount-1){
								nocheck = true;								
							}else{
								nocheck = false;
							}
						}
					}		
			});

			if(nocheck){

				$(checkboxSelector).not(":checked").parents("td").parents("tr").first().addClass("xc__xfile_checkbox_disabled");
				$(checkboxSelector).not(":checked").addClass("xc__xfile_nocheck");
				$(checkboxSelector).not(":checked").attr("disabled","true");
			}else{
				$(".xc__xfile_nocheck"+checkboxSelector).each(function(){
					$(this).parents("td").parents("tr").first().removeClass("xc__xfile_checkbox_disabled");
					$(this).removeClass("xc__xfile_nocheck");
					$(this).removeAttr("disabled","true");
				});
			}

			if(anyChecked){
				if(!fileWindowDisabled){
					fileWindowDisabled=true;
					$("#"+fileInputId).addClass("xc__xfile_disabled").attr("disabled","true");

				}
			}else{
				if(fileWindowDisabled){
					fileWindowDisabled=false;
					$("#"+fileInputId).removeClass("xc__xfile_disabled").removeAttr("disabled");
				}
			}
			
		}
//==================================================================================================INTERFACE
		$(".xc__xfile_disabled").on("click",function(){
			return false;
		});

		$(".xc__xfile").change(function(){
			var	fileInputId = $(this).attr("id"),
				delCheckboxes = $("[data-file_input_id="+fileInputId+"]");

			if($(this).val() != ""){
				delCheckboxes.each(function(){
					var me=$(this);
					me.prop("checked",false);
					me.attr("disabled","true");

					me.parents("td").parents("tr").first().addClass("xc__xfile_checkbox_disabled")
					
					//me.addClass("xc__xfile_checkbox_disabled");	
				});
				$("#"+fileInputId+"_del").val("");
			}else{
				delCheckboxes.each(function(){
					var me=$(this);

					me.removeAttr("disabled");
					me.removeClass("xc__xfile_checkbox_disabled");	
				});
			}
			

		});

		$(".xc__xfile_del_checkbox").on("click",function(){
			processDel($(this));
		});

		
		// click(function(e){
  //   			e.stopPropagation();
  //   			return true;
		// });
		
	});
}