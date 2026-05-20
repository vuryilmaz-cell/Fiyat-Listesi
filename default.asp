<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../fiyat/Connections/fiyat.asp" -->
<!--#include file="../fiyat/member_security.asp" -->
<!--#include file="../fiyat/currency.asp" -->


<%
  dim yonetici, super_yonetici, kullanici, bayi
  super_yonetici = "1"
  yonetici       = "2"
  kullanici      = "3"
  bayi           = "5"
%>

<%
dim list, list_filter, price_list_type, language, cur, parity
dim sdp, sdm, sds, sis, sim, sip, is_aktive_filter
language       = 1
price_list_type = 0

if Session("MM_UserAuthorization") <> bayi then
  list = 1
else
  list = 3
end if

cur    = "DEF"
parity = EurUsdPrty

' ── Session değerleri
if Session("Special_Increasing_Product")  <> "" then sip = Session("Special_Increasing_Product")  else sip = 0 end if
if Session("Special_Increasing_Spare")    <> "" then sis = Session("Special_Increasing_Spare")    else sis = 0 end if
if Session("Special_Increasing_Mechanic") <> "" then sim = Session("Special_Increasing_Mechanic") else sim = 0 end if
if Session("Special_Discount_Product")    <> "" then sdp = Session("Special_Discount_Product")    else sdp = 0 end if
if Session("Special_Discount_Spare")      <> "" then sds = Session("Special_Discount_Spare")      else sds = 0 end if
if Session("Special_Discount_Mechanic")   <> "" then sdm = Session("Special_Discount_Mechanic")   else sdm = 0 end if
if Session("Default_Currency")            <> "" then cur = Session("Default_Currency")             end if

' ── QueryString override
if Request.QueryString("sip")    <> "" then sip    = Request.QueryString("sip")    end if
if Request.QueryString("sim")    <> "" then sim    = Request.QueryString("sim")    end if
if Request.QueryString("sis")    <> "" then sis    = Request.QueryString("sis")    end if
if Request.QueryString("sdp")    <> "" then sdp    = Request.QueryString("sdp")    end if
if Request.QueryString("sdm")    <> "" then sdm    = Request.QueryString("sdm")    end if
if Request.QueryString("sds")    <> "" then sds    = Request.QueryString("sds")    end if
if Request.QueryString("cur")    <> "" then cur    = Request.QueryString("cur")    end if
if Request.QueryString("list")   <> "" then list   = Request.QueryString("list")   end if
if Request.QueryString("lng")    <> "" then language = Request.QueryString("lng")  end if
if Request.QueryString("parity") <> "" then parity = Request.QueryString("parity") end if

' ── List filtresi
if list = 1 then list_filter = "AND 3 = 3"                                                              : price_list_type = 1 end if
if list = 2 then list_filter = "AND id in (26,90)"                                                      : price_list_type = 2 end if
if list = 5 then list_filter = "AND id in (26)"                                                      : price_list_type = 5 end if
if list = 3 then list_filter = "AND id in (26,90,83,29,38,89,79,76,91,92,96,98,99,100)"         : price_list_type = 3 end if
if list = 4 then list_filter = "AND id in (34,35,39,41,85,86,87,88,38,93)"                              : price_list_type = 4 end if

is_aktive_filter = "AND aktif_degil = 0"


%>



<%
Dim products__MMColParam
products__MMColParam = "1"
If (Request("MM_EmptyValue") <> "") Then
  products__MMColParam = Request("MM_EmptyValue")
End If
%>

<%
Dim products, products_cmd, products_numRows
Set products_cmd = Server.CreateObject("ADODB.Command")
products_cmd.ActiveConnection = MM_fiyat_STRING
products_cmd.CommandText = "SELECT * FROM Anakatagori WHERE language=1 " & list_filter & is_aktive_filter & " ORDER BY siralama"
products_cmd.Prepared = true
Set products = products_cmd.Execute
products_numRows = 0
%>

<%
Dim Repeat5__numRows, Repeat5__index
Repeat5__numRows = -1
Repeat5__index   = 0
products_numRows = products_numRows + Repeat5__numRows
%>

<%
'================================================================
' KAMPANYA / ÖNE ÇIKAN ÜRÜNLER SORGUSU
'================================================================
Dim kamp_conn, kamp_rs, kamp_sql
Set kamp_conn = Server.CreateObject("ADODB.Connection")
kamp_conn.Open MM_fiyat_STRING

' list_filter'a göre hangi kategorilerdeki öne çıkan ürünler gösterilsin
Dim kamp_where
if list = 1 then
  kamp_where = "WHERE urunler.one_cikan > 0 AND (urunler.aktif_degil = 0 OR urunler.aktif_degil IS NULL)"
elseif list = 3 then
  kamp_where = "WHERE urunler.one_cikan > 0 AND urunler.akno in (26,90,83,29,38,89,79,76,91,99) AND (urunler.aktif_degil = 0 OR urunler.aktif_degil IS NULL)"
elseif list = 4 then
  kamp_where = "WHERE urunler.one_cikan > 0 AND urunler.akno in (34,35,39,41,85,86,87,88,38,93) AND (urunler.aktif_degil = 0 OR urunler.aktif_degil IS NULL)"
elseif list = 5 then
  kamp_where = "WHERE urunler.one_cikan > 0 AND urunler.akno in (26,90) AND (urunler.aktif_degil = 0 OR urunler.aktif_degil IS NULL)"
else
  kamp_where = "WHERE urunler.one_cikan > 0 AND (urunler.aktif_degil = 0 OR urunler.aktif_degil IS NULL)"
end if

kamp_sql = "SELECT urunler.id, urunler.urunadi, urunler.urunadi_eng, urunler.img, " & _
           "urunler.one_cikan, urunler.one_cikan_etiket, urunler.one_cikan_gorsel, urunler.akno, urunler.ord, " & _
           "Anakatagori.anakatadi, Anakatagori.anakatadi_eng, " & _
           "MIN(ebat.Maliyet_Fiyati) AS min_maliyet, " & _
           "MIN(ebat.Kar_Orani1) AS min_kar, " & _
           "ebat.para_birimi " & _
           "FROM (urunler INNER JOIN Anakatagori ON urunler.akno = Anakatagori.id) " & _
           "INNER JOIN ebat ON urunler.id = ebat.product_id " & _
           kamp_where & _
           " GROUP BY urunler.id, urunler.urunadi, urunler.urunadi_eng, urunler.img, " & _
           "urunler.one_cikan, urunler.one_cikan_etiket, urunler.one_cikan_gorsel, urunler.akno, urunler.ord, " & _
           "Anakatagori.anakatadi, Anakatagori.anakatadi_eng, ebat.para_birimi " & _
           "ORDER BY urunler.one_cikan ASC, urunler.ord ASC"

On Error Resume Next
Set kamp_rs = kamp_conn.Execute(kamp_sql)
Dim kamp_hata : kamp_hata = ""
Dim kamp_var_mi : kamp_var_mi = False
If Err.Number <> 0 Then
  kamp_hata = "SQL HATA: " & Err.Description & " | Sorgu: " & kamp_sql
Else
  If Not kamp_rs.EOF Then kamp_var_mi = True
End If
On Error GoTo 0
%>

<!DOCTYPE html>
<html lang="<%if language=2 then Response.Write("en") else Response.Write("tr") end if%>">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>TUNAYLAR FİYAT LİSTESİ</title>
  <link href="screen.css" media="screen" rel="stylesheet"/>
  <link href="form.css"   media="screen" rel="stylesheet"/>
  <link id="print-style-link" href="print.css" media="print" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Inter+Tight:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>  <script src="acl.js"        type="text/javascript"></script>
  <script src="tnyajax.js"    type="text/javascript"></script>
  <script src="play_video.js" type="text/javascript"></script>
  <script src="fiyat.js"      type="text/javascript"></script>
  <script src="check_form.js" type="text/javascript"></script>
  <script src="moment.js"     type="text/javascript"></script>
  <script>window.onresize = function(){ resize(); };</script>
  <style>
    /* ── Print stil seçici ── */
    .print_stil_sec {
      padding: 8px 14px 10px;
      border-top: 1px solid rgba(255,255,255,.08);
      margin-top: 2px;
    }
    .print_stil_label {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 10px;
      font-weight: 700;
      letter-spacing: 1px;
      text-transform: uppercase;
      color: rgba(255,255,255,.4);
      margin-bottom: 7px;
    }
    .print_stil_secenekler {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }
    .print_stil_opt {
      display: flex;
      align-items: center;
      cursor: pointer;
    }
    .print_stil_opt input[type="radio"] {
      display: none;
    }
    .print_stil_opt span {
      display: flex;
      align-items: center;
      gap: 7px;
      width: 100%;
      padding: 6px 10px;
      border-radius: 5px;
      font-size: 12px;
      font-weight: 600;
      color: rgba(255,255,255,.55);
      border: 1px solid transparent;
      transition: all .15s;
      cursor: pointer;
    }
    .print_stil_opt span i {
      font-size: 11px;
      width: 14px;
      text-align: center;
    }
    .print_stil_opt input:checked + span {
      background: rgba(55,194,228,.15);
      border-color: rgba(55,194,228,.35);
      color: #37c2e4;
    }
    .print_stil_opt span:hover {
      background: rgba(255,255,255,.07);
      color: rgba(255,255,255,.85);
    }
  </style>
</head>



<body onload="actstarter()">
<div id="print_header">
  <span class="header_title">2026 Fiyat Listesi</span>
  <span class="header_firma">TUNAYLAR TARTI SİSTEMLERİ · www.tunaylar.com</span>
</div>

<!--#include file="video_temp.html" -->

<div id="guncelle_container"></div>

<%
'================================================================
' KAPAK SAYFASI  (ekranda display:none — sadece print'te açılır)
'================================================================
%>
<div id="kapak_sayfasi">
  <div class="kapak_ic">
    <div class="kapak_logo_alan">
      <img src="../../fiyat/images/logo.png" alt="Tunaylar"/>
    </div>
    <h1 id="list_type"><%
      if language <> 2 then
        if price_list_type = 1 then
          Response.Write("Fiyat Listesi")
        elseif price_list_type = 2 then
          Response.Write("Fiyat Listesi &mdash; Elektronik Hariç")
        elseif price_list_type = 3 then
          Response.Write("Bayi Ürün Fiyat Listesi")
        elseif price_list_type = 4 then
          Response.Write("Bayi Yedek Parça Fiyat Listesi")
        elseif price_list_type = 5 then
          Response.Write("Bayi Mekanik Fiyat Listesi")
        else
          Response.Write("Fiyat Listesi")
        end if
      else
        if price_list_type = 1 then
          Response.Write("Price List")
        elseif price_list_type = 2 then
          Response.Write("Price List &mdash; Mechanical Only")
        elseif price_list_type = 3 then
          Response.Write("Dealer Product Price List")
        elseif price_list_type = 4 then
          Response.Write("Dealer Spare Parts Price List")
        elseif price_list_type = 5 then
          Response.Write("Dealer Mechanical Price List")
        else
          Response.Write("Price List")
        end if
      end if
    %></h1>
    <h2 class="kapak_tarih_buyuk"><%=Year(Date())%><span>/<%=Month(Date())%></span></h2>
    <p class="kapak_tarih_kucuk"><%=Date()%></p>
    <%if Session("Company_Name") <>"" then%>
    <p class="kapak_firma"><%=Session("Company_Name")%></p>
    <%end if%>
  </div>
</div>

<%
'================================================================
' AÇIKLAMA SAYFASI  (sadece print'te sonraki sayfa)
'================================================================
%>
<% If (language <> 2) Then %>

  <div class="aciklama_sayfasi">
    <div class="aciklama_body">
      <h1>FİYATLAR</h1>
      <p>Bu fiyat listesinde yer alan tüm bedeller <strong>KDV hariçtir</strong>. Fiyatlar, listede belirtilen para birimi üzerinden verilmiş olup; ürün konfigürasyonu, opsiyon seçimi ve proje kapsamına göre değişiklik gösterebilir.</p>
      <p>Fiyat listesinde yer alan bilgiler, yalnızca bilgilendirme amaçlıdır ve Tunaylar tarafından yazılı olarak teyit edilmedikçe bağlayıcı teklif niteliği taşımaz.</p>

      <h2>GARANTİ KOŞULLARI</h2>
      <p>Listede yer alan tartı sistemleri, yürürlükteki garanti şartlarına uygun şekilde <strong>2 (iki) yıl</strong> garantilidir. Garanti kapsamı, şartları ve istisnaları ürün ile birlikte teslim edilen <strong>Garanti Belgesi</strong> ve ilgili teknik dokümanlarda belirtilmiştir.</p>
      <p>Garanti; imalat, işçilik ve malzeme hatalarından kaynaklanan arızaları kapsar. Kullanıcı kaynaklı hatalar, hatalı kullanım, darbe, yanlış montaj, yetkisiz müdahale, uygunsuz elektrik beslemesi/topraklama, doğal afetler ve sarf malzemeleri garanti kapsamı dışındadır.</p>

      <h2>NAKLİYE ve TESLİMAT</h2>
      <p>Listede yer alan fiyatlara <strong>nakliye, sigorta, indirme-bindirme, vinç/iş makinesi hizmetleri</strong> ve <strong>altyapı-inşaat işleri</strong> dahil değildir (aksi yazılı olarak belirtilmedikçe).</p>
      <p>Teslim şekli, proje/teklif bazında belirlenir. Sevkiyat süreci; müşterinin teslimat adresi, saha koşulları ve operasyon planına göre planlanır.</p>

      <h2>ÖDEME KOŞULLARI</h2>
      <p>Ödeme koşulları, satış teklifi ve/veya sözleşmede belirtilen şekilde geçerlidir. Ödemeler <strong>Nakit, Çek veya Banka Havalesi/EFT</strong> yoluyla yapılabilir.</p>
      <p>Yabancı para birimi ile düzenlenen satışlarda, ürün bedeli fatura kesim tarihindeki <strong>T.C. Merkez Bankası Döviz Satış Kuru</strong> üzerinden TL’ye çevrilerek tahsil edilir (aksi sözleşmede belirtilmedikçe).</p>

      <h2>GEÇERLİLİK, REVİZYON ve DİĞER HÜKÜMLER</h2>
      <p>Bu fiyat listesi; hammadde, döviz kuru, lojistik maliyetleri ve diğer piyasa koşullarındaki değişimlere bağlı olarak <strong>önceden bildirim yapılmaksızın</strong> güncellenebilir.</p>
      <p><br />Tunaylar; ürünlerine ait teknik özellikleri, tasarım detaylarını, görsel/renk ve aksesuarları önceden haber vermeksizin değiştirme hakkını saklı tutar.</p>
    </div>
  </div>

<% Else %>

  <div class="aciklama_sayfasi">
    <div class="aciklama_body">
      <h1>TERMS OF SALE AND CONDITIONS</h1>
      <p>This document outlines the general terms and conditions applicable to products and services supplied by <strong>Tunaylar</strong>. Unless otherwise stated in a written quotation or agreement, the following terms apply.</p>

      <h2>PRICES</h2>
      <p>All prices in the price list are provided for information purposes and do not constitute a binding offer unless confirmed in writing. Prices are stated <strong>excluding VAT</strong> and may vary depending on configuration, options, scope of work and project requirements.</p>

      <h2>PAYMENT TERMS</h2>
      <p>Payment terms shall be specified in the quotation and/or sales agreement. Payments may be made by <strong>cash, bank transfer</strong> or other mutually agreed methods.</p>
      <p>For invoices issued in a foreign currency, the equivalent amount in TRY may be calculated based on the <strong>Central Bank of the Republic of Türkiye (CBRT) selling exchange rate</strong> on the invoice date, unless otherwise agreed in writing.</p>

      <h2>DELIVERY TERMS</h2>
      <p>Unless otherwise agreed in writing, delivery is <strong>EXW (Incoterms® 2020)</strong>. The purchaser is responsible for collection, transportation, insurance and all risks from Tunaylar’s premises to the final destination.</p>
      <p>All costs and responsibilities related to import customs, duties, taxes, unloading, customs clearance, storage charges and any required licenses/authorizations are borne by the purchaser.</p>

      <h2>WARRANTY</h2>
      <p>Warranty period begins from the original delivery date stated on the transportation document and is valid for <strong>12 months</strong>, unless a different warranty period is specified in the quotation or contract.</p>
      <p>This warranty covers manufacturing defects, workmanship and material faults. The warranty does not cover damages caused by misuse, improper installation, unauthorized intervention, power supply issues, inadequate grounding, accidents, natural disasters or consumable parts.</p>
      <p>If on-site service is requested during the warranty period, the purchaser shall cover all travel, accommodation, local transportation, daily allowances and required expenses of Tunaylar’s technical staff. Any visa-related taxes/fees (if applicable) are also on the purchaser’s account.</p>

      <h2>TECHNICAL CHANGES &amp; VALIDITY</h2>
      <p>Tunaylar reserves the right to change technical specifications, design, images, colours and accessories without prior notice. The most recent version of the price list and/or written quotation shall prevail.</p>

      <h2>LIMITATION OF LIABILITY</h2>
      <p>In no event shall Tunaylar be liable for indirect or consequential damages, loss of profit, loss of business, or downtime costs, except as required by applicable law.</p>

      <p><br />Tunaylar reserves the right to revise this document and product specifications without prior notice.</p>
    </div>
  </div>

<% End If %>


<%
'================================================================
' İÇİNDEKİLER SAYFASI
'================================================================
%>

<div class="iceridekiler_sayfasi">
  <div class="iceridekiler_body">
    <h1>İÇİNDEKİLER</h1>
    <div id="iceridekiler_liste"></div>
  </div>
</div>


<%
'================================================================
' DETAYLAR POPUP
'================================================================
%>
<div id="detaylar">
  <div id="active_id" class="box_title"></div>
  <div id="detaylar_bolge">
    <p class="detaylar_label"><%if language<>2 then Response.Write("Montaj - Kalibrasyon Bölgesi Seçiniz") else Response.Write("Select Installation Region") end if%></p>
    <select id="bolge_sec" onchange="downloading_product(this)">
      <option value="0"><%if language<>2 then Response.Write("— Bölge Seçiniz —") else Response.Write("— Select Region —") end if%></option>
      <option value="300">1. Bölge &nbsp; 0–100 km &nbsp; 300 $</option>
      <option value="360">2. Bölge &nbsp; 101–200 km &nbsp; 360 $</option>
      <option value="410">3. Bölge &nbsp; 201–400 km &nbsp; 410 $</option>
      <option value="490">4. Bölge &nbsp; 401–600 km &nbsp; 490 $</option>
      <option value="570">5. Bölge &nbsp; 601–800 km &nbsp; 570 $</option>
    </select>
  </div>
  <div id="montajli_fiyat"></div>
</div>

<%
'================================================================
' YARDIM POPUP
'================================================================
%>
<div id="yardim">
  <div class="yardim_ic">
    <h3><%if language<>2 then Response.Write("YARDIM") else Response.Write("HELP") end if%></h3>
    <dl>
      <dt>FİYAT LİSTESİ</dt>
      <dd>Taşıt Kantarı, Vagon Kantarı ve Aks Kantarı maliyetlerine Damga ve Montaj Bedeli dahildir.</dd>
      <dt>BAYİ FİYAT LİSTESİ (ÜRÜNLER)</dt>
      <dd>Bayi alış fiyatlarına Damga ve Montaj bedelleri dahil değildir. Taşıt kantarında %20, ciroya göre ek indirim uygulanır.</dd>
      <dt>BAYİ FİYAT LİSTESİ (YEDEK PARÇA)</dt>
      <dd>Liste fiyatı üzerinden %15 iskonto. Ciroya göre ek indirim uygulanabilir.</dd>
      <dt>BAYİ FİYAT LİSTESİ (MEKANİK)</dt>
      <dd>Elektronik ekipman ve Damga Montaj dahil değildir. %20 iskonto uygulanır.</dd>
      <dt>YAZDIRMA</dt>
      <dd>İstediğiniz listeye gidin → Kategori seçin → <i class="fa fa-eye-slash"></i> ile satırları gizleyin → <strong>Ctrl+P</strong> → <em>Arka Plan Grafikleri Yazdır</em> seçeneğini aktif edin.</dd>
    </dl>
  </div>
</div>

<div id="temporary_div"></div>
<div id="aactive_id" class="box_title"></div>
<div id="aciklama_container"></div>
<div id="menu_div"></div>

<%
'================================================================
' ÜST BAR
'================================================================
%>
<div id="main_container">
  <!--#include file="top_temp.asp" -->
</div>



<%
'================================================================
' ANA İÇERİK: Sidebar + Body
'================================================================
%>
    <%
    '================================================================
    ' KAMPANYA KARTLARI BLOĞU
    '================================================================
    If kamp_hata <> "" Then
      Response.Write("<div style='background:#fdd;border:2px solid red;padding:12px;margin:10px;font-family:monospace;font-size:12px'><b>Kampanya Hata:</b> " & Server.HTMLEncode(kamp_hata) & "</div>")
    End If
    If kamp_var_mi Then
    %>
    <div id="kampanya_bolge">

      <div class="kamp_baslik_satir">
        <div class="kamp_baslik_ic">
          <span class="kamp_baslik_ikon">&#11088;</span>
          <div>
            <h2 class="kamp_baslik_h2"><%if language<>2 then Response.Write("Öne Çıkan Ürünler") else Response.Write("Featured Products") end if%></h2>
            <p class="kamp_baslik_alt"><%if language<>2 then Response.Write("Kampanya ve en çok tercih edilen ürünler") else Response.Write("Campaign and most preferred products") end if%></p>
          </div>
        </div>
        <div class="kamp_pulse_dot"></div>
      </div>

      <div class="kamp_grid">
      <%
      Dim kamp_sayi : kamp_sayi = 0
      Do While Not kamp_rs.EOF And kamp_sayi < 12

        Dim k_id, k_adi, k_img, k_one, k_etiket, k_katadi, k_pb
        Dim k_maliyet, k_kar, k_fiyat
        
        k_id     = kamp_rs("id")
        k_adi    = kamp_rs("urunadi")
        If language = 2 And Not IsNull(kamp_rs("urunadi_eng")) And Trim(kamp_rs("urunadi_eng")) <> "" Then k_adi = kamp_rs("urunadi_eng")
        k_img    = kamp_rs("img")
        k_one    = CInt(kamp_rs("one_cikan"))
        k_etiket = kamp_rs("one_cikan_etiket")
        k_gorsel = kamp_rs("one_cikan_gorsel")

        k_katadi = kamp_rs("anakatadi")
        If language = 2 And Not IsNull(kamp_rs("anakatadi_eng")) Then k_katadi = kamp_rs("anakatadi_eng")
        k_pb     = kamp_rs("para_birimi")
        If IsNull(k_pb) Then k_pb = "$"
        
        ' Etiket metni
        Dim k_rozet_metin, k_rozet_renk, k_rozet_ikon
        If Not IsNull(k_etiket) And Trim(k_etiket) <> "" Then
          k_rozet_metin = k_etiket
        Else
          Select Case k_one
            Case 1 : k_rozet_metin = "&#11088; &#199;ok Satan"       : k_rozet_renk = "#e67e22" : k_rozet_ikon = "&#11088;"
            Case 2 : k_rozet_metin = "&#128293; Kampanya"            : k_rozet_renk = "#e74c3c" : k_rozet_ikon = "&#128293;"
            Case 3 : k_rozet_metin = "&#127381; Yeni &#220;r&#252;n" : k_rozet_renk = "#27ae60" : k_rozet_ikon = "&#127381;"
            Case 4 : k_rozet_metin = "&#128142; &#214;ne &#199;&#305;kan" : k_rozet_renk = "#8e44ad" : k_rozet_ikon = "&#128142;"
            Case Else: k_rozet_metin = "&#11088; &#214;ne &#199;&#305;kan" : k_rozet_renk = "#e67e22" : k_rozet_ikon = "&#11088;"
          End Select
        End If
        
        ' Fiyat hesapla
        Dim k_fiyat_metin : k_fiyat_metin = ""
        If Not IsNull(kamp_rs("min_maliyet")) And Not IsNull(kamp_rs("min_kar")) Then
          Dim k_mal, k_kar_oran
          k_mal = CDbl(kamp_rs("min_maliyet"))
          k_kar_oran = CDbl(kamp_rs("min_kar"))
          If k_kar_oran > 0 And k_kar_oran < 100 Then
            k_fiyat = k_pb & " " & FormatNumber(Round(Abs(k_mal*100)/(100-k_kar_oran), 0), 0)
            k_fiyat_metin = k_fiyat
          End If
        End If
      %>
        
        <div class="kamp_kart" onclick="document.getElementById('main_cat_select').value=<%=k_id%>; var s=document.getElementById('main_cat_select'); var ev=document.createEvent('Event'); ev.initEvent('change',true,true); s.dispatchEvent(ev);">
          
          <% if k_gorsel <> "" then %>
            <div class="kamp_img_wrap" style="height:100%"><img src="<%=(k_gorsel)%>" class="kamp_img" style="height:100%"  onerror="this.parentElement.style.display='none'"/></div>
          <% else %>
          
                    <div class="kamp_rozet" style="background:<%=k_rozet_renk%>"><%=k_rozet_metin%></div>
                    <%if Trim(k_img) <> "" then%>
                    <div class="kamp_img_wrap">
                      <img src="<%=k_img%>" alt="<%=Server.HTMLEncode(k_adi)%>" class="kamp_img" onerror="this.parentElement.style.display='none'"/>
                    </div>
                    <%else%>
                    <div class="kamp_img_wrap kamp_no_img">
                      <span class="kamp_no_img_ikon"><%=k_rozet_ikon%></span>
                    </div>
                    <%end if%>
                    <div class="kamp_kart_ic">
                      <p class="kamp_katadi"><%=Server.HTMLEncode(k_katadi)%></p>
                      <h3 class="kamp_urunadi"><%=Server.HTMLEncode(k_adi)%></h3>
                      <%if k_fiyat_metin <> "" then%>
                      <p class="kamp_fiyat_label"><%if language<>2 then Response.Write("Liste Fiyatından") else Response.Write("From list price") end if%></p>
                      <p class="kamp_fiyat"><%=k_fiyat_metin%></p>
                      <%end if%>
                      <div class="kamp_btn"><%if language<>2 then Response.Write("İncele &rarr;") else Response.Write("View &rarr;") end if%></div>
                    </div>
          <% end if %>
        
        
        </div>

      <%
        kamp_sayi = kamp_sayi + 1
        kamp_rs.MoveNext
      Loop
      kamp_rs.Close
      Set kamp_rs = Nothing
      kamp_conn.Close
      Set kamp_conn = Nothing
      %>
      </div>
    </div>
    <% End If %>

<div id="body_div_container">
<div id="body_div">



  <div id="body_text">

    <div id="filter_bar">
      <div class="filter_group">
        <label class="filter_label"><%if language<>2 then Response.Write("Ürün Kategorisi") else Response.Write("Product Category") end if%></label>
        <select id="main_cat_select" onchange="downloading_product(this)">
          <option value="0"><%if language<>2 then Response.Write("Kategori Seçiniz") else Response.Write("Select Category") end if%></option>
          <%if list <> 2 then%>
            <option value="-1"><%if language<>2 then Response.Write("Tüm Ürünler") else Response.Write("All Products") end if%></option>
            <option value="-2"><%if language<>2 then Response.Write("⭐ Öne Çıkan Ürünler") else Response.Write("⭐ Featured Products") end if%></option>
          <%end if%>
          <%While (Repeat5__numRows <> 0) AND (NOT products.EOF)%>
          <option value="<%=products.Fields.Item("id").Value%>">
            <%if language<>2 then Response.Write(products.Fields.Item("anakatadi").Value) else Response.Write(products.Fields.Item("anakatadi_eng").Value) end if%>
          </option>
          <%Repeat5__index=Repeat5__index+1 : Repeat5__numRows=Repeat5__numRows-1 : products.MoveNext() : Wend%>
        </select>
      </div>
       

      <div class="filter_group">
             <label class="filter_label" id="selected_title"><%if   language<>2 then Response.Write("Ürünler") else Response.Write("Products") end if%></label>

      <div  id="load_select_result">

        <select disabled><option><%if language<>2 then Response.Write("Ürün Seçiniz") else Response.Write("Select Product") end if%></option></select>
      </div>
      </div>
      <div class="filter_group" id="kapasite_select_result"></div>

      <div class="filter_group" style="margin-left:auto;">
  <label class="filter_label">&#160;</label>
  <a onclick="yazdir()" style="
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 8px 18px;
    background: var(--navy);
    color: #fff;
    border-radius: var(--r4);
    font-family: var(--fhead);
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    cursor: pointer;
    border: none;
    transition: background .18s;
    text-decoration: none;
  "
  onmouseover="this.style.background='var(--amber)';this.style.color='var(--navy)'"
  onmouseout="this.style.background='var(--navy)';this.style.color='#fff'"
  >
    <i class="fa fa-print"></i> Yazdır
  </a>
</div>

      <input type="hidden" id="price_list_type" value="<%=price_list_type%>"/>
      <input type="hidden" id="language_type"   value="<%=language%>"/>
      <input type="hidden" id="user_type"        value="<%=Session("MM_UserAuthorization")%>"/>
    
    </div>


    <div id="result_select">
      <div id="loaded_area" style="background-color:#FFF"></div>
    </div>

  </div>

  <div class="clearfix"></div>
  
</div>
</div>


<div id="bottom_container_div">
  <!--#include file="bottom_temp.html" -->
  
</div>

<div id="print_footer">
  <span class="footer_firma">TUNAYLAR BASKÜL SANAYİ VE TİCARET A.Ş.</span>
  <span class="pageNumber">www.tunaylar.com</span>
</div>
<script>
  function printStilDegistir(dosya) {
    document.getElementById('print-style-link').href = dosya;
    try { localStorage.setItem('tny_print_stil', dosya); } catch(e){}
  }
  // Sayfa açılışında kaydedilmiş stili uygula
  (function(){
    try {
      var kayitli = localStorage.getItem('tny_print_stil');
      if(kayitli) {
        document.getElementById('print-style-link').href = kayitli;
        document.querySelectorAll('input[name="print_stil"]').forEach(function(r){
          r.checked = (r.value === kayitli);
        });
      }
    } catch(e){}
  })();
</script>
</body>


</html>

<%
products.Close()
Set products = Nothing

' Kampanya nesnelerini temizle (hata durumunda açık kalmışsa)
On Error Resume Next
If Not IsNull(kamp_rs) Then
  If kamp_rs.State = 1 Then kamp_rs.Close
  Set kamp_rs = Nothing
End If
If Not IsNull(kamp_conn) Then
  If kamp_conn.State = 1 Then kamp_conn.Close
  Set kamp_conn = Nothing
End If
On Error GoTo 0
%>
