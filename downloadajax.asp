<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../fiyat/Connections/fiyat.asp" -->


<% 
If Session("MM_Username") <> "" Then
   If (Not CStr(Session("MM_UserAuthorization"))="") or (Not CStr(Session("MM_Username"))="") Then
    MM_grantAccess = true
  End If
End If

If Not MM_grantAccess Then
  'Session("last_visited_page") = Request.ServerVariables("URL")&"?"&Request.ServerVariables("QUERY_STRING")
  'Session("last_visited_page") = getURL
  'Response.Redirect(MM_authFailedURL)
  Response.Status="302"
  Response.Write(response.Status)
  Response.End

End If
%>

<% Response.Expires=0 %>
<%Response.CharSet = "utf-8"%> 
<% Response.ContentType = "text/HTML" %> 

<%
Function SafeRound(val, decimals)
    If IsNull(val) Or IsEmpty(val) Or val = "" Then
        SafeRound = 0
    Else
        SafeRound = Round(CDbl(val), decimals)
    End If
End Function

Function SafeFormat(val)
    If IsNull(val) Or IsEmpty(val) Or val = "" Then
        SafeFormat = "-"
    Else
        SafeFormat = FormatNumber(val)
    End If
End Function
%>

<!--(durum 1) -->
	<!-- urun id'si alınıyor -->
<% 
	dim yonetici
	dim super_yonetici
	dim kullanici
	dim bayi
  
  	super_yonetici = "1"
  	yonetici = "2"
  	kullanici = "3"
	bayi = "5"
	
%> 
	
    
<%
Dim drawing__MMColParam
drawing__MMColParam = ""
If (Request.QueryString("product_id")   <> "") Then 
	
	drawing__MMColParam = " WHERE ebat.product_id="&Request.QueryString("product_id")   
	
	if (Request.QueryString("kapasite_id")   <> "") Then	
		if (Request.QueryString("kapasite_id")   = "-1") Then	
			drawing__MMColParam = " WHERE ebat.product_id="&Request.QueryString("product_id")
		else
			drawing__MMColParam = " WHERE ebat.product_id="&Request.QueryString("product_id")&"AND ebat.kaptak_id="&Request.QueryString("kapasite_id")
		End if
	End If	

End If
%>


<%
	dim price_list_type
	
		If (Request.QueryString("price_list_type") <> "") Then 
			price_list_type = Request.QueryString("price_list_type")
	end if
	
%>

<%
	dim language
		
		language = 1
	
		If (Request.QueryString("lng") <> "") Then 
		language = Request.QueryString("lng")
	end if
	
%>

<%
dim cur, parity, sdp, sdm, sds, sip, sim, sis
cur = "DEF"

%>

<%
if(Request.QueryString("sip") <> "") then
	sip = Request.QueryString("sip")	
end if
%>

<%
if(Request.QueryString("sim") <> "") then
	sim = Request.QueryString("sim")	
end if
%>

<%
if(Request.QueryString("sis") <> "") then
	sis = Request.QueryString("sis")	
end if
%>


<%

if(Request.QueryString("cur") <> "") then
	cur = Request.QueryString("cur")	
end if
%>


<%

if(Request.QueryString("parity") <> "") then
	parity = Request.QueryString("parity")	
end if

%>

<%
if(Request.QueryString("sdp") <> "") then
	sdp = Request.QueryString("sdp")	
end if

%>

<%
if(Request.QueryString("sdm") <> "") then
	sdm = Request.QueryString("sdm")	
end if

%>

<%
if(Request.QueryString("sds") <> "") then
	sds = Request.QueryString("sds")	
end if

%>


<%
Dim altkatagori__MMColParam
altkatagori__MMColParam = "1"


If (Request.QueryString("akno") <> "") Then 

	
	if (Request.QueryString("akno") = "-2") then
		' Öne Çıkan / Çok Satan / Kampanya ürünleri
		
		if price_list_type = 5 then

			altkatagori__MMColParam = " WHERE urunler.one_cikan > 0 AND urunler.id=26"
			drawing__MMColParam = "WHERE urunler.one_cikan > 0 AND urunler.id=26" 

		else
			altkatagori__MMColParam = " WHERE urunler.one_cikan > 0"
			drawing__MMColParam = "WHERE urunler.one_cikan > 0"

		end if

	

	elseif (Request.QueryString("akno") <> "-1") then
		   altkatagori__MMColParam = "WHERE akno="&Request.QueryString("akno") 
		   drawing__MMColParam = "WHERE ebat.ankno="&Request.QueryString("akno")   
	else
		
		
		if price_list_type = 1 then
			altkatagori__MMColParam = " WHERE 1 = 1"  
			drawing__MMColParam = "WHERE 1 = 1"
		end if

		if price_list_type = 5 then
			'Mekanik Fiyat Listesine Dahil Urunler
			'26 = Taşıt Kantarları
			altkatagori__MMColParam = " WHERE akno in (26)"
			 drawing__MMColParam = "WHERE ebat.ankno in (26)"   
		end if


		if price_list_type = 2 then
			'Mekanik Fiyat Listesine Dahil Urunler
			'26 = Taşıt Kantarları
			'90 = Vagon Kantarları
			'89= Kantar ve Baskül Aksesuarları - Mekanik  
			altkatagori__MMColParam = " WHERE akno in (26,90,89)"
			 drawing__MMColParam = "WHERE ebat.ankno in (26,90,89)"   
		end if


		if price_list_type = 3 then

		'Bayi Listesine Dahil Urunler		
		'26 = Taşıt Kantarları
		'99 = Taşıt Kantarı Otomasyon Sistemleri
		'90 = Vagon Kantarları
		'83 = Aks Kantarları
		'29 = Endüstriyel Baskül ve Kantarlar
		'38= Kantar ve Baskül Aksesuarları - Elektronik  
		'89= Kantar ve Baskül Aksesuarları - Mekanik  
		'79= Mobil Tartım Sistemleri  
		'76= Dinamik Tartım Sistemleri  
		'91= Boyut Ölçüm Sistemleri  
		'92= Liman Çözümleri  
		
	
			altkatagori__MMColParam = " WHERE akno in (26,90,83,29,38, 89,79,76,91,92,96,98,99,100)"
			drawing__MMColParam = "WHERE ebat.ankno in (26,90,83,29,89,79,76,91,92,96,98,99,100)"
			
			'altkatagori__MMColParam = " WHERE akno in (90, 83,29,89,79,76) AND kno in(550, 301, 551, 552, 553, 609,608)"
			'drawing__MMColParam = "WHERE ebat.ankno in (90, 83,29,89,79,76) AND kno in(550, 301, 551, 552, 553, 609,608)"

		end if
		
		if price_list_type = 4 then

		'Servis ve Yedek Parça Listesine Dahil Urunler		
		'34 = Dijital Ağırlık Göstergeleri
		'35 = Yük Hücreleri
		'39 = Yazıcılar
		'41 = Yazılımlar
		'85= Taşıt Kantarları Yenileme Paketleri  
		'86= Teknik Servis Hizmetleri  
		'87= Yük Hücresi Montaj Aksesuarları  
		'88= Elektronik Yedek Parça
		'38= Kantar ve Baskül Aksesuarları Elektronik
		'93= Yazıcı Aksesuarları    
		
	
			altkatagori__MMColParam = " WHERE akno in (34,35,39,41,85, 86,87,88,38,93)"
			drawing__MMColParam = "WHERE ebat.ankno in (34,35,39,41,85, 86,87,88,38,93)"
			
			'altkatagori__MMColParam = " WHERE akno in (90, 83,29,89,79,76) AND kno in(550, 301, 551, 552, 553, 609,608)"
			'drawing__MMColParam = "WHERE ebat.ankno in (90, 83,29,89,79,76) AND kno in(550, 301, 551, 552, 553, 609,608)"

		end if

		if price_list_type = 0 then
			' Tüm listeler için geçerli - öne çıkan filtresi
			altkatagori__MMColParam = " WHERE 1 = 1"
			drawing__MMColParam = "WHERE 1 = 1"
		end if

	
	End if
  

	


End If
%>

<%
Dim Damga_Montaj_Bedeli
Damga_Montaj_Bedeli = 1000

%>


<%
Dim kapasite__MMColParam
kapasite__MMColParam = "1"
If (Request.QueryString("product_id") <> "" AND Request.QueryString("kapasite_id") = "") Then 
  kapasite__MMColParam = Request.QueryString("product_id")
   'drawing__MMColParam = " WHERE ebat.product_id="&Request.QueryString("product_id")&" AND kaptak.kap_taksimat="&Request.QueryString("kapasite") 	

End If
%>



	<!-- ilgili urune ait cizimler cekiliyor-->
<%
Dim drawing
Dim drawing_cmd
Dim drawing_numRows

Set drawing_cmd = Server.CreateObject ("ADODB.Command")
drawing_cmd.ActiveConnection = MM_fiyat_STRING
Dim drawing_aktif_filter
If Trim(drawing__MMColParam) = "" Then
	drawing_aktif_filter = " WHERE (urunler.aktif_degil = 0 OR urunler.aktif_degil IS NULL) AND (Anakatagori.aktif_degil = 0 OR Anakatagori.aktif_degil IS NULL) AND (kaptak.aktif_degil = 0 OR kaptak.aktif_degil IS NULL) AND (ebat.aktif_degil = 0 OR ebat.aktif_degil IS NULL)"
Else
	drawing_aktif_filter = " AND (urunler.aktif_degil = 0 OR urunler.aktif_degil IS NULL) AND (Anakatagori.aktif_degil = 0 OR Anakatagori.aktif_degil IS NULL) AND (kaptak.aktif_degil = 0 OR kaptak.aktif_degil IS NULL) AND (ebat.aktif_degil = 0 OR ebat.aktif_degil IS NULL)"
End If
drawing_cmd.CommandText = "SELECT kaptak.kap_taksimat, Anakatagori.siralama, Anakatagori.img AS anakat_img, Anakatagori.anakatadi, Anakatagori.anakatadi_eng, ebat.id, ebat.ankno, ebat.model_kodu, ebat.product_id, ebat.para_birimi, ebat.Aciklama, ebat.Aciklama_eng, ebat.Maliyet_Fiyati, ebat.Mekanik_Maliyet, ebat.Kar_Orani1, ebat.Kar_Orani2, ebat.Kar_Orani3, ebat.Kar_Orani4, ebat.Mekanik_Kar_Orani1, ebat.Mekanik_Kar_Orani2, ebat.Mekanik_Kar_Orani3, ebat.x_genislik, ebat.y_genislik,ebat.z_yukseklik, ebat.order, urunler.fiyat_liste_aciklama, urunler.fiyat_liste_aciklama_eng, urunler.bayi_fiyat_liste_aciklama,urunler.bayi_fiyat_liste_aciklama_eng, urunler.fiyat_liste_alt_aciklama, urunler.fiyat_liste_alt_aciklama_eng, urunler.urunadi , urunler.urunadi_eng, urunler.print_group, urunler.img, urunler.ord, urunler.kno,urunler.akno, urunler.aksiyon, urunler.one_cikan, urunler.one_cikan_etiket FROM (((ebat INNER JOIN kaptak ON ebat.kaptak_id = kaptak.id) INNER JOIN Anakatagori ON ebat.ankno = Anakatagori.id) INNER JOIN urunler ON ebat.product_id = urunler.id) "&drawing__MMColParam&drawing_aktif_filter&" ORDER BY Anakatagori.siralama ASC, urunler.ord, ebat.product_id, ebat.x_genislik, ebat.x_genislik, ebat.y_genislik, kaptak.kap_taksimat, ebat.order, ebat.id ASC" 
drawing_cmd.Prepared = true

Set drawing = drawing_cmd.Execute
drawing_numRows = 0
%>
<!--(durum 1) -->


<!--(durum 2) -->
	<!-- secilen ana katagoriden seçim kutusu gondermek için alt katagoriler belirleniyor (durum 2)-->


<%
Dim altkatagori
Dim altkatagori_cmd
Dim altkatagori_numRows

Set altkatagori_cmd = Server.CreateObject ("ADODB.Command")
altkatagori_cmd.ActiveConnection = MM_fiyat_STRING
Dim altkatagori_aktif_filter
altkatagori_aktif_filter = " AND (urunler.aktif_degil = False OR urunler.aktif_degil IS NULL) AND (Anakatagori.aktif_degil = 0 OR Anakatagori.aktif_degil IS NULL)"

Dim altkatagori_where
If Trim(altkatagori__MMColParam) = "1" Or Trim(altkatagori__MMColParam) = "" Then
	altkatagori_where = " WHERE 1=1"
Else
	altkatagori_where = " " & altkatagori__MMColParam
End If

altkatagori_cmd.CommandText = "SELECT urunler.id, urunler.urunadi, urunler.urunadi_eng FROM urunler INNER JOIN Anakatagori ON urunler.akno = Anakatagori.id" & altkatagori_where & altkatagori_aktif_filter & " ORDER BY urunler.ord ASC" 
'altkatagori_cmd.CommandText = "SELECT urunler.id, urunler.urunadi, Anakatagori.siralama FROM urunler INNER JOIN Anakatagori ON urunler.akno = Anakatagori.id  "&altkatagori__MMColParam&" ORDER BY Anakatagori.siralama ASC, urunler.ord ASC"
altkatagori_cmd.Prepared = true

Set altkatagori = altkatagori_cmd.Execute
altkatagori_numRows = 0
%>
<!--(durum 2) -->



<!--(durum 3) -->
	<!-- secilen alt katagoriden kapasiteler gönderiliyor (durum 2)-->


<%
Dim kapasite
Dim kapasite_cmd
Dim kapasite_numRows

Set kapasite_cmd = Server.CreateObject ("ADODB.Command")
kapasite_cmd.ActiveConnection = MM_fiyat_STRING
kapasite_cmd.CommandText = "SELECT kaptak.id, kaptak.kap_taksimat, kaptak.product_id FROM (kaptak INNER JOIN urunler ON kaptak.product_id = urunler.id) INNER JOIN Anakatagori ON urunler.akno = Anakatagori.id WHERE kaptak.product_id = ? AND (kaptak.aktif_degil = False OR kaptak.aktif_degil IS NULL) AND (urunler.aktif_degil = False OR urunler.aktif_degil IS NULL) AND (Anakatagori.aktif_degil = 0 OR Anakatagori.aktif_degil IS NULL) ORDER BY kaptak.kap_taksimat ASC" 
kapasite_cmd.Prepared = true
kapasite_cmd.Parameters.Append kapasite_cmd.CreateParameter("param1", 5, 1, -1, kapasite__MMColParam) ' adDouble

Set kapasite = kapasite_cmd.Execute
kapasite_numRows = 0
%>
<!--(durum 3) -->





<% 
tasit_kantarlari = Array(118,149,169,439,460,491,492)

%>
<%

Function agirlik_birim(agirlik)

if(agirlik>1000) then
	agirlik_yeni = agirlik/1000 
	Response.Write(agirlik_yeni&" ton") 
else
	Response.Write(agirlik&" kg")
end if
end Function
%>


<!--(durum 2 islem) -->
<%
Dim Repeat1__numRows
Dim Repeat1__index

Repeat1__numRows = -1
Repeat1__index = 0
drawing_numRows = drawing_numRows + Repeat1__numRows
%>
<%
Dim Repeat2__numRows
Dim Repeat2__index

Repeat2__numRows = -1
Repeat2__index = 0
altkatagori_numRows = altkatagori_numRows + Repeat2__numRows
%>


<%
Dim Repeat3__numRows
Dim Repeat3__index

Repeat3__numRows = -1
Repeat3__index = 0
kapasite_numRows = kapasite_numRows + Repeat3__numRows
%>

<%
Dim liste_fiyati_kar_orani

%>




<% If Not kapasite.EOF Or Not kapasite.BOF Then %>

<% liste_fiyati_kar_orani = drawing.Fields.Item("Kar_Orani1").Value %>

<div id="kapasite_element_part"> 
 
 <div>
	<div >
	  <label class="filter_label"><%if (language <> 2) then Response.Write("Kapasiteler") else Response.Write("Capacity") end if%></label> 
	  </div>
	
    <div id="load_kapasite_result">

 <input type="hidden" id="kapasite_product_id" value="<%=(kapasite.Fields.Item("product_id").Value)%>" />
    <% Response.Write("<select name='3' id='kapasite_select' onchange='downloading_product(this)'>")%>
    <%if (language <> 2) then Response.Write("<option value='-1'>Tüm Kapasiteler</option>") else Response.Write("<option value='-1'>All Capacities</option>") end if%>
    <% 
While ((Repeat2__numRows <> 0) AND (NOT kapasite.EOF)) 
%>
  <option value="<%=(kapasite.Fields.Item("id").Value)%>"><%=(kapasite.Fields.Item("kap_taksimat").Value)%></option>
  <% 
  Repeat2__index=Repeat2__index+1
  Repeat2__numRows=Repeat2__numRows-1
  kapasite.MoveNext()
Wend
%>
  <% Response.Write("</select>")%>
</div>

    </div>

</div>
 
 
 <% End If ' end Not kapasite.EOF Or NOT kapasite.BOF %>









<% If Not altkatagori.EOF Or Not altkatagori.BOF Then %>

<div id="select_element_part"> 

	<% Response.Write("<select name='2' id='products_select' onchange='downloading_product(this)'>")%>
    <%if (language <> 2) then Response.Write("<option value='0'>Ürün Seçiniz</option>") else Response.Write("<option>Select Product</option>") end if%>
    <% 
While ((Repeat2__numRows <> 0) AND (NOT altkatagori.EOF)) 
%>
  <option value="<%=(altkatagori.Fields.Item("id").Value)%>"><%if (language <> 2) then Response.Write(altkatagori.Fields.Item("urunadi").Value) else Response.Write(altkatagori.Fields.Item("urunadi_eng").Value) end if%></option>
  <% 
  Repeat2__index=Repeat2__index+1
  Repeat2__numRows=Repeat2__numRows-1
  altkatagori.MoveNext()
Wend
%>
  <% Response.Write("</select>")%>
</div>
<% End If ' end Not altkatagori.EOF Or NOT altkatagori.BOF %>

<!--(durum 2 islem sonu) -->


<!-- Durum 1 islem; Eger secilen urune ait cizim varsa  asagidaki koadlar isleme gierecektir -->

<% If Not drawing.EOF Or Not drawing.BOF Then %>

<!--
<% 'if drawing.Fields.Item("anakatadi").Value ="Taşıt Kantarları" OR urun_adi2 = "AXLELINE Serisi Sabit Aks Kantarı" OR drawing.Fields.Item("anakatadi").Value = "Vagon Kantarı" then %>
<div id="damga_montaj_part">
<select name="3" id="damga_montaj_select" onchange='downloading_product(this)'>
<option value="0"> Montaj - Kalibrasyon Bölgesi Seçiniz</option>
<option value="300">1. Bölge : 0 - 100 km : $300 </option>
<option value="360">2. Bölge : 101 - 200 km : $360 </option>
<option value="410">3. Bölge : 201 - 400 km : $410</option>
<option value="490">4. Bölge : 401 - 600 km : $490</option>
<option value="570">5. Bölge : 601 - 800 km : $570</option>

</select>
</div>
<%'end if%>
-->


<div id="content_element_part">

  <div class="loaded_">
<% 
	dim modelkodu1,modelkodu2 ,xgenislik1, xgenislik2, ygenislik1, ygenislik2, flag_olculer, flag_kapasiteler, division, metric, Maliyet_Fiyati1, Maliyet_Fiyati2, urun_adi1, urun_adi2, urun_katagori1, urun_katagori2, fiyat_liste_aciklama, bayi_fiyat_liste_aciklama, fiyat_liste_alt_aciklama, seperator_flag, flag_aciklama, Aciklama1, kapasite1, kapasite2, kapasite_line_reset_count, anakatagori_adi1, anakatagori_adi2, row_count, print_group1, print_group2, anakat_flag
	urun_adi1=null
	urun_adi2=null
	fiyat_liste_aciklama=null
	bayi_fiyat_liste_aciklama=null
	fiyat_liste_alt_aciklama=null
	modelkodu1=null
	modelkodu2=null
	xgenislik1=null
	xgenislik2=null
	ygenislik1=null
	ygenislik2=null		
	Aciklama1 = null
	anakatagori_adi1 = null
	anakatagori_adi2 = null
	print_group1 = null
	print_group2 = null
	flag_olculer=0
	flag_kapasiteler=0
	flag_aciklama=0
	division=1
	metric=mm
	kapasite_line_reset_count = 0
	seperator_flag=0
	row_count = 0
	anakat_flag =0
	urun_katagori1=null '<!--Şüphe olursa bunları kaldır-->
	urun_katagori2=null '<!--'Şüphe olursa bunları kaldır-->
%>



	<% 
While ((Repeat1__numRows <> 0) AND (NOT drawing.EOF)) 
%>

 

 
 <%  urun_adi2 = drawing.Fields.Item("urunadi").Value  %>

<%  if(urun_adi2 = urun_adi1) then %>


<%else%>

	<!--(ters_div_container_beraber silinebilir) -->

	
    <!--(ters_div_container_beraber silinebilir) -->

    	  <%  print_group2 = drawing.Fields.Item("print_group").Value %>
     
      <% if(print_group2 <> print_group1) then %>
     
         <footer></footer>
        
        <% end if %>
 
  

 
  <!--(Anakatogori Adı baslangic) -->	
  
	<% if (seperator_flag = 1) then %>
        <div style="clear:both"></div>
             </div>
	<% end if %>
    
    
    
      <%  anakatagori_adi2 = drawing.Fields.Item("anakatadi").Value  %>

<%  if(anakatagori_adi2 = anakatagori_adi1) then %>

	
<%else%>
	

	<% if anakat_flag = 0 then %>
    
  
        <div class="anakat_adi1"><div><i class="fa fa-eye-slash" onClick="printed_elements(this)"></i><%if (language <> 2) then Response.Write(drawing.Fields.Item("anakatadi").Value) else Response.Write(drawing.Fields.Item("anakatadi_eng").Value) end if%></div><div><img src="<% =(drawing.Fields.Item("anakat_img").Value) %>"></div></div>
    <% else %>
       <div class="anakat_adi1"><div><i class="fa fa-eye-slash" onClick="printed_elements(this)"></i><%if (language <> 2) then Response.Write(drawing.Fields.Item("anakatadi").Value) else Response.Write(drawing.Fields.Item("anakatadi_eng").Value) end if%></div><div><img src="<% =(drawing.Fields.Item("anakat_img").Value) %>"></div></div>
    <% end if %>
	
    <% anakat_flag = 1 %>
    
<%end if%>
    
    <div class="seperator" id="<%=(drawing.Fields.Item("product_id").Value)%>">

   <!--(Anakatogori Adı bitiş) -->	
 
 
  <!--(urun adi baslangic) -->	




 <% seperator_flag = 1 %>


 	<div class="cizim_adi"><i class="fa fa-eye-slash" onClick="printed_elements(this)"></i>&nbsp;&nbsp;<%if (language <> 2) then Response.Write(drawing.Fields.Item("urunadi").Value) else Response.Write(drawing.Fields.Item("urunadi_eng").Value) end if%>
<%
Dim one_cikan_val, one_cikan_etiket_val, rozet_html
one_cikan_val = 0
one_cikan_etiket_val = ""
If Not IsNull(drawing.Fields.Item("one_cikan").Value) Then
  one_cikan_val = CInt(drawing.Fields.Item("one_cikan").Value)
End If
If Not IsNull(drawing.Fields.Item("one_cikan_etiket").Value) Then
  one_cikan_etiket_val = CStr(drawing.Fields.Item("one_cikan_etiket").Value)
End If

If one_cikan_val > 0 Then
  Dim rozet_ikon, rozet_renk
  Select Case one_cikan_val
    Case 1: rozet_ikon="&#11088;" : rozet_renk="#e67e22"
    Case 2: rozet_ikon="&#128293;" : rozet_renk="#e74c3c"
    Case 3: rozet_ikon="&#127381;" : rozet_renk="#27ae60"
    Case 4: rozet_ikon="&#128142;" : rozet_renk="#8e44ad"
    Case Else: rozet_ikon="&#11088;" : rozet_renk="#e67e22"
  End Select
  If Trim(one_cikan_etiket_val) <> "" Then
    rozet_html = "<span class='one_cikan_rozet' style='background:" & rozet_renk & "'>" & rozet_ikon & " " & one_cikan_etiket_val & "</span>"
  Else
    Select Case one_cikan_val
      Case 1: rozet_html = "<span class='one_cikan_rozet' style='background:" & rozet_renk & "'>" & rozet_ikon & " &#199;ok Satan</span>"
      Case 2: rozet_html = "<span class='one_cikan_rozet' style='background:" & rozet_renk & "'>" & rozet_ikon & " Kampanya</span>"
      Case 3: rozet_html = "<span class='one_cikan_rozet' style='background:" & rozet_renk & "'>" & rozet_ikon & " Yeni &#220;r&#252;n</span>"
      Case 4: rozet_html = "<span class='one_cikan_rozet' style='background:" & rozet_renk & "'>" & rozet_ikon & " &#214;ne &#199;&#305;kan</span>"
    End Select
  End If
  Response.Write(rozet_html)
End If
%>
</div>

<div class="left_container"><i class="fa fa-eye-slash" onClick="printed_elements(this)"></i>

 <!--(aciklamalar baslangic) -->

<% urun_katagori2 = drawing.Fields.Item("id").Value %>

	<% 
	if(language <> 2) then 
			fiyat_liste_aciklama = drawing.Fields.Item("fiyat_liste_aciklama").Value 
	else 
			fiyat_liste_aciklama = drawing.Fields.Item("fiyat_liste_aciklama_eng").Value
	end if 
	%>

	<% 
	if(language <> 2) then 
			fiyat_liste_alt_aciklama = drawing.Fields.Item("fiyat_liste_alt_aciklama").Value 
	else 
			fiyat_liste_alt_aciklama = drawing.Fields.Item("fiyat_liste_alt_aciklama_eng").Value
	end if 
	%>


	<% 
	if(language <> 2) then 
			bayi_fiyat_liste_aciklama = drawing.Fields.Item("bayi_fiyat_liste_aciklama").Value 
	else 
			bayi_fiyat_liste_aciklama = drawing.Fields.Item("bayi_fiyat_liste_aciklama_eng").Value
	end if 
	%>



<%' fiyat_liste_alt_aciklama = drawing.Fields.Item("fiyat_liste_alt_aciklama").Value %>
<% 'fiyat_liste_aciklama = drawing.Fields.Item("fiyat_liste_aciklama").Value %>
<% 'bayi_fiyat_liste_aciklama = drawing.Fields.Item("bayi_fiyat_liste_aciklama").Value %>

<%if price_list_type = 2 then%>

	<% 
	if(language <> 2) then 
			fiyat_liste_aciklama = "<h1>Açıklamalar: </h1>Tartı Terminali, Yük Hücreleri, Junction Box ve Diğer Elektronik Aksamlar Fiyatlara Dahil Değildir." 
	else 
			fiyat_liste_aciklama = "<h1>General Explanations : </h1>Weighing Terminal, Load Cells, Junction Box and Other Electronic Components Are Excluded."
	end if 
	%>



    <% fiyat_liste_alt_aciklama = "" %>
<%end if%>


<%if price_list_type = 5 then%>

	<% 
	if(language <> 2) then 
			fiyat_liste_aciklama = "<h1>Açıklamalar: </h1>Tartı Terminali, Yük Hücreleri, Junction Box ve Diğer Elektronik Aksamlar Fiyatlara Dahil Değildir." 
	else 
			fiyat_liste_aciklama = "<h1>General Explanations : </h1>Weighing Terminal, Load Cells, Junction Box and Other Electronic Components Are Excluded."
	end if 
	%>



    <% fiyat_liste_alt_aciklama = "" %>
<%end if%>





<%if price_list_type = 3 then%>	
		<% if Trim(bayi_fiyat_liste_aciklama) <> "" then%>
			<% fiyat_liste_aciklama = bayi_fiyat_liste_aciklama %>	
    <%end if%>

	
<%end if%>






<% fiyat_liste_img = drawing.Fields.Item("img").Value %>

<% if(urun_katagori1 = urun_katagori2 ) then %>
<% else %>
    
	<% if (fiyat_liste_img <>"") then %>
    <div class="fiyat_img">
    <img src="<%Response.Write(""&fiyat_liste_img)%>" width="150"  alt="Resim" />
    </div>
	<%end if%>
	
	<% if (fiyat_liste_aciklama <>"") then %>
        
        <div class="fiyat_aciklama">
        <%
			Response.Write(fiyat_liste_aciklama)
		%>
         <div style="clear:both"></div>
        </div>
	<%end if%>
    
      <% if (fiyat_liste_alt_aciklama <>"") then %>
        <div class="fiyat_aciklama">
        <%
			Response.Write(fiyat_liste_alt_aciklama)
		%>
         <div style="clear:both"></div>
        </div>
	<% end if %>
    
<%end if%>
 <!--(aciklamalar bitis) -->		
<div style="clear:both"></div>
</div>


<% if(drawing.Fields.Item("z_yukseklik").Value > 0 OR (drawing.Fields.Item("x_genislik").Value) > 0 OR (drawing.Fields.Item("y_genislik").Value) > 0) then %>
    	<% flag_olculer = 1 %>

<%else  flag_olculer = 0 %>

	<%end if%>


<% if(drawing.Fields.Item("kap_taksimat").Value > 0) then%>
                 
<% flag_kapasiteler = 1 %>

<%else  flag_kapasiteler = 0 %>

<%end if%>






<div class="fiyat_title_container">
<i class="fa fa-eye-slash" onClick="printed_elements(this)"></i>
<div class="model_kodu">

<%if (language <> 2) then Response.Write("MODEL KODU") else Response.Write("MODEL CODE") end if%></div>

<% if (flag_olculer > 0) then %>
	
    <% if(flag_kapasiteler > 0) then %> 
    <div class="olculer"><%if (language <> 2) then Response.Write("ÖLÇÜLER") else Response.Write("DIMENSION") end if%></div>
    <% else %>
    <div class="olculer2"><%if (language <> 2) then Response.Write("ÖLÇÜLER") else Response.Write("DIMENSION") end if%></div>
    <%end if%>	
<%else%>
	
    <% if(flag_kapasiteler > 0) then %> 
    	<div class="aciklama1"><%if (language <> 2) then Response.Write("AÇIKLAMA") else Response.Write("EXPLANATION") end if%></div>
	<% else %>
    	<div class="aciklama2"><%if (language <> 2) then Response.Write("AÇIKLAMA") else Response.Write("EXPLANATION") end if%></div>
	<%end if%>
    
<%end if%>

<% if(flag_kapasiteler > 0) then %> 
<div class="kapasite"><%if (language <> 2) then Response.Write("KAPASİTE") else Response.Write("CAPACITY") end if%></div>
<%end if%>	







<% if price_list_type = 1 then %>

<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%>  
<div class="fiyat_maliyet"><%if (language <> 2) then Response.Write("MALİYET") else Response.Write("COST") end if%></div>
<% end if %>
<div class="fiyat_liste"><%if (language <> 2) then Response.Write("LİSTE FİYATI") else Response.Write("PRICE") end if%></div>
<div class="fiyat_tavsiye"><%if (language <> 2) then Response.Write("TAVSİYE SATIŞ") else Response.Write("RECOMMENDED PRICE") end if%></div>
<div class="fiyat_son"><%if (language <> 2) then Response.Write("SON SATIŞ") else Response.Write("LAST PRICE") end if%></div>		
<% end if %>


<% if price_list_type = 2 then %>
<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> 
	<div class="fiyat_maliyet"><%if (language <> 2) then Response.Write("MEKANİK MALİYET") else Response.Write("MECHANICAL COST") end if%></div>
<% end if %> 
	<div class="fiyat_liste"><%if (language <> 2) then Response.Write("LİSTE FİYATI") else Response.Write("PRICE") end if%></div>
    <div class="fiyat_tavsiye"><%if (language <> 2) then Response.Write("TAVSİYE SATIŞ") else Response.Write("RECOMMENDED PRICE") end if%></div>
    <div class="fiyat_son"><%if (language <> 2) then Response.Write("SON SATIŞ") else Response.Write("LAST PRICE") end if%></div>		
<% end if %>





<% if price_list_type = 5 then %>

	<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> 
    <div class="fiyat_maliyet"><%if (language <> 2) then Response.Write("MEKANİK MALİYET") else Response.Write("MECHANICAL COST") end if%></div>
    <% end if %>
	<div class="fiyat_tavsiye"><%if (language <> 2) then Response.Write("BAYİ ALIŞ") else Response.Write("DEALER BUYING") end if%></div>
    <div class="fiyat_liste"><%if (language <> 2) then Response.Write("LİSTE FİYATI") else Response.Write("PRICE") end if%></div> 
    <!-- <div class="fiyat_son">SON SATIŞ FİYATI</div>-->		
<% end if %>


<% if price_list_type = 3 then %>
	<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> 
    <div class="fiyat_maliyet"><%if (language <> 2) then Response.Write("MALİYET") else Response.Write("COST") end if%></div>
    <% end if %>
	<div class="fiyat_tavsiye"><%if (language <> 2) then Response.Write("BAYİ ALIŞ") else Response.Write("DEALER BUYING") end if%></div>
    <div class="fiyat_liste"><%if (language <> 2) then Response.Write("LİSTE FİYATI") else Response.Write("PRICE") end if%></div> 
    <!-- <div class="fiyat_son">SON SATIŞ FİYATI</div>-->		
<% end if %>

<% if price_list_type = 4 then %>
	<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> 
    <div class="fiyat_maliyet"><%if (language <> 2) then Response.Write("MALİYET") else Response.Write("COST") end if%></div>
    <% end if %>
	<div class="fiyat_tavsiye"><%if (language <> 2) then Response.Write("BAYİ ALIŞ") else Response.Write("DEALER BUYING") end if%></div>
    <div class="fiyat_liste"><%if (language <> 2) then Response.Write("LİSTE FİYATI") else Response.Write("PRICE") end if%></div> 
    <!-- <div class="fiyat_son">SON SATIŞ FİYATI</div>-->		
<% end if %>








</div>

<% end if %>

 <!--(urun adi bitis) -->	


<div class="right_container">


<%
dim para_birimi 
if (drawing.Fields.Item("para_birimi").Value<>"") then
	para_birimi = drawing.Fields.Item("para_birimi").Value
else
	para_birimi =""
end if
%> 


<%
dim aksiyon 
if (drawing.Fields.Item("aksiyon").Value<>"") then
	aksiyon = drawing.Fields.Item("aksiyon").Value
else
	aksiyon ="detayli_fiyatlar"
end if
%> 
<% kapasite2 = drawing.Fields.Item("kap_taksimat").Value  %>
	
	<% modelkodu2 = drawing.Fields.Item("model_kodu").Value%>
    
	<% xgenislik2 = drawing.Fields.Item("x_genislik").Value%>
    
	<% ygenislik2 = drawing.Fields.Item("y_genislik").Value%>
  
	
    <% if(trim(xgenislik2)= trim(xgenislik1) AND trim(ygenislik2)= trim(ygenislik1)) then %>
	 
	 <% kapasite_line_reset_count = 0 %> 
        	
	<% else%>
   	
	    <!--36 = Kütle ve Setler -->	
		<% if(drawing.Fields.Item("akno").Value <> "36" ) then %>
        	<div class="cizim_bosluk"><i class="fa fa-eye-slash" onClick="printed_elements(this)"></i></div>
		<%end if%>
	
	<% kapasite_line_reset_count = 1 %>
	<% end if %>


		         <% if(trim(kapasite2) <> "" AND trim(kapasite2)= trim(kapasite1)) then %>
                 
           
				<% else%>
   					
                    	<% if(drawing.Fields.Item("akno").Value = "36" ) then %>
        					<div class="cizim_bosluk"><i class="fa fa-eye-slash" onClick="printed_elements(this)"></i></div>
						<%end if%>
	
					
					
					<% if kapasite_line_reset_count = 0 then %>
                   			<div class="cizim_bosluk_ufak"><i class="fa fa-eye-slash" onClick="printed_elements(this)"></i></div>
					<% end if%>
				
				<% end if %>



  <!--(line_container baslangic divi) -->	
<div class="line_container" style="cursor:pointer;" onmouseover="div_over(this);" onmouseout="div_out(this);"

<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici  then%> 
onclick="admin_action('<%=("maliyet_guncelle")%>', this.id)"  
<% end if %>
id="<% =(drawing.Fields.Item("id").Value)%>">
  <!--(line_container baslangic divi) -->
	
	<% if( trim(modelkodu1) = trim(modelkodu2)) then %>
    

	<% else %>
    
  	 	
        	
        
    
		<% if(trim(drawing.Fields.Item("model_kodu").Value)="") then %>	    
        
		
		<% else %>
		<% if (trim(modelkodu2)<>"") then %>
<div class="model_kodu" id="<% =(drawing.Fields.Item("id").Value)&"_" %>">
    			<% Response.Write(modelkodu2) %>
	  </div>
		<% end if %>
        
		<% end if%>
    		
      <% if(flag_olculer > 0) then %> 
            
              <% if(flag_kapasiteler > 0) then %> 
                <div class="olculer">
                <% else %>
                <div class="olculer2">
                <%end if%>	      
 
                
        <% 
		if(((drawing.Fields.Item("x_genislik").Value / 2900)>1) And ((drawing.Fields.Item("y_genislik").Value / 2900)>1)) then
        	division=1000
			metric="m"
		Elseif (((drawing.Fields.Item("x_genislik").Value / 100)>1) And ((drawing.Fields.Item("y_genislik").Value / 100)>1)) then
        	division=10
			metric="cm"
		else
			division=1
			metric="mm"
		end if
		
		%>
        
		<% if((drawing.Fields.Item("x_genislik").Value > 0)) then %>
                    <% =((drawing.Fields.Item("x_genislik").Value)/(division))%>  
                <%end if%>
                
<% if((drawing.Fields.Item("y_genislik").Value > 0)) then %>
                    x <%=((drawing.Fields.Item("y_genislik").Value)/(division))%>
<% end if %>	
                
                <% if((drawing.Fields.Item("z_yukseklik").Value > 0)) then %>
x <% =((drawing.Fields.Item("z_yukseklik").Value)/(division))%> 
                <%else%>
                <%end if%>
                
                    <% Response.Write(" "&metric)%>
                
      </div>  
    
	<%else%>
		<!--<div class="olculer">- </div>-->
        
		<% if language <> 2 then Aciklama1 = drawing.Fields.Item("Aciklama").Value else  Aciklama1 = drawing.Fields.Item("Aciklama_eng").Value end if %> 
		
        	<% if(flag_kapasiteler > 0) then %> 
            	<div class="aciklama1"><%=(Aciklama1)%> </div>
			<%else%>
    			<div class="aciklama2"><%=(Aciklama1)%> </div>
			<%end if%>	
	
	<% end if %>
			 
	
        
			 
      <% if(flag_kapasiteler > 0) then %> 
            
          
            <div class="kapasite"> 
		 		<% agirlik_birim(kapasite2) %>
	  </div>
			
			<% else %>
            	
          
			<% end if %>
            
             
    	<%dim maliyet_fiyati %>
		
        
        
        
        <!------------------------------------ Elektronik Dahil Liste Başı------------------------------------------ -->		
		
   
   
       
        
		<% if price_list_type = 1 then %>	

			<%

				liste_fiyati_kar_orani = drawing.Fields.Item("Kar_Orani1").Value

			%>
		   
		   <% if(drawing.Fields.Item("Maliyet_Fiyati").Value <>"") then %> <!---- Maliyet girildiyse -->
           
                <%
                    
                    maliyet_fiyati = drawing.Fields.Item("Maliyet_Fiyati").Value
                    
                    if anakatagori_adi2 ="Taşıt Kantarları"  OR urun_adi2 = "AXLELINE Serisi Sabit Aks Kantarı" OR anakatagori_adi2 = "Vagon Kantarları" then
                            maliyet_fiyati = maliyet_fiyati + Damga_Montaj_Bedeli 
                    end if
                
               %>
       
      		 	<!---- Yöneticiyse goster --- -->
                
						<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> 	 	
                   
                                <div class="fiyat_maliyet"> 
                                
                                    <% if cur = "USD" then %>
										<% if para_birimi ="$" then %>	
                                            <%Response.Write(para_birimi &" "& FormatNumber(Round(maliyet_fiyati,2),0))%> 
                                        <% end if %>
                                        
                                        	<% if para_birimi = "€" then %>	
                                            <%Response.Write("$" &" "& FormatNumber(Round((maliyet_fiyati/parity),2),0))%> 
                                        <% end if %>
									
                                    <% elseif cur = "EUR" then %>
											<% if para_birimi ="$" then %>
												<%Response.Write(" €" &" "& FormatNumber(Round((maliyet_fiyati*parity),2),0))%> 
                                    		<% end if %>
                                            
                                            <% if para_birimi ="€" then %>
												<%Response.Write(para_birimi &" "& FormatNumber(Round((maliyet_fiyati),2),0))%> 
                                    		<% end if %>
                                                        
                                	<% else %>
											<%Response.Write(para_birimi &" "& FormatNumber(Round(maliyet_fiyati,2),0))%>
									<% end if %>
                                    
                                
                                </div>
                        <% end if %>
            
            <!---- Yöneticiyse goster --- -->	
             
                
            <% else %>   <!---- Maliyet girilmediyse -->
                   	
				  <% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> 
                    
                    <!---- Yöneticiyse goster --- -->
                    <div class="fiyat_maliyet"> -  </div> 
        			
					<% end if %> <!---- Yöneticiyse goster --- -->	
         
        
            
            <% end if %> 
        
        <% if(liste_fiyati_kar_orani <>"") then %> 

   	 	<div class="fiyat_liste"> 
            	
				<% if cur = "USD" then %>
					
						<% if para_birimi ="$" then %>	
                        <%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani)),0),0))%>
                        <%end if%>
                        
                        <%if para_birimi ="€" then %>        		
                        <%Response.Write("$" &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))/parity),0),0))%>
                        <% end if %>
                				
				<% elseif cur = "EUR" then %>
						<% if para_birimi ="$" then %>					
                        <%Response.Write("€" &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))*parity),0),0))%>
                        <%end if%>  
                        <%if para_birimi ="€" then %>
                        <%Response.Write(para_birimi &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))),0),0))%>  
                        <%end if%>
					
					<% else %>
							 <%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani)),0),0))%>
					<% end if %>
                
				<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->	 
				<%Response.Write("<span class='kar_marjlari' >&nbsp;&nbsp;%"&FormatNumber(liste_fiyati_kar_orani,0)&"</span>")%>
                <% end if %> <!---- Yöneticiyse goster --- -->	
                
        </div>

	   <% else %>
             <div class="fiyat_liste"> - </div>
        
		<% end if %>



    
   		<% if(drawing.Fields.Item("Kar_Orani2").Value <>"") then %> 

   	  	 	<div class="fiyat_tavsiye"> 
            	
				<% if cur = "USD" then %>
					
						<% if para_birimi ="$" then %>	
                        <%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-drawing.Fields.Item("Kar_Orani2").Value)),0),0))%>
                        <%end if%>
                        
                        <%if para_birimi ="€" then %>        		
                        <%Response.Write("$" &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-drawing.Fields.Item("Kar_Orani2").Value))/parity),0),0))%>
                        <% end if %>
                				
				<% elseif cur = "EUR" then %>
						<% if para_birimi ="$" then %>					
                        <%Response.Write("€" &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-drawing.Fields.Item("Kar_Orani2").Value))*parity),0),0))%>
                        <%end if%>  
                        <%if para_birimi ="€" then %>
                        <%Response.Write(para_birimi &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-drawing.Fields.Item("Kar_Orani2").Value))),0),0))%>  
                        <%end if%>
					
					<% else %>
							 <%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-drawing.Fields.Item("Kar_Orani2").Value)),0),0))%>
					<% end if %>
                
				<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->	 
				<%Response.Write("<span class='kar_marjlari' >&nbsp;&nbsp;%"&FormatNumber(drawing.Fields.Item("Kar_Orani2").Value,0)&"</span>")%>
                <% end if %> <!---- Yöneticiyse goster --- -->
            </div>

	   <% else %>
             <div class="fiyat_tavsiye"> - </div>
        
		<% end if %>
   
      		<% if(drawing.Fields.Item("Kar_Orani3").Value <>"") then %> 

   	   	 	<div class="fiyat_son"> 
            	
				<% if cur = "USD" then %>
					
						<% if para_birimi ="$" then %>	
                        <%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-drawing.Fields.Item("Kar_Orani3").Value)),0),0))%>
                        <%end if%>
                        
                        <%if para_birimi ="€" then %>        		
                        <%Response.Write("$" &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-drawing.Fields.Item("Kar_Orani3").Value))/parity),0),0))%>
                        <% end if %>
                				
				<% elseif cur = "EUR" then %>
						<% if para_birimi ="$" then %>					
                        <%Response.Write("€" &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-drawing.Fields.Item("Kar_Orani3").Value))*parity),0),0))%>
                        <%end if%>  
                        <%if para_birimi ="€" then %>
                        <%Response.Write(para_birimi &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-drawing.Fields.Item("Kar_Orani3").Value))),0),0))%>  
                        <%end if%>
					
					<% else %>
							 <%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-drawing.Fields.Item("Kar_Orani3").Value)),0),0))%>
					<% end if %>
                
				<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->	 
				<%Response.Write("<span class='kar_marjlari' >&nbsp;&nbsp;%"&FormatNumber(drawing.Fields.Item("Kar_Orani3").Value,0)&"</span>")%>
                <% end if %> <!---- Yöneticiyse goster --- -->
            </div>

	   <% else %>
             <div class="fiyat_son"> - </div>
        
		<% end if %>
        
	

     
       <!------------------------------------ Elektronik Dahil Liste Sonu------------------------------------------ -->
		
        
        
        
        
        
        
        
        
         <!------------------------------------ Elektronik Hariç Liste Başı------------------------------------------ -->	
   		<% elseif price_list_type = 2 then %>
			
         
         
           
            <% if(drawing.Fields.Item("Mekanik_Maliyet").Value <>"") then %> <!-- Mekanik Maliyet Girildiyse -->
           
                <%

                    maliyet_fiyati = drawing.Fields.Item("Mekanik_Maliyet").Value
               %>
       
       				<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->
                        <div class="fiyat_maliyet"> 
                            <%Response.Write(para_birimi &" "& FormatNumber(Round(maliyet_fiyati,2),2))%> 
                        </div>
                     <% end if %>   
					                
            <% else %> <!-- Mekanik Maliyet Girilmediyse -->
            
                    <% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->
                    	<div class="fiyat_maliyet"> -  </div>
            		 <% end if %>
            
			<% end if %>
        	
           
		<% if(liste_fiyati_kar_orani <>"") then %> 

   	 	<div class="fiyat_liste"> 
            	<%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani)),2),2))%>        		
                <% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->
    				<%Response.Write("<span class='kar_marjlari'>&nbsp;&nbsp;%"&FormatNumber(liste_fiyati_kar_orani,2)&"</span>")%>
        		<% end if %>
        </div>

	   <% else %>
             <div class="fiyat_liste"> - </div>
        
		<% end if %>



    
   		<% if(drawing.Fields.Item("Mekanik_Kar_Orani2").Value <>"") then %> 

   	  	 	<div class="fiyat_tavsiye"> 
            	<%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-drawing.Fields.Item("Mekanik_Kar_Orani2").Value)),2),2))%>        		
    			<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->
					<%Response.Write("<span class='kar_marjlari' >&nbsp;&nbsp;%"&FormatNumber(drawing.Fields.Item("Mekanik_Kar_Orani2").Value,2)&"</span>")%>
            	<% end if %>	
            </div>

	   <% else %>
             <div class="fiyat_tavsiye"> - </div>
        
		<% end if %>
   
      		<% if(drawing.Fields.Item("Mekanik_Kar_Orani3").Value <>"") then %> 

   	   	 	<div class="fiyat_son"> 
            	<%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-drawing.Fields.Item("Mekanik_Kar_Orani3").Value)),2),2))%>        		
                <% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->
    				<%Response.Write("<span class='kar_marjlari'>&nbsp;&nbsp;%"&FormatNumber(drawing.Fields.Item("Mekanik_Kar_Orani3").Value,2)&"</span>")%>
            	<% end if %>
            
            </div>

	   <% else %>
             <div class="fiyat_son"> - </div>
        
		<% end if %>
        
        
	
          <!------------------------------------ Elektronik Hariç Liste Sonu------------------------------------------ -->		
        
		
        
        
        
		
		
                <!------------------------------------ Bayi Fiyat Listesi Basşı ------------------------------------------ -->		
<%
		   		dim bayi_iskonto_orani
				dim bayi_iskonto_katsayi
				dim bayi_alis_fiyati
				dim bayi_alis_fiyatli_kar_marji
					

%>
		
		<% elseif price_list_type = 3 then %>	

		   
		   <% 
		   		
				bayi_iskonto_orani = sdp
				bayi_iskonto_katsayi = 1 - bayi_iskonto_orani
		   %>
           
           <%

				liste_fiyati_kar_orani = drawing.Fields.Item("Kar_Orani1").Value + (sip*100)

			%>
		   
		   <% if(drawing.Fields.Item("Maliyet_Fiyati").Value <>"") then %> <!---- Maliyet girildiyse -->
           
                <%
 					maliyet_fiyati = drawing.Fields.Item("Maliyet_Fiyati").Value
              %>
       
      		 	<!---- Yöneticiyse goster --- -->
                
						<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> 	 	
                   
                                <div class="fiyat_maliyet"> 
                                
                                    <% if cur = "USD" then %>
										<% if para_birimi ="$" then %>	
                                            <%Response.Write(para_birimi &" "& FormatNumber(Round((maliyet_fiyati),2),0))%> 
                                        <% end if %>
                                        
                                        	<% if para_birimi = "€" then %>	
                                            <%Response.Write("$" &" "& FormatNumber(Round(((maliyet_fiyati)/parity),2),0))%> 
                                        <% end if %>
									
                                    <% elseif cur = "EUR" then %>
											<% if para_birimi ="$" then %>
												<%Response.Write(" €" &" "& FormatNumber(Round(((maliyet_fiyati)*parity),2),0))%> 
                                    		<% end if %>
                                            
                                            <% if para_birimi ="€" then %>
												<%Response.Write(para_birimi &" "& FormatNumber(Round(((maliyet_fiyati)),2),0))%> 
                                    		<% end if %>
                                                        
                                	<% else %>
											<%Response.Write(para_birimi &" "& FormatNumber(Round((maliyet_fiyati),2),0))%>
									<% end if %>
                                    
                                
                                </div>
                        <% end if %>
            
            <!---- Yöneticiyse goster --- -->	
             
                
            <% else %>   <!---- Maliyet girilmediyse -->
                   	
				  <% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> 
                    
                    <!---- Yöneticiyse goster --- -->
                    <div class="fiyat_maliyet"> -  </div> 
        			
					<% end if %> <!---- Yöneticiyse goster --- -->	
         
        
            
            <% end if %> 
          
        
       
       
    
   		<% if(drawing.Fields.Item("Maliyet_Fiyati").Value <>"") then %> 
				<% 
					bayi_alis_fiyati = Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani)
					'bayi_alis_fiyati = bayi_alis_fiyati * bayi_iskonto_katsayi
					
					if anakatagori_adi2 ="Taşıt Kantarları" OR anakatagori_adi2 = "Vagon Kantarları" OR urun_adi2 = "AXLELINE Serisi Sabit Aks Kantarı"  then
							maliyet_fiyati = maliyet_fiyati + Damga_Montaj_Bedeli
							bayi_alis_fiyati = (Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))					
							bayi_alis_fiyati = bayi_alis_fiyati * bayi_iskonto_katsayi
                   			bayi_alis_fiyatli_kar_marji = (bayi_alis_fiyati-(maliyet_fiyati-Damga_Montaj_Bedeli))/bayi_alis_fiyati
				    else 
						bayi_alis_fiyati = bayi_alis_fiyati * bayi_iskonto_katsayi
						bayi_alis_fiyatli_kar_marji = (bayi_alis_fiyati-(maliyet_fiyati))/bayi_alis_fiyati
					
					end if					
						
						
						bayi_alis_fiyatli_kar_marji = bayi_alis_fiyatli_kar_marji *100						
				%>
			
      

   	  	 	<div class="fiyat_tavsiye"> 
            	
				<% if cur = "USD" then %>
					
						<% if para_birimi ="$" then %>	
                        <%Response.Write(para_birimi &" "& FormatNumber(SafeRound(bayi_alis_fiyati,0),0))%>
                        <%end if%>
                        
                        <%if para_birimi ="€" then %>        		
                        <%Response.Write("$" &" "& FormatNumber(SafeRound((bayi_alis_fiyati/parity),0),0))%>
                        <% end if %>
                				
				<% elseif cur = "EUR" then %>
						<% if para_birimi ="$" then %>					
                        <%Response.Write("€" &" "& FormatNumber(SafeRound((bayi_alis_fiyati*parity),0),0))%>
                        <%end if%>  
                        <%if para_birimi ="€" then %>
                        <%Response.Write(para_birimi &" "& FormatNumber(SafeRound(bayi_alis_fiyati,0),0))%>  
                        <%end if%>
					
					<% else %>
							 <%Response.Write(para_birimi &" "& FormatNumber(SafeRound(bayi_alis_fiyati,0),0))%>
					<% end if %>
                
				<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->	 
				<%Response.Write("<span class='kar_marjlari' >&nbsp;&nbsp;%"&SafeFormat(bayi_alis_fiyatli_kar_marji)&"</span>")%>
                <% end if %> <!---- Yöneticiyse goster --- -->
            </div>

	   <% else %>
             <div class="fiyat_tavsiye"> - </div>
        
		<% end if %>
     
     
     
     
     
     
     
      	
         <% if(drawing.Fields.Item("Maliyet_Fiyati").Value <>"" and liste_fiyati_kar_orani <>"") then %> 



                <%
                    
                    
					maliyet_fiyati = drawing.Fields.Item("Maliyet_Fiyati").Value
                    
                       if anakatagori_adi2 ="Taşıt Kantarları"  OR urun_adi2 = "AXLELINE Serisi Sabit Aks Kantarı" OR anakatagori_adi2 = "Vagon Kantarları" then
                            maliyet_fiyati = maliyet_fiyati + Damga_Montaj_Bedeli 
						
					end if
                
               %>


         
                
                
                <div class="fiyat_liste"> 
            	
				<% if cur = "USD" then %>
					
						<% if para_birimi ="$" then %>	
                        <%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani)),0),0))%>
                        <%end if%>
                        
                        <%if para_birimi ="€" then %>        		
                        <%Response.Write("$" &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))/parity),0),0))%>
                        <% end if %>
                				
				<% elseif cur = "EUR" then %>
						<% if para_birimi ="$" then %>					
                        <%Response.Write("€" &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))*parity),0),0))%>
                        <%end if%>  
                        <%if para_birimi ="€" then %>
                        <%Response.Write(para_birimi &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))),0),0))%>  
                        <%end if%>
					
					<% else %>
							 <%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani)),0),0))%>
					<% end if %>
                
				<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->	 
				<%Response.Write("<span class='kar_marjlari' >&nbsp;&nbsp;%"&FormatNumber(liste_fiyati_kar_orani,0)&"</span>")%>
                <% end if %> <!---- Yöneticiyse goster --- -->	
                
        </div>

	   <% else %>
             <div class="fiyat_liste"> - </div>
        
		<% end if %>
        
        
  
     <!------------------------------------ Yedek Parça ve Servis Fiyat Listesi Başı ------------------------------------------ -->
    
    <% elseif price_list_type = 4 then %>	

		   <% 
		   		
				bayi_iskonto_orani = sds
				bayi_iskonto_katsayi = 1 - bayi_iskonto_orani
		   %>
		   
		   	<%

				liste_fiyati_kar_orani = drawing.Fields.Item("Kar_Orani1").Value + (sis*100)

			%>
		   
		   <% if(drawing.Fields.Item("Maliyet_Fiyati").Value <>"") then %> <!---- Maliyet girildiyse -->
           
                <%
 					maliyet_fiyati = drawing.Fields.Item("Maliyet_Fiyati").Value
              %>
       
      		 	<!---- Yöneticiyse goster --- -->
                
						<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> 	 	
                   
                                <div class="fiyat_maliyet"> 
                                
                                    <% if cur = "USD" then %>
										<% if para_birimi ="$" then %>	
                                            <%Response.Write(para_birimi &" "& FormatNumber(Round((maliyet_fiyati),2),2))%> 
                                        <% end if %>
                                        
                                        	<% if para_birimi = "€" then %>	
                                            <%Response.Write("$" &" "& FormatNumber(Round(((maliyet_fiyati)/parity),2),2))%> 
                                        <% end if %>
									
                                    <% elseif cur = "EUR" then %>
											<% if para_birimi ="$" then %>
												<%Response.Write(" €" &" "& FormatNumber(Round(((maliyet_fiyati)*parity),2),2))%> 
                                    		<% end if %>
                                            
                                            <% if para_birimi ="€" then %>
												<%Response.Write(para_birimi &" "& FormatNumber(Round(((maliyet_fiyati)),2),2))%> 
                                    		<% end if %>
                                                        
                                	<% else %>
											<%Response.Write(para_birimi &" "& FormatNumber(Round((maliyet_fiyati),2),2))%>
									<% end if %>
                                    
                                
                                </div>
                        <% end if %>
            
            <!---- Yöneticiyse goster --- -->	
             
                
            <% else %>   <!---- Maliyet girilmediyse -->
                   	
				  <% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> 
                    
                    <!---- Yöneticiyse goster --- -->
                    <div class="fiyat_maliyet"> -  </div> 
        			
					<% end if %> <!---- Yöneticiyse goster --- -->	
         
        
            
            <% end if %> 
          
        
       
       
    
   		<% if(drawing.Fields.Item("Maliyet_Fiyati").Value <>"") then %> 
				<% 
					bayi_alis_fiyati = Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani)
					bayi_alis_fiyati = bayi_alis_fiyati * bayi_iskonto_katsayi
					
					'if anakatagori_adi2 ="Taşıt Kantarları" OR anakatagori_adi2 = "Vagon Kantarları" OR urun_adi2 = "AXLELINE Serisi Sabit Aks Kantarı"  then
'							maliyet_fiyati = maliyet_fiyati + Damga_Montaj_Bedeli
'							bayi_alis_fiyati = (Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))					
'							bayi_alis_fiyati = bayi_alis_fiyati * bayi_iskonto_katsayi
'                   			bayi_alis_fiyatli_kar_marji = (bayi_alis_fiyati-(maliyet_fiyati-Damga_Montaj_Bedeli))/bayi_alis_fiyati
'				    else 
'						bayi_alis_fiyatli_kar_marji = (bayi_alis_fiyati-(maliyet_fiyati))/bayi_alis_fiyati
'					
'					end if					
						
						bayi_alis_fiyatli_kar_marji = (bayi_alis_fiyati-(maliyet_fiyati))/bayi_alis_fiyati
						bayi_alis_fiyatli_kar_marji = bayi_alis_fiyatli_kar_marji *100						
				%>
			
      

   	  	 	<div class="fiyat_tavsiye"> 
            	
				<% if cur = "USD" then %>
					
						<% if para_birimi ="$" then %>	
                        <%Response.Write(para_birimi &" "& FormatNumber(SafeRound(bayi_alis_fiyati,2),2))%>
                        <%end if%>
                        
                        <%if para_birimi ="€" then %>        		
                        <%Response.Write("$" &" "& FormatNumber(SafeRound((bayi_alis_fiyati/parity),2),2))%>
                        <% end if %>
                				
				<% elseif cur = "EUR" then %>
						<% if para_birimi ="$" then %>					
                        <%Response.Write("€" &" "& FormatNumber(SafeRound((bayi_alis_fiyati*parity),2),2))%>
                        <%end if%>  
                        <%if para_birimi ="€" then %>
                        <%Response.Write(para_birimi &" "& FormatNumber(SafeRound(bayi_alis_fiyati,2),2))%>  
                        <%end if%>
					
					<% else %>
							 <%Response.Write(para_birimi &" "& FormatNumber(SafeRound(bayi_alis_fiyati,2),2))%>
					<% end if %>
                
				<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->	 
				<%Response.Write("<span class='kar_marjlari' >&nbsp;&nbsp;%"&SafeFormat(bayi_alis_fiyatli_kar_marji)&"</span>")%>
                <% end if %> <!---- Yöneticiyse goster --- -->
            </div>

	   <% else %>
             <div class="fiyat_tavsiye"> - </div>
        
		<% end if %>
     
     
     
      	
         <% if(drawing.Fields.Item("Maliyet_Fiyati").Value <>"" and liste_fiyati_kar_orani <>"") then %> 



               <%
'                    
'                    
'					maliyet_fiyati = drawing.Fields.Item("Maliyet_Fiyati").Value
'                    
'                       if anakatagori_adi2 ="Taşıt Kantarları"  OR urun_adi2 = "AXLELINE Serisi Sabit Aks Kantarı" OR anakatagori_adi2 = "Vagon Kantarları" then
'                            maliyet_fiyati = maliyet_fiyati + Damga_Montaj_Bedeli 
'						
'					end if
'                
'               %>


         
                
                
                <div class="fiyat_liste"> 
            	
				<% if cur = "USD" then %>
					
						<% if para_birimi ="$" then %>	
                        <%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani)),2),2))%>
                        <%end if%>
                        
                        <%if para_birimi ="€" then %>        		
                        <%Response.Write("$" &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))/parity),2),2))%>
                        <% end if %>
                				
				<% elseif cur = "EUR" then %>
						<% if para_birimi ="$" then %>					
                        <%Response.Write("€" &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))*parity),2),2))%>
                        <%end if%>  
                        <%if para_birimi ="€" then %>
                        <%Response.Write(para_birimi &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))),2),2))%>  
                        <%end if%>
					
					<% else %>
							 <%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani)),2),2))%>
					<% end if %>
                
				<% if Session("MM_UserAuthorization") = yonetici  Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->	 
				<%Response.Write("<span class='kar_marjlari' >&nbsp;&nbsp;%"&FormatNumber(liste_fiyati_kar_orani,0)&"</span>")%>
                <% end if %> <!---- Yöneticiyse goster --- -->	
                
        </div>

	   <% else %>
             <div class="fiyat_liste"> - </div>
        
		<% end if %>
        
         <!------------------------------------ Yedek Parça ve Servis Fiyat Listesi Sonu ------------------------------------------ -->
  
    
    
    
    
    
    	
        
        
        <!-------------------------- Bayi fiyat listesi Mekanik  --------------------------->
        
		
		<% elseif price_list_type = 5 then %>	

		   <% 

				bayi_iskonto_orani = sdm
				bayi_iskonto_katsayi = 1 - bayi_iskonto_orani
		   %>
		   
		   <%

				liste_fiyati_kar_orani = drawing.Fields.Item("Mekanik_Kar_Orani1").Value + (sim*100)

			%>
		   
		   
		   <% if(drawing.Fields.Item("Mekanik_Maliyet").Value <>"") then %> <!---- Maliyet girildiyse -->
           
                <%
                    
                    maliyet_fiyati = drawing.Fields.Item("Mekanik_Maliyet").Value
                    
                       Damga_Montaj_Bedeli = 0
					   if anakatagori_adi2 ="Taşıt Kantarları"  OR urun_adi2 = "AXLELINE Serisi Sabit Aks Kantarı" OR anakatagori_adi2 = "Vagon Kantarları" then
                            'Damga_Montaj_Bedeli = 0
							maliyet_fiyati = maliyet_fiyati + Damga_Montaj_Bedeli
							
                    end if
                
               %>
       
      		 	<!---- Yöneticiyse goster --- vuralvural -->
                
						<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> 	 	
                   
                                <div class="fiyat_maliyet"> 
                                
                                    <% if cur = "USD" then %>
										<% if para_birimi ="$" then %>	
                                            <%Response.Write(para_birimi &" "& FormatNumber(Round((maliyet_fiyati-Damga_Montaj_Bedeli),2),0))%> 
                                        <% end if %>
                                        
                                        	<% if para_birimi = "€" then %>	
                                            <%Response.Write("$" &" "& FormatNumber(Round(((maliyet_fiyati-Damga_Montaj_Bedeli)/parity),2),0))%> 
                                        <% end if %>
									
                                    <% elseif cur = "EUR" then %>
											<% if para_birimi ="$" then %>
												<%Response.Write(" €" &" "& FormatNumber(Round(((maliyet_fiyati-Damga_Montaj_Bedeli)*parity),2),0))%> 
                                    		<% end if %>
                                            
                                            <% if para_birimi ="€" then %>
												<%Response.Write(para_birimi &" "& FormatNumber(Round(((maliyet_fiyati-Damga_Montaj_Bedeli)),2),0))%> 
                                    		<% end if %>
                                                        
                                	<% else %>
											<%Response.Write(para_birimi &" "& FormatNumber(Round((maliyet_fiyati-Damga_Montaj_Bedeli),2),0))%>
									<% end if %>
                                    
                                
                                </div>
                        <% end if %>
            
            <!---- Yöneticiyse goster --- -->	
             
                
            <% else %>   <!---- Maliyet girilmediyse -->
                   	
				  <% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> 
                    
                    <!---- Yöneticiyse goster --- -->
                    <div class="fiyat_maliyet"> -  </div> 
        			
					<% end if %> <!---- Yöneticiyse goster --- -->	
         
        
            
            <% end if %> 
          
        
       
    
   		<% if(drawing.Fields.Item("Mekanik_Maliyet").Value <>"") then %> 
				<% 
				
					bayi_alis_fiyati = Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani)
					'bayi_alis_fiyati = bayi_alis_fiyati * bayi_iskonto_katsayi
					
					if anakatagori_adi2 ="Taşıt Kantarları" OR anakatagori_adi2 = "Vagon Kantarları" OR urun_adi2 = "AXLELINE Serisi Sabit Aks Kantarı"  then
							bayi_alis_fiyati = (Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))					
							bayi_alis_fiyati = bayi_alis_fiyati * bayi_iskonto_katsayi
                   			bayi_alis_fiyatli_kar_marji = (bayi_alis_fiyati-(maliyet_fiyati-Damga_Montaj_Bedeli))/bayi_alis_fiyati
				    else 
						bayi_alis_fiyatli_kar_marji = (bayi_alis_fiyati-(maliyet_fiyati))/bayi_alis_fiyati
					
					end if					
						
						bayi_alis_fiyatli_kar_marji = bayi_alis_fiyatli_kar_marji *100						
				%>
			
      

   	  	 	<div class="fiyat_tavsiye"> 
            	
				<% if cur = "USD" then %>
					
						<% if para_birimi ="$" then %>	
                        <%Response.Write(para_birimi &" "& FormatNumber(SafeRound(bayi_alis_fiyati,0),0))%>
                        <%end if%>
                        
                        <%if para_birimi ="€" then %>        		
                        <%Response.Write("$" &" "& FormatNumber(SafeRound((bayi_alis_fiyati/parity),0),0))%>
                        <% end if %>
                				
				<% elseif cur = "EUR" then %>
						<% if para_birimi ="$" then %>					
                        <%Response.Write("€" &" "& FormatNumber(SafeRound((bayi_alis_fiyati*parity),0),0))%>
                        <%end if%>  
                        <%if para_birimi ="€" then %>
                        <%Response.Write(para_birimi &" "& FormatNumber(SafeRound(bayi_alis_fiyati,0),0))%>  
                        <%end if%>
					
					<% else %>
							 <%Response.Write(para_birimi &" "& FormatNumber(SafeRound(bayi_alis_fiyati,0),0))%>
					<% end if %>
                
				<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->	 
				<%Response.Write("<span class='kar_marjlari' >&nbsp;&nbsp;%"&SafeFormat(bayi_alis_fiyatli_kar_marji)&"</span>")%>
                <% end if %> <!---- Yöneticiyse goster --- -->
            </div>

	   <% else %>
             <div class="fiyat_tavsiye"> - </div>
        
		<% end if %>
     
     
     
     
     
     
     
      	
         <% if(drawing.Fields.Item("Mekanik_Maliyet").Value <>"" and liste_fiyati_kar_orani <>"") then %> 

   	    	 	<div class="fiyat_liste"> 
            	
				<% if cur = "USD" then %>
					
						<% if para_birimi ="$" then %>	
                        <%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani)),0),0))%>
                        <%end if%>
                        
                        <%if para_birimi ="€" then %>        		
                        <%Response.Write("$" &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))/parity),0),0))%>
                        <% end if %>
                				
				<% elseif cur = "EUR" then %>
						<% if para_birimi ="$" then %>					
                        <%Response.Write("€" &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))*parity),0),0))%>
                        <%end if%>  
                        <%if para_birimi ="€" then %>
                        <%Response.Write(para_birimi &" "& FormatNumber(Round(((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani))),0),0))%>  
                        <%end if%>
					
					<% else %>
							 <%Response.Write(para_birimi &" "& FormatNumber(Round((Abs(maliyet_fiyati*100)/(100-liste_fiyati_kar_orani)),0),0))%>
					<% end if %>
                
				<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then%> <!---- Yöneticiyse goster --- -->	 
				<%Response.Write("<span class='kar_marjlari' >&nbsp;&nbsp;%"&FormatNumber(liste_fiyati_kar_orani,0)&"</span>")%>
                <% end if %> <!---- Yöneticiyse goster --- -->	
                
        </div>

	   <% else %>
             <div class="fiyat_liste"> - </div>
        
		<% end if %>
        
        
		
		
		<% end if %> 
       
    
    
    
    
    
    

  
  
	
  <!--(line_container son divi) -->
   <div style="clear:both"></div>
  </div>
   <!---->
        
	<%end if%>
 


<%
	row_count = row_count + 1 
	
	if (row_count > 30) then
%>	
		<!-- <div style="page-break-after:always"></div> -->

<%	
	row_count = 0
	end if
	
%>


</div>


 


  <% 
  modelkodu1 = modelkodu2
  xgenislik1 = xgenislik2
  kapasite1 = kapasite2
  kapasite_line_reset_count = 1
  urun_katagori1 = urun_katagori2
  print_group1 = print_group2
  urun_adi1 = urun_adi2
  anakatagori_adi1 =  anakatagori_adi2
  ygenislik1 = ygenislik2
  Repeat1__index=Repeat1__index+1
  Repeat1__numRows=Repeat1__numRows-1
  maliyet_fiyati=0
  
  bayi_alis_fiyati = null
  liste_fiyati_kar_orani = null
  bayi_alis_fiyatli_kar_marji = null
  
Aciklama1 = null	
  
%>




  	 


<%
drawing.MoveNext()
Wend
%>
 
 <% seperator_flag = 0 %>
 <% anakat_flag = 0 %>
 
 <div style="clear:both"></div>
 </div> 








</div>
<% End If ' end Not drawing.EOF Or NOT drawing.BOF %>



<%
drawing.Close()
Set drawing = Nothing
%>
<%
altkatagori.Close()
Set altkatagori = Nothing
%>

<%
kapasite.Close()
Set kapasite = Nothing
%>
