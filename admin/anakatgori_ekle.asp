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
%>

<%
Function SqlStr(v)  : SqlStr  = "'" & Replace(Trim(v),"'","''") & "'" : End Function
Function SqlStrN(v) : Dim x:x=Trim(v) : If x="" Then SqlStrN="NULL" Else SqlStrN="'" & Replace(x,"'","''") & "'" : End If : End Function
Function SafeHtml(v)
  If IsNull(v) Or IsEmpty(v) Then
    SafeHtml = ""
  Else
    SafeHtml = Server.HTMLEncode(CStr(v))
  End If
End Function

'================================================================
' SİLME
'================================================================
Dim sil_msg : sil_msg = ""
If Request.QueryString("sil_id") <> "" Then
  Dim sil_id : sil_id = CLng(Request.QueryString("sil_id"))
  On Error Resume Next
  Dim dc1 : Set dc1 = Server.CreateObject("ADODB.Command")
  dc1.ActiveConnection = MM_fiyat_STRING
  dc1.CommandText = "SELECT COUNT(*) FROM urunler WHERE akno=?"
  dc1.Prepared = True
  dc1.Parameters.Append dc1.CreateParameter("p1",5,1,-1,sil_id)
  Dim rs1 : Set rs1 = dc1.Execute
  Dim ubag : ubag=0 : If Not rs1.EOF Then ubag=rs1(0)
  rs1.Close:Set rs1=Nothing:Set dc1=Nothing
  If ubag > 0 Then
    sil_msg = "UYARI: Bu kategoriye bağlı " & ubag & " ürün var. Önce ürünleri silin."
  Else
    Dim dc2 : Set dc2 = Server.CreateObject("ADODB.Command")
    dc2.ActiveConnection = MM_fiyat_STRING
    dc2.CommandText = "DELETE FROM Anakatagori WHERE id=?"
    dc2.Prepared = True
    dc2.Parameters.Append dc2.CreateParameter("p1",5,1,-1,sil_id)
    dc2.Execute
    If Err.Number<>0 Then sil_msg="HATA: "&Err.Description Else sil_msg="ok"
    Set dc2=Nothing
  End If
  On Error GoTo 0
End If

'================================================================
' EKLEME
'================================================================
Dim ekle_msg, ekle_tip, yeni_id
ekle_msg="" : ekle_tip="" : yeni_id=0
If Request.Form("kaydet") = "1" Then
  Dim fad,fad_en,fsira,fimg
  fad    = Trim(Request.Form("anakatadi"))
  fad_en = Trim(Request.Form("anakatadi_eng"))
  fsira  = Trim(Request.Form("siralama"))
  fimg   = Trim(Request.Form("img"))

  If fad="" Then
    ekle_msg="Kategori adı (TR) zorunludur." : ekle_tip="err"
  Else
    On Error Resume Next
    Dim db_e : Set db_e = Server.CreateObject("ADODB.Connection")
    db_e.Open MM_fiyat_STRING

    If fsira="" Or Not IsNumeric(fsira) Then
      Dim rs_sira : Set rs_sira=db_e.Execute("SELECT MAX(siralama) FROM Anakatagori WHERE language=1")
      If Not IsNull(rs_sira(0)) Then fsira=CStr(CLng(rs_sira(0))+10) Else fsira="10"
      rs_sira.Close:Set rs_sira=Nothing
    End If

    Dim faktif_e : faktif_e = 0
    If InStr(Request.Form("aktif_degil"),"1") > 0 Then faktif_e = 1
    db_e.Execute "INSERT INTO Anakatagori (anakatadi,anakatadi_eng,siralama,img,language,aktif_degil) VALUES (" & _
      SqlStr(fad) & "," & SqlStrN(fad_en) & "," & CLng(fsira) & "," & SqlStrN(fimg) & ",1," & -1*(faktif_e=1) & ")"

    If Err.Number<>0 Then
      ekle_msg="Kayıt hatası: "&Err.Description : ekle_tip="err"
    Else
      Dim rs_new:Set rs_new=db_e.Execute("SELECT MAX(id) FROM Anakatagori WHERE language=1")
      yeni_id=rs_new(0):rs_new.Close:Set rs_new=Nothing
      ekle_msg="Kategori eklendi (ID: "&yeni_id&")." : ekle_tip="ok"
    End If
    db_e.Close:Set db_e=Nothing:On Error GoTo 0
  End If
End If

'================================================================
' DÜZENLEME KAYDET
'================================================================
Dim duz_msg, duz_tip
duz_msg="" : duz_tip=""
If Request.Form("duzenle") = "1" Then
  Dim did,dad,dad_en,dsira,dimg
  did    = CLng(Request.Form("edit_id"))
  dad    = Trim(Request.Form("edit_anakatadi"))
  dad_en = Trim(Request.Form("edit_anakatadi_eng"))
  dsira  = Trim(Request.Form("edit_siralama"))
  dimg   = Trim(Request.Form("edit_img"))

  If dad="" Then
    duz_msg="Kategori adı zorunludur." : duz_tip="err"
  Else
    Dim daktif : daktif = 0
  If InStr(Request.Form("edit_aktif_degil"),"1") > 0 Then daktif = 1
  If dsira="" Or Not IsNumeric(dsira) Then dsira="0"
    On Error Resume Next
    Dim db_d : Set db_d = Server.CreateObject("ADODB.Connection")
    db_d.Open MM_fiyat_STRING

    db_d.Execute "UPDATE Anakatagori SET anakatadi=" & SqlStr(dad) & _
      ",anakatadi_eng=" & SqlStrN(dad_en) & _
      ",siralama=" & CLng(dsira) & _
      ",img=" & SqlStrN(dimg) & _
      ",aktif_degil=" & -1*(daktif=1) & _
      " WHERE id=" & did

    If Err.Number<>0 Then duz_msg="Hata: "&Err.Description:duz_tip="err" Else duz_msg="Kategori güncellendi.":duz_tip="ok"
    db_d.Close:Set db_d=Nothing:On Error GoTo 0
  End If
End If

'================================================================
' KATEGORİ SIRALAMA KAYDET (AJAX)
'================================================================
If Request.Form("act") = "kat_siralama_kaydet" Then
  Dim ks_json : ks_json = Trim(Request.Form("siralar"))
  Dim ks_ok : ks_ok = True
  On Error Resume Next
  Dim ks_db : Set ks_db = Server.CreateObject("ADODB.Connection")
  ks_db.Open MM_fiyat_STRING
  Dim ks_pos : ks_pos = 1
  Do
    Dim ks_s : ks_s = InStr(ks_pos, ks_json, "{")
    Dim ks_e : ks_e = InStr(ks_pos, ks_json, "}")
    If ks_s = 0 Or ks_e = 0 Then Exit Do
    Dim ks_blok : ks_blok = Mid(ks_json, ks_s+1, ks_e-ks_s-1)
    Dim ks_id_pos  : ks_id_pos  = InStr(ks_blok, """id"":")
    Dim ks_ord_pos : ks_ord_pos = InStr(ks_blok, """ord"":")
    If ks_id_pos > 0 And ks_ord_pos > 0 Then
      Dim ks_id_str  : ks_id_str  = Mid(ks_blok, ks_id_pos+5)
      Dim ks_ord_str : ks_ord_str = Mid(ks_blok, ks_ord_pos+6)
      Dim ks_id_v, ks_ord_v
      If InStr(ks_id_str, ",")>0  Then ks_id_v  = Left(ks_id_str,  InStr(ks_id_str, ",")-1)  Else ks_id_v  = ks_id_str
      If InStr(ks_ord_str,",")>0  Then ks_ord_v = Left(ks_ord_str, InStr(ks_ord_str,",")-1)  Else ks_ord_v = ks_ord_str
      ks_id_v = Trim(ks_id_v) : ks_ord_v = Trim(ks_ord_v)
      If IsNumeric(ks_id_v) And IsNumeric(ks_ord_v) Then
        ks_db.Execute "UPDATE Anakatagori SET siralama=" & CLng(ks_ord_v) & " WHERE id=" & CLng(ks_id_v) & " AND language=1"
        If Err.Number <> 0 Then ks_ok = False : Err.Clear
      End If
    End If
    ks_pos = ks_e + 1
  Loop
  ks_db.Close : Set ks_db = Nothing
  On Error GoTo 0
  Response.ContentType = "application/json"
  If ks_ok Then Response.Write("{""ok"":true}") Else Response.Write("{""ok"":false}")
  Response.End
End If

'================================================================
' LİSTE ÇEK
'================================================================
Dim db_l : Set db_l = Server.CreateObject("ADODB.Connection")
db_l.Open MM_fiyat_STRING
Dim rs_list : Set rs_list = db_l.Execute( _
  "SELECT a.id,a.anakatadi,a.anakatadi_eng,a.siralama,a.img,a.aktif_degil," & _
  "(SELECT COUNT(*) FROM urunler WHERE akno=a.id) AS urun_sayisi " & _
  "FROM Anakatagori a WHERE a.language=1 ORDER BY a.siralama")

Dim duz_id : duz_id = ""
If Request.QueryString("duzenle_id") <> "" Then duz_id = CStr(CLng(Request.QueryString("duzenle_id")))
%>

<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="utf-8"/>
  <title>Kategori Yönetimi — Tunaylar</title>
  <link href="../screen.css" media="screen" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
  <style>
    *{box-sizing:border-box}
    body{font-family:'Barlow',Arial,sans-serif;background:#f0f2f5;margin:0}
    .hdr{background:#1a2332;color:#fff;padding:0 24px;display:flex;align-items:center;justify-content:space-between;height:52px}
    .hdr h1{margin:0;font-size:17px;font-weight:600;display:flex;align-items:center;gap:10px}
    .hdr-nav{display:flex;gap:6px}
    .hdr-nav a{color:#37c2e4;text-decoration:none;font-size:12px;padding:5px 10px;border-radius:4px;border:1px solid rgba(55,194,228,.3);display:flex;align-items:center;gap:5px}
    .hdr-nav a:hover{background:rgba(55,194,228,.15)}
    .wrap{max-width:1080px;margin:28px auto;padding:0 20px}
    .card{background:#fff;border-radius:8px;box-shadow:0 1px 4px rgba(0,0,0,.08);margin-bottom:22px;overflow:hidden}
    .card-head{background:#ecf0f1;padding:10px 18px;font-weight:700;font-size:13px;color:#2c3e50;border-bottom:1px solid #dde;display:flex;align-items:center;gap:8px}
    .card-body{padding:18px}
    .frow{display:flex;gap:12px;align-items:flex-end;flex-wrap:wrap}
    .fcol{flex:1;min-width:160px}
    .fcol label{display:block;font-size:11px;font-weight:700;color:#666;margin-bottom:4px;text-transform:uppercase;letter-spacing:.4px}
    .req{color:#e74c3c}
    .fcol input{width:100%;padding:8px 10px;border:1px solid #ccd;border-radius:4px;font-size:13px;font-family:inherit;background:#fafafa}
    .fcol input:focus{outline:none;border-color:#37c2e4;background:#fff}
    .fhint{font-size:11px;color:#aaa;margin-top:3px}
    .btn{display:inline-flex;align-items:center;gap:5px;padding:7px 14px;border:none;border-radius:5px;font-size:13px;cursor:pointer;font-weight:600;text-decoration:none;white-space:nowrap}
    .btn-green{background:#2ecc71;color:#fff}.btn-green:hover{background:#27ae60}
    .btn-blue{background:#37c2e4;color:#fff}.btn-blue:hover{background:#2aabb0}
    .btn-red{background:#e74c3c;color:#fff}.btn-red:hover{background:#c0392b}
    .btn-grey{background:#95a5a6;color:#fff}.btn-grey:hover{background:#7f8c8d}
    .btn-sm{padding:4px 9px;font-size:12px}
    .msg{padding:10px 16px;border-radius:5px;margin-bottom:16px;font-size:13px;font-weight:500;display:flex;align-items:center;gap:8px}
    .msg-ok{background:#d4edda;color:#155724;border:1px solid #c3e6cb}
    .msg-err{background:#f8d7da;color:#721c24;border:1px solid #f5c6cb}
    .msg-warn{background:#fff3cd;color:#856404;border:1px solid #ffeeba}
    .tbl{width:100%;border-collapse:collapse;font-size:13px}
    .tbl thead tr{background:#1a2332;color:#fff}
    .tbl th{padding:10px 12px;text-align:left;font-weight:600;white-space:nowrap}
    .tbl td{padding:9px 12px;border-bottom:1px solid #f0f0f0;vertical-align:middle}
    .tbl tr:last-child td{border-bottom:none}
    .tbl tr:hover td{background:#f7fbff}
    .edit-row td{background:#fffde7!important}
    .edit-row input{width:100%;padding:5px 8px;border:1px solid #ccd;border-radius:3px;font-size:12px;box-sizing:border-box}
    .badge{display:inline-flex;align-items:center;justify-content:center;min-width:22px;padding:2px 7px;border-radius:10px;font-size:11px;font-weight:700;text-decoration:none}
    .badge-blue{background:#37c2e4;color:#fff}
    .badge-grey{background:#bdc3c7;color:#fff}
    .ops{display:flex;gap:4px;justify-content:center}
    .overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:9999;align-items:center;justify-content:center}
    .modal{background:#fff;border-radius:10px;padding:32px;max-width:400px;width:90%;text-align:center;box-shadow:0 8px 32px rgba(0,0,0,.2)}
    .modal h3{margin:0 0 12px;font-size:17px;color:#2c3e50}
    .modal p{margin:0 0 22px;font-size:13px;color:#666;line-height:1.6}
    .modal-btns{display:flex;gap:10px;justify-content:center}
    .thumb{width:56px;height:40px;object-fit:contain;border:1px solid #dde;border-radius:4px;background:#fff;padding:2px}
    .img-path{font-size:11px;color:#777;word-break:break-all}
    .drag-handle{cursor:grab;color:#bbb;font-size:16px;user-select:none;padding:0 4px;display:inline-block}
    .drag-handle:hover{color:#37c2e4}
    .tbl tbody tr.dragging{opacity:.4;background:#e8f0fe!important}
    .tbl tbody tr.drag-over td{border-top:2px solid #37c2e4!important}
    .sira-toast{position:fixed;bottom:18px;right:18px;background:#2c3e50;color:#fff;padding:8px 16px;border-radius:6px;font-size:12px;font-weight:600;z-index:9999;display:none;align-items:center;gap:8px}
  </style>
</head>
<body>

<div class="hdr">
  <h1><i class="fa fa-layer-group"></i> Kategori Yönetimi</h1>
  <div class="hdr-nav">
    <a href="urun_ekle.asp"><i class="fa fa-plus"></i> Yeni Ürün</a>
    <a href="urun_listesi.asp"><i class="fa fa-list"></i> Ürün Listesi</a>
    <a href="../default.asp"><i class="fa fa-arrow-left"></i> Fiyat Listesi</a>
  </div>
</div>

<div class="wrap">

  <%
  If sil_msg="ok" Then
    Response.Write "<div class='msg msg-ok'><i class='fa fa-check-circle'></i> Kategori silindi.</div>"
  ElseIf Left(sil_msg&"  ",5)="HATA:" Then
    Response.Write "<div class='msg msg-err'><i class='fa fa-times-circle'></i> " & sil_msg & "</div>"
  ElseIf Left(sil_msg&"  ",6)="UYARI:" Then
    Response.Write "<div class='msg msg-warn'><i class='fa fa-exclamation-triangle'></i> " & sil_msg & "</div>"
  End If
  If ekle_tip="ok" Then
    Response.Write "<div class='msg msg-ok'><i class='fa fa-check-circle'></i> " & ekle_msg & "</div>"
  ElseIf ekle_tip="err" Then
    Response.Write "<div class='msg msg-err'><i class='fa fa-times-circle'></i> " & ekle_msg & "</div>"
  End If
  If duz_tip="ok" Then
    Response.Write "<div class='msg msg-ok'><i class='fa fa-check-circle'></i> " & duz_msg & "</div>"
  ElseIf duz_tip="err" Then
    Response.Write "<div class='msg msg-err'><i class='fa fa-times-circle'></i> " & duz_msg & "</div>"
  End If
  %>

  <div class="card">
    <div class="card-head"><i class="fa fa-plus-circle"></i> Yeni Kategori Ekle</div>
    <div class="card-body">
      <form method="post" action="anakatgori_ekle.asp">
      <input type="hidden" name="kaydet" value="1"/>
      <div class="frow">
        <div class="fcol">
          <label>Kategori Adı (TR) <span class="req">*</span></label>
          <input type="text" name="anakatadi" value="<%=SafeHtml(Request.Form("anakatadi"))%>" placeholder="ör. Taşıt Kantarları" maxlength="200"/>
        </div>
        <div class="fcol">
          <label>Kategori Adı (EN)</label>
          <input type="text" name="anakatadi_eng" value="<%=SafeHtml(Request.Form("anakatadi_eng"))%>" placeholder="e.g. Truck Scales" maxlength="200"/>
        </div>
        <div class="fcol">
          <label>Görsel (img)</label>
          <input type="text" name="img" value="<%=SafeHtml(Request.Form("img"))%>" placeholder="../images/kategori.jpg" maxlength="255"/>
          <div class="fhint">Kategori görsel yolu</div>
        </div>
        <div class="fcol" style="max-width:130px">
          <label>Sıralama</label>
          <input type="text" name="siralama" value="<%=SafeHtml(Request.Form("siralama"))%>" placeholder="Otomatik"/>
          <div class="fhint">Küçük = üstte</div>
        </div>
        <div class="fcol" style="max-width:130px;display:flex;flex-direction:column;justify-content:flex-end">
          <label>Durum</label>
          <label style="display:flex;align-items:center;gap:6px;padding:8px 0;cursor:pointer;font-size:13px;font-weight:400;text-transform:none;letter-spacing:0">
            <input type="hidden" name="aktif_degil" value="0"/><input type="checkbox" name="aktif_degil" value="1" style="width:auto"/> Pasif yap
          </label>
        </div>
        <div style="display:flex;align-items:flex-end">
          <button type="submit" class="btn btn-green"><i class="fa fa-save"></i> Kaydet</button>
        </div>
      </div>
      </form>
    </div>
  </div>

  <div class="card">
    <div class="card-head"><i class="fa fa-list"></i> Mevcut Kategoriler</div>

    <% If rs_list.EOF And rs_list.BOF Then %>
      <div style="text-align:center;padding:36px;color:#aaa">
        <i class="fa fa-folder-open" style="font-size:32px;display:block;margin-bottom:10px;opacity:.3"></i>
        Henüz kategori yok. Yukarıdan ekleyin.
      </div>
    <% Else %>
    <form method="post" action="anakatgori_ekle.asp">
    <input type="hidden" name="duzenle" value="1"/>
    <table class="tbl">
      <thead><tr>
        <th style="width:32px"></th>
        <th style="width:50px">ID</th>
        <th>Kategori Adı (TR)</th>
        <th>Kategori Adı (EN)</th>
        <th style="width:220px">Görsel</th>
        <th style="width:70px;text-align:center">Sıra</th>
        <th style="width:80px;text-align:center">Durum</th>
        <th style="width:80px;text-align:center">Ürünler</th>
        <th style="width:150px;text-align:center">İşlem</th>
      </tr></thead>
      <tbody>
      <%
      Do While Not rs_list.EOF
        Dim r_id,r_adi,r_adi_en,r_sira,r_ucnt,r_img
        r_id     = rs_list("id")
        r_adi    = "" & rs_list("anakatadi")
        r_adi_en = "" & rs_list("anakatadi_eng")
        r_sira   = rs_list("siralama")
        r_ucnt   = rs_list("urun_sayisi")
        r_img    = "" & rs_list("img")
        Dim r_aktif : r_aktif = rs_list("aktif_degil")
        If IsNull(r_aktif) Then r_aktif = 0
        Dim is_edit : is_edit = (CStr(r_id)=duz_id)
        Dim safe_adi : safe_adi = Replace(Replace(r_adi,"\","\\"),"'","\'")
      %>
        <tr draggable="true" data-id="<%=r_id%>" data-ord="<%=r_sira%>" <%If is_edit Then Response.Write("class='edit-row'") End If%>>
          <td style="width:32px;text-align:center">
            <%If Not is_edit Then%><span class="drag-handle" title="Sürükleyerek sırala">&#9776;</span><%End If%>
          </td>
          <td style="color:#bbb;font-size:11px"><%=r_id%></td>
          <% If is_edit Then %>
            <td>
              <input type="hidden" name="edit_id" value="<%=r_id%>"/>
              <input type="text" name="edit_anakatadi" value="<%=SafeHtml(r_adi)%>" maxlength="200"/>
            </td>
            <td><input type="text" name="edit_anakatadi_eng" value="<%=SafeHtml(r_adi_en)%>" maxlength="200"/></td>
            <td><input type="text" name="edit_img" value="<%=SafeHtml(r_img)%>" maxlength="255" placeholder="../images/kategori.jpg"/></td>
            <td style="text-align:center"><input type="text" name="edit_siralama" value="<%=r_sira%>" style="width:55px;text-align:center"/></td>
            <td style="text-align:center">
              <label style="display:flex;align-items:center;justify-content:center;gap:5px;cursor:pointer;font-size:12px;font-weight:400">
                <input type="hidden" name="edit_aktif_degil" value="0"/><input type="checkbox" name="edit_aktif_degil" value="1" style="width:auto" <%If (r_aktif <> 0 And Not IsNull(r_aktif)) Then Response.Write("checked") End If%>/> Pasif
              </label>
            </td>
          <% Else %>
            <td><strong><%=SafeHtml(r_adi)%></strong></td>
            <td style="color:#666"><%=SafeHtml(r_adi_en)%></td>
            <td>
              <% If Trim(r_img) <> "" Then %>
                <div style="display:flex;align-items:center;gap:8px">
                  <img src="<%=SafeHtml(r_img)%>" alt="" class="thumb"/>
                  <span class="img-path"><%=SafeHtml(r_img)%></span>
                </div>
              <% Else %>
                <span style="color:#bbb">-</span>
              <% End If %>
            </td>
            <td style="text-align:center;color:#888"><span class="k-ord-val"><%=r_sira%></span></td>
            <td style="text-align:center">
              <% If (r_aktif <> 0 And Not IsNull(r_aktif)) Then %>
                <span style="background:#e74c3c;color:#fff;border-radius:10px;padding:2px 9px;font-size:11px;font-weight:700">Pasif</span>
              <% Else %>
                <span style="background:#2ecc71;color:#fff;border-radius:10px;padding:2px 9px;font-size:11px;font-weight:700">Aktif</span>
              <% End If %>
            </td>
          <% End If %>
          <td style="text-align:center">
            <% If r_ucnt > 0 Then %>
              <a href="urun_listesi.asp?akno=<%=r_id%>" class="badge badge-blue" title="Ürünleri gör"><%=r_ucnt%></a>
            <% Else %>
              <span class="badge badge-grey">0</span>
            <% End If %>
          </td>
          <td>
            <div class="ops">
              <% If is_edit Then %>
                <button type="submit" class="btn btn-green btn-sm"><i class="fa fa-check"></i> Kaydet</button>
                <a href="anakatgori_ekle.asp" class="btn btn-grey btn-sm"><i class="fa fa-times"></i></a>
              <% Else %>
                <a href="anakatgori_ekle.asp?duzenle_id=<%=r_id%>" class="btn btn-blue btn-sm" title="Düzenle"><i class="fa fa-pen"></i></a>
                <% If Session("MM_UserAuthorization") = super_yonetici Then %>
                <button type="button" class="btn btn-red btn-sm" onclick="silOnay(<%=r_id%>,'<%=safe_adi%>',<%=r_ucnt%>)" title="Sil"><i class="fa fa-trash"></i></button>
                <% End If %>
              <% End If %>
            </div>
          </td>
        </tr>
      <%  rs_list.MoveNext : Loop
          rs_list.Close : Set rs_list = Nothing
          db_l.Close : Set db_l = Nothing
      %>
      </tbody>
    </table>
    </form>
    <% End If %>
  </div>

</div>

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
function silOnay(id,ad,ucnt){
  var m=document.getElementById('modal-msg'), l=document.getElementById('modal-link');
  if(ucnt>0){
    m.innerHTML='<strong>'+ad+'</strong> kategorisine bağlı <strong>'+ucnt+' ürün</strong> var.<br><small style="color:#e74c3c">Önce ürünleri silmeniz gerekir.</small>';
    l.href='#'; l.onclick=function(){kapat();return false;};
  } else {
    m.innerHTML='<strong>'+ad+'</strong> kategorisini silmek istediğinize emin misiniz?';
    l.href='anakatgori_ekle.asp?sil_id='+id; l.onclick=null;
  }
  document.getElementById('overlay').style.display='flex';
}
function kapat(){document.getElementById('overlay').style.display='none';}
document.getElementById('overlay').addEventListener('click',function(e){if(e.target===this)kapat();});

// ================================================================
// SIRALAMA: Drag & Drop
// ================================================================
var kDragSrc   = null;
var kSiraTimer = null;
var kToast     = document.getElementById('sira-toast');
var kToastMsg  = document.getElementById('sira-toast-msg');
var kToastIkon = document.getElementById('sira-toast-ikon');

function kGosterToast(msg, ikon) {
  kToastMsg.textContent = msg;
  kToastIkon.className = ikon || 'fa fa-spinner fa-spin';
  kToast.style.display = 'flex';
}
function kGizleToast(ms) {
  setTimeout(function(){ kToast.style.display = 'none'; }, ms || 2000);
}

function kSiraKaydet() {
  var satirlar = document.querySelectorAll('.tbl tbody tr[data-id]');
  var siralar = [];
  var ord = 10;
  satirlar.forEach(function(tr) {
    siralar.push({ id: parseInt(tr.dataset.id), ord: ord });
    var span = tr.querySelector('.k-ord-val');
    if (span) span.textContent = ord;
    tr.dataset.ord = ord;
    ord += 10;
  });
  kGosterToast('Sıralama kaydediliyor…', 'fa fa-spinner fa-spin');
  fetch('anakatgori_ekle.asp', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'act=kat_siralama_kaydet&siralar=' + encodeURIComponent(JSON.stringify(siralar))
  })
  .then(function(r) { return r.json(); })
  .then(function(d) {
    kGosterToast(d.ok ? 'Sıralama kaydedildi ✓' : 'Hata oluştu!',
                 d.ok ? 'fa fa-check-circle'    : 'fa fa-times-circle');
    kGizleToast(1800);
  })
  .catch(function() {
    kGosterToast('Bağlantı hatası!', 'fa fa-times-circle');
    kGizleToast(2000);
  });
}

function kDebounceKaydet() {
  clearTimeout(kSiraTimer);
  kSiraTimer = setTimeout(kSiraKaydet, 600);
}

document.querySelectorAll('.tbl tbody tr[data-id]').forEach(function(tr) {
  tr.addEventListener('dragstart', function(e) {
    kDragSrc = this;
    this.classList.add('dragging');
    e.dataTransfer.effectAllowed = 'move';
  });
  tr.addEventListener('dragend', function() {
    this.classList.remove('dragging');
    document.querySelectorAll('.tbl tbody tr').forEach(function(r){ r.classList.remove('drag-over'); });
    kDebounceKaydet();
  });
  tr.addEventListener('dragover', function(e) {
    e.preventDefault();
    if (kDragSrc && this !== kDragSrc && this.dataset.id) {
      document.querySelectorAll('.tbl tbody tr').forEach(function(r){ r.classList.remove('drag-over'); });
      this.classList.add('drag-over');
      e.dataTransfer.dropEffect = 'move';
    }
  });
  tr.addEventListener('drop', function(e) {
    e.preventDefault();
    if (!kDragSrc || this === kDragSrc || !this.dataset.id) return;
    this.parentNode.insertBefore(kDragSrc, this);
    this.classList.remove('drag-over');
  });
});
</script>

</body>
</html>