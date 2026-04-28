<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../Connections/fiyat2.asp" -->
<!--#include file="../member_security.asp" -->
<%
  Dim yonetici, super_yonetici
  super_yonetici = "1"
  yonetici       = "2"
  If Session("MM_UserAuthorization") <> yonetici And _
     Session("MM_UserAuthorization") <> super_yonetici Then
    Response.Redirect("../default.asp")
  End If
  Dim urun_id : urun_id = 0
  If Request.QueryString("id") <> "" And IsNumeric(Request.QueryString("id")) Then
    urun_id = CLng(Request.QueryString("id"))
  End If
  If urun_id = 0 Then Response.Redirect("urun_listesi.asp")
%>

<%
Function SafeHtml(v)
  If IsNull(v) Or IsEmpty(v) Then
    SafeHtml = ""
  Else
    SafeHtml = Server.HTMLEncode(CStr(v))
  End If
End Function
%>

<%
'================================================================
' YARDIMCI FONKSİYONLAR
'================================================================
Function SS(v) : SS = "'" & Replace(Trim(v),"'","''") & "'" : End Function
Function SN(v)
  Dim x : x = Trim(Replace(v,",","."))
  If x="" Or Not IsNumeric(x) Then SN="NULL" Else SN=CStr(CDbl(x))
End Function
Function SNL(v)
  Dim x : x = Trim(v)
  If x="" Then SNL="NULL" Else SNL="'" & Replace(x,"'","''") & "'"
End Function

'================================================================
' İŞLEM: ÜRÜN GÜNCELLE
'================================================================
Dim msg, msg_tip : msg="" : msg_tip=""

If Request.Form("act") = "urun_kaydet" Then
  Dim fu,fue,fakno,ford,fatr,faen,falt_tr,falt_en,fbay_tr,fbay_en,fimg,fpg
  fu=Trim(Request.Form("urunadi")) : fue=Trim(Request.Form("urunadi_eng"))
  fakno=Trim(Request.Form("akno")) : ford=Trim(Request.Form("ord"))
  fatr=Trim(Request.Form("aciklama_tr")) : faen=Trim(Request.Form("aciklama_en"))
  falt_tr=Trim(Request.Form("alt_tr")) : falt_en=Trim(Request.Form("alt_en"))
  fbay_tr=Trim(Request.Form("bayi_tr")) : fbay_en=Trim(Request.Form("bayi_en"))
  fimg=Trim(Request.Form("img")) : fpg=Trim(Request.Form("print_group"))

  Dim fone_cikan, fone_etiket, fone_gorsel
  fone_cikan = Trim(Request.Form("one_cikan"))
  If fone_cikan="" Or Not IsNumeric(fone_cikan) Then fone_cikan=0
  fone_etiket = Trim(Request.Form("one_cikan_etiket"))
  fone_gorsel = Trim(Request.Form("one_cikan_gorsel"))

  Dim fad_aktif : fad_aktif = 0
  If InStr(Request.Form("aktif_degil"),"1") > 0 Then fad_aktif = 1

  If fu="" Then
    msg="Ürün adı zorunludur." : msg_tip="err"
  ElseIf fakno="" Or Not IsNumeric(fakno) Then
    msg="Kategori seçimi zorunludur." : msg_tip="err"
  Else
    If ford="" Or Not IsNumeric(ford) Then ford="0"
    On Error Resume Next
    Dim db0 : Set db0=Server.CreateObject("ADODB.Connection")
    db0.Open MM_fiyat_STRING
    db0.Execute("UPDATE urunler SET " & _
      "urunadi=" & SS(fu) & ",urunadi_eng=" & SNL(fue) & _
      ",akno=" & CLng(fakno) & ",ord=" & CLng(ford) & _
      ",fiyat_liste_aciklama=" & SNL(fatr) & _
      ",fiyat_liste_aciklama_eng=" & SNL(faen) & _
      ",fiyat_liste_alt_aciklama=" & SNL(falt_tr) & _
      ",fiyat_liste_alt_aciklama_eng=" & SNL(falt_en) & _
      ",bayi_fiyat_liste_aciklama=" & SNL(fbay_tr) & _
      ",bayi_fiyat_liste_aciklama_eng=" & SNL(fbay_en) & _
      ",img=" & SNL(fimg) & ",print_group=" & SNL(fpg) & _
      ",one_cikan=" & CLng(fone_cikan) & _
      ",one_cikan_etiket=" & SNL(fone_etiket) & _
      ",one_cikan_gorsel=" & SNL(fone_gorsel) & _
      ",aktif_degil=" & -1*(fad_aktif=1) & _
      " WHERE id=" & urun_id)
    If Err.Number<>0 Then
      msg="Hata: "&Err.Description : msg_tip="err"
    Else
      ' Kategori değişmişse ebat tablosundaki ankno'yu da güncelle
      db0.Execute("UPDATE ebat SET ankno=" & CLng(fakno) & " WHERE product_id=" & urun_id)
      msg="Ürün bilgileri güncellendi." : msg_tip="ok"
    End If
    db0.Close:Set db0=Nothing:On Error GoTo 0
  End If
End If

'================================================================
' İŞLEM: KAPASİTE EKLE
'================================================================
Dim kap_msg, kap_tip : kap_msg="" : kap_tip=""
Dim yeni_kap_id : yeni_kap_id = 0

If Request.Form("act") = "kap_ekle" Then
  Dim fkap : fkap = Trim(Request.Form("kap_taksimat"))
  If fkap="" Or Not IsNumeric(Replace(fkap,",",".")) Then
    kap_msg="Geçerli bir kapasite değeri giriniz (sadece sayı)." : kap_tip="err"
  Else
    On Error Resume Next
    Dim db_k : Set db_k=Server.CreateObject("ADODB.Connection")
    db_k.Open MM_fiyat_STRING
    db_k.Execute("INSERT INTO kaptak (kap_taksimat,product_id,aktif_degil) VALUES (" & SN(fkap) & "," & urun_id & ",0)")
    If Err.Number<>0 Then
      kap_msg="Kapasite eklenemedi: "&Err.Description : kap_tip="err"
    Else
      Dim rk : Set rk=db_k.Execute("SELECT MAX(id) FROM kaptak WHERE product_id=" & urun_id)
      yeni_kap_id = rk(0) : rk.Close : Set rk=Nothing
      kap_msg="Kapasite eklendi (ID: " & yeni_kap_id & ")." : kap_tip="ok"
    End If
    db_k.Close:Set db_k=Nothing:On Error GoTo 0
  End If
End If

' Kapasite güncelle
If Request.Form("act") = "kap_guncelle" Then
  Dim gk_id : gk_id=CLng(Request.Form("gk_id"))
  Dim gk_kap : gk_kap=Trim(Request.Form("gk_kap"))
  Dim gk_aktif : gk_aktif = 0
  If InStr(Request.Form("gk_aktif_degil"),"1") > 0 Then gk_aktif = 1
  On Error Resume Next
  Dim db_kg:Set db_kg=Server.CreateObject("ADODB.Connection")
  db_kg.Open MM_fiyat_STRING
  db_kg.Execute("UPDATE kaptak SET kap_taksimat=" & SN(gk_kap) & ",aktif_degil=" & -1*(gk_aktif=1) & " WHERE id=" & gk_id & " AND product_id=" & urun_id)
  If Err.Number<>0 Then kap_msg="Güncelleme hatası: "&Err.Description:kap_tip="err" Else kap_msg="Kapasite güncellendi.":kap_tip="ok"
  db_kg.Close:Set db_kg=Nothing:On Error GoTo 0
End If

' Kapasite sil
If Request.QueryString("sil_kap_id") <> "" Then
  Dim sk_id:sk_id=CLng(Request.QueryString("sil_kap_id"))
  On Error Resume Next
  Dim db_kd:Set db_kd=Server.CreateObject("ADODB.Connection")
  db_kd.Open MM_fiyat_STRING
  Dim rs_kchk:Set rs_kchk=db_kd.Execute("SELECT COUNT(*) FROM ebat WHERE kaptak_id=" & sk_id)
  Dim kbag:kbag=0:If Not rs_kchk.EOF Then kbag=rs_kchk(0):End If:rs_kchk.Close:Set rs_kchk=Nothing
  If kbag>0 Then
    kap_msg="Bu kapasiteye bağlı "&kbag&" ebat var. Önce ebatları silin." : kap_tip="warn"
  Else
    db_kd.Execute("DELETE FROM kaptak WHERE id=" & sk_id & " AND product_id=" & urun_id)
    If Err.Number<>0 Then kap_msg="Silme hatası: "&Err.Description:kap_tip="err" Else kap_msg="Kapasite silindi.":kap_tip="ok"
  End If
  db_kd.Close:Set db_kd=Nothing:On Error GoTo 0
End If

'================================================================
' İŞLEM: EBAT/FİYAT EKLE
'================================================================
Dim ebat_msg, ebat_tip : ebat_msg="" : ebat_tip=""
Dim yeni_ebat_id : yeni_ebat_id=0

If Request.Form("act") = "ebat_ekle" Then
  Dim ef_kap_id : ef_kap_id = Trim(Request.Form("ebat_kap_id"))
  If ef_kap_id="" Or Not IsNumeric(ef_kap_id) Then
    ebat_msg="Kapasite seçimi zorunludur." : ebat_tip="err"
  Else
    On Error Resume Next
    Dim db_ea:Set db_ea=Server.CreateObject("ADODB.Connection")
    db_ea.Open MM_fiyat_STRING
    ' ankno al
    Dim rs_an:Set rs_an=db_ea.Execute("SELECT akno FROM urunler WHERE id=" & urun_id)
    Dim v_ankno:v_ankno=0:If Not rs_an.EOF Then v_ankno=rs_an(0):End If:rs_an.Close:Set rs_an=Nothing
    ' order
    Dim ef_ord:ef_ord=Trim(Request.Form("ebat_order"))
    If ef_ord="" Or Not IsNumeric(ef_ord) Then ef_ord="10" Else ef_ord=CStr(CLng(ef_ord))
    Dim ef_pb:ef_pb=Trim(Request.Form("ebat_pb"))
    If ef_pb="" Then ef_pb="$"

    db_ea.Execute("INSERT INTO ebat (" & _
      "product_id,ankno,kaptak_id,model_kodu," & _
      "x_genislik,y_genislik,z_yukseklik," & _
      "para_birimi,Aciklama,[order]," & _
      "Maliyet_Fiyati,Kar_Orani1,Kar_Orani2,Kar_Orani3," & _
      "Mekanik_Maliyet,Mekanik_Kar_Orani1,Mekanik_Kar_Orani2,Mekanik_Kar_Orani3" & _
      ") VALUES (" & _
      urun_id & "," & v_ankno & "," & CLng(ef_kap_id) & "," & SNL(Request.Form("ebat_model")) & "," & _
      SN(Request.Form("ebat_x")) & "," & SN(Request.Form("ebat_y")) & "," & SN(Request.Form("ebat_z")) & "," & _
      SS(ef_pb) & "," & SNL(Request.Form("ebat_aciklama")) & "," & ef_ord & "," & _
      SN(Request.Form("ebat_maliyet")) & "," & SN(Request.Form("ebat_k1")) & "," & SN(Request.Form("ebat_k2")) & "," & SN(Request.Form("ebat_k3")) & "," & _
      SN(Request.Form("ebat_mm")) & "," & SN(Request.Form("ebat_mk1")) & "," & SN(Request.Form("ebat_mk2")) & "," & SN(Request.Form("ebat_mk3")) & ")")
    If Err.Number<>0 Then
      ebat_msg="Ebat eklenemedi: "&Err.Description : ebat_tip="err"
    Else
      Dim re:Set re=db_ea.Execute("SELECT MAX(id) FROM ebat WHERE product_id=" & urun_id)
      yeni_ebat_id=re(0):re.Close:Set re=Nothing
      ebat_msg="Ebat/fiyat eklendi (ID: " & yeni_ebat_id & ")." : ebat_tip="ok"
    End If
    db_ea.Close:Set db_ea=Nothing:On Error GoTo 0
  End If
End If

' Ebat güncelle
If Request.Form("act") = "ebat_guncelle" Then
  Dim ge_id:ge_id=CLng(Request.Form("ge_id"))
  Dim ge_ord:ge_ord=Trim(Request.Form("ge_order"))
  If ge_ord="" Or Not IsNumeric(ge_ord) Then ge_ord="NULL" Else ge_ord=CStr(CLng(ge_ord))
  Dim ge_aktif : ge_aktif = 0
  If InStr(Request.Form("ge_aktif_degil"),"1") > 0 Then ge_aktif = 1
  On Error Resume Next
  Dim db_eg:Set db_eg=Server.CreateObject("ADODB.Connection")
  db_eg.Open MM_fiyat_STRING
  db_eg.Execute("UPDATE ebat SET " & _
    "model_kodu=" & SNL(Request.Form("ge_model")) & _
    ",x_genislik=" & SN(Request.Form("ge_x")) & _
    ",y_genislik=" & SN(Request.Form("ge_y")) & _
    ",z_yukseklik=" & SN(Request.Form("ge_z")) & _
    ",para_birimi=" & SS(Request.Form("ge_pb")) & _
    ",Aciklama=" & SNL(Request.Form("ge_aciklama")) & _
    ",[order]=" & ge_ord & _
    ",Maliyet_Fiyati=" & SN(Request.Form("ge_maliyet")) & _
    ",Kar_Orani1=" & SN(Request.Form("ge_k1")) & _
    ",Kar_Orani2=" & SN(Request.Form("ge_k2")) & _
    ",Kar_Orani3=" & SN(Request.Form("ge_k3")) & _
    ",Mekanik_Maliyet=" & SN(Request.Form("ge_mm")) & _
    ",Mekanik_Kar_Orani1=" & SN(Request.Form("ge_mk1")) & _
    ",Mekanik_Kar_Orani2=" & SN(Request.Form("ge_mk2")) & _
    ",Mekanik_Kar_Orani3=" & SN(Request.Form("ge_mk3")) & _
    ",aktif_degil=" & -1*(ge_aktif=1) & _
    " WHERE id=" & ge_id & " AND product_id=" & urun_id)
  If Err.Number<>0 Then ebat_msg="Hata: "&Err.Description:ebat_tip="err" Else ebat_msg="Ebat güncellendi.":ebat_tip="ok"
  db_eg.Close:Set db_eg=Nothing:On Error GoTo 0
End If

' Ebat sil
If Request.QueryString("sil_ebat_id") <> "" Then
  Dim se_id:se_id=CLng(Request.QueryString("sil_ebat_id"))
  On Error Resume Next
  Dim db_ed:Set db_ed=Server.CreateObject("ADODB.Connection")
  db_ed.Open MM_fiyat_STRING
  db_ed.Execute("DELETE FROM ebat WHERE id=" & se_id & " AND product_id=" & urun_id)
  If Err.Number<>0 Then ebat_msg="Silme hatası: "&Err.Description:ebat_tip="err" Else ebat_msg="Ebat silindi.":ebat_tip="ok"
  db_ed.Close:Set db_ed=Nothing:On Error GoTo 0
End If

'================================================================
' EBAT SIRALAMA KAYDET (AJAX)
'================================================================
If Request.Form("act") = "ebat_siralama_kaydet" Then
  Dim es_json : es_json = Trim(Request.Form("siralar"))
  Dim es_ok : es_ok = True
  On Error Resume Next
  Dim es_db : Set es_db = Server.CreateObject("ADODB.Connection")
  es_db.Open MM_fiyat_STRING
  Dim es_pos : es_pos = 1
  Do
    Dim es_s : es_s = InStr(es_pos, es_json, "{")
    Dim es_e : es_e = InStr(es_pos, es_json, "}")
    If es_s = 0 Or es_e = 0 Then Exit Do
    Dim es_blok : es_blok = Mid(es_json, es_s+1, es_e-es_s-1)
    Dim es_id_pos  : es_id_pos  = InStr(es_blok, """id"":")
    Dim es_ord_pos : es_ord_pos = InStr(es_blok, """ord"":")
    If es_id_pos > 0 And es_ord_pos > 0 Then
      Dim es_id_str  : es_id_str  = Mid(es_blok, es_id_pos+5)
      Dim es_ord_str : es_ord_str = Mid(es_blok, es_ord_pos+6)
      Dim es_id_v, es_ord_v
      If InStr(es_id_str, ",")>0  Then es_id_v  = Left(es_id_str,  InStr(es_id_str, ",")-1)  Else es_id_v  = es_id_str
      If InStr(es_ord_str,",")>0  Then es_ord_v = Left(es_ord_str, InStr(es_ord_str,",")-1)  Else es_ord_v = es_ord_str
      es_id_v = Trim(es_id_v) : es_ord_v = Trim(es_ord_v)
      If IsNumeric(es_id_v) And IsNumeric(es_ord_v) Then
        es_db.Execute "UPDATE ebat SET [order]=" & CLng(es_ord_v) & " WHERE id=" & CLng(es_id_v) & " AND product_id=" & urun_id
        If Err.Number <> 0 Then es_ok = False : Err.Clear
      End If
    End If
    es_pos = es_e + 1
  Loop
  es_db.Close : Set es_db = Nothing
  On Error GoTo 0
  Response.ContentType = "application/json"
  If es_ok Then Response.Write("{""ok"":true}") Else Response.Write("{""ok"":false}")
  Response.End
End If

'================================================================
' VERİ ÇEKİMİ
'================================================================
Dim db : Set db=Server.CreateObject("ADODB.Connection")
db.Open MM_fiyat_STRING

' Ürün
Dim rs_u:Set rs_u=db.Execute("SELECT * FROM urunler WHERE id=" & urun_id)
If rs_u.EOF Then rs_u.Close:Set rs_u=Nothing:db.Close:Set db=Nothing:Response.Redirect("urun_listesi.asp")
Dim vu,vue,vakno,vord,vatr,vaen,valt_tr,valt_en,vbay_tr,vbay_en,vimg,vpg,vaktif
vu=rs_u("urunadi"):vue=rs_u("urunadi_eng") & "":vakno=rs_u("akno"):vord=rs_u("ord")
vatr=rs_u("fiyat_liste_aciklama"):vaen=rs_u("fiyat_liste_aciklama_eng")
valt_tr=rs_u("fiyat_liste_alt_aciklama"):valt_en=rs_u("fiyat_liste_alt_aciklama_eng")
vbay_tr=rs_u("bayi_fiyat_liste_aciklama"):vbay_en=rs_u("bayi_fiyat_liste_aciklama_eng")
vimg=rs_u("img"):vpg=rs_u("print_group")
Dim vone_cikan, vone_etiket, vone_gorsel
vone_cikan=rs_u("one_cikan"):If IsNull(vone_cikan) Then vone_cikan=0
vone_etiket=rs_u("one_cikan_etiket"):If IsNull(vone_etiket) Then vone_etiket=""
vone_gorsel=rs_u("one_cikan_gorsel"):If IsNull(vone_gorsel) Then vone_gorsel=""
vaktif=rs_u("aktif_degil"):If IsNull(vaktif) Then vaktif=0
rs_u.Close:Set rs_u=Nothing

' Kategori dropdown
Dim rs_kat:Set rs_kat=db.Execute("SELECT id,anakatadi FROM Anakatagori WHERE language=1 ORDER BY siralama")

' Kapasite listesi
Dim gk_edit_id:gk_edit_id=""
If Request.QueryString("kap_duzenle") <> "" Then gk_edit_id=CStr(CLng(Request.QueryString("kap_duzenle")))
Dim rs_kap:Set rs_kap=db.Execute("SELECT id,kap_taksimat,aktif_degil FROM kaptak WHERE product_id=" & urun_id & " ORDER BY kap_taksimat")

' Ebat listesi
Dim ge_edit_id:ge_edit_id=""
If Request.QueryString("ebat_duzenle") <> "" Then ge_edit_id=CStr(CLng(Request.QueryString("ebat_duzenle")))
Dim rs_eb
Set rs_eb=db.Execute( _
  "SELECT e.*,k.kap_taksimat FROM ebat e " & _
  "INNER JOIN kaptak k ON e.kaptak_id=k.id " & _
  "WHERE e.product_id=" & urun_id & " ORDER BY k.kap_taksimat, e.[order]")

' Hangi sekme açık?
Dim aktif_sekme : aktif_sekme = "urun"
If Request.QueryString("sekme") = "kapasite" Or kap_tip <> "" Then aktif_sekme = "kapasite"
If Request.QueryString("sekme") = "ebat" Or ebat_tip <> "" Then aktif_sekme = "ebat"
If Request.Form("act") = "urun_kaydet" Then aktif_sekme = "urun"
%>

<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="utf-8"/>
  <title>Ürün Düzenle — <%=Server.HTMLEncode(vu)%></title>
  <link href="../screen.css" media="screen" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
  <style>
    *{box-sizing:border-box}
    body{font-family:'Barlow',Arial,sans-serif;background:#f0f2f5;margin:0}

    .hdr{background:#1a2332;color:#fff;padding:0 24px;display:flex;align-items:center;justify-content:space-between;height:52px}
    .hdr h1{margin:0;font-size:16px;font-weight:600;display:flex;align-items:center;gap:8px;overflow:hidden}
    .hdr h1 em{font-style:normal;font-weight:400;color:#aaa;font-size:14px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
    .hdr-nav{display:flex;gap:6px;flex-shrink:0}
    .hdr-nav a{color:#37c2e4;text-decoration:none;font-size:12px;padding:5px 10px;border-radius:4px;border:1px solid rgba(55,194,228,.3);display:flex;align-items:center;gap:5px;white-space:nowrap}
    .hdr-nav a:hover{background:rgba(55,194,228,.15)}

    /* SEKMELER */
    .tab-bar{background:#fff;border-bottom:2px solid #e8eaed;padding:0 24px;display:flex;gap:0}
    .tab{padding:12px 20px;font-size:13px;font-weight:600;color:#888;cursor:pointer;border-bottom:3px solid transparent;margin-bottom:-2px;display:flex;align-items:center;gap:7px;user-select:none;text-decoration:none}
    .tab:hover{color:#37c2e4}
    .tab.on{color:#37c2e4;border-bottom-color:#37c2e4}
    .tab .cnt{background:#37c2e4;color:#fff;border-radius:10px;padding:1px 6px;font-size:10px;font-weight:700}
    .tab .cnt.grey{background:#bdc3c7}

    .page-wrap{max-width:1400px;margin:20px auto;padding:0 20px}

    /* KART */
    .card{background:#fff;border-radius:8px;box-shadow:0 1px 4px rgba(0,0,0,.08);margin-bottom:20px;overflow:hidden}
    .card-head{background:#ecf0f1;padding:10px 18px;font-weight:700;font-size:13px;color:#2c3e50;border-bottom:1px solid #dde;display:flex;align-items:center;justify-content:space-between;gap:8px}
    .card-body{padding:18px}

    /* FORM */
    .frow{display:flex;gap:14px;margin-bottom:14px;flex-wrap:wrap}
    .fcol{flex:1;min-width:180px}
    .fcol label{display:block;font-size:11px;font-weight:700;color:#666;margin-bottom:4px;text-transform:uppercase;letter-spacing:.4px}
    .req{color:#e74c3c}
    .fcol input,.fcol select,.fcol textarea{width:100%;padding:8px 10px;border:1px solid #ccd;border-radius:4px;font-size:13px;font-family:inherit;background:#fafafa}
    .fcol input:focus,.fcol select:focus,.fcol textarea:focus{outline:none;border-color:#37c2e4;background:#fff}
    .fcol textarea{resize:vertical;min-height:76px}
    .fhint{font-size:11px;color:#999;margin-top:3px}

    /* BUTONLAR */
    .btn{display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border:none;border-radius:5px;font-size:13px;cursor:pointer;font-weight:600;text-decoration:none;white-space:nowrap}
    .btn-green{background:#2ecc71;color:#fff}.btn-green:hover{background:#27ae60}
    .btn-blue{background:#37c2e4;color:#fff}.btn-blue:hover{background:#2aabb0}
    .btn-red{background:#e74c3c;color:#fff}.btn-red:hover{background:#c0392b}
    .btn-grey{background:#95a5a6;color:#fff}.btn-grey:hover{background:#7f8c8d}
    .btn-orange{background:#f39c12;color:#fff}.btn-orange:hover{background:#d68910}
    .btn-sm{padding:4px 9px;font-size:12px}

    /* MESAJ */
    .msg{padding:10px 16px;border-radius:5px;margin-bottom:14px;font-size:13px;font-weight:500;display:flex;align-items:center;gap:8px}
    .msg-ok{background:#d4edda;color:#155724;border:1px solid #c3e6cb}
    .msg-err{background:#f8d7da;color:#721c24;border:1px solid #f5c6cb}
    .msg-warn{background:#fff3cd;color:#856404;border:1px solid #ffeeba}

    /* KAPASİTE TABLOSU */
    .kap-table{width:100%;border-collapse:collapse;font-size:13px}
    .kap-table thead tr{background:#2c3e50;color:#fff}
    .kap-table th{padding:9px 12px;text-align:left;font-weight:600}
    .kap-table td{padding:8px 12px;border-bottom:1px solid #f0f0f0;vertical-align:middle}
    .kap-table tr:last-child td{border-bottom:none}
    .kap-table tr:hover td{background:#f7fbff}
    .kap-table .edit-row td{background:#fffde7!important}
    .kap-table input{width:100%;padding:5px 8px;border:1px solid #ccd;border-radius:3px;font-size:12px;box-sizing:border-box}

    /* EBAT TABLOSU */
    .ebat-wrap{overflow-x:auto}
    .ebat-table{width:100%;border-collapse:collapse;font-size:12px;white-space:nowrap}
    .ebat-table thead tr{background:#2c3e50;color:#fff}
    .ebat-table th{padding:8px 7px;text-align:left;font-weight:600}
    .ebat-table td{padding:6px 7px;border-bottom:1px solid #f0f0f0;vertical-align:middle}
    .ebat-table tr:last-child td{border-bottom:none}
    .ebat-table tr:hover td{background:#f7fbff}
    .ebat-table .edit-row td{background:#fffde7!important}
    .ebat-table input{box-sizing:border-box;padding:4px 5px;border:1px solid #ccd;border-radius:3px;font-size:11px;background:#fafafa}
    .ebat-table input:focus{border-color:#37c2e4;background:#fff;outline:none}
    .pb-sel{padding:4px 3px;border:1px solid #ccd;border-radius:3px;font-size:11px}

    /* SIRALAMA */
    .drag-handle{cursor:grab;color:#bbb;padding:0 5px;font-size:15px;user-select:none;display:inline-block}
    .drag-handle:hover{color:#37c2e4}
    .ebat-table tbody tr.dragging{opacity:.4;background:#e8f0fe!important}
    .ebat-table tbody tr.drag-over td{border-top:2px solid #37c2e4!important}
    .sira-toast{position:fixed;bottom:18px;right:18px;background:#2c3e50;color:#fff;padding:8px 16px;border-radius:6px;font-size:12px;font-weight:600;z-index:9999;display:none;align-items:center;gap:8px}

    /* SEKSİYON AYRAÇ */
    .sep{border:none;border-top:2px dashed #e0e0e0;margin:14px 0}

    /* ONAY OVERLAY */
    .overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:9999;align-items:center;justify-content:center}
    .modal{background:#fff;border-radius:10px;padding:32px;max-width:400px;width:90%;text-align:center;box-shadow:0 8px 32px rgba(0,0,0,.2)}
    .modal h3{margin:0 0 12px;font-size:17px;color:#2c3e50}
    .modal p{margin:0 0 22px;font-size:13px;color:#666;line-height:1.6}
    .modal-btns{display:flex;gap:10px;justify-content:center}

    /* EKLE FORMU VURGU */
    .add-box{background:#f0f8ff;border:1px solid #bee5eb;border-radius:6px;padding:16px;margin-bottom:20px}
    .add-box-title{font-size:12px;font-weight:700;color:#0c5460;text-transform:uppercase;letter-spacing:.5px;margin-bottom:12px;display:flex;align-items:center;gap:7px}

    .badge{display:inline-flex;align-items:center;justify-content:center;min-width:22px;padding:2px 7px;border-radius:10px;font-size:11px;font-weight:700;text-decoration:none}
    .badge-blue{background:#37c2e4;color:#fff}
    .badge-grey{background:#bdc3c7;color:#fff}

    /* GÖRSEL ÖNİZLEME */
    .img-preview{margin-top:7px;border:2px solid #dde;border-radius:5px;overflow:hidden;background:#f8f8f8;display:inline-block}
    .img-preview img{display:block;max-width:200px;max-height:130px;object-fit:contain}
  </style>
</head>
<body>

<div class="hdr">
  <h1>
    <i class="fa fa-pen"></i>
    <em><%=Server.HTMLEncode(vu)%></em>
  </h1>
  <div class="hdr-nav">
    <a href="urun_ekle.asp"><i class="fa fa-plus"></i> Yeni Ürün</a>
    <a href="urun_listesi.asp"><i class="fa fa-list"></i> Ürün Listesi</a>
    <a href="../default.asp"><i class="fa fa-arrow-left"></i> Fiyat Listesi</a>
  </div>
</div>

<!-- SEKMELER -->
<%
Dim kap_cnt:kap_cnt=0:Dim ebat_cnt:ebat_cnt=0
Dim rs_cnt:Set rs_cnt=db.Execute("SELECT COUNT(*) FROM kaptak WHERE product_id=" & urun_id)
If Not rs_cnt.EOF Then kap_cnt=rs_cnt(0):End If:rs_cnt.Close:Set rs_cnt=Nothing
Set rs_cnt=db.Execute("SELECT COUNT(*) FROM ebat WHERE product_id=" & urun_id)
If Not rs_cnt.EOF Then ebat_cnt=rs_cnt(0):End If:rs_cnt.Close:Set rs_cnt=Nothing
%>
<div class="tab-bar">
  <a class="tab <%If aktif_sekme="urun" Then Response.Write("on") End If%>" onclick="sekme('urun')" href="#">
    <i class="fa fa-info-circle"></i> Ürün Bilgileri
  </a>
  <a class="tab <%If aktif_sekme="kapasite" Then Response.Write("on") End If%>" onclick="sekme('kapasite')" href="#">
    <i class="fa fa-gauge"></i> Kapasite
    <% If kap_cnt>0 Then %><span class="cnt"><%=kap_cnt%></span><% Else %><span class="cnt grey">0</span><% End If %>
  </a>
  <a class="tab <%If aktif_sekme="ebat" Then Response.Write("on") End If%>" onclick="sekme('ebat')" href="#">
    <i class="fa fa-ruler-combined"></i> Ebat / Fiyat
    <% If ebat_cnt>0 Then %><span class="cnt"><%=ebat_cnt%></span><% Else %><span class="cnt grey">0</span><% End If %>
  </a>
</div>

<div class="page-wrap">

<!-- ================================================================
     PANEL 1: ÜRÜN BİLGİLERİ
     ================================================================ -->
<div id="panel-urun" class="panel">

  <% If msg<>"" Then %>
  <div class="msg msg-<%=msg_tip%>">
    <% If msg_tip="ok" Then %><i class="fa fa-check-circle"></i><% Else %><i class="fa fa-times-circle"></i><% End If %> <%=msg%>
  </div>
  <% End If %>

  <div class="card">
    <div class="card-head"><span><i class="fa fa-info-circle"></i> Temel Bilgiler</span></div>
    <div class="card-body">
      <form method="post" action="urun_duzenle.asp?id=<%=urun_id%>">
      <input type="hidden" name="act" value="urun_kaydet"/>
      <div class="frow">
        <div class="fcol">
          <label>Ürün Adı (TR) <span class="req">*</span></label>
          <input type="text" name="urunadi" value="<%=Server.HTMLEncode(vu)%>" maxlength="200"/>
        </div>
        <div class="fcol">
          <label>Ürün Adı (EN)</label>
          <input type="text" name="urunadi_eng" value="<%=Server.HTMLEncode(vue)%>" maxlength="200"/>
        </div>
      </div>
      <div class="frow">
        <div class="fcol">
          <label>Kategori <span class="req">*</span></label>
          <select name="akno">
            <%
            Do While Not rs_kat.EOF
              Dim ok_id,ok_adi:ok_id=rs_kat(0):ok_adi=""+rs_kat(1)
            %><option value="<%=ok_id%>" <%If CStr(ok_id)=CStr(vakno) Then Response.Write("selected") End If%>><%=Server.HTMLEncode(ok_adi)%></option><%
            rs_kat.MoveNext:Loop:rs_kat.Close:Set rs_kat=Nothing
            %>
          </select>
        </div>
        <div class="fcol" style="max-width:110px">
          <label>Sıra</label>
          <input type="text" name="ord" value="<%=vord%>"/>
          <div class="fhint">Küçük = üstte</div>
        </div>
        <div class="fcol" style="max-width:110px">
          <label>Print Group</label>
<input type="text" name="print_group" value="<%=SafeHtml(vpg)%>" maxlength="50"/>
        </div>
        <div class="fcol">
          <label>Görsel Yolu (img)</label>
          <input type="text" name="img" id="txt_img" value="<%=SafeHtml(vimg)%>" maxlength="255" placeholder="../../fiyat/images/..." oninput="gorselOnizle(this,'prev_img')"/>
          <div id="prev_img" class="img-preview" style="<%If SafeHtml(vimg)<>"" Then Response.Write("display:block") Else Response.Write("display:none") End If%>">
            <%If SafeHtml(vimg)<>"" Then%><img src="<%=SafeHtml(vimg)%>" alt="Görsel" onerror="this.parentNode.style.display='none'"/><%End If%>
          </div>
        </div>
        <div class="fcol" style="max-width:110px;display:flex;flex-direction:column;justify-content:flex-end">
          <label>Durum</label>
          <label style="display:flex;align-items:center;gap:6px;padding:9px 0;cursor:pointer;font-size:13px;font-weight:400;text-transform:none;letter-spacing:0">
            <input type="hidden" name="aktif_degil" value="0"/><input type="checkbox" name="aktif_degil" value="1" style="width:auto" <%If (vaktif <> 0 And Not IsNull(vaktif)) Then Response.Write("checked") End If%>/> Pasif
          </label>
        </div>
      </div>

      <hr class="sep"/>
      <div class="frow">
        <div class="fcol">
          <label>&#11088; Öne Çıkar / Etiket</label>
          <select name="one_cikan">
            <option value="0" <%If CInt(vone_cikan)=0 Then Response.Write("selected") End If%>>Normal (Öne çıkarma)</option>
            <option value="1" <%If CInt(vone_cikan)=1 Then Response.Write("selected") End If%>>&#11088; Çok Satan</option>
            <option value="2" <%If CInt(vone_cikan)=2 Then Response.Write("selected") End If%>>&#128293; Kampanya</option>
            <option value="3" <%If CInt(vone_cikan)=3 Then Response.Write("selected") End If%>>&#127381; Yeni Ürün</option>
            <option value="4" <%If CInt(vone_cikan)=4 Then Response.Write("selected") End If%>>&#128142; Öne Çıkan</option>
          </select>
        </div>
        <div class="fcol">
          <label>Özel Etiket Metni <span style="font-weight:400;color:#999">(ör: %15 İndirim)</span></label>
          <input type="text" name="one_cikan_etiket" value="<%=SafeHtml(vone_etiket)%>" maxlength="50" placeholder="Boş bırakırsanız varsayılan etiket kullanılır"/>
        </div>
        <div class="fcol">
          <label>Özel Görsel <span style="font-weight:400;color:#999">(ör: ../fiyat/img/kampanya/urun.jpg)</span></label>
          <input type="text" name="one_cikan_gorsel" id="txt_og" value="<%=SafeHtml(vone_gorsel)%>" maxlength="255" placeholder="Boş bırakırsanız varsayılan görsel kullanılır" oninput="gorselOnizle(this,'prev_og')"/>
          <div id="prev_og" class="img-preview" style="<%If SafeHtml(vone_gorsel)<>"" Then Response.Write("display:block") Else Response.Write("display:none") End If%>">
            <%If SafeHtml(vone_gorsel)<>"" Then%><img src="<%=SafeHtml(vone_gorsel)%>" alt="Özel Görsel" onerror="this.parentNode.style.display='none'"/><%End If%>
          </div>
        </div>
      </div>

      <hr class="sep"/>
      <div class="frow">
        <div class="fcol">
          <label>Açıklama (TR)</label>
<textarea name="aciklama_tr"><%=SafeHtml(vatr)%></textarea>          <div class="fhint">HTML kullanılabilir</div>
        </div>
        <div class="fcol">
          <label>Açıklama (EN)</label>
          <textarea name="aciklama_en"><%=SafeHtml(vaen)%></textarea>
        </div>
      </div>
      <div class="frow">
        <div class="fcol">
          <label>Alt Açıklama (TR)</label>
          <textarea name="alt_tr"><%=SafeHtml(valt_tr)%></textarea>
        </div>
        <div class="fcol">
          <label>Alt Açıklama (EN)</label>
          <textarea name="alt_en"><%=SafeHtml(valt_en)%></textarea>
        </div>
      </div>
      <div class="frow">
        <div class="fcol">
          <label>Bayi Açıklama (TR)</label>
          <textarea name="bayi_tr"><%=SafeHtml(vbay_tr)%></textarea>
          <div class="fhint">Boşsa normal açıklama kullanılır</div>
        </div>
        <div class="fcol">
          <label>Bayi Açıklama (EN)</label>
          <textarea name="bayi_en"><%=SafeHtml(vbay_en)%></textarea>
        </div>
      </div>

      <div style="display:flex;gap:10px;justify-content:flex-end">
        <a href="urun_listesi.asp" class="btn btn-grey"><i class="fa fa-times"></i> İptal</a>
        <button type="submit" class="btn btn-green"><i class="fa fa-save"></i> Kaydet</button>
      </div>
      </form>
    </div>
  </div>
</div><!-- /panel-urun -->


<!-- ================================================================
     PANEL 2: KAPASİTE
     ================================================================ -->
<div id="panel-kapasite" class="panel">

  <% If kap_msg<>"" Then %>
  <div class="msg msg-<%=kap_tip%>">
    <% If kap_tip="ok" Then %><i class="fa fa-check-circle"></i><% Else %><i class="fa fa-exclamation-circle"></i><% End If %> <%=kap_msg%>
  </div>
  <% End If %>

  <!-- YENİ KAPASİTE EKLE FORMU -->
  <div class="add-box">
    <div class="add-box-title"><i class="fa fa-plus-circle"></i> Yeni Kapasite Ekle</div>
    <form method="post" action="urun_duzenle.asp?id=<%=urun_id%>&sekme=kapasite">
    <input type="hidden" name="act" value="kap_ekle"/>
    <div style="display:flex;gap:12px;align-items:flex-end;flex-wrap:wrap">
      <div class="fcol" style="max-width:220px">
        <label>Kapasite / Taksimat <span class="req">*</span></label>
        <input type="text" name="kap_taksimat" placeholder="ör. 60000" style="background:#fff"/>
        <div class="fhint">Sadece sayı · &gt;1000=ton, ≤1000=kg</div>
      </div>
      <div>
        <button type="submit" class="btn btn-green"><i class="fa fa-save"></i> Kapasite Ekle</button>
      </div>
    </div>
    </form>
  </div>

  <!-- KAPASİTE LİSTESİ -->
  <div class="card">
    <div class="card-head">
      <span><i class="fa fa-gauge"></i> Mevcut Kapasiteler</span>
      <span style="font-size:11px;color:#888;font-weight:400">Ebatı olan kapasite silinemez</span>
    </div>
    <% If rs_kap.EOF And rs_kap.BOF Then %>
      <div style="text-align:center;padding:36px;color:#aaa">
        <i class="fa fa-gauge" style="font-size:32px;display:block;margin-bottom:10px;opacity:.3"></i>
        Henüz kapasite yok. Yukarıdan ekleyin.
      </div>
    <% Else %>
    <form method="post" action="urun_duzenle.asp?id=<%=urun_id%>&sekme=kapasite">
    <input type="hidden" name="act" value="kap_guncelle"/>
    <table class="kap-table">
      <thead><tr>
        <th style="width:55px">ID</th>
        <th>Kapasite / Taksimat</th>
        <th style="width:90px;text-align:center">Ebat Sayısı</th>
        <th style="width:90px;text-align:center">Durum</th>
        <th style="width:150px;text-align:center">İşlem</th>
      </tr></thead>
      <tbody>
      <%
      Do While Not rs_kap.EOF
        Dim k_id,k_kap : k_id=rs_kap("id") : k_kap=rs_kap("kap_taksimat")
        Dim k_aktif : k_aktif = rs_kap("aktif_degil") : If IsNull(k_aktif) Then k_aktif=0
        Dim k_ecnt:Set rs_cnt=db.Execute("SELECT COUNT(*) FROM ebat WHERE kaptak_id=" & k_id)
        k_ecnt=0:If Not rs_cnt.EOF Then k_ecnt=rs_cnt(0):End If:rs_cnt.Close:Set rs_cnt=Nothing
        Dim k_edit:k_edit=(CStr(k_id)=gk_edit_id)
      %>
        <tr <%If k_edit Then Response.Write("class='edit-row'") End If%>>
          <td style="color:#bbb;font-size:11px"><%=k_id%></td>
          <% If k_edit Then %>
            <td>
              <input type="hidden" name="gk_id" value="<%=k_id%>"/>
              <input type="text" name="gk_kap" value="<%=k_kap%>" style="width:140px"/>
            </td>
            <td style="text-align:center">
              <a href="urun_duzenle.asp?id=<%=urun_id%>&sekme=kapasite" class="badge badge-blue" title="Ebatları gör"><%=k_ecnt%></a>
            </td>
            <td style="text-align:center">
              <label style="display:flex;align-items:center;justify-content:center;gap:5px;cursor:pointer;font-size:12px;font-weight:400">
                <input type="hidden" name="gk_aktif_degil" value="0"/><input type="checkbox" name="gk_aktif_degil" value="1" style="width:auto" <%If (k_aktif <> 0 And Not IsNull(k_aktif)) Then Response.Write("checked") End If%>/> Pasif
              </label>
            </td>
          <% Else %>
            <td><strong><%=k_kap%></strong></td>
            <td style="text-align:center">
              <% If k_ecnt>0 Then %>
                <a href="urun_duzenle.asp?id=<%=urun_id%>&sekme=ebat" class="badge badge-blue" title="Ebatları gör"><%=k_ecnt%></a>
              <% Else %>
                <span class="badge badge-grey">0</span>
              <% End If %>
            </td>
            <td style="text-align:center">
              <% If (k_aktif <> 0 And Not IsNull(k_aktif)) Then %>
                <span style="background:#e74c3c;color:#fff;border-radius:10px;padding:2px 9px;font-size:11px;font-weight:700">Pasif</span>
              <% Else %>
                <span style="background:#2ecc71;color:#fff;border-radius:10px;padding:2px 9px;font-size:11px;font-weight:700">Aktif</span>
              <% End If %>
            </td>
          <% End If %>
          <td>
            <div style="display:flex;gap:4px;justify-content:center">
              <% If k_edit Then %>
                <button type="submit" class="btn btn-green btn-sm"><i class="fa fa-check"></i> Kaydet</button>
                <a href="urun_duzenle.asp?id=<%=urun_id%>&sekme=kapasite" class="btn btn-grey btn-sm"><i class="fa fa-times"></i></a>
              <% Else %>
                <a href="urun_duzenle.asp?id=<%=urun_id%>&sekme=kapasite&kap_duzenle=<%=k_id%>" class="btn btn-blue btn-sm" title="Düzenle"><i class="fa fa-pen"></i></a>
                <% If Session("MM_UserAuthorization")=super_yonetici Then %>
                <button type="button" class="btn btn-red btn-sm" onclick="silOnay('kap',<%=k_id%>,<%=k_kap%>,<%=k_ecnt%>)" title="Sil"><i class="fa fa-trash"></i></button>
                <% End If %>
              <% End If %>
            </div>
          </td>
        </tr>
      <%  rs_kap.MoveNext : Loop
          rs_kap.Close : Set rs_kap = Nothing
      %>
      </tbody>
    </table>
    </form>
    <% End If %>
  </div>

  <div style="background:#fff8e1;border:1px solid #ffe082;border-radius:6px;padding:12px 16px;font-size:12px;color:#856404">
    <i class="fa fa-arrow-right"></i> <strong>Sonraki adım:</strong>
    Kapasite ekledikten sonra <a href="#" onclick="sekme('ebat');return false;" style="color:#37c2e4;font-weight:600">Ebat / Fiyat</a> sekmesine geçerek bu kapasiteye ebat ve fiyat tanımlayın.
  </div>
</div><!-- /panel-kapasite -->


<!-- ================================================================
     PANEL 3: EBAT / FİYAT
     ================================================================ -->
<div id="panel-ebat" class="panel">

  <% If ebat_msg<>"" Then %>
  <div class="msg msg-<%=ebat_tip%>">
    <% If ebat_tip="ok" Then %><i class="fa fa-check-circle"></i><% Else %><i class="fa fa-exclamation-circle"></i><% End If %> <%=ebat_msg%>
  </div>
  <% End If %>

  <!-- YENİ EBAT EKLE FORMU -->
  <div class="add-box">
    <div class="add-box-title"><i class="fa fa-plus-circle"></i> Yeni Ebat / Fiyat Ekle</div>
    <form method="post" action="urun_duzenle.asp?id=<%=urun_id%>&sekme=ebat">
    <input type="hidden" name="act" value="ebat_ekle"/>

    <%
    ' Kapasite dropdown için tekrar çek
    Dim rs_kdd:Set rs_kdd=db.Execute("SELECT id,kap_taksimat FROM kaptak WHERE product_id=" & urun_id & " ORDER BY kap_taksimat")
    If rs_kdd.EOF Then
    %>
      <div style="background:#f8d7da;border:1px solid #f5c6cb;border-radius:5px;padding:12px;color:#721c24;font-size:13px">
        <i class="fa fa-exclamation-circle"></i> Bu ürüne henüz kapasite tanımlanmamış.
        <a href="#" onclick="sekme('kapasite');return false;" style="color:#37c2e4;font-weight:600">Önce kapasite ekleyin.</a>
      </div>
    <% Else %>
    <div class="frow">
      <div class="fcol" style="max-width:160px">
        <label>Kapasite <span class="req">*</span></label>
        <select name="ebat_kap_id" style="background:#fff">
          <option value="">— Seçiniz —</option>
          <%
          Do While Not rs_kdd.EOF
          %><option value="<%=rs_kdd("id")%>"><%=rs_kdd("kap_taksimat")%></option><%
          rs_kdd.MoveNext:Loop
          %>
        </select>
      </div>
      <div class="fcol" style="flex:2;min-width:180px">
        <label>Model Kodu</label>
        <input type="text" name="ebat_model" placeholder="ör. TCZ-PLT-3x18" maxlength="100" style="background:#fff"/>
      </div>
      <div class="fcol" style="max-width:60px">
        <label>Sıra</label>
        <input type="text" name="ebat_order" placeholder="10" style="background:#fff"/>
      </div>
    </div>
    <div class="frow">
      <div class="fcol" style="max-width:60px">
        <label>X (mm)</label>
        <input type="text" name="ebat_x" style="background:#fff"/>
      </div>
      <div class="fcol" style="max-width:60px">
        <label>Y (mm)</label>
        <input type="text" name="ebat_y" style="background:#fff"/>
      </div>
      <div class="fcol" style="max-width:60px">
        <label>Z (mm)</label>
        <input type="text" name="ebat_z" style="background:#fff"/>
      </div>
      <div class="fcol" style="max-width:75px">
        <label>Para Bir.</label>
        <select name="ebat_pb" style="background:#fff">
          <option value="$">$ USD</option>
          <option value="€">€ EUR</option>
          <option value="TL">TL</option>
        </select>
      </div>
    </div>
    <p style="font-size:11px;font-weight:700;color:#555;margin:4px 0 8px;text-transform:uppercase">Elektronik Dahil</p>
    <div class="frow">
      <div class="fcol" style="max-width:90px"><label>Maliyet</label><input type="text" name="ebat_maliyet" placeholder="0" style="background:#fff"/></div>
      <div class="fcol" style="max-width:60px"><label>%K1</label><input type="text" name="ebat_k1" placeholder="40" style="background:#fff"/></div>
      <div class="fcol" style="max-width:60px"><label>%K2</label><input type="text" name="ebat_k2" placeholder="35" style="background:#fff"/></div>
      <div class="fcol" style="max-width:60px"><label>%K3</label><input type="text" name="ebat_k3" placeholder="30" style="background:#fff"/></div>
    </div>
    <p style="font-size:11px;font-weight:700;color:#555;margin:4px 0 8px;text-transform:uppercase">Mekanik</p>
    <div class="frow">
      <div class="fcol" style="max-width:90px"><label>Maliyet</label><input type="text" name="ebat_mm" placeholder="0" style="background:#fff"/></div>
      <div class="fcol" style="max-width:60px"><label>%MK1</label><input type="text" name="ebat_mk1" placeholder="30" style="background:#fff"/></div>
      <div class="fcol" style="max-width:60px"><label>%MK2</label><input type="text" name="ebat_mk2" placeholder="25" style="background:#fff"/></div>
      <div class="fcol" style="max-width:60px"><label>%MK3</label><input type="text" name="ebat_mk3" placeholder="20" style="background:#fff"/></div>
    </div>
    <div class="frow">
      <div class="fcol">
        <label>Açıklama</label>
        <textarea name="ebat_aciklama" rows="4" placeholder="Uzun açıklama buraya..." style="background:#fff;resize:vertical;font-size:12px;line-height:1.5;padding:6px;width:100%"></textarea>
      </div>
    </div>
    <div style="text-align:right">
      <button type="submit" class="btn btn-green"><i class="fa fa-save"></i> Ebat / Fiyat Ekle</button>
    </div>
    <% End If
    rs_kdd.Close:Set rs_kdd=Nothing
    %>
    </form>
  </div>

  <!-- EBAT LİSTESİ -->
  <div class="card">
    <div class="card-head">
      <span><i class="fa fa-ruler-combined"></i> Mevcut Ebat / Fiyat Satırları</span>
    </div>
    <% If rs_eb.EOF And rs_eb.BOF Then %>
      <div style="text-align:center;padding:36px;color:#aaa">
        <i class="fa fa-ruler-combined" style="font-size:32px;display:block;margin-bottom:10px;opacity:.3"></i>
        Henüz ebat/fiyat kaydı yok.
      </div>
    <% Else %>
    <div class="ebat-wrap">
    <form method="post" action="urun_duzenle.asp?id=<%=urun_id%>&sekme=ebat">
    <input type="hidden" name="act" value="ebat_guncelle"/>
    <table class="ebat-table">
      <thead><tr>
        <th style="width:28px"></th>
        <th>ID</th>
        <th>Kapasite</th>
        <th>Model Kodu</th>
        <th>X</th><th>Y</th><th>Z</th>
        <th>PB</th>
        <th>Maliyet</th>
        <th>%K1</th><th>%K2</th><th>%K3</th>
        <th>Mek.Mal.</th>
        <th>%MK1</th><th>%MK2</th><th>%MK3</th>
        <th>Sıra</th>
        <th>Durum</th>
        <th>İşlem</th>
        <th>Açıklama</th>
      </tr></thead>
      <tbody>
      <%
      Do While Not rs_eb.EOF
        Dim ei_id,ei_kap,ei_kap_id,ei_model,ei_x,ei_y,ei_z,ei_pb,ei_ac,ei_ord
        Dim ei_mal,ei_k1,ei_k2,ei_k3,ei_mm,ei_mk1,ei_mk2,ei_mk3
        ei_id     = "" & rs_eb("id")
        ei_kap    = "" & rs_eb("kap_taksimat")
        ei_kap_id = "" & rs_eb("kaptak_id")
        ei_model= "" & rs_eb("model_kodu")
        ei_x    = "" & rs_eb("x_genislik")
        ei_y    = "" & rs_eb("y_genislik")
        ei_z    = "" & rs_eb("z_yukseklik")
        ei_pb   = "" & rs_eb("para_birimi")
        ei_ac   = "" & rs_eb("Aciklama")
        ei_ord  = "" & rs_eb("order")
        ei_mal  = "" & rs_eb("Maliyet_Fiyati")
        ei_k1   = "" & rs_eb("Kar_Orani1")
        ei_k2   = "" & rs_eb("Kar_Orani2")
        ei_k3   = "" & rs_eb("Kar_Orani3")
        ei_mm   = "" & rs_eb("Mekanik_Maliyet")
        ei_mk1  = "" & rs_eb("Mekanik_Kar_Orani1")
        ei_mk2  = "" & rs_eb("Mekanik_Kar_Orani2")
        ei_mk3  = "" & rs_eb("Mekanik_Kar_Orani3")
        Dim ei_aktif : ei_aktif = rs_eb("aktif_degil") : If IsNull(ei_aktif) Then ei_aktif=0
        Dim ei_edit:ei_edit=(ei_id=ge_edit_id)
      %>
        <tr draggable="true" data-id="<%=ei_id%>" data-ord="<%=ei_ord%>" <%If ei_edit Then Response.Write("class='edit-row'") End If%>>
          <td style="width:28px;text-align:center">
            <%If Not ei_edit Then%><span class="drag-handle" title="Sürükleyerek sırala">&#9776;</span><%End If%>
          </td>
          <td style="color:#bbb;font-size:10px"><%=ei_id%></td>
          <%If ei_edit Then%>
            <td style="color:#555"><strong><%=ei_kap%></strong></td>
            <input type="hidden" name="ge_id" value="<%=ei_id%>"/>
            <td><input type="text" name="ge_model"   value="<%=Server.HTMLEncode(ei_model)%>" style="width:140px"/></td>
            <td><input type="text" name="ge_x"       value="<%=ei_x%>" style="width:42px"/></td>
            <td><input type="text" name="ge_y"       value="<%=ei_y%>" style="width:42px"/></td>
            <td><input type="text" name="ge_z"       value="<%=ei_z%>" style="width:42px"/></td>
            <td><select name="ge_pb" class="pb-sel" style="width:46px;padding:2px 2px">
              <option value="$"  <%If ei_pb="$"  Then Response.Write("selected")End If%>>$</option>
              <option value="€"  <%If ei_pb="€"  Then Response.Write("selected")End If%>>€</option>
              <option value="TL" <%If ei_pb="TL" Then Response.Write("selected")End If%>>TL</option>
            </select></td>
            <td><input type="text" name="ge_maliyet" value="<%=ei_mal%>" style="width:70px"/></td>
            <td><input type="text" name="ge_k1"      value="<%=ei_k1%>"  style="width:32px"/></td>
            <td><input type="text" name="ge_k2"      value="<%=ei_k2%>"  style="width:32px"/></td>
            <td><input type="text" name="ge_k3"      value="<%=ei_k3%>"  style="width:32px"/></td>
            <td><input type="text" name="ge_mm"      value="<%=ei_mm%>"  style="width:70px"/></td>
            <td><input type="text" name="ge_mk1"     value="<%=ei_mk1%>" style="width:32px"/></td>
            <td><input type="text" name="ge_mk2"     value="<%=ei_mk2%>" style="width:32px"/></td>
            <td><input type="text" name="ge_mk3"     value="<%=ei_mk3%>" style="width:32px"/></td>
            <td><input type="text" name="ge_order"   value="<%=ei_ord%>" style="width:30px"/></td>
            <td>
              <label style="display:flex;align-items:center;justify-content:center;gap:4px;cursor:pointer;font-size:11px;font-weight:400;white-space:nowrap">
                <input type="hidden" name="ge_aktif_degil" value="0"/><input type="checkbox" name="ge_aktif_degil" value="1" style="width:auto" <%If (ei_aktif <> 0 And Not IsNull(ei_aktif)) Then Response.Write("checked") End If%>/> Pasif
              </label>
            </td>
            <td>
              <div style="display:flex;gap:3px">
                <button type="submit" class="btn btn-green btn-sm"><i class="fa fa-check"></i></button>
                <a href="urun_duzenle.asp?id=<%=urun_id%>&sekme=ebat" class="btn btn-grey btn-sm"><i class="fa fa-times"></i></a>
              </div>
            </td>
            <td><textarea name="ge_aciklama" rows="8" style="width:220px;font-size:11px;line-height:1.4;resize:vertical;padding:4px"><%=Server.HTMLEncode(ei_ac)%></textarea></td>
          <%Else%>
            <td><strong><%=ei_kap%></strong></td>
            <td><%=Server.HTMLEncode(ei_model)%></td>
            <td style="color:#888"><%=ei_x%></td>
            <td style="color:#888"><%=ei_y%></td>
            <td style="color:#888"><%=ei_z%></td>
            <td><%=ei_pb%></td>
            <td><%=ei_mal%></td>
            <td><%=ei_k1%></td><td><%=ei_k2%></td><td><%=ei_k3%></td>
            <td><%=ei_mm%></td>
            <td><%=ei_mk1%></td><td><%=ei_mk2%></td><td><%=ei_mk3%></td>
            <td style="color:#888"><span class="e-ord-val"><%=ei_ord%></span></td>
            <td style="text-align:center">
              <% If (ei_aktif <> 0 And Not IsNull(ei_aktif)) Then %>
                <span style="background:#e74c3c;color:#fff;border-radius:10px;padding:2px 7px;font-size:10px;font-weight:700">Pasif</span>
              <% Else %>
                <span style="background:#2ecc71;color:#fff;border-radius:10px;padding:2px 7px;font-size:10px;font-weight:700">Aktif</span>
              <% End If %>
            </td>
            <td>
              <div style="display:flex;gap:3px">
                <a href="urun_duzenle.asp?id=<%=urun_id%>&sekme=ebat&ebat_duzenle=<%=ei_id%>" class="btn btn-blue btn-sm" title="Düzenle"><i class="fa fa-pen"></i></a>
                <button type="button" class="btn btn-sm" title="Çoğalt — formu doldur"
                  style="background:#f39c12;color:#fff;border:none;cursor:pointer"
                  data-kapid="<%=ei_kap_id%>"
                  data-model="<%=Server.HTMLEncode(ei_model)%>"
                  data-x="<%=ei_x%>" data-y="<%=ei_y%>" data-z="<%=ei_z%>"
                  data-pb="<%=ei_pb%>"
                  data-mal="<%=ei_mal%>" data-k1="<%=ei_k1%>" data-k2="<%=ei_k2%>" data-k3="<%=ei_k3%>"
                  data-mm="<%=ei_mm%>" data-mk1="<%=ei_mk1%>" data-mk2="<%=ei_mk2%>" data-mk3="<%=ei_mk3%>"
                  data-ac="<%=Server.HTMLEncode(ei_ac)%>"
                  data-ord="<%=ei_ord%>"
                  onclick="cogalt(this)">
                  <i class="fa fa-copy"></i>
                </button>
                <%If Session("MM_UserAuthorization")=super_yonetici Then%>
                <button type="button" class="btn btn-red btn-sm" onclick="silOnay('ebat',<%=ei_id%>,0,0)" title="Sil"><i class="fa fa-trash"></i></button>
                <%End If%>
              </div>
            </td>
            <td style="color:#666;font-size:11px;white-space:pre-wrap;min-width:180px;max-width:280px;vertical-align:top;padding-top:6px"><%=Server.HTMLEncode(ei_ac)%></td>
          <%End If%>
        </tr>
      <%  rs_eb.MoveNext:Loop
          rs_eb.Close:Set rs_eb=Nothing
      %>
      </tbody>
    </table>
    </form>
    </div>
    <% End If %>
  </div>

</div><!-- /panel-ebat -->

</div><!-- /page-wrap -->

<%
db.Close:Set db=Nothing
%>

<!-- ONAY OVERLAY -->
<div class="overlay" id="overlay">
  <div class="modal">
    <h3><i class="fa fa-exclamation-triangle" style="color:#e74c3c"></i> Silme Onayı</h3>
    <p id="modal-msg"></p>
    <div class="modal-btns">
      <button class="btn btn-grey" onclick="kapat()"><i class="fa fa-times"></i> İptal</button>
      <a href="#" id="modal-link" class="btn btn-red"><i class="fa fa-trash"></i> Evet, Sil</a>
    </div>
  </div>
</div>

<!-- SIRALAMA TOAST -->
<div class="sira-toast" id="sira-toast">
  <i class="fa fa-spinner fa-spin" id="sira-toast-ikon"></i>
  <span id="sira-toast-msg">Sıralama kaydediliyor…</span>
</div>

<script>
var UID=<%=urun_id%>;

// Aktif sekme
var aktif='<%=aktif_sekme%>';
function sekme(s){
  document.querySelectorAll('.panel').forEach(function(el){el.style.display='none';});
  document.querySelectorAll('.tab').forEach(function(el){el.classList.remove('on');});
  document.getElementById('panel-'+s).style.display='block';
  document.querySelectorAll('.tab').forEach(function(el){
    if(el.getAttribute('onclick').indexOf("'"+s+"'")>-1) el.classList.add('on');
  });
  aktif=s;
}
sekme(aktif);

function silOnay(tip,id,val,bag){
  var m=document.getElementById('modal-msg'), l=document.getElementById('modal-link');
  if(tip==='kap'){
    if(bag>0){
      m.innerHTML='Kapasite <strong>'+val+'</strong> değerine bağlı <strong>'+bag+' ebat</strong> var.<br><small style="color:#e74c3c">Önce ebatları silin.</small>';
      l.href='#';l.onclick=function(){kapat();return false;};
    } else {
      m.innerHTML='Kapasite değeri <strong>'+val+'</strong> silinecek. Emin misiniz?';
      l.href='urun_duzenle.asp?id='+UID+'&sekme=kapasite&sil_kap_id='+id;l.onclick=null;
    }
  } else {
    m.innerHTML='Ebat ID: <strong>'+id+'</strong> kaydı silinecek. Emin misiniz?';
    l.href='urun_duzenle.asp?id='+UID+'&sekme=ebat&sil_ebat_id='+id;l.onclick=null;
  }
  document.getElementById('overlay').style.display='flex';
}
function kapat(){document.getElementById('overlay').style.display='none';}
document.getElementById('overlay').addEventListener('click',function(e){if(e.target===this)kapat();});

// Hash ile sekme açma
if(window.location.hash==='#ebatlar') sekme('ebat');
if(window.location.hash==='#kapasite') sekme('kapasite');

function gorselOnizle(input, prevId) {
  var prev = document.getElementById(prevId);
  var val = input.value.trim();
  if (!val) { prev.style.display = 'none'; prev.innerHTML = ''; return; }
  prev.innerHTML = '<img src="' + val + '" alt="Görsel" onerror="this.parentNode.style.display=\'none\'" onload="this.parentNode.style.display=\'inline-block\'"/>';
  prev.style.display = 'inline-block';
}

// ================================================================
// EBAT SIRALAMA: Drag & Drop
// ================================================================
var eDragSrc  = null;
var eSiraTimer = null;
var eToast     = document.getElementById('sira-toast');
var eToastMsg  = document.getElementById('sira-toast-msg');
var eToastIkon = document.getElementById('sira-toast-ikon');

function eGosterToast(msg, ikon) {
  eToastMsg.textContent = msg;
  eToastIkon.className = ikon || 'fa fa-spinner fa-spin';
  eToast.style.display = 'flex';
}
function eGizleToast(ms) {
  setTimeout(function(){ eToast.style.display = 'none'; }, ms || 2000);
}

function eSiraKaydet() {
  var satirlar = document.querySelectorAll('.ebat-table tbody tr[data-id]');
  var siralar = [];
  var ord = 10;
  satirlar.forEach(function(tr) {
    siralar.push({ id: parseInt(tr.dataset.id), ord: ord });
    var span = tr.querySelector('.e-ord-val');
    if (span) span.textContent = ord;
    tr.dataset.ord = ord;
    ord += 10;
  });
  eGosterToast('Sıralama kaydediliyor…', 'fa fa-spinner fa-spin');
  fetch('urun_duzenle.asp?id=' + UID + '&sekme=ebat', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'act=ebat_siralama_kaydet&siralar=' + encodeURIComponent(JSON.stringify(siralar))
  })
  .then(function(r) { return r.json(); })
  .then(function(d) {
    if (d.ok) {
      eGosterToast('Sıralama kaydedildi ✓', 'fa fa-check-circle');
    } else {
      eGosterToast('Hata oluştu!', 'fa fa-times-circle');
    }
    eGizleToast(1800);
  })
  .catch(function() {
    eGosterToast('Bağlantı hatası!', 'fa fa-times-circle');
    eGizleToast(2000);
  });
}

function eDebounceKaydet() {
  clearTimeout(eSiraTimer);
  eSiraTimer = setTimeout(eSiraKaydet, 600);
}

document.querySelectorAll('.ebat-table tbody tr[data-id]').forEach(function(tr) {
  tr.addEventListener('dragstart', function(e) {
    eDragSrc = this;
    this.classList.add('dragging');
    e.dataTransfer.effectAllowed = 'move';
  });
  tr.addEventListener('dragend', function() {
    this.classList.remove('dragging');
    document.querySelectorAll('.ebat-table tbody tr').forEach(function(r) { r.classList.remove('drag-over'); });
    eDebounceKaydet();
  });
  tr.addEventListener('dragover', function(e) {
    e.preventDefault();
    if (eDragSrc && this !== eDragSrc && this.dataset.id) {
      document.querySelectorAll('.ebat-table tbody tr').forEach(function(r) { r.classList.remove('drag-over'); });
      this.classList.add('drag-over');
      e.dataTransfer.dropEffect = 'move';
    }
  });
  tr.addEventListener('drop', function(e) {
    e.preventDefault();
    if (!eDragSrc || this === eDragSrc || !this.dataset.id) return;
    this.parentNode.insertBefore(eDragSrc, this);
    this.classList.remove('drag-over');
  });
});

// ── ÇOĞALT: mevcut satır verilerini "Yeni Ebat Ekle" formuna doldur ──
function cogalt(btn) {
  var d = btn.dataset;
  // Kapasite dropdown
  var selKap = document.querySelector('select[name="ebat_kap_id"]');
  if (selKap) {
    for (var i = 0; i < selKap.options.length; i++) {
      if (selKap.options[i].value == d.kapid) { selKap.selectedIndex = i; break; }
    }
  }
  // Metin alanları
  var set = function(name, val) {
    var el = document.querySelector('[name="' + name + '"]');
    if (el) el.value = val;
  };
  set('ebat_model',    d.model);
  set('ebat_x',        d.x);
  set('ebat_y',        d.y);
  set('ebat_z',        d.z);
  set('ebat_maliyet',  d.mal);
  set('ebat_k1',       d.k1);
  set('ebat_k2',       d.k2);
  set('ebat_k3',       d.k3);
  set('ebat_mm',       d.mm);
  set('ebat_mk1',      d.mk1);
  set('ebat_mk2',      d.mk2);
  set('ebat_mk3',      d.mk3);
  set('ebat_aciklama', d.ac);
  set('ebat_order',    d.ord);
  // Para birimi
  var selPb = document.querySelector('select[name="ebat_pb"]');
  if (selPb) {
    for (var j = 0; j < selPb.options.length; j++) {
      if (selPb.options[j].value === d.pb) { selPb.selectedIndex = j; break; }
    }
  }
  // Formu vurgula ve scroll et
  var addBox = document.querySelector('.add-box');
  if (addBox) {
    addBox.scrollIntoView({ behavior: 'smooth', block: 'start' });
    addBox.style.outline = '3px solid #f39c12';
    setTimeout(function(){ addBox.style.outline = ''; }, 2000);
  }
  // Model kodu alanına odaklan
  var mEl = document.querySelector('[name="ebat_model"]');
  if (mEl) { setTimeout(function(){ mEl.focus(); mEl.select(); }, 400); }
}
</script>

</body>
</html>
