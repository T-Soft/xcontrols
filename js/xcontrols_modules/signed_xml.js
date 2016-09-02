function signed_xml_init(){
	var	CAPICOM_CURRENT_USER_STORE = 2,
		CAPICOM_LOCAL_MACHINE_STORE = 1,
	 	CAPICOM_MY_STORE = "My",
	 	CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED = 2,
	 	CAPICOM_CERTIFICATE_FIND_SUBJECT_NAME = 1,
	 	CAPICOM_CERTIFICATE_FIND_SHA1_HASH = 0,
		CAPICOM_CERT_INFO_SUBJECT_SIMPLE_NAME = 0,
	 	CADESCOM_XML_SIGNATURE_TYPE_TEMPLATE = 2,
	 	CADESCOM_XML_SIGNATURE_TYPE_ENVELOPING = 1,
	 	CADESCOM_ENCODE_BASE64 = 0,
	 	CADESCOM_CADES_BES = 1,
	 	CADESCOM_BASE64_TO_BINARY = 1,
	 	CADESCOM_STRING_TO_UCS2LE = 0,
		CADESCOM_XML_SIGNATURE_TYPE_ENVELOPED = 0,
		XmlDsigGost3410UrlObsolete = "http://www.w3.org/2001/04/xmldsig-more#gostr34102001-gostr3411",
		XmlDsigGost3411UrlObsolete = "http://www.w3.org/2001/04/xmldsig-more#gostr3411",
		XmlDsigGost3410Url = "urn:ietf:params:xml:ns:cpxmlsec:algorithms:gostr34102001-gostr3411",
		XmlDsigGost3411Url = "urn:ietf:params:xml:ns:cpxmlsec:algorithms:gostr3411",
		CADES_version="1.05.1633",
		urlCADESx32="http://www.cryptopro.ru/sites/default/files/products/cades/current_release/cadescom-win32.msi",
		urlCADESx64="http://www.cryptopro.ru/sites/default/files/products/cades/current_release/cadescom-x64.msi";

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
//=====================================================================================base64 encode

		function _utf8_encode(string) {
			string = string.replace(/\r\n/g,"\n");
			var utftext = "";
			for (var n = 0; n < string.length; n++) {
				var c = string.charCodeAt(n);
				if( c < 128 ){
					utftext += String.fromCharCode(c);
				}else if( (c > 127) && (c < 2048) ){
					utftext += String.fromCharCode((c >> 6) | 192);
					utftext += String.fromCharCode((c & 63) | 128);
				}else {
					utftext += String.fromCharCode((c >> 12) | 224);
					utftext += String.fromCharCode(((c >> 6) & 63) | 128);
					utftext += String.fromCharCode((c & 63) | 128);
				}
			}
			return utftext;
		}
		function Base64Encode(str) {
			// Символы для base64-преобразования
			var b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefg'+
				'hijklmnopqrstuvwxyz0123456789+/=';
			var b64encoded = '';
			var chr1, chr2, chr3;
			var enc1, enc2, enc3, enc4;

			str = _utf8_encode(str);

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
//==================================================================================================Browser plug-in part
		function GetErrorMessage(e) {
			var err = e.message;
			if (!err) {
				err = e;
			} else if (e.number) {
				err += " (" + e.number + ")";
			}
			return err;
		}
//===============================================================================create CADES object
		function CreateObject(name) {
			switch (navigator.appName) {
				case "Microsoft Internet Explorer":
					return new ActiveXObject(name);
				default:
					var userAgent = navigator.userAgent;
					if (userAgent.match(/Trident\/./i)) { // IE11
						return new ActiveXObject(name);
					}
					var cadesobject = document.getElementById("cadesplugin");
					return cadesobject.CreateObject(name);
			}
		}
//=================================================================================find certificates
		function find_certs(search_location){

			oCert_list = new Object();

			var oStore = CreateObject("CAPICOM.Store");

			switch (search_location){
				case 'current_user':
					oStore.Open(CAPICOM_CURRENT_USER_STORE, CAPICOM_MY_STORE,CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);
					break;
				case 'local_machine':
					oStore.Open(CAPICOM_LOCAL_MACHINE_STORE, CAPICOM_MY_STORE,CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);
					break;
				default :
					oStore.Open(CAPICOM_CURRENT_USER_STORE, CAPICOM_MY_STORE,CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);
			}

			var oCertificates_total = oStore.Certificates.Find(
				CAPICOM_CERTIFICATE_FIND_SUBJECT_NAME , " ");

			if(oCertificates_total.Count >= 1){
				$("#sbmt_sign").button({ disabled: false });

				for (var i=1;i<=oCertificates_total.Count;i++){
					var oTestCertificate = CreateObject("CAPICOM.Certificate");
					oTestCertificate = oCertificates_total.Item(i);

					var sCertSubjectName = oTestCertificate.SubjectName;
					//var re = new RegExp("CN=([a-zа-яё0-9 _-]+)","i");
					var re = new RegExp("CN[ ]*=[ ]*([a-zа-яё0-9 _-]+)","i");
					var sSubjectName = sCertSubjectName.match(re);

					oCert_list[sSubjectName[1]+" ("+sCertSubjectName+")"]=oTestCertificate.Thumbprint;
				}

				var sSelect ="";
				for (var sSubj in oCert_list){

					var re = /([\d\w.]+)=([\w\d.\-@А-Яа-я №#]+)/g;
					var aSplit = sSubj.match(re);
					var sTitle ="";
					for(var i=0; i<aSplit.length;i++){
						sTitle+=aSplit[i]+'\n';
					}
					sTitle+='\n'+sSubj;

					sSelect += "<option class='titled_option' title="+"'"+sTitle+"'"+" value="+"'"+oCert_list[sSubj]+"'"+">"+sSubj+"</option>";
					sTitle="";
				}
				sSelect += "<option value='custom'>Найти сертификат по SHA1 отпечатку</option>";
				document.getElementById("sel_certificate").innerHTML=sSelect;

				$("#inp_cert_thumb").val($("#sel_certificate").val());
			}else{


				sSelect += "<option >Сертификаты не найдены</option>";
				document.getElementById("sel_certificate").innerHTML=sSelect;

				$("#inp_cert_thumb").attr("readonly","readonly");
				$("#sbmt_sign").button({ disabled: true });
				$("#inp_cert_thumb").val("");
			}
		}
//=================================================================================get cert by thumb
		function GetCertificateByThumb(sCert_thumb){
			var oStore = CreateObject("CAPICOM.Store");
			oStore.Open(CAPICOM_CURRENT_USER_STORE, CAPICOM_MY_STORE,CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

			var oCertificates = oStore.Certificates.Find(CAPICOM_CERTIFICATE_FIND_SHA1_HASH, sCert_thumb);

			if (oCertificates.Count == 0) {
				$.alert("Не найден сертификат с отпечатком '" + sCert_thumb+"'","Не найден сертификат!");
				return 'no_cert';
			}
			var oCertificate = oCertificates.Item(1);
			return oCertificate;
		}
//=========================================================================create detached signature
//==================================certSubjectName - SHA1 Thumbprint
		function DetachedSignature(sCert_thumb, dataToSign) {

			var oSigner = CreateObject("CAdESCOM.CPSigner");
			oSigner.Certificate = GetCertificateByThumb(sCert_thumb);

			var oSignedData = CreateObject("CAdESCOM.CadesSignedData");
			// Значение свойства ContentEncoding должно быть задано
			// до заполнения свойства Content
			oSignedData.ContentEncoding = CADESCOM_BASE64_TO_BINARY;

			oSignedData.Content = dataToSign;

			var sSignedMessage = "";
			try {
				sSignedMessage = oSignedData.SignCades(oSigner, CADESCOM_CADES_BES, true);
			} catch (err) {
				switch (err){
					case "Cannot find the certificate and private key for decryption. (0x8009200B)":
						$.alert("Указанный контейнер не содержит открытого или закрытого ключа.", "Ключевая пара неполна.");
						break;
					case "The action was cancelled by the user. (0x8010006E)":
						$.alert("Документ не подписан: подписание отменено пользователем.", "Отмена.");
						break;
					default:
						$.alert("Ошибка: " + GetErrorMessage(err), "Невозможно создать подпись.");
				}
				return 'signing_failed';
			}

			return sSignedMessage;
		}
//========================================================================create enveloped signature
		function EnvelopedSignature(sCert_thumb, dataToSign){
			var oSigner = CreateObject("CAdESCOM.CPSigner");
			oSigner.Certificate = GetCertificateByThumb(sCert_thumb);

			// Создаем объект CAdESCOM.SignedXML
			var oSignedXML = CreateObject("CAdESCOM.SignedXML");
			oSignedXML.Content = dataToSign;

			// Указываем тип подписи - в данном случае вложенная
			oSignedXML.SignatureType = CADESCOM_XML_SIGNATURE_TYPE_ENVELOPED;

			// Указываем алгоритм подписи
			oSignedXML.SignatureMethod = XmlDsigGost3410Url;

			// Указываем алгоритм хэширования
			oSignedXML.DigestMethod = XmlDsigGost3411Url;

			var sSignedMessage;
			try {
				sSignedMessage = oSignedXML.Sign(oSigner);
			} catch (err) {
				alert("Failed to create signature. Error: " + GetErrorMessage(err));
				return;
			}

			return sSignedMessage;
		}
//==================================================================================verify signature
		function VerifyDetached(sSignedMessage, dataToVerify) {
			var oSignedData = CreateObject("CAdESCOM.CadesSignedData");
			try {
				// Значение свойства ContentEncoding должно быть задано
				// до заполнения свойства Content
				oSignedData.ContentEncoding = CADESCOM_BASE64_TO_BINARY;
				oSignedData.Content = dataToVerify;
				oSignedData.VerifyCades(sSignedMessage, CADESCOM_CADES_BES, true);

			} catch (err) {
				alert("Failed to verify signature. Error: " + GetErrorMessage(err));
				return false;
			}

			return true;
		}


		function VerifyEnveloped(sSignedMessage) {

			// Создаем объект CAdESCOM.SignedXML
			var oSignedXML = CreateObject("CAdESCOM.SignedXML");

			try {
				oSignedXML.Verify(sSignedMessage);
			} catch (err) {
				alert("Failed to verify signature. Error: " + GetErrorMessage(err));
				return false;
			}

			return true;
		}
//=====================================================================remove spaces from thumbprint
		function kill_spaces_and_capitalize(input){
			var sInput = input.value;
			var sRepaired = "";

			var re = new RegExp ("[^A-F0-9]","ig");
			var sRepaired = sInput.replace(re,'');
/*
			for(var i=0; i<sInput.length;i++){
				if(sInput[i] != ' '){
					sRepaired+=sInput[i];
				}
			}
*/
			input.value = sRepaired.toUpperCase();
		}
//=======================================================================signing process entry point
		function run() {
			var oCert_thumb = document.getElementById("sel_certificate");
			var sCert_thumb = oCert_thumb.value;
			var inpCert_thumb = document.getElementById("inp_cert_thumb");
			var signatureType = document.getElementById("signature_type").value;

			if($("#sel_certificate").val() == "custom"){

				if($("#inp_cert_thumb").val() != ""){
					kill_spaces_and_capitalize(inpCert_thumb);
					sCert_thumb = inpCert_thumb.value;
				}else{
					$.alert("Введите отпечаток сертификата (sha1 hash).","Отсутствует отпечаток.");
					return false;
				}
			}
			var signedMessage;
			var VerificationResult = false;
			var sDocument_base64;
			var sDocumentToSign;

			switch (signatureType){
				case "detached":
						sDocument_base64 = document.getElementById("tar_doc_to_sign").value;
						signedMessage = DetachedSignature(sCert_thumb, sDocument_base64);

// в FF не работает				VerificationResult = VerifyDetached(signedMessage,sDocument_base64);
						VerificationResult = true;

						break;
				case "enveloped":
						sDocumentToSign = document.getElementById("tar_doc_to_sign").value;
						signedMessage = EnvelopedSignature(sCert_thumb, sDocumentToSign);
						VerificationResult = VerifyEnveloped(signedMessage);
						break;
			}
			switch (signedMessage){
				case 'no_cert':
					return false;
					break;
				case 'signing_failed':
					return false;
					break;
				default:
					if(VerificationResult){
						if(!sDocument_base64){
							document.getElementById("signature").value = Base64Encode(signedMessage);
							//document.getElementById("signature").value = signedMessage;
						}else{
							document.getElementById("signature").value = signedMessage;
						}
						return true;
					}else{
						return false;
					}
			}
		}
//==================================================================================================INTERFACE
		$("#sbmt_form_xml").button();

		$("#sbmt_sign").button();

		$( "#cert_store" ).buttonset().change(function(){
			var value = $("input:radio:checked").val();
			find_certs(value);
		});


//==================================================================================================EVENT HANDLERS
//=============================================================================start signing process
		$( document ).submit(function( event ) {
			if(! run()){
				event.preventDefault();
			}
		});
//=========================================================================find certificates to sign

		$("#sel_certificate").change(function(){
			if(this.value != "custom"){
				$("#inp_cert_thumb").attr("readonly","readonly");
				$("#inp_cert_thumb").val(this.value);
				$("#thumbprint_div").fadeOut();
				//$("#thumbprint_div").display='none';
			}else{
				$("#inp_cert_thumb").removeAttr("readonly");
				$("#inp_cert_thumb").val("");
				$("#thumbprint_div").fadeIn();
				//$("#thumbprint_div").display='block';
			}
		})
//==================================================================================================RUN AFTER LOAD
		try{
			find_certs('current_user');
		}catch(e){
			//alert(e.message);
			var hrefx32= '<a href="'+urlCADESx32+'">Windows x32</a>';
			var hrefx64= '<a href="'+urlCADESx64+'">Windows x64</a>';
			$.alert('Не установлен CADESCOM plug-in версии '+CADES_version+'. Пожалуйста, посетите страницу загрузки и установите его (скачать для '+hrefx32+' и '+hrefx64+').','CADESCOM plug-in не найден');
			$("#sbmt_sign").button({
				disabled:true
			});
			return false;
		}
	});
};