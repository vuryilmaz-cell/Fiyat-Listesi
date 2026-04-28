// JavaScript Document

var timer;
var flag=null;
var active_menu_a ;
var active_menu_a_src;
var active_menu_son;

function trim(stringToTrim)
{
return stringToTrim.replace(/^\s+|\s+$/g,"");
}


function actstarter(action)
{
	//adjust_liste("kirilim_liste")

}




function sub_link_action()
{
	if(document.getElementById("sub_products")!=null)
	{
		
		var active_list = document.getElementById("sub_products").innerHTML;
		var act_URL = document.URL;
		var act_grupID = act_URL.split("_")[1];
		var ac_li_list = document.getElementById(act_grupID);
		ac_li_list.innerHTML = ac_li_list.innerHTML + active_list;
	}
}



function getElementsByClassName(oElm, strTagName, strClassName)
{
	var arrElements = (strTagName == "*" && oElm.all)? oElm.all : oElm.getElementsByTagName(strTagName);
	var arrReturnElements = new Array();
	strClassName = strClassName.replace(/\-/g, "\\-");
	var oRegExp = new RegExp("(^|\\s)" + strClassName + "(\\s|$)");
	var oElement;
	
	for(var i=0; i<arrElements.length; i++)
	{
		oElement = arrElements[i];
		if(oRegExp.test(oElement.className))
		{
			arrReturnElements.push(oElement);
		}
	}
	
	return (arrReturnElements)
}










function slide()
{
	
	
	var banner_div = getElementsByClassName(slide_conatiner,"div","div_slide"); //banner div leri diziye aktarılıyor.
	var div_width = 220;

	for(var i=0; i<banner_div.length;i++)
	{
			
			if(i==0)
			{
				banner_div[i].style.marginLeft = (i*div_width)+"px";	
				banner_div[i].style.display="block";
			}
			else
			{
				banner_div[i].style.marginLeft = (i*div_width)+i*11+"px";
				banner_div[i].style.display="block";
			}
	}
	
	var left_navigater = document.getElementById("left_navigater");
	var right_navigater = document.getElementById("right_navigater");
	
	var slide_top= document.getElementById("slide_conatiner").offsetTop;
	var slide_left= document.getElementById("slide_conatiner").offsetLeft;
	left_navigater.style.marginTop = slide_top+80+"px";
	left_navigater.style.marginLeft = slide_left-19+"px";
	left_navigater.style.display="block";

	right_navigater.style.marginTop = slide_top+80+"px";
	right_navigater.style.marginLeft = slide_left+897+"px";
	right_navigater.style.display="block";

	document.getElementById("right_navigater_count").style.marginTop = slide_top+60+"px";
	document.getElementById("right_navigater_count").style.marginLeft = slide_left+897+"px";
	document.getElementById("right_navigater_count").innerHTML=0;

	document.getElementById("left_navigater_count").style.marginTop = slide_top+60+"px";
	document.getElementById("left_navigater_count").style.marginLeft = slide_left-19+"px";
	document.getElementById("left_navigater_count").innerHTML=banner_div.length-1;
}


function slide_button_over(target)
{
	document.body.style.cursor = 'pointer';
}

function slide_button_out(target)
{
	document.body.style.cursor = 'default';
}



var my_interval
var middle_count = 4;
var right_count = 0;
var left_count = 0;
var initalize_flag=0;
var flag = 0;

function slide_action(target)
{	
	
	var banner_div = getElementsByClassName(slide_conatiner,"div","div_slide");

	if(initalize_flag == 0)
	{
		right_count = banner_div.length - middle_count;
		initalize_flag = 1;
	}
	
	if(target.id=="right_navigater")
	{
		//if(right_count >0)
		{
			
			target.setAttribute("onclick","");
			my_interval = setInterval(slide_to_left,5);
			right_count =  right_count-1;
			left_count = left_count+1;
		}				
	}
	if(target.id=="left_navigater")
	{
		//if(left_count > 0)
		{
			
						
			banner_div[parseInt(document.getElementById("left_navigater_count").innerHTML)].style.marginLeft = banner_div[parseInt(document.getElementById("left_navigater_count").innerHTML)].offsetLeft-(banner_div.length*(220+11))+"px";

			target.setAttribute("onclick","");
			my_interval = setInterval(slide_to_right,5);
			left_count = left_count-1;
			right_count =  right_count+1;
		}
	}

}

var interval_count = 0;

function slide_to_left()
{
	var banner_div = getElementsByClassName(slide_conatiner,"div","div_slide");
	
	for(var i=0; i<banner_div.length;i++)
	{
			banner_div[i].style.marginLeft = banner_div[i].offsetLeft - 11+"px";
	}
	
	interval_count = interval_count+1;	
	
	if(interval_count==21)
	{
		clearInterval(my_interval);	
		interval_count = 0;
			

		banner_div[parseInt(document.getElementById("right_navigater_count").innerHTML)].style.marginLeft = banner_div[parseInt(document.getElementById("right_navigater_count").innerHTML)].offsetLeft+(banner_div.length*(220+11))+"px";
		
		
		var rnc = parseInt(document.getElementById("right_navigater_count").innerHTML);
		var lnc = parseInt(document.getElementById("left_navigater_count").innerHTML);
			
	
			
		if(rnc < banner_div.length-1)
			{
				document.getElementById("right_navigater_count").innerHTML = parseInt(document.getElementById("right_navigater_count").innerHTML)+1; 
				
				if(lnc<banner_div.length-1)
					document.getElementById("left_navigater_count").innerHTML = parseInt(document.getElementById("left_navigater_count").innerHTML)+1;			
				else
				{
					document.getElementById("left_navigater_count").innerHTML = 0;
				}
			
			}
		else
		{
			document.getElementById("right_navigater_count").innerHTML = 0;
			document.getElementById("left_navigater_count").innerHTML = banner_div.length-1;
		}
		
		document.getElementById("right_navigater").setAttribute("onclick","slide_action(this)");

	}
}


function slide_to_right()
{
	var banner_div = getElementsByClassName(slide_conatiner,"div","div_slide");
	
	for(var i=0; i<banner_div.length;i++)
	{
			banner_div[i].style.marginLeft = banner_div[i].offsetLeft + 11+"px";
	}
	
	interval_count = interval_count+1;	
	
	if(interval_count==21)
	{
		clearInterval(my_interval);	
		interval_count = 0;
		
		
		
		
		var rnc = parseInt(document.getElementById("right_navigater_count").innerHTML);
		var lnc = parseInt(document.getElementById("left_navigater_count").innerHTML);
			
	
			
		if(lnc > 0)
			{
				document.getElementById("left_navigater_count").innerHTML = parseInt(document.getElementById("left_navigater_count").innerHTML)-1; 
				
				
				
				if(rnc<banner_div.length)
					
					if(rnc==0)
						document.getElementById("right_navigater_count").innerHTML = banner_div.length-1;	
					else
						document.getElementById("right_navigater_count").innerHTML = parseInt(document.getElementById("right_navigater_count").innerHTML)-1;			
						
				else
				{
					document.getElementById("right_navigater_count").innerHTML = banner_div.length-1;
				}
			}
		else
		{
			document.getElementById("left_navigater_count").innerHTML = banner_div.length-1;
			document.getElementById("right_navigater_count").innerHTML = 0;
		}
		
		
		document.getElementById("left_navigater").setAttribute("onclick","slide_action(this)");
	}
}



function checkform()
{
	
	
	var lang, adi, telefon, email, firma, konu, mesaj, hata, uyarimetni, uyariyeri;
	
	if(window.document.URL.search("/eng/")>-1)
		lang="eng";
	else if (window.document.URL.search("/fr/")>-1)
		lang="fr";
	else if (window.document.URL.search("/arabic/")>-1)
		lang="arabic";
	else
		lang="tr";	
	
	uyarimetni="";
	uyariyeri = document.getElementById("uyari");
	
	adi= document.getElementById("Adi").value;
	telefon = document.getElementById("Telefon").value;
	email = document.getElementById("email").value;	
	firma=document.getElementById("firma").value;
	konu=document.getElementById("Konu").value;
	mesaj=document.getElementById("Mesaj").value;
	
	
	hata=0;
	
	if(trim(adi)=="")
	{
		if(lang=="tr")
			uyarimetni += "Lütfen <strong>Ad Soyad</strong> alanını boş bırakmayınız...| ";
		else
			uyarimetni += "Missing <strong>NAME</strong>...| ";
		
		hata=1;
	}

	

	if(trim(telefon)=="")
	{
		if(lang=="tr")
			uyarimetni += "Lütfen <strong>TELEFON</strong> alanını boş bırakmayınız...| ";
		else
			uyarimetni += "Missing <strong>TEL NUMBER</strong>...| ";
		
		hata=1;
	}
	
	if(trim(email)=="")
	{
		if(lang=="tr")
		{
			uyarimetni += "Lütfen <strong>E-MAIL</strong> alanını boş bırakmayınız...";
		}
		else
		{
			uyarimetni += "Missing <strong>E-MAIL</strong>...| ";
		}
		
		hata=1;
	}
	else if(email.indexOf("@")==-1 || email.indexOf(".")==-1)  
	{
		if(lang=="tr")
		{
			uyarimetni += "Lütfen Geçerli Bir <strong>E-MAIL</strong> Adresi Giriniz...";
		}
		else
		{
			uyarimetni += "Invalid <strong>E-MAIL</strong>...| ";
		}
		hata=1;
	}
		
	if(hata==1)
	{
		uyariyeri.innerHTML = uyarimetni;
	}
	else
	{	
			
		var ajax_url = "../../aclmail.asp";
		var ajax_params = "Adi="+encodeURI(adi)+"&firma="+encodeURI(firma)+"&Konu="+encodeURI(konu)+"&Mesaj="+encodeURI(mesaj)+"&email="+email+"&Telefon="+encodeURI(telefon)+"&lang="+lang;
		ajaxFunction();
		xmlHttp.open("POST", ajax_url, true);
		xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
		xmlHttp.onreadystatechange = handleHttpResponse; 
		//xmlHttp.setRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT");
		xmlHttp.setRequestHeader("Content-length", ajax_params.length);
		xmlHttp.setRequestHeader("Connection", "close");
		xmlHttp.send(ajax_params); 
		
	}

	function handleHttpResponse()  
	{
		if (xmlHttp.readyState == 1)
		{
		 if(lang=="eng")
		 	document.getElementById("uyari").innerHTML="Sending";     
		else
			document.getElementById("uyari").innerHTML="Mesajınız Gönderiliyor";
			var interval_count=0;
			var my__color_interval = setInterval(change_color,500);
			
			function change_color()
			{
				
				document.getElementById("uyari").style.color=0xD92323;		
				
				if(interval_count % 2)
				{
					document.getElementById("uyari").style.color=0x000000;
				}
				
				interval_count+=1;
				if (interval_count >= 50)
					
					clearInterval(my__color_interval);
			}
		
		} 
		
		else if (xmlHttp.readyState == 4) 
		{
			
	
		
			if (xmlHttp.status == 200) 
				{
					var metin = xmlHttp.responseText;  
					
					if(metin=="ok")
					{
						if(lang=="eng")
							window.location="../../eng/message.asp"
						else if (lang=="fr")
							window.location="../../fr/message.asp"
						else if (lang=="arabic")
							window.location="../../arabic/message.asp"
						else
							window.location="../../message.asp"
					}
	
					else
					{
						document.getElementById("uyari").innerHTML=metin;
					}
					
					
				} 
			
				else 
				{
			  
				}        
		}

	}

}









function img_navigate_over(img)
{
	img.style.cursor="pointer";
	//img.style.cursor="hand";
	img.style.borderColor="#3399CC";	
}

function img_navigate_out(img)
{

	img.style.borderColor="#CCC";	
}



function resize()
{
	
	if(document.getElementById("slide_container"))
	{
		resize_navigation();
	}
	
	if(document.getElementById("main_banner"))
	{
		set_main_banner();
	}
	
	if(document.getElementById("osprt_bar_container"))
	{
		
		bar_move();
	}

	if(document.getElementById("my_video"))
	{
		if(document.getElementById("my_video").style.display=="block")
		{
			set_my_video();
			//check_object();
		}
	}

	if(document.getElementById("logo_div"))
	{
			set_logo_div();
			set_logo_img();
	}

	if(document.getElementById("top_cat"))
	{
		set_top_cat()
	}


}







function open_window(target)
{
	my_window = window.open('search_details.asp?id='+target,'','directories=no,location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=520,height=542');
	my_window.focus();
}



function menu_bag_back(active_menu)
{
	if(active_menu+"_div")
	{
		timer = setTimeout(acilir_menu,20);
	}
	
	
	active_menu_a_src = active_menu;


	
	
	
	active_menu.style.backgroundColor="";
	flag=null;
	
	function acilir_menu()
	{
		if (flag==null)
		{
		
			document.getElementById("menu_div").style.visibility="hidden";
			
		}
	
	}
	
	
	
}



function menu_bag_chang(active_menu)
{


	active_menu.style.cursor="hand";
	
	flag=active_menu.id;
	
	if(active_menu+"_div")
	{
		acilirmenu(active_menu);
	}
	
	
	active_menu.style.backgroundColor="RGB(0,0,0)";
	active_menu_son = active_menu;
	
	//if(active_menu.id=="kurumsal" ||  active_menu.id=="main_page")
	//{
	//	active_menu.style.backgroundImage="url(images/active_menu.gif)";
	//	document.getElementById("menu_div").style.width=220+"px";
	//}

}


function acilirmenu(active_menu)
{
	var menu_div= document.getElementById("menu_div");
	
	if(document.getElementById(active_menu.id+"_list"))
	{
	
		var zero_left_margin = document.getElementById("ana_sayfa").offsetLeft+0+"px";
		//menu_div.style.width=217+"px";
		//menu_div.style.marginLeft=active_menu.offsetLeft+0+"px";
		menu_div.style.width=936+"px"
		menu_div.style.marginLeft= zero_left_margin;
		menu_div.style.marginTop=active_menu.offsetTop+42+"px";
		
		if(active_menu.id=="kasa_grubu")
		{
			menu_div.style.width=936+"px";
			menu_div.style.marginTop=active_menu.offsetTop+42+"px";

		}
		
		var ul_element;
		var all_li_eelement;
		ul_element = active_menu.parentNode;
		all_li_eelement = ul_element.getElementsByTagName("li");
		

		
		var list_text = document.getElementById(active_menu.id+"_list").innerHTML;
		menu_div.innerHTML=list_text;
		menu_div.style.visibility="visible";
		
		if(navigator.appName=="Microsoft Internet Explorer")
		{
			menu_div.style.opacity=0.5;
			menu_div.style.filter='alpha(opacity=50)';
			
			var opinterval = setInterval(changeopacitiy,15);
			var op_count = 5;
		
			function changeopacitiy()
			{
				menu_div.style.opacity=op_count/10;
				menu_div.style.filter='alpha(opacity='+op_count*10+')';
				op_count++;
			
				if(op_count >10 )
				{
					clearInterval(opinterval);
					
				}
		
			}
		}
		
		
	}
	
	else
	{
		flag=null;
	}
	
	

}



function altdivshow(activesub)
{
flag="nonull";

active_menu_a_src.style.backgroundColor="RGB(0,0,0)";
document.getElementById("menu_div").style.visibility="visible";
}


function altdivhide(activesub)
{

active_menu_a_src.style.backgroundColor="";

flag=null;
document.getElementById("menu_div").style.visibility="hidden";



}


var active_aciklama, active_aciklama2, aciklama_open_div

function div_over(target)
{
	//aciklama_open_div = document.getElementById("aciklama_container");
	//active_aciklama2 = document.getElementById(target.id+"_aciklama2");
	
	//if (active_aciklama2.innerHTML !="")
	//{
	//	aciklama_open_div.innerHTML = active_aciklama2.innerHTML;	
	//	active_aciklama = document.getElementById(target.id);
	//	aciklama_open_div.style.marginLeft = 50+"px";
	//	aciklama_open_div.style.marginTop = active_aciklama.offsetTop-50+"px";
	//	aciklama_open_div.style.display = "block";	
	//}
	//else
	//{
	//}

	
	target.style.cursor = "pointer";
	target.style.borderColor = "#3399CC";
}

function div_out(target)
{
	target.style.borderColor="#FFFFFF";
	var aciklama_open_div = document.getElementById("aciklama_container");
	aciklama_open_div.style.display="none";
}



function as3()
{
	var my_location = document.location;
	return my_location.toString();
	
}

function arama()
{
	
	var en = document.getElementById("en").value;
	var boy = document.getElementById("boy").value;
	var kapasite = document.getElementById("kapasite").value;
	urun_grubu = document.getElementById("ana_grup").value;
	var urun_kodu ="";
	if(document.getElementById("urun_kodu"))
	{
		urun_kodu = document.getElementById("urun_kodu").value
	}
	var arama_tercihi = 0;
	if(document.getElementById("search_option")!=null)
		arama_tercihi = document.getElementById("search_option").value;

	document.location = "search.asp?en="+en+"&boy="+boy+"&kapasite="+kapasite+"&urun_grubu="+urun_grubu+"&arama_tercihi="+arama_tercihi+"&urun_kodu="+urun_kodu;
}
function arama_admin()
{
	
	var en = document.getElementById("en").value;
	var boy = document.getElementById("boy").value;
	var kapasite = document.getElementById("kapasite").value;
	var urun_grubu = document.getElementById("ana_grup").value;
	var arama_tercihi = 0;
	var ana_grup;
	if(document.getElementById("search_option")!=null)
	{
		arama_tercihi = document.getElementById("search_option").value;
		
	}	
	var redirect_location;
	var doc_location = document.URL;
	
	if (doc_location.search("edit_record.asp")!=-1)
		redirect_location = "edit_record.asp"
	else
		redirect_location = "default.asp"

	document.location = redirect_location+"?en="+en+"&boy="+boy+"&kapasite="+kapasite+"&urun_grubu="+urun_grubu+"&arama_tercihi="+arama_tercihi;
}

var scroll_y_pos = 0;

function admin_action(adres,product_id){ 
	
		var secilen = document.getElementById("active_id").innerHTML;
		var active_url;
		active_url="";
		//active_url = document.getElementById("active_url").value;
		

			if(adres=="delete_record")
			{
				var yanit = confirm("Kayıt kalıcı olarak silinecektir. Silmek istediğinizden emin misiniz?") 
				
				if(yanit)
				{
					document.location=adres +  '.asp?secim='+secilen+"&active_url="+active_url;
				}
				
				else
				{
				}
			}
			
			if(adres=="detayli_fiyatlar")
			{
				
				//play_video('detaylar','700', '300', 'mail_form', product_id);
				//document.location=adres +  '.asp?secim='+secilen+"&active_url="+active_url;
			}
			
			else
			{
				
			}
			
			
			if(adres=="montaj_kalibrasyon_ekle")
			{
				
				play_video('detaylar','700', '300', 'mail_form', product_id);
				//document.location=adres +  '.asp?secim='+secilen+"&active_url="+active_url;
			}
			
			if(adres=="maliyet_guncelle")
			{
				
				ajaxcommand("maliyet_guncelle", product_id);
				//play_video('guncelle','400', '300', 'mail_form', product_id);
				//document.getElementById("active_id").innerHTML = document.getElementById(product_id + "_").innerHTML;
				//scroll_y_pos = window.scrollY;
			}
			
			
			if(adres=="maliyet_guncelle_action")
			{
				
				var product_id = document.getElementById("product_id").value;
				ajaxcommand("maliyet_guncelle_action", product_id);
				//play_video('guncelle','400', '300', 'mail_form', product_id);
				//document.getElementById("active_id").innerHTML = document.getElementById(product_id + "_").innerHTML;
				//scroll_y_pos = window.scrollY;
			}
			
			
			
			else
			{
				
			}
			
			
		

	
	
}




function img_action()
{
	if(xmlHttp.readyState==4)
  		{
			if(xmlHttp.status == 200)
			{
					
				document.getElementById("img_ajax").innerHTML=xmlHttp.responseText;
					
			}
			else
			{

			}
		}
}

function img_navigate_over(img)
{
	img.style.cursor="pointer";
	//img.style.cursor="hand";
	img.style.borderColor="#3399CC";	
}

function img_navigate_out(img)
{

	img.style.borderColor="#CCC";	
}

function imgcheck(active_img_div)
{
	
		var win1 = null; 
	
		if(win1!=null && !win1.closed)
		{ 
			win1.close(); 
		} 
			
		win1 = window.open('upload.asp?',"Gorsel","width=300, height=305, top=0, scrollbars=0 ,menubar=0, location=0, status=no, toolbar=no"); 
		win1.focus();
		
	

	
}




function ajaxcommand(target,product_id)
{

	
	if (target == "maliyet_guncelle")
	{
	

		ajaxFunction();
		
		var list_type;
		list_type = document.getElementById("price_list_type").value;
		var url="../fiyat/guncelle_form.asp?update_product_id="+product_id+"&price_list_type="+list_type;	
		xmlHttp.open("GET",url,true);
		xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
		xmlHttp.onreadystatechange = open_products_update_window;
		xmlHttp.setRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT");
		xmlHttp.setRequestHeader("Connection", "close");
		xmlHttp.send(null);
		
	}
	
	if (target == "maliyet_guncelle_action")
	{
	

		ajaxFunction();
		var Maliyet_Fiyati = document.getElementById("Maliyet_Fiyati").value;
		var Kar_Orani1 = document.getElementById("Kar_Orani1").value;
		var Kar_Orani2 = document.getElementById("Kar_Orani2").value;
		var Kar_Orani3 = document.getElementById("Kar_Orani3").value;
		//var Mekanik_Maliyet = document.getElementById("Mekanik_Maliyet").value;
		//var Mekanik_Kar_Orani1 = document.getElementById("Mekanik_Kar_Orani1").value;
		//var Mekanik_Kar_Orani2 = document.getElementById("Mekanik_Kar_Orani2").value;
		//var Mekanik_Kar_Orani3 = document.getElementById("Mekanik_Kar_Orani3").value;
		//var para_birimi = document.getElementById("para_birimi").value;
		//var Agirlik = document.getElementById("Agirlik").value;
		alert(Maliyet_Fiyati);
		var url="../fiyat/guncelle_form.asp?update_action_id="+product_id+"&Maliyet_Fiyati="+Maliyet_Fiyati+"&Kar_Orani1="+Kar_Orani1+"&Kar_Orani2="+Kar_Orani2+"&Kar_Orani3="+Kar_Orani3+"&Mekanik_Maliyet="+Mekanik_Maliyet+"&Mekanik_Kar_Orani1="+Mekanik_Kar_Orani1+"&Mekanik_Kar_Orani2="+Mekanik_Kar_Orani2+"&Mekanik_Kar_Orani3="+Mekanik_Kar_Orani3+"&para_birimi="+para_birimi+"&Agirlik="+Agirlik;	
		xmlHttp.open("GET",url,true);
		xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
		xmlHttp.onreadystatechange = open_products_update_action_window;
		xmlHttp.setRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT");
		xmlHttp.setRequestHeader("Connection", "close");
		xmlHttp.send(null);
		
	}
	
	

}

function open_products_update_window()
{
		
		var target_area = document.getElementById("guncelle_container");
		if(xmlHttp.readyState==1)
		{

		}
		if(xmlHttp.readyState==4)
  		{
			
			if(xmlHttp.status == 200)
			{
					target_area.innerHTML ="";
					target_area.innerHTML=xmlHttp.responseText;
					play_video('guncelle','900', '550', 'mail_form', "");
					//document.getElementById("active_id").innerHTML = document.getElementById(product_id + "_").innerHTML;
					scroll_y_pos = window.scrollY;
			}
			else
			{
				
			}
		}	

}


function open_products_update_action_window()
{
		
		if(xmlHttp.readyState==1)
		{

		}
		if(xmlHttp.readyState==4)
  		{
			
			if(xmlHttp.status == 200)
			{
					
					if (xmlHttp.responseText == "ok")
					{
						my_video_hide();
						scroll_y_pos = window.scrollY;
					}
			}
			else
			{
				
			}
		}	

}





function ana_katagori_islem(target)
{
	var url=null, selected_item, action, item_no, item_name_tr, item_name_eng; 
	switch(target)
	{
	case "ana_katagori_sil" :

			action = "delete_ana_katagori"
			selected_item = document.getElementById("ana_grup_id").value;
			document.getElementById("update_part").style.display="none";
			document.getElementById("add_part").style.display="none";
			if(selected_item=="")
			{
				alert("Önce bir ana katagori öğesi seçiniz");
			}
			else
			{
				if(document.getElementById("alt_grup_id").length>0)
				{
					alert("Silmek istediğiniz ana katagoriye bağlı alt katogoriler bulunmaktadır. Ana katagoriyi silmek için önce alt katagorileri silinmelidir.")
				}
				else
				{
					var yanit = confirm("Kayıt kalıcı olarak silinecektir. Silmek istediğinizden emin misiniz?"); 
				
					if(yanit)
					{
						url = "../ick/menu_action.asp?selected_item="+encodeURI(selected_item)+"&action="+encodeURI(action);					

					}
				
					else
					{
					}
				}

			}
	

		break;
	case "ana_katagori_ekle" :
			if(document.getElementById("update_part").style.display=="block")
			{
				document.getElementById("update_part").style.display="none";
			}
			if(document.getElementById("add_part").style.display!="block") 
			{
				document.getElementById("add_part").style.display="block";
			}
		break;
	case "ana_katagori_guncelle" :
			
			selected_item = document.getElementById("ana_grup_id").value;

			if(selected_item=="")
			{
				alert("Önce bir ana katagori öğesi seçiniz");
			}
			else
			{
				if(document.getElementById("add_part").style.display != "none")
				{
					document.getElementById("add_part").style.display="none";
				}
				if(document.getElementById("update_part").style.display!="block") 
				{
					document.getElementById("update_part").style.display="block";
				}
				var item_name, item_name_tr, item_sira; 
					item_name_tr = document.getElementById("update_ana_katagori_tr");
					item_sira = document.getElementById("update_ana_katagori_sira");
					item_name = document.getElementById("ana_grup_id")[document.getElementById("ana_grup_id").selectedIndex].innerHTML.split("&nbsp;&gt;&gt;&nbsp;");
					
					item_sira.value = item_name[0];
					item_name_tr.value = item_name[1];
			}
		break;
	
	case "ekle" :
	{
	
		action = "anakatagori_ekle";
		selected_item = document.getElementById("ana_grup_id").value;
		item_no = document.getElementById("ana_katagori_sira").value; 
		item_name_tr = document.getElementById("ana_katagori_tr").value;
		if(item_no !="" & item_name_tr!="")
			url = "../ick/menu_action.asp?selected_item="+encodeURI(selected_item)+"&action="+encodeURI(action)+"&item_no="+encodeURI(item_no)+"&item_name_tr="+encodeURI(item_name_tr);
		else
			alert("Eklemek istediğiniz Anakatagori öğesiyle ilgilii tüm bilgileri giriniz");
		break;		
	}
	
	case "guncelle" :
	{
		action = "anakatagori_guncelle";
		
		selected_item = document.getElementById("ana_grup_id").value;		 
		item_no = document.getElementById("update_ana_katagori_sira").value;	
		item_name_tr = document.getElementById("update_ana_katagori_tr").value;
		alert(item_name_tr);
		if(item_no !="" & item_name_tr!="")
			url = "../ick/menu_action.asp?selected_item="+encodeURI(selected_item)+"&action="+encodeURI(action)+"&item_no="+encodeURI(item_no)+"&item_name_tr="+encodeURI(item_name_tr);
		else
			alert("Güncellemek istediğiniz Anakatagori öğesiyle ilgilii tüm bilgileri giriniz");			
		break;
	}
	
	default :	
	}
	if(url!=null)
	{	
			ajaxFunction();
			xmlHttp.open("GET",url,true);
			xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
			xmlHttp.onreadystatechange = menu_action_result;
			xmlHttp.setRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT");
			xmlHttp.setRequestHeader("Connection", "close");
			xmlHttp.send(null);
	}
}


function menu_action_result()
{
	
	if (xmlHttp.status == 200) 
	{
		document.getElementById("add_input").innerHTML = xmlHttp.responseText;

	}
}


function alt_katagori_islem(target)
{
	var url = null, alt_selected_item, alt_action, alt_item_no, alt_item_name_tr; 
	switch(target)
	{
	case "alt_katagori_sil" :

			alt_action = "delete_alt_katagori";
			alt_selected_item = document.getElementById("alt_grup_id").value;
			ana_selected_item = document.getElementById("ana_grup_id").value;
			document.getElementById("alt_update_part").style.display="none";
			document.getElementById("alt_add_part").style.display="none";
			if(alt_selected_item=="")
			{
				alert("Önce bir alt katagori öğesi seçiniz");
			}
			else
			{


					var yanit = confirm("Kayıt kalıcı olarak silinecektir. Silmek istediğinizden emin misiniz?"); 
					if(yanit)
					{
						url = "../ick/menu_action.asp?selected_item="+encodeURI(alt_selected_item)+"&ana_selected_item="+encodeURI(ana_selected_item)+"&action="+encodeURI(alt_action);						
					}
					else
					{
					}
			}	
	

		break;
	case "alt_katagori_ekle" :
			if(! document.getElementById("ana_grup_id").value)
			{
				alert("Alt katagori eklemek için once alt katagorinin ekleneceği ana katagoriyi seçiniz");
			}
			else
			{
				if(document.getElementById("alt_add_part").style.display!="block") 
				{
					document.getElementById("alt_add_part").style.display="block";
				}
			
			}
			if(document.getElementById("alt_update_part").style.display=="block")
			{
				document.getElementById("alt_update_part").style.display="none";
			}
			
		break;
	case "alt_katagori_guncelle" :
			
			alt_selected_item = document.getElementById("alt_grup_id").value;

			if(alt_selected_item=="")
			{
				alert("Önce bir alt katagori öğesi seçiniz");
			}
			else
			{
				if(document.getElementById("alt_add_part").style.display != "none")
				{
					document.getElementById("alt_add_part").style.display="none";
				}
				if(document.getElementById("alt_update_part").style.display!="block") 
				{
					document.getElementById("alt_update_part").style.display="block";
				}
				var alt_item_name, alt_item_name_tr, alt_item_sira; 
					alt_item_name_tr = document.getElementById("update_alt_katagori_tr");
					
					alt_item_sira = document.getElementById("update_alt_katagori_sira");
					alt_item_name = document.getElementById("alt_grup_id")[document.getElementById("alt_grup_id").selectedIndex].innerHTML.split("&nbsp;&gt;&gt;&nbsp;");
					alt_item_sira.value = alt_item_name[0];
					alt_item_name_tr.value = alt_item_name[1];
					
			}
		break;
	
	case "alt_ekle" :
	{
	
		alt_action = "altkatagori_ekle";
		ana_selected_item = document.getElementById("ana_grup_id").value;
		alt_selected_item = document.getElementById("alt_grup_id").value;
		alt_item_no = document.getElementById("alt_katagori_sira").value; 
		alt_item_name_tr = document.getElementById("alt_katagori_tr").value;

		if(alt_item_no !="" & alt_item_name_tr!="")
		url = "../ick/menu_action.asp?selected_item="+encodeURI(alt_selected_item)+"&ana_selected_item="+encodeURI(ana_selected_item)+"&action="+encodeURI(alt_action)+"&item_no="+encodeURI(alt_item_no)+"&item_name_tr="+encodeURI(alt_item_name_tr);
		else
			alert("Eklemek istediğiniz alt katagori öğesiyle ilgilii tüm bilgileri giriniz");


		break;		
	}
	
	case "alt_guncelle" :
	{
		alt_action = "altkatagori_guncelle";
		ana_selected_item = document.getElementById("ana_grup_id").value;
		alt_selected_item = document.getElementById("alt_grup_id").value;
		alt_item_no = document.getElementById("update_alt_katagori_sira").value; 
		alt_item_name_tr = document.getElementById("update_alt_katagori_tr").value;

		if(alt_item_no !="" & alt_item_name_tr!="")
		url = "../ick/menu_action.asp?selected_item="+encodeURI(alt_selected_item)+"&ana_selected_item="+encodeURI(ana_selected_item)+"&action="+encodeURI(alt_action)+"&item_no="+encodeURI(alt_item_no)+"&item_name_tr="+encodeURI(alt_item_name_tr);
		else
			alert("Güncellemek istediğiniz alt katagori öğesiyle ilgili tüm bilgileri giriniz");			

		break;
	}
	
	default :	
	}

	if(url!=null)
	{	
			ajaxFunction();
			xmlHttp.open("GET",url,true);
			xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
			xmlHttp.onreadystatechange = menu_action_result_sub;
			xmlHttp.setRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT");
			xmlHttp.setRequestHeader("Connection", "close");
			xmlHttp.send(null);
	}

}

function menu_action_result_sub()
{
	
	if (xmlHttp.status == 200) 
	{
		
		document.getElementById("alt_grup_add").innerHTML = xmlHttp.responseText;
	}
}

