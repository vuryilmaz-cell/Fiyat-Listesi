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
'================================================================
' SİLME İŞLEMLERİ
'================================================================
Dim silme_mesaj : silme_mesaj = ""

' --- Ebat sil ---
If Request.QueryString("sil_ebat_id") <> "" Then
  Dim sil_ebat_id : sil_ebat_id = CLng(Request.QueryString("sil_ebat_id"))
  On Error Resume Next
  Dim dc1 : Set dc1 = Server.CreateObject("ADODB.Command")
  dc1.ActiveConnection = MM_fiyat_STRING
  dc1.CommandText = "DELETE FROM ebat WHERE id=?"
  dc1.Prepared = True
  dc1.Parameters.Append dc1.CreateParameter("p1",5,1,-1,sil_ebat_id)
  dc1.Execute
  If Err.Number <> 0 Then silme_mesaj = "HATA: " & Err.Description Else silme_mesaj = "ok_ebat"
  Set dc1 = Nothing : On Error GoTo 0
End If

' --- Ürün sil ---
If Request.QueryString("sil_urun_id") <> "" Then
  Dim sil_urun_id : sil_urun_id = CLng(Request.QueryString("sil_urun_id"))
  On Error Resume Next
  Dim dc2 : Set dc2 = Server.CreateObject("ADODB.Command")
  dc2.ActiveConnection = MM_fiyat_STRING
  dc2.CommandText = "SELECT COUNT(*) FROM ebat WHERE product_id=?"
  dc2.Prepared = True
  dc2.Parameters.Append dc2.CreateParameter("p1",5,1,-1,sil_urun_id)
  Dim rs2 : Set rs2 = dc2.Execute
  Dim ubag : ubag = 0
  If Not rs2.EOF Then ubag = rs2(0)
  rs2.Close : Set rs2 = Nothing : Set dc2 = Nothing
  If ubag > 0 Then
    silme_mesaj = "UYARI: Bu ürüne bağlı " & ubag & " ebat kaydı var. Önce ebatları silin."
  Else
    Dim dc3 : Set dc3 = Server.CreateObject("ADODB.Command")
    dc3.ActiveConnection = MM_fiyat_STRING
    dc3.CommandText = "DELETE FROM kaptak WHERE product_id=?"
    dc3.Prepared = True
    dc3.Parameters.Append dc3.CreateParameter("p1",5,1,-1,sil_urun_id)
    dc3.Execute : Set dc3 = Nothing
    Dim dc4 : Set dc4 = Server.CreateObject("ADODB.Command")
    dc4.ActiveConnection = MM_fiyat_STRING
    dc4.CommandText = "DELETE FROM urunler WHERE id=?"
    dc4.Prepared = True
    dc4.Parameters.Append dc4.CreateParameter("p1",5,1,-1,sil_urun_id)
    dc4.Execute
    If Err.Number <> 0 Then silme_mesaj = "HATA: " & Err.Description Else silme_mesaj = "ok_urun"
    Set dc4 = Nothing
  End If
  On Error GoTo 0
End If

'================================================================
' AKTİF/PASİF TOGGLE (AJAX)
'================================================================
If Request.Form("act") = "toggle_aktif" Then
  Dim t_id, t_val
  t_id  = 0
  t_val = 0
  If IsNumeric(Request.Form("urun_id")) Then t_id = CLng(Request.Form("urun_id"))
  If IsNumeric(Request.Form("yeni_deger")) Then t_val = CLng(Request.Form("yeni_deger"))
  If t_id > 0 Then
    Dim tc : Set tc = Server.CreateObject("ADODB.Command")
    tc.ActiveConnection = MM_fiyat_STRING
    tc.CommandText = "UPDATE urunler SET aktif_degil=? WHERE id=?"
    tc.Prepared = True
    tc.Parameters.Append tc.CreateParameter("p1",2,1,-1,t_val)
    tc.Parameters.Append tc.CreateParameter("p2",5,1,-1,t_id)
    tc.Execute : Set tc = Nothing
    Response.ContentType = "application/json"
    Response.Write("{""ok"":true,""yeni_deger"":" & t_val & "}")
    Response.End
  End If
End If


Dim filtre_akno : filtre_akno = ""
If Request.QueryString("akno") <> "" Then filtre_akno = Request.QueryString("akno")

Dim db : Set db = Server.CreateObject("ADODB.Connection")
db.Open MM_fiyat_STRING

' Kategori dropdown
Dim rs_kat : Set rs_kat = db.Execute("SELECT id, anakatadi FROM Anakatagori WHERE language=1 ORDER BY siralama")

' Ürün listesi
Dim urun_where
If filtre_akno <> "" Then
  urun_where = "WHERE u.akno=" & CLng(filtre_akno)
Else
  urun_where = "WHERE 1=1"
End If

Dim rs_urun : Set rs_urun = db.Execute( _
  "SELECT u.id, u.urunadi, u.akno, u.aktif_degil, a.anakatadi, " & _
  "(SELECT COUNT(*) FROM ebat WHERE product_id=u.id) AS ebat_sayisi, " & _
  "(SELECT COUNT(*) FROM kaptak WHERE product_id=u.id) AS kap_sayisi " & _
  "FROM urunler u INNER JOIN Anakatagori a ON u.akno=a.id " & _
  urun_where & " ORDER BY a.siralama, u.ord")
%>

<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="utf-8"/>
  <title>Ürün Yönetimi — Tunaylar</title>
  <link href="../screen.css" media="screen" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
  <style>
    *{box-sizing:border-box}
    body{font-family:'Barlow',Arial,sans-serif;background:#f0f2f5;margin:0}

    /* HEADER */
    .hdr{background:#1a2332;color:#fff;padding:0 24px;display:flex;align-items:center;justify-content:space-between;height:52px}
    .hdr h1{margin:0;font-size:17px;font-weight:600;display:flex;align-items:center;gap:10px}
    .hdr-nav{display:flex;gap:6px}
    .hdr-nav a{color:#37c2e4;text-decoration:none;font-size:12px;padding:5px 10px;border-radius:4px;border:1px solid rgba(55,194,228,.3);display:flex;align-items:center;gap:5px}
    .hdr-nav a:hover{background:rgba(55,194,228,.15)}

    /* TOOLBAR */
    .tbr{background:#fff;border-bottom:2px solid #e8eaed;padding:10px 24px;display:flex;align-items:center;gap:10px;flex-wrap:wrap}
    .tbr select{padding:7px 10px;border:1px solid #ccd;border-radius:5px;font-size:13px;min-width:220px;background:#fafafa}
    .tbr-sep{width:1px;height:28px;background:#dde;margin:0 4px}

    /* BUTONLAR */
    .btn{display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border:none;border-radius:5px;font-size:13px;cursor:pointer;font-weight:600;text-decoration:none;white-space:nowrap}
    .btn-green {background:#2ecc71;color:#fff} .btn-green:hover{background:#27ae60}
    .btn-blue  {background:#37c2e4;color:#fff} .btn-blue:hover{background:#2aabb0}
    .btn-red   {background:#e74c3c;color:#fff} .btn-red:hover{background:#c0392b}
    .btn-grey  {background:#95a5a6;color:#fff} .btn-grey:hover{background:#7f8c8d}
    .btn-dark  {background:#2c3e50;color:#fff} .btn-dark:hover{background:#1a252f}
    .btn-sm{padding:4px 9px;font-size:12px}

    /* MESAJ */
    .msg{padding:10px 16px;border-radius:5px;margin-bottom:16px;font-size:13px;font-weight:500;display:flex;align-items:center;gap:8px}
    .msg-ok   {background:#d4edda;color:#155724;border:1px solid #c3e6cb}
    .msg-err  {background:#f8d7da;color:#721c24;border:1px solid #f5c6cb}
    .msg-warn {background:#fff3cd;color:#856404;border:1px solid #ffeeba}

    /* İÇERİK */
    .content{padding:20px 24px}

    /* TABLO */
    .tbl{width:100%;border-collapse:collapse;background:#fff;border-radius:8px;overflow:hidden;box-shadow:0 1px 4px rgba(0,0,0,.07);font-size:13px}
    .tbl thead tr{background:#1a2332;color:#fff}
    .tbl th{padding:10px 12px;text-align:left;font-weight:600;white-space:nowrap}
    .tbl td{padding:9px 12px;border-bottom:1px solid #f0f0f0;vertical-align:middle}
    .tbl tr:last-child td{border-bottom:none}
    .tbl tr:hover td{background:#f7fbff}

    /* KATEGORİ SATIRI */
    .kat-row td{background:#e8f0fe;color:#1a2332;font-weight:700;font-size:12px;text-transform:uppercase;letter-spacing:.5px;padding:7px 12px}

    /* BADGE */
    .badge{display:inline-flex;align-items:center;justify-content:center;min-width:24px;padding:2px 7px;border-radius:12px;font-size:11px;font-weight:700;text-decoration:none}
    .badge-blue{background:#37c2e4;color:#fff}
    .badge-grey{background:#bdc3c7;color:#fff}
    .badge-green{background:#2ecc71;color:#fff}

    /* İŞLEM GRUBU */
    .ops{display:flex;gap:4px}

    /* ONAY OVERLAY */
    .overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:9999;align-items:center;justify-content:center}
    .modal{background:#fff;border-radius:10px;padding:32px;max-width:400px;width:90%;text-align:center;box-shadow:0 8px 32px rgba(0,0,0,.2)}
    .modal h3{margin:0 0 12px;font-size:17px;color:#2c3e50}
    .modal p{margin:0 0 22px;font-size:13px;color:#666;line-height:1.6}
    .modal-btns{display:flex;gap:10px;justify-content:center}

    /* BOŞ DURUM */
    .empty{text-align:center;padding:60px 20px;color:#aaa}
    .empty i{font-size:48px;display:block;margin-bottom:14px;opacity:.4}

    /* STEP BADGES (toolbar) */
    .step-badge{display:inline-flex;align-items:center;gap:6px;background:#e8f0fe;border:1px solid #c5d8f8;border-radius:5px;padding:6px 12px;font-size:12px;color:#1a56db;font-weight:600;text-decoration:none}
    .step-badge:hover{background:#d0e3fc}
    .step-badge .num{background:#1a56db;color:#fff;border-radius:50%;width:18px;height:18px;display:inline-flex;align-items:center;justify-content:center;font-size:10px;font-weight:700}
  </style>
</head>
<body>

<div class="hdr">
  <h1><i class="fa-solid fa-list-check"></i> Ürün Yönetimi</h1>
  <div class="hdr-nav">
    <a href="anakatgori_ekle.asp"><i class="fa fa-layer-group"></i> Kategoriler</a>
    <a href="../default.asp"><i class="fa fa-arrow-left"></i> Fiyat Listesi</a>
  </div>
</div>

<div class="tbr">
  <label style="font-size:12px;font-weight:700;color:#555;white-space:nowrap">KATEGORİ:</label>
  <select onchange="window.location='urun_listesi.asp?akno='+this.value">
    <option value="">— Tümü —</option>
    <%
    Do While Not rs_kat.EOF
    %><option value="<%=rs_kat("id")%>" <%If CStr(rs_kat("id"))=filtre_akno Then Response.Write("selected") End If%>><%=Server.HTMLEncode(rs_kat("anakatadi"))%></option><%
    rs_kat.MoveNext : Loop
    rs_kat.Close : Set rs_kat = Nothing
    %>
  </select>
  <% If filtre_akno <> "" Then %><a href="urun_listesi.asp" class="btn btn-grey btn-sm"><i class="fa fa-times"></i></a><% End If %>

  <div class="tbr-sep"></div>

  <span style="font-size:11px;color:#888;font-weight:600">EKLE:</span>
  <a href="urun_ekle.asp<%If filtre_akno<>"" Then Response.Write("?akno="&filtre_akno) End If%>" class="step-badge">
    <span class="num">1</span> Ürün Ekle
  </a>
  <a href="urun_listesi.asp#" onclick="alert('Ürünü seçip Düzenle butonuna tıklayın, ardından Kapasite Ekle sekmesini kullanın.')" class="step-badge">
    <span class="num">2</span> Kapasite Ekle
  </a>
  <a href="urun_listesi.asp#" onclick="alert('Ürünü seçip Düzenle butonuna tıklayın, ardından Ebat/Fiyat Ekle sekmesini kullanın.')" class="step-badge">
    <span class="num">3</span> Ebat / Fiyat Ekle
  </a>
</div>

<div class="content">

  <%
  If silme_mesaj = "ok_ebat" Then
    Response.Write("<div class='msg msg-ok'><i class='fa fa-check-circle'></i> Ebat/kapasite kaydı silindi.</div>")
  ElseIf silme_mesaj = "ok_urun" Then
    Response.Write("<div class='msg msg-ok'><i class='fa fa-check-circle'></i> Ürün silindi.</div>")
  ElseIf Left(silme_mesaj & "  ", 5) = "HATA:" Then
    Response.Write("<div class='msg msg-err'><i class='fa fa-times-circle'></i> " & silme_mesaj & "</div>")
  ElseIf Left(silme_mesaj & "  ", 6) = "UYARI:" Then
    Response.Write("<div class='msg msg-warn'><i class='fa fa-exclamation-triangle'></i> " & silme_mesaj & "</div>")
  End If
  %>

  <% If rs_urun.EOF And rs_urun.BOF Then %>
    <div class="empty">
      <i class="fa fa-box-open"></i>
      Ürün bulunamadı.<br><br>
      <a href="urun_ekle.asp" class="btn btn-green"><i class="fa fa-plus"></i> İlk Ürünü Ekle</a>
    </div>
  <% Else %>

  <table class="tbl">
    <thead>
      <tr>
        <th style="width:46px">ID</th>
        <th>Ürün Adı</th>
        <th style="width:80px;text-align:center">Kapasite</th>
        <th style="width:80px;text-align:center">Ebat</th>
        <th style="width:80px;text-align:center">Durum</th>
        <th style="width:170px;text-align:center">İşlemler</th>
      </tr>
    </thead>
    <tbody>
    <%
    Dim prv_akno : prv_akno = ""
    Do While Not rs_urun.EOF
      Dim u_id, u_adi, u_akno, u_kat, u_ebat, u_kap
      u_id   = rs_urun("id")
      u_adi  = "" & rs_urun("urunadi")
      u_akno = "" & rs_urun("akno")
      u_kat  = "" & rs_urun("anakatadi")
      u_ebat = rs_urun("ebat_sayisi")
      u_kap  = rs_urun("kap_sayisi")
      Dim u_aktif : u_aktif = rs_urun("aktif_degil") : If IsNull(u_aktif) Then u_aktif=0

      If u_akno <> prv_akno Then
    %>
      <tr class="kat-row">
        <td colspan="6"><i class="fa fa-folder" style="margin-right:6px"></i><%=Server.HTMLEncode(u_kat)%></td>
      </tr>
    <%  prv_akno = u_akno
      End If
      Dim safe_adi : safe_adi = Replace(Replace(u_adi, "\", "\\"), "'", "\'")
    %>
      <tr>
        <td style="color:#bbb;font-size:11px"><%=u_id%></td>
        <td><strong><%=Server.HTMLEncode(u_adi)%></strong></td>
        <td style="text-align:center">
          <% If u_kap > 0 Then %>
            <a href="urun_duzenle.asp?id=<%=u_id%>&sekme=kapasite" class="badge badge-green" title="Kapasiteleri gör/ekle"><%=u_kap%></a>
          <% Else %>
            <a href="urun_duzenle.asp?id=<%=u_id%>&sekme=kapasite" class="badge badge-grey" title="Kapasite ekle">0</a>
          <% End If %>
        </td>
        <td style="text-align:center">
          <% If u_ebat > 0 Then %>
            <a href="urun_duzenle.asp?id=<%=u_id%>&sekme=ebat" class="badge badge-blue" title="Ebatları gör/ekle"><%=u_ebat%></a>
          <% Else %>
            <a href="urun_duzenle.asp?id=<%=u_id%>&sekme=ebat" class="badge badge-grey" title="Ebat ekle">0</a>
          <% End If %>
        </td>
        <td style="text-align:center">
          <% If (u_aktif <> 0 And Not IsNull(u_aktif)) Then %>
            <button class="toggle-btn" data-id="<%=u_id%>" data-aktif="1"
              style="background:#e74c3c;color:#fff;border:none;border-radius:10px;padding:3px 9px;font-size:11px;font-weight:700;cursor:pointer;white-space:nowrap"
              title="Tıkla → Aktif yap">
              <i class="fa fa-times-circle" style="margin-right:3px"></i>Pasif
            </button>
          <% Else %>
            <button class="toggle-btn" data-id="<%=u_id%>" data-aktif="0"
              style="background:#2ecc71;color:#fff;border:none;border-radius:10px;padding:3px 9px;font-size:11px;font-weight:700;cursor:pointer;white-space:nowrap"
              title="Tıkla → Pasif yap">
              <i class="fa fa-check-circle" style="margin-right:3px"></i>Aktif
            </button>
          <% End If %>
        </td>
        <td>
          <div class="ops">
            <a href="urun_duzenle.asp?id=<%=u_id%>" class="btn btn-blue btn-sm" title="Düzenle / Kapasite & Ebat Yönet">
              <i class="fa fa-pen"></i> Düzenle
            </a>
            <% If Session("MM_UserAuthorization") = super_yonetici Then %>
            <button class="btn btn-red btn-sm" title="Sil" onclick="silOnay('urun',<%=u_id%>,'<%=safe_adi%>')">
              <i class="fa fa-trash"></i>
            </button>
            <% End If %>
          </div>
        </td>
      </tr>
    <%
      rs_urun.MoveNext
    Loop
    rs_urun.Close : Set rs_urun = Nothing
    db.Close : Set db = Nothing
    %>
    </tbody>
  </table>
  <% End If %>
</div>

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

<script>
var fSuffix='<%If filtre_akno<>"" Then Response.Write("&akno="&filtre_akno) End If%>';
function silOnay(tip,id,ad){
  var m=document.getElementById('modal-msg'),l=document.getElementById('modal-link');
  if(tip==='urun'){
    m.innerHTML='<strong>'+ad+'</strong> ürününü silmek istediğinize emin misiniz?<br><small style="color:#e74c3c">Bağlı ebat varsa silinemez.</small>';
    l.href='urun_listesi.asp?sil_urun_id='+id+fSuffix;
  }
  document.getElementById('overlay').style.display='flex';
}
function kapat(){document.getElementById('overlay').style.display='none';}
document.getElementById('overlay').addEventListener('click',function(e){if(e.target===this)kapat();});

// Aktif/Pasif toggle
document.querySelectorAll('.toggle-btn').forEach(function(btn){
  btn.addEventListener('click', function(){
    var id      = this.dataset.id;
    var aktif   = parseInt(this.dataset.aktif);
    var yeniDgr = aktif === 0 ? -1 : 0;  // Access: 0=aktif, -1=pasif
    var btnEl   = this;
    btnEl.disabled = true;
    btnEl.style.opacity = '0.5';

    var body = 'act=toggle_aktif&urun_id='+id+'&yeni_deger='+yeniDgr;
    fetch('urun_listesi.asp', {
      method:'POST',
      headers:{'Content-Type':'application/x-www-form-urlencoded'},
      body: body
    })
    .then(function(r){ return r.json(); })
    .then(function(d){
      if(d.ok){
        if(yeniDgr === 0){
          // Aktif yapıldı
          btnEl.style.background = '#2ecc71';
          btnEl.innerHTML = '<i class="fa fa-check-circle" style="margin-right:3px"></i>Aktif';
          btnEl.dataset.aktif = '0';
          btnEl.title = 'Tıkla → Pasif yap';
        } else {
          // Pasif yapıldı
          btnEl.style.background = '#e74c3c';
          btnEl.innerHTML = '<i class="fa fa-times-circle" style="margin-right:3px"></i>Pasif';
          btnEl.dataset.aktif = '1';
          btnEl.title = 'Tıkla → Aktif yap';
        }
      }
      btnEl.disabled = false;
      btnEl.style.opacity = '1';
    })
    .catch(function(){
      btnEl.disabled = false;
      btnEl.style.opacity = '1';
      alert('Bağlantı hatası. Lütfen tekrar deneyin.');
    });
  });
});
</script>

</body>
</html>
