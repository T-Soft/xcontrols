has_errors = false;
isUploading=false;
already_attached=0;
//==================================================================================================BROWSER TEST
//==================================================================================================INITIALIZE jQuery
function local_lib_init(){

	var	error_msg = {
			'has_errors' : "<div class='has_errors'>имеются ошибки заполнения формы</div>",
			'required' : "<div class='required_text'>пожалуйста, заполните это поле</div>",
			'ogrn' : "<div class='error_text'>введен некорректный ОГРН. Проверить ОГРН можно на сайте <a href='http://egrul.nalog.ru/' target='_blank'>Федеральной Налоговой Службы</a></div>",
			'inn' : "<div class='error_text'>введен некорректный ИНН. Проверить ИНН можно на сайте <a href='http://egrul.nalog.ru/' target='_blank'>Федеральной Налоговой Службы</a></div>",
			'tnved' : "<div class='error_text'>указывается только один ТНВЭД. допускаются только цифры</div>",
			'float' : "<div class='error_text'>только целые или дробные числа. десятичный разделитель - точка</div>",
			'int' : "<div class='error_text'>только целые числа</div>",
			'file' : "<div class='error_text'>суммарный размер файлов превышает максимально допустимый</div>",
			'date' : "<div class='error_text'>недопустимый формат даты. необходимый формат : ГГГГ-ММ-ДД</div>",
		},
        out_of_bounds = "<div class='out_of_bounds'>%msg%</div>",	//OOB - out of bounds
		//for IE-trim() compatiability: all spaces were deleted. obsolete (used $.trim() instead)
		special_check_calss = ".xc__int,.xc__float,.xc__ogrn,.xc__inn,.xc__tnved,.xc__file,.xc__date",
		bounds_check_class = ".xc__int,.xc__float,.xc__tnved";

	$(function() {
//==================================================================================================FUNCTIONS
//=====================================================================================base64 encode
		function Base64Encode(str) {
			// Символы для base64-преобразования
			var b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefg'+
				'hijklmnopqrstuvwxyz0123456789+/=';
			var b64encoded = '';
			var chr1, chr2, chr3;
			var enc1, enc2, enc3, enc4;

			for (var i=0; i<str.length;) {
				chr1 = str.charCodeAt(i++);
				chr2 = str.charCodeAt(i++);
				chr3 = str.charCodeAt(i++);

				enc1 = chr1 >> 2;
				enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);

				enc3 = isNaN(chr2) ? 64:(((chr2 & 15) << 2) | (chr3 >> 6));
				enc4 = isNaN(chr3) ? 64:(chr3 & 63);

				b64encoded += b64chars.charAt(enc1) + b64chars.charAt(enc2) +
					b64chars.charAt(enc3) + b64chars.charAt(enc4);
			}
			return b64encoded;
		}
//=====================================================================================base64 decode
		function Base64Decode(str) {
			var b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefg'+
				'hijklmnopqrstuvwxyz0123456789+/=';
			var b64decoded = '';
			var chr1, chr2, chr3;
			var enc1, enc2, enc3, enc4;

			str = str.replace(/[^a-z0-9\+\/\=]/gi, '');

			for (var i=0; i<str.length;) {
				enc1 = b64chars.indexOf(str.charAt(i++));
				enc2 = b64chars.indexOf(str.charAt(i++));
				enc3 = b64chars.indexOf(str.charAt(i++));
				enc4 = b64chars.indexOf(str.charAt(i++));

				chr1 = (enc1 << 2) | (enc2 >> 4);
				chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
				chr3 = ((enc3 & 3) << 6) | enc4;

				b64decoded = b64decoded + String.fromCharCode(chr1);

				if (enc3 < 64) {
					b64decoded += String.fromCharCode(chr2);
				}
				if (enc4 < 64) {
					b64decoded += String.fromCharCode(chr3);
				}
			}
			return b64decoded;
		}
//===========================================================================check browser & version
		function checkSupport(){
			//var	isFileSupported = (window.File && window.FileReader && window.FileList && window.Blob);

			var user = detect.parse(navigator.userAgent);
			var supported = {
				'IE' : 8
				,'Safari' : 5
				,'Opera' : 11
				,'Chrome' : 10
				,'Firefox' : 4
			};

			return (user.browser.major >= supported[user.browser.family]);
		}

		if(!checkSupport()){
			$('.submit').button({
				disabled : true
			});
			$.alert("Пожалуйста, обновите браузер","Ваш браузер не поддерживается",300).focus();
		}
//=====================================================================remove spaces from thumbprint
		function kill_spaces_and_capitalize(input){
			var sInput = input.value;
			var sRepaired = "";

			var re = new RegExp ("[^A-F0-9]","ig");
			var sRepaired = sInput.replace(re,'');

			input.value = sRepaired.toUpperCase();
		}
//==========================================================browser properties & compatiability test
		function support(ret) {
			var ua = navigator.userAgent;
			var bName = function () {
				if (ua.search(/MSIE/) > -1) return "ie";
				if (ua.search(/Firefox/) > -1) return "firefox";
				if (ua.search(/Opera/) > -1) return "opera";
				if (ua.search(/Chrome/) > -1) return "chrome";
				if (ua.search(/Safari/) > -1) return "safari";
				if (ua.search(/Konqueror/) > -1) return "konqueror";
				if (ua.search(/Iceweasel/) > -1) return "iceweasel";
				if (ua.search(/SeaMonkey/) > -1) return "seamonkey";}();
			var version = function (bName) {
				switch (bName) {
					case "ie" : return (ua.split("MSIE ")[1]).split(";")[0];break;
					case "firefox" : return ua.split("Firefox/")[1];break;
					case "opera" : return ua.split("Version/")[1];break;
					case "chrome" : return (ua.split("Chrome/")[1]).split(" ")[0];break;
					case "safari" : return (ua.split("Version/")[1]).split(" ")[0];break;
					case "konqueror" : return (ua.split("KHTML/")[1]).split(" ")[0];break;
					case "iceweasel" : return (ua.split("Iceweasel/")[1]).split(" ")[0];break;
					case "seamonkey" : return ua.split("SeaMonkey/")[1];break;
				}}(bName);
			switch (ret) {
				case "browser_name" : return bName; break;
				case "browser_version" : return version; break;
				case "jquery_version":	return $.fn.jquery;
				default : return bName + ' v' + version; break;
			}
		}
		function isNumeric(n) {
			return !isNaN(parseFloat(n)) && isFinite(n);
		}
//==================================================================================================FIELDS CHECK
//=========================================================================================check inn
		function check_inn(inn_object){
			var 	check_val = $.trim(inn_object.val()),
				inputNumber = check_val.split('');

			if(check_val == "000000000000" || check_val=="0000000000"){
				return false;
			}
		    // ИНН 10
			if((inputNumber.length == 10) && (inputNumber[9] == ((
					2 * inputNumber[0] +
					4 * inputNumber[1] +
					10 * inputNumber[2] +
					3 * inputNumber[3] +
					5 * inputNumber[4] +
					9 * inputNumber[5] +
					4 * inputNumber[6] +
					6 * inputNumber[7] +
					8 * inputNumber[8]) % 11) % 10)){
				return true;
		    // ИНН 12
			}else if((inputNumber.length == 12) && ((inputNumber[10] == ((
					7 * inputNumber[0] +
					2 * inputNumber[1] +
					4 * inputNumber[2] +
					10 * inputNumber[3] +
					3 * inputNumber[4] +
					5 * inputNumber[5] +
					9 * inputNumber[6] +
					4 * inputNumber[7] +
					6 * inputNumber[8] +
					8 * inputNumber[9]) % 11) % 10) && (inputNumber[11] == ((
					3 * inputNumber[0] +
					7 * inputNumber[1] +
					2 * inputNumber[2] +
					4 * inputNumber[3] +
					10 * inputNumber[4] +
					3 * inputNumber[5] +
					5 * inputNumber[6] +
					9 * inputNumber[7] +
					4 * inputNumber[8] +
					6 * inputNumber[9] +
					8 * inputNumber[10]) % 11) % 10))){
				return true;
			}else{
				return false;
			}
		}
//========================================================================================check ogrn
		function check_ogrn(ogrn_object){
			var 	checkedValue = $.trim(ogrn_object.val());

			if(checkedValue =="0000000000000" || checkedValue =="000000000000000"){
				return false;
			}

			// ОГРН 13
			if(checkedValue.length == 13 && (checkedValue.slice(-1) == ((checkedValue.slice(0,-1))%11 + '').slice(-1))){
				return true;
			// ОГРН 15
			}else if(checkedValue.length == 15 && (checkedValue.slice(-1) == ((checkedValue.slice(0,-1))%13 + '').slice(-1))){
				return true;
			}else{
				return false;
			}
		}
//=======================================================================================check tnved
		function check_tnved(tnved_object){
			var 	check_val = tnved_object.val(),
				val_length = check_val.length,
				re = /\d+/,
				found,
				isOk = true;

			found=check_val.match(re);

			if((found == null) || (found[0].length < val_length)){
				isOk=false;
			}
			return isOk;
		}
//==================================================================================================
//===============================================================================isIn interval check
		function isIn(value,interval){
			var	right,
				left,
				exclude = "none";

//======================exclude interval ends ?
			if(interval.right[interval.right.length - 1] =="_"){
				exclude ="right";
			}
			if((interval.left[interval.left.length - 1] =="_") && exclude =="right"){
				exclude = "both";
			}else if ((interval.left[interval.left.length - 1] =="_")){
				exclude = "left";
			}
//======================parse interval ends
			if(isNaN(parseFloat(interval.left))){
				left = -Infinity;
			}else{
				left = parseFloat(interval.left);
			}

			if(isNaN(parseFloat(interval.right))){
				right = Infinity;
			}else{
				right = parseFloat(interval.right);
			}
//======================isIn ?
			switch(exclude){
				case "none":
					return ( (value >= left)&&(value <= right) );
					break;
				case "left":
					return ( (value > left)&&(value <= right) );
					break;
				case "right":
					return ( (value >= left)&&(value < right) );
					break;
				case "both":
					return ( (value > left)&&(value < right) );
					break;
			}
		}
//======================================================================================bounds check
		function bounds_check(obj){
			var	data_obj = obj.data(),
				value = obj.val(),
				interval = {},
				isOk = true,
				nocheck = true,
				status = [],
				add_class = true;

//======================if current control is in need of check
			var class_to_check = bounds_check_class.split(',');
			for(i=0;i<class_to_check.length;i++){
				if(obj.hasClass($.trim(class_to_check[i]).substr(1))){
					nocheck = false;
				}
			}
//======================//
			if(!nocheck){
				i=0;
				$(".out_of_bounds",obj.parent()).remove();
				while(data_obj["bound_"+i+"_type"] != undefined){
					var data = {};

					interval.left=data_obj["bound_"+i+"_min"].toString();
					interval.right=data_obj["bound_"+i+"_max"].toString();

					data.type = data_obj["bound_"+i+"_type"];
					data.message = data_obj["bound_"+i+"_message"];

					obj.removeClass("oob_"+data.type);

					if(isIn(value,interval) && value != ""){
						status.push(data);
					}
					i++;
				}
				if(status.length != 0){
					for(var j in status){
						add_class = true;

						if(status[j].type == "oob_error"){
							isOk= false;
						}
						if( !obj.hasClass("oob_"+status[j].type) ){
							switch("oob_"+status[j].type){
								case "oob_error":
									obj.removeClass("oob_info oob_warning");
									break;
								case "oob_warning":
									if(obj.hasClass("oob_error")){
										add_class = false;
									}
									obj.removeClass("oob_info");
									break;
								case "oob_info":
									if(obj.hasClass("oob_error") || obj.hasClass("oob_warning")){
										add_class = false;
									}
									break;
							}

							if(add_class){
								obj.addClass("oob_"+status[j].type);
							}
							obj.parent().append(out_of_bounds.replace("%msg%",status[j].message));
						}
					}
				}else{
					isOk = true;
				}
			}
			return isOk;
		}
//=====================================================================================check integer
		function check_int(int_object){
			var 	check_val = int_object.val(),
				val_length = check_val.length,
				re = /\d+/,
				isOk = true;

			found=check_val.match(re);

			if( (found == null) || (found[0].length < val_length) ){
				isOk=false;
			}
			return isOk;
		}
//=======================================================================================check float
		function check_float(float_object){
			var 	check_val = float_object.val(),
				val_length = check_val.length,
				re_subst = /[б,<ю>\/?]/i,
				subst = '.';
				re_check = /(\d+.\d+)|\d+/,
				found = '',
				repaired = '',
				isOk = true;

			repaired = check_val.replace(re_subst,subst);
			float_object.val(repaired);
			found = repaired.match(re_check);

			if( (found == null) || (found[0].length < val_length) ){
				isOk=false;
			}
			return isOk;
		}

		function printSizeof(raw){
			var	fsizeRaw = eval(raw),
				fsizeMb = eval(fsizeRaw / (1024 * 1024)),
				result;


			if(fsizeMb >= 1024){
				if(eval(fsizeMb/1024) > 1024){
					result=eval(fsizeMb/1024/1024).toFixed(2)+" TБайт"
				}else{
					result=eval(fsizeMb/1024).toFixed(2)+" ГБайт"
				}
			}
			if (fsizeMb >=1 && fsizeMb < 1024){
				result = fsizeMb.toFixed(2)+ " МБайт";
			}
			if(fsizeMb <1){
				if(fsizeMb <=0.0009){
					result = eval(fsizeMb * 1024 *1024).toFixed(2)+" Байт"

				}else{
					result = eval(fsizeMb * 1024).toFixed(2)+" кБайт"
				}

			}
			return result;
		}

		function writeFileSize(obj, this_ref){
			var	isFileSupported = (window.File && window.FileReader && window.FileList && window.Blob);
			if(isFileSupported){
				var 	files=obj.target.files;

				try{

					var filesize = files[0].size,
					maxPost = $(this_ref).data("max-post-size");
					//filename = fileobject[0].type;

					$(this_ref).data("file-size",filesize);

					var strSizeof = "Размер: "+printSizeof(filesize);
					if(filesize >maxPost){
						strSizeof += ". Возможно превышение максимально допустимого объема."
					}

					$(this_ref).siblings(".file_info").html(strSizeof);
				}catch(e){
					$(this_ref).siblings(".file_info").html("");
				}
			}
		}
//=======================================================================================check float
		function check_file(file_object){
			var	isFileSupported = (window.File && window.FileReader && window.FileList && window.Blob);

			if(isFileSupported){
				var 	filesize = file_object.data("file-size"),
					maxPost = file_object.data("max-post-size");

				already_attached+=filesize;

				var strSizeof = "Размер: "+printSizeof(filesize);
				var isOverflow = already_attached > maxPost;

				if(isOverflow){
					$(file_object).siblings(".file_info").html(strSizeof);
					error_msg["file"]="<div class='error_text'>суммарный размер файлов превышает максимально допустимый "+ printSizeof(maxPost) +"</div>";
					return false;
				}else{
					error_msg["file"]="<div class='error_text'>суммарный размер файлов превышает максимально допустимый</div>";
					return true;
				}
			}else{
				return true;
			}
		}
//========================================================================================check date
		function check_date(date_object){
			var 	check_val = date_object.val(),
				val_length = check_val.length,

//				re = /\d{4}-\d{2}-\d{2}/,
				re = /[0-9]{4}-(0[1-9]|1[012])-(0[1-9]|1[0-9]|2[0-9]|3[01])/,

				isOk = true;

			found=check_val.match(re);

			if( (found == null) || (found[0].length < val_length) ){

//				re = /\d{2}[.-]\d{2}[.-]\d{4}/;
				re = /(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d/;

				found=check_val.match(re);
				if( (found == null) || (found[0].length < val_length) ){
					isOk=false;
				}
				else {
					date_object.val(check_val.substr(6,4)+'-'+check_val.substr(3,2)+'-'+check_val.substr(0,2));
//					alert( date_object.val() );
				}
			}
			return isOk;
		}
//=============================================================================required fields check
		function required_check(){
			var 	inputs = $("input, textarea"),
				isComplete = true;
			inputs.each(function(){
				if($(this).data('required')!= undefined && $(this).attr('data-required')!= "false"){

					var 	re = /^[\n\r\t ]*/,
						valToCheck = '';


					if($(this).attr('type') == 'radio'){

						if ( $("input[name = '"+$(this).attr('name')+"']:checked").length > 0 ) {
							valToCheck = 'CHECKED'; /* valToCheck должно быть не пустым, само значение не важно */
						}
					}
					else {
						valToCheck = $(this).val().replace(re,"");
					}


					//if($(this).val() == ''){
					if(valToCheck == ''){
						if(!$(this).hasClass('required')){
							$(this).addClass('required');

							if($(this).siblings('.required_text').length == 0) {
								$(this).parent().append(error_msg['required']);
							}
						}
						isComplete=false;
					}else{
						$(this).removeClass('required');
						$(this).siblings('.required_text').remove();
					}
				}else if($(this).attr('data-required')== "false"){
						$(this).removeClass('required');
						$(this).siblings('.required_text').remove();
//						isComplete = true;
				}

			});
			return isComplete;
		};

//==============================================================================special fields check
		function special_check(){
			var	check_objects = $(special_check_calss),
				isOk = true,
				tests = {
					'ogrn' : function(obj){return check_ogrn(obj)},
					'inn' : function(obj){return check_inn(obj)},
					'tnved' : function(obj){return check_tnved(obj)},
					'int' : function(obj){return check_int(obj)},
					'float' : function(obj){return check_float(obj)},
					'file' : function(obj){return check_file(obj)},
					'date' : function(obj){return check_date(obj)}
				};

			already_attached = 0;
			check_objects.each(function(){
				var type = $(this).data('type');

				if($(this).val() != ''){
					if(!tests[type]($(this))){
						$(this).removeClass("info warning");
						if($(this).hasClass('required')){
							$(this).removeClass('required');
							$(".required_text",$(this).parents()).remove();
							$(this).addClass('error');
							$(this).parent().append(error_msg[type]);
						}else{
							if($(".error_text",$(this).parent()).length == 0){
								if(!$(this).hasClass('error')){
									$(this).addClass('error');
								}
								$(this).parent().append(error_msg[type]);
							}
						}
						isOk=false;
					}else{
						$(this).removeClass('error');
						$(".error_text",$(this).parent()).remove();
					}
				}else{
					$(this).removeClass('error');
					$(".error_text",$(this).parent()).remove();

					if($(this).data('required')!= undefined && !$(this).hasClass('required')){
						$(this).addClass('required');
						$(this).parent().append(error_msg['required']);
					}
				}
			});

			return isOk;
		};
//==================================================================================================INTERFACE
		$(".xcontrols_div").css("display","block");

//==================================================================================================EVENT HANDLERS
		$("form").on('focus',function(event){
			var	inputs = $("input");

			inputs.each(function(){
				bounds_check($(this));
			});
		});
//============================================================================================submit

		$("form").on('click',':submit.submit',function(event){
		//$(".submit").on('click',function(event){
			if(isUploading){
				return false;
			}

			var	inputs = $("input, textarea"),
				focused = false,
				has_errors = false;
			if($(this).hasClass("initfile_submit")){
				return true;
			}
			if(!required_check()){
				special_check();

				inputs.each(function(){
					bounds_check($(this));
					if(($(this).hasClass('required') || $(this).hasClass('error') || $(this).hasClass('oob_error')) && !focused){
						if (($(this).hasClass('error')) && ($(this).hasClass('oob_error'))) {
							$(this).removeClass('error');
							$(this).siblings('.error_text').remove();
						}
						focused++;
						$(this).focus();
					}
				});

				if(!has_errors){
					if( $('.has_errors').length == 0 ){
						$('.submit').parent().append(error_msg['has_errors']);
						has_errors++;
					}
				}

				if (event.preventDefault) {
					event.preventDefault();
				} else { // вариант IE<9:
					event.returnValue = false;
				}

			}else{
				if(!special_check()){
					inputs.each(function(){
						if(($(this).hasClass('error')) && ($(this).hasClass('oob_error'))){
							$(this).removeClass('error');
							$(this).siblings('.error_text').remove();
						}
					});
					if( $('.has_errors').length == 0 ){
						$('.submit').parent().append(error_msg['has_errors']);
						has_errors++;
					}
					focus_element = $(".error:first");
					focus_element.focus();
					event.preventDefault();
				}else{
					$('.has_errors').remove();
					has_errors = false;

					$('#xcvar__javascript_error').val("0");

					$('.submit').val("Идет отправка формы...");
					isUploading = true;
					$('.submit').toggleClass("upload_processing");
				}
			}

		});


		$("input.xc__file").on('change',function(event){
			writeFileSize(event,this);
		});

//============================================================================real-time bounds check
		$("input.xc__int , input.xc__float").on('blur',function(event){
			bounds_check($(this));
		});

		$("form.xform input[type=text]:not(.xc__date)").addClear({
			showOnLoad:true,
			hideOnBlur :false,
			returnFocus: true
		});
		$("form.xform input[type=text].xc__date:not([data-required=true])").addClear({
			showOnLoad:true,
			hideOnBlur :false,
			returnFocus: false
		});

	});
};
/*	if there is a need for a js function call from parser3

function verify_data(e){
	alert("Foo");
	e.preventDefault();
};
*/
