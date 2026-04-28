
function OpenPriceDiv(div){
	var open_div = document.getElementById("extra_div_container");
		
		if(open_div.style.display != "none"){
				open_div.style.display ="none";			
			}
		else{
				open_div.style.display ="block";
			
			}
	
	}


function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}


function formatMyMoney(price) {
  
  var currency_symbol = "₺"

  var formattedOutput = new Intl.NumberFormat('tr-TR', {
      style: 'currency',
      currency: 'TRY',
      minimumFractionDigits: 3,
    });

  return formattedOutput.format(price).replace(currency_symbol, '')
}




function fiyat_hesapla(kar_marji)
{
	if(kar_marji != "")
	{
		var toplam_maliyet = document.getElementById("Toplam_Maliyet_Hidden").value;
		var para_birimi = document.getElementById("Para_Birimi_").value;
		var usd_satis_kur = document.getElementById("dolar_satis").value;
		var eur_satis_kur = document.getElementById("euro_satis").value;
		var target_price_field_usd = document.getElementById("Fiyat_Liste_USD_4");
		var target_price_field_eur = document.getElementById("Fiyat_Liste_EUR_4");
		var target_price_field_tl = document.getElementById("Fiyat_Liste_TL_4");

		var target_price = (toplam_maliyet*100)/(100-kar_marji);
			
		var usd_cevir;
		var tl_cevir;
		var eur_cevir;

		if (para_birimi == "$")
		{
			usd_cevir = 1;
			tl_cevir = usd_satis_kur;
			eur_cevir = usd_satis_kur/eur_satis_kur;
		}
		
		else if (para_birimi == "€")
		{
			usd_cevir = eur_satis_kur/usd_satis_kur;
			tl_cevir = eur_satis_kur;
			eur_cevir = 1;
		}
		else if (para_birimi == "TL")
		{ 
			usd_cevir = usd_satis_kur;
			tl_cevir = 1;
			eur_cevir = eur_satis_kur;
		}
		
		
		target_price_field_usd.value = formatNumbervyz(Math.round((usd_cevir*target_price)));
		target_price_field_eur.value = formatNumbervyz(Math.round((eur_cevir*target_price)));
		target_price_field_tl.value = formatNumbervyz(Math.round((tl_cevir*target_price)));
	
	}
}

function formatNumbervyz(num) {
  return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
}


function numberWithCommas(x) {
    var parts = x.toString().split(".");
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    return parts.join(".");
}

function virgul_nokta_sil(metin)
{
 	metin.replace(/[^0-9]/g,'');
	return metin;
}

function kar_marji_hesaplama(fiyat)
{
	if(fiyat != "")
	{

		var enter_fiyat = document.getElementById(fiyat).value;
		//enter_fiyat = numberWithCommas(enter_fiyat);
		enter_fiyat = virgul_nokta_sil(enter_fiyat);
		var toplam_maliyet = document.getElementById("Toplam_Maliyet_Hidden").value;
		var para_birimi = document.getElementById("Para_Birimi_").value;

		
		var usd_satis_kur = document.getElementById("dolar_satis").value;
		var eur_satis_kur = document.getElementById("euro_satis").value;
			
		var usd_cevir;
		var tl_cevir;
		var eur_cevir;
		var kar_marji;
		
		if (fiyat == "Fiyat_Liste_TL_4")
		{
			
			if (para_birimi == "$")
			{
				kar_marji = (enter_fiyat - (toplam_maliyet*usd_satis_kur))/(enter_fiyat);
			}
			
			else if (para_birimi == "€")
			{
				kar_marji = (enter_fiyat - (toplam_maliyet*eur_satis_kur))/(enter_fiyat);
			}
			else if (para_birimi == "TL")
			{ 
				kar_marji = (enter_fiyat - toplam_maliyet)/(enter_fiyat);
			}
			
		}
		
		else if (fiyat == "Fiyat_Liste_EUR_4")
		{
			if (para_birimi == "$")
			{
				kar_marji = (enter_fiyat - (toplam_maliyet*(usd_satis_kur/eur_satis_kur)))/(enter_fiyat);
			}
			
			else if (para_birimi == "€")
			{
				kar_marji = (enter_fiyat - toplam_maliyet)/(enter_fiyat);
			}
			else if (para_birimi == "TL")
			{ 
				kar_marji = (enter_fiyat - (toplam_maliyet*eur_satis_kur))/(enter_fiyat);
			}
		}
		else if (fiyat == "Fiyat_Liste_USD_4")
		{ 
			if (para_birimi == "$")
			{
				kar_marji = (enter_fiyat - toplam_maliyet)/(enter_fiyat);
			}
			
			else if (para_birimi == "€")
			{
				kar_marji = (enter_fiyat - (toplam_maliyet*(eur_satis_kur/usd_satis_kur)))/(enter_fiyat);
			
			}
			else if (para_birimi == "TL")
			{ 
				kar_marji = (enter_fiyat - (toplam_maliyet*eur_satis_kur))/(enter_fiyat);
			}
		}
		

		

		//target_price_field_usd.value = (usd_cevir*target_price).toFixed(3);
		
		//var Fiyat_Liste_4 = document.getElementById("Fiyat_Liste_USD_4");
	
		var target_field = document.getElementById("Kar_Orani4");
		target_field.value = (kar_marji*100).toFixed(0);
		fiyat_hesapla((kar_marji*100));
		//Fiyat_Liste_4.value =  para_birimi +" "+fiyat;
	}
	else
	{
		
	}
}





function adjust_list(element)
{
	var checked_element = document.getElementById(element);
	
	if (checked_element.checked)
	{ 
		adjust_liste("maliyet_liste")
	}
	else
	{
		adjust_liste("fiyat_liste")	
	}
}



function adjust_liste(task)
{
	var url_list_type = getParameterByName("list");
	var hide_maliyet_element = getElementsByClassName(document,"div","fiyat_maliyet");
	var hide_tavsiye_element = getElementsByClassName(document,"div","fiyat_tavsiye");
	var hide_son_element = getElementsByClassName(document,"div","fiyat_son");
	var liste_fiyati = getElementsByClassName(document,"div","fiyat_liste");
	var maliyet_fiyati = getElementsByClassName(document,"div","fiyat_maliyet");
	var aciklama = getElementsByClassName(document,"div","aciklama1");
	var aciklama2 = getElementsByClassName(document,"div","aciklama2");
	var olculer = getElementsByClassName(document,"div","olculer");
	var olculer2 = getElementsByClassName(document,"div","olculer2");
	var kapasite = getElementsByClassName(document,"div","kapasite");
	//var right_container = getElementsByClassName(document,"div","right_container");
	//var left_container = getElementsByClassName(document,"div","right_container");
	var model_kodu = getElementsByClassName(document,"div","model_kodu");
	var kar_marjlari = getElementsByClassName(document,"span","kar_marjlari");
	var language = document.getElementById("language_type").value;
	var user_type = document.getElementById("user_type").value;
	//var fiyat_title_container = getElementsByClassName(document,"div","fiyat_title_container");
	
	
	var price_list_type = document.getElementById("price_list_type").value;
	

		if (task =="fiyat_liste")
		{
			
			for(var i=0; i<hide_maliyet_element.length;i++)
			{
					hide_maliyet_element[i].style.display="none";  //Tüm Katagorilerde Maliyet verilerini gizle 
			}
		
	
	
			for(var i=0; i<hide_tavsiye_element.length;i++)
			{
					if (price_list_type == 1 || price_list_type == 2) 
						hide_tavsiye_element[i].style.display="none"; //Eğer Fiyat Listesi veya Mekanik Fiyat Listesi Seçili ise Tavsiye Fiyatları gizle sadece Liste Fiyatını Göster//
						 
					else
						hide_tavsiye_element[i].style.display="none";	//Eğer Bayi Fiyat Listeleri seçili ise Tavsiye Fiyatları (Bayi Alış) Göster//
			}
	
			/****/
			for(var i=0; i<hide_son_element.length;i++)
			{
					if (price_list_type == 1 || price_list_type == 2)
						hide_son_element[i].style.display="none";  //Eğer Fiyat Listesi veya Mekanik Fiyat Listesi Seçili ise Son Satış Fiyatlarını gizle //
					else
						hide_son_element[i].style.display="none"; //Eğer Bayi Fiyat Listeleri seçili ise Son Satış Fiyatını Göster//		
			}
			/****/
			
			
			for(var i=0; i<kar_marjlari.length;i++)
			{
					kar_marjlari[i].style.display="none"; //Tüm Katagorilerde Marjları gizle 
			}
	
		
			for(var i=0; i<model_kodu.length;i++)
			{
					model_kodu[i].style.width="25%"; //Model Kodu kolonu genişliğini arttır 
			}
			
			for(var i=0; i<aciklama.length;i++)
			{
						if (price_list_type == 3 || price_list_type == 4 || price_list_type == 5)
							aciklama[i].style.width="30%"; //Bayi Listellerinde aciklama kolonunu arttır
						else
							aciklama[i].style.width="30%"; //Fiyat ve Mekanik Fiyat Listellerinde aciklama kolonunu ayarla
			}
			
			for(var i=0; i<aciklama2.length;i++)
			{
						if (price_list_type == 3 || price_list_type == 4 || price_list_type == 5)					
							aciklama2[i].style.width="40%";
						else
							aciklama2[i].style.width="40%";
						
			}
			
			for(var i=0; i<kapasite.length;i++)
			{
					kapasite[i].style.width="20%";
			}
			
			for(var i=0; i<olculer.length;i++)
			{
					if (price_list_type == 3 || price_list_type == 4 || price_list_type == 5)
						olculer[i].style.width="25%";
					else
						olculer[i].style.width="30%";	
			}
			
			for(var i=0; i<olculer2.length;i++)
			{
						if (price_list_type == 3 || price_list_type == 4 || price_list_type == 5)
							olculer2[i].style.width="41%";
						else
							olculer2[i].style.width="39%";
						
			}
			
			for(var i=0; i<liste_fiyati.length;i++)
			{
					if (price_list_type == 3 || price_list_type == 4 || price_list_type == 5)
						liste_fiyati[i].style.width="20%";
					else
						liste_fiyati[i].style.width="25%";
						
			}
	
			
			if (price_list_type == 1 || price_list_type == 2)
			{
				if (language == 2)
				{
					document.getElementById("list_type").innerHTML = "Price List";
					document.getElementById("top_title").innerHTML = "Price List";
				}
				else
				{
					document.getElementById("list_type").innerHTML = "Fiyat Listesi";
					document.getElementById("top_title").innerHTML = "Fiyat Listesi";
				
				}
				
			}
			else
			{
				if (price_list_type == 3 || price_list_type == 5) 
				{
					
					if (language == 2)
					{
						document.getElementById("list_type").innerHTML = "Dealer Price List <br> (Products)";
						document.getElementById("top_title").innerHTML = "Dealer Price List";
					}
					else
					{
						document.getElementById("list_type").innerHTML = "Bayi Fiyat Listesi <br> (Ürunler)";
						document.getElementById("top_title").innerHTML = "Bayi Fiyat Listesi";
					
					}
					

				}
				else
				{
					if (language == 2)
					{
						document.getElementById("list_type").innerHTML = "Dealer Price List <br> (Spare Parts)";
						document.getElementById("top_title").innerHTML = "Dealer Price List";
					}
					else
					{
						document.getElementById("list_type").innerHTML = "Bayi Fiyat Listesi<br>(Yedek Parça)";
						document.getElementById("top_title").innerHTML = "Bayi Fiyat Listesi";
					
					}
				
				}
			}
		}
		
		
		else if(task == "maliyet_liste")
		{
		
			
			for(var i=0; i<hide_maliyet_element.length;i++)
			{
					if (price_list_type == 1 || price_list_type == 2)
						hide_maliyet_element[i].style.display="";
					else
						hide_maliyet_element[i].style.display="block";	
			}
	
			for(var i=0; i<hide_tavsiye_element.length;i++)
			{
					if (price_list_type == 1 || price_list_type == 2)
						hide_tavsiye_element[i].style.display="";
					else
						hide_tavsiye_element[i].style.display="block";
			}
	
			for(var i=0; i<hide_son_element.length;i++)
			{
					hide_son_element[i].style.display="";
			}
			

		
			for(var i=0; i<model_kodu.length;i++)
			{
					model_kodu[i].style.width="";
			}
			
			for(var i=0; i<aciklama.length;i++)
			{
					aciklama[i].style.width="";
			}
			
			for(var i=0; i<aciklama2.length;i++)
			{
						aciklama2[i].style.width="";
			}
			
			
			
			for(var i=0; i<kapasite.length;i++)
			{
					kapasite[i].style.width="";
			}
			
			for(var i=0; i<olculer.length;i++)
			{
					olculer[i].style.width="";
			}
			
				for(var i=0; i<olculer2.length;i++)
			{
					olculer2[i].style.width="";
			}
			

		
			for(var i=0; i<liste_fiyati.length;i++)
			{
					if (price_list_type == 1 || price_list_type == 2)
					{
						liste_fiyati[i].style.width="";

					}
					else
					{
						liste_fiyati[i].style.width="18%";
					}
					
					liste_fiyati[i].style.float="";
			}

			
					
				for(var i=0; i<maliyet_fiyati.length;i++)
			{
					if (price_list_type == 3 || price_list_type == 4 || price_list_type == 5)
					{
						maliyet_fiyati[i].style.width="18%";
					}
			}
			
		
			if (price_list_type == 1 || price_list_type == 2)
			{
			
				if (user_type == 2)
				{
					if (language == 2)
					{
						document.getElementById("list_type").innerHTML = "Price List with Cost";
						document.getElementById("top_title").innerHTML = "Price List with Cost";
					}
					else
					{
						document.getElementById("list_type").innerHTML = "Maliyetli Fiyat Listesi";
						document.getElementById("top_title").innerHTML = "Maliyetli Fiyat Listesi";
						
					}
		
				}
				
				else
				{				
					if (language == 2)
					{
						document.getElementById("list_type").innerHTML = "Price List with Breakdown";
						document.getElementById("top_title").innerHTML = "Price List with Breakdown";
					}
					else
					{
						document.getElementById("list_type").innerHTML = "Kırılımlı Fiyat Listesi";
						document.getElementById("top_title").innerHTML = "Kırılımlı Fiyat Listesi";
						
					}
				}
				
			
			}
			else
			{		
			
				if (user_type == 2)
				{
				
					if (language == 2)
					{
						document.getElementById("list_type").innerHTML = "Dealer Price List with Cost";
						document.getElementById("top_title").innerHTML = "Dealer Price List with Cost";
					}
					else
					{
						document.getElementById("list_type").innerHTML = "Maliyetli Bayi Fiyat Listesi";
						document.getElementById("top_title").innerHTML = "Maliyetli Bayi Fiyat Listesi";
					}
				}
				else
				
				{
					if (language == 2)
					{
						document.getElementById("list_type").innerHTML = "Dealer Price List with Breakdown";
						document.getElementById("top_title").innerHTML = "Dealer Price List with Breakdown";
					}
					else
					{
						document.getElementById("list_type").innerHTML = "Bayi Fiyat Listesi (Ürünler)";
						document.getElementById("top_title").innerHTML = "Kırılımlı Bayi Fiyat Listesi";
					}
				}
			
			
			
			}
			
			for(var i=0; i<kar_marjlari.length;i++)
			{
					kar_marjlari[i].style.display="";
			}
		
		
		}
		
		
		else if(task == "kirilim_liste")
		{
			
			for(var i=0; i<hide_maliyet_element.length;i++)
			{
					if (price_list_type == 1|| price_list_type == 2)
						hide_maliyet_element[i].style.display="none";
					else
						hide_maliyet_element[i].style.display="none";	
			}
	
			for(var i=0; i<hide_tavsiye_element.length;i++)
			{
					if (price_list_type == 1 || price_list_type == 2)
						hide_tavsiye_element[i].style.display="block";
					else
						hide_tavsiye_element[i].style.display="block";
			}
	
			for(var i=0; i<hide_son_element.length;i++)
			{
					hide_son_element[i].style.display="block";
			}
			

		
			for(var i=0; i<model_kodu.length;i++)
			{
					model_kodu[i].style.width="";
			}
			
			for(var i=0; i<aciklama.length;i++)
			{
					aciklama[i].style.width="";
			}
			
			for(var i=0; i<aciklama2.length;i++)
			{
						aciklama2[i].style.width="";
			}
			
			
			
			for(var i=0; i<kapasite.length;i++)
			{
					kapasite[i].style.width="";
			}
			
			for(var i=0; i<olculer.length;i++)
			{
					olculer[i].style.width="";
			}
			
				for(var i=0; i<olculer2.length;i++)
			{
					olculer2[i].style.width="";
			}
			

		
			for(var i=0; i<liste_fiyati.length;i++)
			{
					if (price_list_type == 1 || price_list_type == 2)
					{
						liste_fiyati[i].style.width="";

					}
					else
					{
						liste_fiyati[i].style.width="18%";
					}
					
					liste_fiyati[i].style.float="";
			}

			
					
				for(var i=0; i<maliyet_fiyati.length;i++)
			{
					if (price_list_type == 1 || price_list_type == 3 || price_list_type == 4 || price_list_type == 5)
					{
						//maliyet_fiyati[i].style.width="18%";
						
					}
			}
			
		
			if (price_list_type == 1 || price_list_type == 2)
			{
			
				if (user_type == 2)
				{
					if (language == 2)
					{
						document.getElementById("list_type").innerHTML = "Price List with Breakdown";
						document.getElementById("top_title").innerHTML = "Price List with Breakdown";
					}
					else
					{
						document.getElementById("list_type").innerHTML = "Kırılımlı Fiyat Listesi";
						document.getElementById("top_title").innerHTML = "Kırılımlı Fiyat Listesi";
						
					}
		
				}
				
				else
				{				
					if (language == 2)
					{
						document.getElementById("list_type").innerHTML = "Price List with Breakdown";
						document.getElementById("top_title").innerHTML = "Price List with Breakdown";
					}
					else
					{
						document.getElementById("list_type").innerHTML = "Kırılımlı Fiyat Listesi";
						document.getElementById("top_title").innerHTML = "Kırılımlı Fiyat Listesi";
						
					}
				}
				
			
			}
			else
			{		
			
				if (user_type == 2)
				{
				
					if (language == 2)
					{
						document.getElementById("list_type").innerHTML = "Dealer Price List with Breakdown(Products)";
						document.getElementById("top_title").innerHTML = "Dealer Price List with Breakdown(Products)";
					}
					else
					{
						document.getElementById("list_type").innerHTML = "Kırılımlı Bayi Fiyat Listesi (Ürünler)";
						document.getElementById("top_title").innerHTML = "Kırılımlı Bayi Fiyat Listesi (Ürünler)";
					}
				}
				else
				
				{
					if (language == 2)
					{
						document.getElementById("list_type").innerHTML = "Dealer Price List with Breakdown(Products)";
						document.getElementById("top_title").innerHTML = "Dealer Price List with Breakdown (Products)";
					}
					else
					{
						document.getElementById("list_type").innerHTML = "Kırılımlı Bayi Fiyat Listesi (Ürünler)";
						document.getElementById("top_title").innerHTML = "Kırılımlı Bayi Fiyat Listesi (Ürünler)";
					}
				}
			
			
			
			}
			
			for(var i=0; i<kar_marjlari.length;i++)
			{
					kar_marjlari[i].style.display="none";
			}
		
		
		}
		
		
	
	
	}


function yazdir() {
  generateTableOfContents();
  setTimeout(function() {
    window.print();
  }, 300); // DOM güncellenmesi için bekle
}


	
function isaretle(target)
{
target.parentNode.style.cursor = "pointer";
target.parentNode.style.borderColor = "#3399CC";
}


function printed_elements(target)
{
	//document.getElementById("").style.display="none";
	
	//target.parentNode.style.display="none";
	
	
	if(target.className=="fa fa-eye-slash")
	{
		target.setAttribute("class", "fa fa-eye");
		
		var my_className;
		
		if (target.parentNode.className == "cizim_adi"|| target.parentNode.className == "cizim_bosluk")
		{
			my_className =  target.parentNode.parentNode.className;
			my_className = my_className + " my_hidden_div";
			target.parentNode.parentNode.setAttribute("class", my_className);
			target.parentNode.parentNode.style.opacity="0.2";
		}
		else
		{
			my_className =  target.parentNode.className;
			my_className = my_className + " my_hidden_div";
			target.parentNode.setAttribute("class", my_className);
			target.parentNode.style.opacity="0.2";
		}	
		

		return;
	}

	if(target.className=="fa fa-eye")
	{
		target.setAttribute("class", "fa fa-eye-slash");
		
		var my_className;
		
		if (target.parentNode.className == "cizim_adi"|| target.parentNode.className == "cizim_bosluk")
		{
			my_className =  target.parentNode.parentNode.className;
			my_className = my_className.replace(" my_hidden_div", "");
			target.parentNode.parentNode.setAttribute("class", my_className);
			target.parentNode.parentNode.style.opacity="1";
		}
		else
		{
			my_className =  target.parentNode.className;
			my_className = my_className.replace(" my_hidden_div", "");
			target.parentNode.setAttribute("class", my_className);
			target.parentNode.style.opacity="1";
		}	
				
		
		return;
	}
	
	
	var urun_div = getElementsByClassName(target.parentNode.parentNode.parentNode,"div","cizim_adi"); //banner div leri diziye aktarılıyor.
	

	
	for(var i=0; i<getElementsByClassName("cizim_adi").length; i++)
	{
			//document.getElementsByClassName("cizim_adi").item(i);	
	}
//	alert(document.getElementsByClassName("cizim_adi").length);

}


/*
function print_list()
{
	document.getElementById("admin_menu_div").style.display="none";
	
	
	var listed_product = getElementsByClassName(loaded_area,"div","anakat_adi");
	var products = ""
	
	for(var i=0; i<listed_product.length;i++)
	{
			
				products =  products + listed_product[i].innerHTML + "<br>";
	}
	
	
		document.getElementById("title_products").innerHTML = products;
		document.getElementById("kapak_sayfasi").style.display="block";
	
	
	
	
	
	
	var hide_div = getElementsByClassName(body_text,"div","main_cat_select");
	
	for(var i=0; i<hide_div.length;i++)
	{
			
				hide_div[i].style.display="none";
	}
	
	
	var hide_div_2 = getElementsByClassName(top_div,"div","main_menu");
	for(var i=0; i<hide_div_2.length;i++)
	{
			
				hide_div_2[i].style.display="none";
	}
	
	
	
	
	print();

	document.getElementById("admin_menu_div").style.display="block";
	for(var j=0; j<hide_div.length;j++)
	{
			
				hide_div[j].style.display="block";
	}
	
	for(var j=0; j<hide_div_2.length;j++)
	{
			
				hide_div_2[j].style.display="block";
	}

	document.getElementById("kapak_sayfasi").style.display="none";
	//document.getElementById("kapak_sayfasi").innerHTML="";
}
*/
function downloading_product(selected_target)
{
	var price_list_type = document.getElementById("price_list_type").value;
	var language = document.getElementById("language_type").value;
	var cur = document.getElementById("cur_type").value;
	var parity = document.getElementById("parity_type").value;
	
	
	var sdp = document.getElementById("sdp_type") ? document.getElementById("sdp_type").value : null;
var sdm = document.getElementById("sdm_type") ? document.getElementById("sdm_type").value : null;
var sds = document.getElementById("sds_type") ? document.getElementById("sds_type").value : null;
var sip = document.getElementById("sip_type") ? document.getElementById("sip_type").value : null;
var sim = document.getElementById("sim_type") ? document.getElementById("sim_type").value : null;
var sis = document.getElementById("sis_type") ? document.getElementById("sis_type").value : null;	
	
switch(selected_target.id)
	{
		
		case  "main_cat_select" :
		{
			
				document.getElementById("selected_title").innerHTML= selected_target.options[selected_target.selectedIndex].innerHTML;
				url = trim("downloadajax.asp?akno="+selected_target.options[selected_target.selectedIndex].value+"&price_list_type="+price_list_type+"&lng="+language+"&cur="+cur+"&parity="+parity+"&sdp="+sdp+"&sdm="+sdm+"&sds="+sds+"&sip="+sip+"&sim="+sim+"&sis="+sis);
				target_area = document.getElementById("load_select_result");
				target_area_2 = document.getElementById("loaded_area");
				document.getElementById("loaded_area").innerHTML="";
				document.getElementById("kapasite_select_result").innerHTML="";


				break;
			
		}
	
		case "products_select":
		{
			url = trim("downloadajax.asp?product_id="+selected_target.options[selected_target.selectedIndex].value+"&price_list_type="+price_list_type+"&lng="+language+"&cur="+cur+"&parity="+parity+"&sdp="+sdp+"&sdm="+sdm+"&sds="+sds+"&sip="+sip+"&sim="+sim+"&sis="+sis);
			target_area = document.getElementById("loaded_area");
			target_area_3 = document.getElementById("kapasite_select_result");
			document.getElementById("loaded_area").innerHTML="";
			document.getElementById("kapasite_select_result").innerHTML="";
			break;
			
		}
		
		case "kapasite_select":
		{
			
			var product_id = document.getElementById("kapasite_product_id").value;
			url = trim("downloadajax.asp?product_id="+product_id+"&kapasite_id="+selected_target.options[selected_target.selectedIndex].value+"&price_list_type="+price_list_type+"&lng="+language+"&cur="+cur+"&parity="+parity+"&sdp="+sdp+"&sdm="+sdm+"&sds="+sds+"&sip="+sip+"&sim="+sim+"&sis="+sis);
			target_area = document.getElementById("loaded_area");
			document.getElementById("loaded_area").innerHTML="";
			break;
			
		}
		
		case "bolge_sec":
		{
			var prdc_id = +document.getElementById("active_id").innerHTML;
			
			
			url = trim("detaylifiyatajax.asp?add_price="+selected_target.options[selected_target.selectedIndex].value+"&product_id="+prdc_id+"&price_list_type="+price_list_type+"&lng="+language+"&cur="+cur+"&parity="+parity+"&sdp="+sdp+"&sdm="+sdm+"&sds="+sds+"&sip="+sip+"&sim="+sim+"&sis="+sis);			
			target_area = document.getElementById("montajli_fiyat");
			document.getElementById("montajli_fiyat").innerHTML="";
			break;
		}
		
		case "damga_montaj_select":
		{
			/*var product_id = document.getElementById("kapasite_product_id").value;
			url = trim("downloadajax.asp?product_id="+product_id+"&kapasite_id="+selected_target.options[selected_target.selectedIndex].value+"add_price="+);
			target_area = document.getElementById("loaded_area");
			document.getElementById("loaded_area").innerHTML="";
			*/
			break;
		
		
		}
		
		
		case "cur_type":
		{
			
				
/*				var sselected = document.getElementById("main_cat_select");
				alert(selected_target.id);
				url = trim("downloadajax.asp?akno="+sselected.options[selected_target.selectedIndex].value+"&price_list_type="+price_list_type+"&lng="+language+"&cur="+cur+"&parity="+parity+"&sdp="+sdp+"&sdm="+sdm+"&sds="+sds);
				target_area = document.getElementById("load_select_result");
				target_area_2 = document.getElementById("loaded_area");
				document.getElementById("loaded_area").innerHTML="";
				document.getElementById("kapasite_select_result").innerHTML="";*/
				
				formFill("main_cat_select","0");
				break;
		
		
		}
	
		case "parity_type":
		{
			/*var product_id = document.getElementById("kapasite_product_id").value;
			url = trim("downloadajax.asp?product_id="+product_id+"&kapasite_id="+selected_target.options[selected_target.selectedIndex].value+"add_price="+);
			target_area = document.getElementById("loaded_area");
			document.getElementById("loaded_area").innerHTML="";
			*/
			formFill("main_cat_select","0");
			break;
		
		
		}
		
		
			case "sdp_type":
		{
			/*var product_id = document.getElementById("kapasite_product_id").value;
			url = trim("downloadajax.asp?product_id="+product_id+"&kapasite_id="+selected_target.options[selected_target.selectedIndex].value+"add_price="+);
			target_area = document.getElementById("loaded_area");
			document.getElementById("loaded_area").innerHTML="";
			*/
			formFill("main_cat_select","0");
			break;
		
		
		}
		
		
		case "sdm_type":
		{
			/*var product_id = document.getElementById("kapasite_product_id").value;
			url = trim("downloadajax.asp?product_id="+product_id+"&kapasite_id="+selected_target.options[selected_target.selectedIndex].value+"add_price="+);
			target_area = document.getElementById("loaded_area");
			document.getElementById("loaded_area").innerHTML="";
			*/
			formFill("main_cat_select","0");
			break;
		
		
		}
		
		case "sds_type":
		{
			/*var product_id = document.getElementById("kapasite_product_id").value;
			url = trim("downloadajax.asp?product_id="+product_id+"&kapasite_id="+selected_target.options[selected_target.selectedIndex].value+"add_price="+);
			target_area = document.getElementById("loaded_area");
			document.getElementById("loaded_area").innerHTML="";
			*/
			
			formFill("main_cat_select","0");
		
			
			break;
			
		}			
	
	
		case "sip_type":
		{
			/*var product_id = document.getElementById("kapasite_product_id").value;
			url = trim("downloadajax.asp?product_id="+product_id+"&kapasite_id="+selected_target.options[selected_target.selectedIndex].value+"add_price="+);
			target_area = document.getElementById("loaded_area");
			document.getElementById("loaded_area").innerHTML="";
			*/
			formFill("main_cat_select","0");
			break;
		
		
		}
		
		
		case "sim_type":
		{
			/*var product_id = document.getElementById("kapasite_product_id").value;
			url = trim("downloadajax.asp?product_id="+product_id+"&kapasite_id="+selected_target.options[selected_target.selectedIndex].value+"add_price="+);
			target_area = document.getElementById("loaded_area");
			document.getElementById("loaded_area").innerHTML="";
			*/
			formFill("main_cat_select","0");
			break;
		
		
		}
		
		case "sis_type":
		{
			/*var product_id = document.getElementById("kapasite_product_id").value;
			url = trim("downloadajax.asp?product_id="+product_id+"&kapasite_id="+selected_target.options[selected_target.selectedIndex].value+"add_price="+);
			target_area = document.getElementById("loaded_area");
			document.getElementById("loaded_area").innerHTML="";
			*/
			
			formFill("main_cat_select","0");
		
			
			break;
			
		}	
	
		default:
		{
			
		}
	}
	
	
	
		
	ajaxFunction();
	xmlHttp.open("GET",url,true);	
	xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
	xmlHttp.onreadystatechange=yukle;
	xmlHttp.setRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT");
	xmlHttp.setRequestHeader("Connection", "close");
	xmlHttp.send(null);
	
	
}


function formFill(select_form_id, selected_form_value )
{
				alert("deneme")
				var select_form, select_form_length
				select_form = document.getElementById(select_form_id);
				select_form_length = select_form.length;
			
				
				for(var i = 0;i < select_form_length;i++)
					{
						if(select_form.options[i].selected == true )
							{
								//select_form.options[i].selected = true;
								select_form.onchange();
							}
					}
}
			
		
		
		


function yukle()
{
		
		
		if(xmlHttp.readyState==1)
			
			target_area.innerHTML="Dosya yükleniyor...";
		
		if(xmlHttp.readyState==4)
  		{
			
			if(xmlHttp.status == 200)
			{
				
				
				//if(trim(xmlHttp.getResponseHeader("Content-Length"))>0)
				//{
					
					var parser=new DOMParser();
  					var xmlDoc=parser.parseFromString(xmlHttp.responseText,"text/html");
					var select_element = xmlDoc.getElementById("select_element_part");
					var kapasite_element = xmlDoc.getElementById("kapasite_element_part");	
					var content_element = xmlDoc.getElementById("content_element_part");
					var detailed_element = xmlDoc.getElementById("detailed_element_part");
					var damga_montaj_element = xmlDoc.getElementById("damga_montaj_part");					
					
					
					if (select_element != null)
					{
						target_area.innerHTML=select_element.innerHTML;

					}
					
					if (kapasite_element != null)
					{
						target_area_3.innerHTML=kapasite_element.innerHTML;
					}
					
					
					if(content_element != null)
					{
						target_area_2.innerHTML = content_element.innerHTML;
					}
					
					if(detailed_element != null)
					{
						target_area.innerHTML = detailed_element.innerHTML;
					}
					
					if(damga_montaj_element != null)
					{
						//target_area.innerHTML = detailed_element.innerHTML;
					}
					
					//target_area.innerHTML=xmlHttp.responseText;
				//}
				//else
				//{
				//	target_area.innerHTML="<strong>Sistemde sorguladığınız kriterlere uygun döküman bulunmamaktadır.</strong>";
  					//document.getElementById("selected_title").innerHTML=selected_target.parentNode.innerHTML;
				//}
			
				adjust_list("list_adjustment");
			}
			if(xmlHttp.status == 302)
			{
				
				location.href = "../../fiyat/admin/login.asp?err=7";
			}
			
			else
				target_area="hata";
			
		}
			
		
				
}

// print butonu tetiklendiğinde çağırın
function generateTableOfContents() {
  
	const tocContainer = document.getElementById('iceridekiler_liste');
	if (!tocContainer) return;
	
	tocContainer.innerHTML = '';
	
	const basliklar = document.querySelectorAll('.anakat_adi1, .cizim_adi');
	
	let grupNo = 0;
	
	basliklar.forEach((el, index) => {
	  
	  // Kendisi gizli ise atla
	  if (el.classList.contains('my_hidden_div')) return;
  
	  // Parent'ı hem seperator hem my_hidden_div ise atla
	  const parent = el.parentNode;
	  if (parent && parent.classList.contains('seperator') && parent.classList.contains('my_hidden_div')) return;
  
	  if (!el.id) el.id = 'baslik_' + index;
	  
	  if (el.classList.contains('anakat_adi1')) {
		grupNo++;
		const satir = document.createElement('div');
		satir.className = 'toc_grup_baslik';
		satir.innerHTML = `
		  <span class="toc_no">${grupNo}</span>
		  <span class="toc_ad">${el.innerText.trim()}</span>
		  <span class="toc_nokta"></span>
		  <span class="toc_sayfa">00</span>
		`;
		tocContainer.appendChild(satir);
  
	  } else if (el.classList.contains('cizim_adi')) {
		const satir = document.createElement('div');
		satir.className = 'toc_urun';
		satir.innerHTML = `
		  <span class="toc_no"></span>
		  <span class="toc_tire">—</span>
		  <span class="toc_ad">${el.innerText.trim()}</span>
		  <span class="toc_nokta"></span>
		  <span class="toc_sayfa">00</span>
		`;
		tocContainer.appendChild(satir);
	  }
	});
  }
  