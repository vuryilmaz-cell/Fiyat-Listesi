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

Dim msg, msg_tip, yeni_id
msg="" : msg_tip="" : yeni_id=0

If Request.Form("kaydet") = "1" Then
  Dim fu,fue,fakno,ford,fatr,faen,falt_tr,falt_en,fbay_tr,fbay_en,fimg,fpg
  fu      = Trim(Request.Form("urunadi"))
  fue     = Trim(Request.Form("urunadi_eng"))
  fakno   = Trim(Request.Form("akno"))
  ford    = Trim(Request.Form("ord"))
  fatr    = Trim(Request.Form("aciklama_tr"))
  faen    = Trim(Request.Form("aciklama_en"))
  falt_tr = Trim(Request.Form("alt_tr"))
  falt_en = Trim(Request.Form("alt_en"))
  fbay_tr = Trim(Request.Form("bayi_tr"))
  fbay_en = Trim(Request.Form("bayi_en"))
  fimg    = Trim(Request.Form("img"))
  fpg     = Trim(Request.Form("print_group"))

  Dim faktif : faktif = 0
  If InStr(Request.Form("aktif_degil"),"1") > 0 Then faktif = 1

  If fu = "" Then
    msg="Ürün adı (TR) zorunludur." : msg_tip="err"
  ElseIf fakno = "" Or Not IsNumeric(fakno) Then
    msg="Kategori seçimi zorunludur." : msg_tip="err"
  Else
    On Error Resume Next
    Dim db : Set db = Server.CreateObject("ADODB.Connection")
    db.Open MM_fiyat_STRING

    If ford="" Or Not IsNumeric(ford) Then
      Dim rs_ord : Set rs_ord = db.Execute("SELECT MAX(ord) FROM urunler WHERE akno=" & CLng(fakno))
      If Not IsNull(rs_ord(0)) Then ford=CStr(CLng(rs_ord(0))+10) Else ford="10"
      rs_ord.Close : Set rs_ord=Nothing
    End If

    db.Execute "INSERT INTO urunler (" & _
      "urunadi,urunadi_eng,akno,ord," & _
      "fiyat_liste_aciklama,fiyat_liste_aciklama_eng," & _
      "fiyat_liste_alt_aciklama,fiyat_liste_alt_aciklama_eng," & _
      "bayi_fiyat_liste_aciklama,bayi_fiyat_liste_aciklama_eng," & _
      "img,print_group,aktif_degil) VALUES (" & _
      SqlStr(fu) & "," & SqlStrN(fue) & "," & CLng(fakno) & "," & CLng(ford) & "," & _
      SqlStrN(fatr) & "," & SqlStrN(faen) & "," & _
      SqlStrN(falt_tr) & "," & SqlStrN(falt_en) & "," & _
      SqlStrN(fbay_tr) & "," & SqlStrN(fbay_en) & "," & _
      SqlStrN(fimg) & "," & SqlStrN(fpg) & "," & -1*(faktif=1) & ")"

    If Err.Number <> 0 Then
      msg = "Kayıt hatası: " & Err.Description : msg_tip = "err"
    Else
      Dim rs_new : Set rs_new = db.Execute("SELECT MAX(id) FROM urunler WHERE akno=" & CLng(fakno))
      yeni_id = rs_new(0) : rs_new.Close : Set rs_new=Nothing
      msg = "Ürün eklendi (ID: " & yeni_id & ")." : msg_tip = "ok"
    End If
    db.Close : Set db=Nothing : On Error GoTo 0
  End If
End If

Dim db2 : Set db2 = Server.CreateObject("ADODB.Connection")
db2.Open MM_fiyat_STRING
Dim rs_kat : Set rs_kat = db2.Execute("SELECT id,anakatadi FROM Anakatagori WHERE language=1 ORDER BY siralama")
%>

<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="utf-8"/>
  <title>Yeni Ürün Ekle — Tunaylar</title>
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
    .wrap{max-width:860px;margin:28px auto;padding:0 20px}
    .card{background:#fff;border-radius:8px;box-shadow:0 1px 4px rgba(0,0,0,.08);margin-bottom:20px;overflow:hidden}
    .card-head{background:#ecf0f1;padding:10px 18px;font-weight:700;font-size:13px;color:#2c3e50;border-bottom:1px solid #dde;display:flex;align-items:center;gap:8px}
    .card-body{padding:20px}
    .frow{display:flex;gap:14px;margin-bottom:14px;flex-wrap:wrap}
    .fcol{flex:1;min-width:200px}
    .fcol label{display:block;font-size:11px;font-weight:700;color:#666;margin-bottom:4px;text-transform:uppercase;letter-spacing:.4px}
    .req{color:#e74c3c}
    .fcol input,.fcol select,.fcol textarea{width:100%;padding:8px 10px;border:1px solid #ccd;border-radius:4px;font-size:13px;font-family:inherit;background:#fafafa}
    .fcol input:focus,.fcol select:focus,.fcol textarea:focus{outline:none;border-color:#37c2e4;background:#fff}
    .fcol textarea{resize:vertical;min-height:86px}
    .fhint{font-size:11px;color:#aaa;margin-top:3px}
    .btn{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;border:none;border-radius:5px;font-size:13px;cursor:pointer;font-weight:600;text-decoration:none}
    .btn-green{background:#2ecc71;color:#fff}.btn-green:hover{background:#27ae60}
    .btn-grey{background:#95a5a6;color:#fff}.btn-grey:hover{background:#7f8c8d}
    .msg{padding:12px 16px;border-radius:5px;margin-bottom:18px;font-size:13px;font-weight:500;display:flex;align-items:center;gap:8px}
    .msg-ok{background:#d4edda;color:#155724;border:1px solid #c3e6cb}
    .msg-err{background:#f8d7da;color:#721c24;border:1px solid #f5c6cb}
    .next-box{background:#fff8e1;border:1px solid #ffe082;border-radius:6px;padding:14px 18px;font-size:13px;margin-top:4px}
    .next-box a{color:#37c2e4;font-weight:600;text-decoration:none}
    .next-box a:hover{text-decoration:underline}
    .sep{border:none;border-top:2px dashed #e8eaed;margin:14px 0}
  </style>
</head>
<body>

<div class="hdr">
  <h1><i class="fa fa-plus-circle"></i> Yeni Ürün Ekle</h1>
  <div class="hdr-nav">
    <a href="anakatgori_ekle.asp"><i class="fa fa-layer-group"></i> Kategoriler</a>
    <a href="urun_listesi.asp"><i class="fa fa-list"></i> Ürün Listesi</a>
    <a href="../default.asp"><i class="fa fa-arrow-left"></i> Fiyat Listesi</a>
  </div>
</div>

<div class="wrap">

  <% If msg_tip="ok" Then %>
    <div class="msg msg-ok"><i class="fa fa-check-circle"></i> <%=msg%></div>
    <div class="next-box">
      <strong>Sonraki adım:</strong>&nbsp;
      <a href="urun_duzenle.asp?id=<%=yeni_id%>&sekme=kapasite">Kapasiteyi Ekle</a>
      &nbsp;·&nbsp;
      <a href="urun_ekle.asp">Yeni Ürün Daha Ekle</a>
      &nbsp;·&nbsp;
      <a href="urun_listesi.asp">Ürün Listesine Dön</a>
    </div>
  <% Else %>
    <% If msg_tip="err" Then %><div class="msg msg-err"><i class="fa fa-times-circle"></i> <%=msg%></div><% End If %>

    <form method="post" action="urun_ekle.asp">
    <input type="hidden" name="kaydet" value="1"/>

    <div class="card">
      <div class="card-head"><i class="fa fa-info-circle"></i> Temel Bilgiler</div>
      <div class="card-body">
        <div class="frow">
          <div class="fcol">
            <label>Ürün Adı (TR) <span class="req">*</span></label>
            <input type="text" name="urunadi" value="<%=Server.HTMLEncode(Request.Form("urunadi"))%>" placeholder="ör. Taşıt Kantarı T-BRIDGE" maxlength="200"/>
          </div>
          <div class="fcol">
            <label>Ürün Adı (EN)</label>
            <input type="text" name="urunadi_eng" value="<%=Server.HTMLEncode(Request.Form("urunadi_eng"))%>" placeholder="e.g. Truck Scale T-BRIDGE" maxlength="200"/>
          </div>
        </div>
        <div class="frow">
          <div class="fcol">
            <label>Kategori <span class="req">*</span></label>
            <select name="akno">
              <option value="">— Kategori Seçiniz —</option>
              <%
              Dim sel_akno : sel_akno = ""
              If Request.Form("akno") <> "" Then
                sel_akno = CStr(Request.Form("akno"))
              ElseIf Request.QueryString("akno") <> "" Then
                sel_akno = CStr(Request.QueryString("akno"))
              End If
              Do While Not rs_kat.EOF
                Dim ok_id,ok_adi : ok_id=rs_kat(0) : ok_adi=""+rs_kat(1)
              %><option value="<%=ok_id%>" <%If CStr(ok_id)=sel_akno Then Response.Write("selected") End If%>><%=Server.HTMLEncode(ok_adi)%></option><%
              rs_kat.MoveNext : Loop
              rs_kat.Close:Set rs_kat=Nothing
              db2.Close:Set db2=Nothing
              %>
            </select>
            <div class="fhint"><a href="anakatgori_ekle.asp" target="_blank" style="color:#37c2e4">Yeni kategori ekle ↗</a></div>
          </div>
          <div class="fcol" style="max-width:110px">
            <label>Sıra (ord)</label>
            <input type="text" name="ord" value="<%=Server.HTMLEncode(Request.Form("ord"))%>" placeholder="Otomatik"/>
            <div class="fhint">Küçük = üstte</div>
          </div>
          <div class="fcol" style="max-width:110px">
            <label>Print Group</label>
            <input type="text" name="print_group" value="<%=Server.HTMLEncode(Request.Form("print_group"))%>" maxlength="50"/>
          </div>
          <div class="fcol">
            <label>Görsel Yolu (img)</label>
            <input type="text" name="img" value="<%=Server.HTMLEncode(Request.Form("img"))%>" placeholder="../../fiyat/images/urun.jpg" maxlength="255"/>
          </div>
          <div class="fcol" style="max-width:110px;display:flex;flex-direction:column;justify-content:flex-end">
            <label>Durum</label>
            <label style="display:flex;align-items:center;gap:6px;padding:9px 0;cursor:pointer;font-size:13px;font-weight:400;text-transform:none;letter-spacing:0">
              <input type="hidden" name="aktif_degil" value="0"/><input type="checkbox" name="aktif_degil" value="1" style="width:auto"/> Pasif yap
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="card">
      <div class="card-head"><i class="fa fa-align-left"></i> Açıklamalar <span style="font-size:11px;font-weight:400;color:#888;margin-left:8px">(HTML kullanılabilir)</span></div>
      <div class="card-body">
        <div class="frow">
          <div class="fcol">
            <label>Fiyat Listesi Açıklama (TR)</label>
            <textarea name="aciklama_tr"><%=Server.HTMLEncode(Request.Form("aciklama_tr"))%></textarea>
          </div>
          <div class="fcol">
            <label>Fiyat Listesi Açıklama (EN)</label>
            <textarea name="aciklama_en"><%=Server.HTMLEncode(Request.Form("aciklama_en"))%></textarea>
          </div>
        </div>
        <div class="frow">
          <div class="fcol">
            <label>Alt Açıklama (TR)</label>
            <textarea name="alt_tr"><%=Server.HTMLEncode(Request.Form("alt_tr"))%></textarea>
          </div>
          <div class="fcol">
            <label>Alt Açıklama (EN)</label>
            <textarea name="alt_en"><%=Server.HTMLEncode(Request.Form("alt_en"))%></textarea>
          </div>
        </div>
        <div class="frow">
          <div class="fcol">
            <label>Bayi Açıklama (TR)</label>
            <textarea name="bayi_tr"><%=Server.HTMLEncode(Request.Form("bayi_tr"))%></textarea>
            <div class="fhint">Boşsa normal açıklama kullanılır</div>
          </div>
          <div class="fcol">
            <label>Bayi Açıklama (EN)</label>
            <textarea name="bayi_en"><%=Server.HTMLEncode(Request.Form("bayi_en"))%></textarea>
          </div>
        </div>
      </div>
    </div>

    <div style="display:flex;gap:10px;justify-content:flex-end;margin-bottom:40px">
      <a href="urun_listesi.asp" class="btn btn-grey"><i class="fa fa-times"></i> İptal</a>
      <button type="submit" class="btn btn-green"><i class="fa fa-save"></i> Ürünü Kaydet</button>
    </div>
    </form>
  <% End If %>

</div>
</body>
</html>
