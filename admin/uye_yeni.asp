<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>

<%
Option Explicit
Response.Charset = "utf-8"
%>

<%
Dim MM_authorizedUsers, MM_authFailedURL, MM_grantAccess
MM_authorizedUsers = "1"
MM_authFailedURL = "../login.asp?err=5"
MM_grantAccess = False
%>

<!--#include file="../access_security.asp" -->
<!--#include file="../Connections/uyeler.asp" -->

<%
Dim q, sql, rs, price_list_type, language
q = Trim(Request.QueryString("q"))

sql = "SELECT id, username, User_Name, User_Surname, Company_Name, member_type, allow, active_passive, Default_Currency, Default_Language " & _
      "FROM tblUsersCor_Personel "

If Len(q) > 0 Then
  q = Replace(q, "'", "''")
  sql = sql & "WHERE username LIKE '%" & q & "%' " & _
              "OR User_Name LIKE '%" & q & "%' " & _
              "OR User_Surname LIKE '%" & q & "%' " & _
              "OR Company_Name LIKE '%" & q & "%' "
End If

sql = sql & "ORDER BY id DESC"

Set rs = Server.CreateObject("ADODB.Recordset")
rs.Open sql, MM_stok_STRING, 1, 1   ' <-- doğru connection

Function YesNoText(v)
  If IsNull(v) Then
    YesNoText = "?"
  ElseIf CBool(v) Then
    YesNoText = "Evet"
  Else
    YesNoText = "Hayır"
  End If
End Function

Function RoleText(v)
  Select Case CLng(0 & v)
    Case 1: RoleText = "Süper"
    Case 2: RoleText = "Yönetici"
    Case 3: RoleText = "Kullanıcı"
    Case 5: RoleText = "Bayi"
    Case Else: RoleText = CStr(v)
  End Select
End Function
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
  <title>Üye Yönetimi</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link href="../screen.css" rel="stylesheet" type="text/css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <script src="acl.js" language="javascript" type="text/javascript"></script>

  <!-- Login benzeri modern görünüm için ek CSS -->
  <style>
/* --- Yeni Üye Form Stil Ayarları --- */
#body_text{
  margin: 20px auto 40px auto;
  padding: 0 16px;
}

/* Formu kart görünümüne yaklaştır */
#body_text form{
  background:#fff;
  border:1px solid #e6e8ee;
  border-radius:10px;
  box-shadow:0 6px 24px rgba(0,0,0,.06);
  padding:18px;
}

/* Form içi yazı ve label düzeni */
#body_text form{
  margin-left:250px;
  margin-right:250px;


font-size:13px;
  color:#222;
  line-height:1.4;
}

/* Input / Select / Textarea ortak görünüm */
#body_text input[type="text"],
#body_text input[type="password"],
#body_text input[type="number"],
#body_text select,
#body_text textarea{
  width: 100%;
  max-width: 520px;
  height: 38px;
  padding: 0 10px;
  border: 1px solid #d7dbe6;
  border-radius: 8px;
  background: #fff;
  box-sizing: border-box;
  outline: none;
}

/* textarea yüksekliği */
#body_text textarea{
  height: auto;
  min-height: 90px;
  padding: 10px;
  max-width: 720px;
}

/* Focus efekti */
#body_text input[type="text"]:focus,
#body_text input[type="password"]:focus,
#body_text input[type="number"]:focus,
#body_text select:focus,
#body_text textarea:focus{
  border-color:#2f6fed;
  box-shadow:0 0 0 3px rgba(47,111,237,.15);
}

/* Satır araları */
#body_text br{ line-height: 14px; }

/* Aynı satırdaki Discount / Increasing alanlarını hizala */
#body_text form input[name="Special_Discount_Product"],
#body_text form input[name="Special_Discount_Spare"],
#body_text form input[name="Special_Discount_Mechanic"],
#body_text form input[name="Special_Increasing_Product"],
#body_text form input[name="Special_Increasing_Spare"],
#body_text form input[name="Special_Increasing_Mechanic"]{
  width: 140px;
  max-width: none;
  display: inline-block;
  vertical-align: middle;
  margin-right: 10px;
}

/* Submit / Button’ları modern buton yap */
#body_text input[type="submit"],
#body_text input[type="button"]{
  height: 36px;
  padding: 0 14px;
  border-radius: 8px;
  cursor: pointer;
  border: 1px solid #cfd5e3;
  background:#fff;
  margin-right: 10px;
}

/* Kaydet butonu primary */
#body_text input[type="submit"]{
  border-color:#2f6fed;
  background:#2f6fed;
  color:#fff;
}

/* İptal butonu hover */
#body_text input[type="button"]:hover{
  border-color:#b9c2d8;
  background:#f7f9ff;
}

/* Kaydet hover */
#body_text input[type="submit"]:hover{
  filter: brightness(0.95);
}
  </style>
</head>

<body>


<div id="menu_div" onMouseOver="altdivshow(this)" onMouseOut="altdivhide(this)"></div>

<div id="main_container"><%Server.Execute("../top_temp.asp")%></div>
<div id="body_div_container">
  <div id="body_div" style="border:none">


    <div id="admin_menu_div">
      <div class="menu_active"><i class="fa-solid fa-user-lock" style="font-size:20px"></i> BAYİ YÖNETİMİ</div>
      <div class="admin_menu" style="display:block; width:calc(100% - 242px)"></div>
      <div class="admin_menu" style="display:none"></div>
      <div class="admin_menu" style="display:none"></div>
    </div>


    <div id="body_text">
        <h2 class="title">BAYİ YÖNETİMİ</h2>
  
       <form method="post" action="uye_kaydet.asp">
    <input type="hidden" name="mode" value="create" />

    Kullanıcı Adı (username):<br />
    <input type="text" name="username" required /><br /><br />

    Şifre (password):<br />
    <input type="password" name="password" required /><br /><br />

    Ad (User_Name):<br />
    <input type="text" name="User_Name" /><br /><br />

    Soyad (User_Surname):<br />
    <input type="text" name="User_Surname" /><br /><br />

    Firma (Company_Name):<br />
    <input type="text" name="Company_Name" /><br /><br />

    Yetki (1=süper,2=yonetici,3=kullanici,5=bayi):<br />
    <input type="number" name="member_type" value="3" /><br /><br />

    Allow:<br />
    <select name="allow">
      <option value="-1" selected>Evet</option>
      <option value="0">Hayır</option>
    </select><br /><br />

    Active (active_passive):<br />
    <select name="active_passive">
      <option value="-1" selected>Aktif</option>
      <option value="0">Pasif</option>
    </select><br /><br />

    Default Currency:<br />
    <select name="Default_Currency">
      <option value="TRY">TRY</option>
      <option value="USD" selected>USD</option>
      <option value="EUR">EUR</option>
    </select><br /><br />

    Default Language (1=TR, 2=EN gibi):<br />
    <input type="number" name="Default_Language" value="1" /><br /><br />

    Special Discount / Increasing (Sayı):<br />
    Discount_Product: <input type="number" name="Special_Discount_Product" value="0" />
    Discount_Spare: <input type="number" name="Special_Discount_Spare" value="0" />
    Discount_Mechanic: <input type="number" name="Special_Discount_Mechanic" value="0" /><br /><br />

    Increasing_Product: <input type="number" name="Special_Increasing_Product" value="0" />
    Increasing_Spare: <input type="number" name="Special_Increasing_Spare" value="0" />
    Increasing_Mechanic: <input type="number" name="Special_Increasing_Mechanic" value="0" /><br /><br />

    Açıklama (Description):<br />
    <textarea name="Description" rows="3" cols="60"></textarea><br /><br />

    <input type="submit" value="Kaydet" />
    <input type="button" value="İptal" onclick="location.href='uyeler.asp';" />
</form>

   



    </div>
      <div style="clear:both"></div>

  </div>
</div>

<div id="bottom_container_div"><!--#include file="../bottom_temp.html" --></div>
</body>
</html>