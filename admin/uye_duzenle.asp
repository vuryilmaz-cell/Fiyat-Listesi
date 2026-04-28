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
Dim id, sql, rs
id = CLng(Request.QueryString("id"))

sql = "SELECT * FROM tblUsersCor_Personel WHERE id=" & id

Set rs = Server.CreateObject("ADODB.Recordset")
rs.Open sql, MM_stok_STRING, 1, 1

If rs.EOF Then
  rs.Close : Set rs = Nothing
  Response.Write "Kayıt bulunamadı."
  Response.End
End If

Function SelYN(v, valTrue)
  ' valTrue = -1
  If IsNull(v) Then
    SelYN = ""
  ElseIf CBool(v) And (valTrue = -1) Then
    SelYN = "selected"
  ElseIf (Not CBool(v)) And (valTrue = 0) Then
    SelYN = "selected"
  Else
    SelYN = ""
  End If
End Function
%>

<html>
<head>
  <title>Üye Düzenle</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link rel="stylesheet" type="text/css" href="../css/form.css" />
</head>
<body>
  <h2>Üye Düzenle</h2>

  <form method="post" action="uye_kaydet.asp">
    <input type="hidden" name="mode" value="update" />
    <input type="hidden" name="id" value="<%=rs("id")%>" />

    Kullanıcı Adı (username):<br />
    <input type="text" name="username" value="<%=Server.HTMLEncode("" & rs("username"))%>" required /><br /><br />

    Şifre (boş bırakırsan değişmez):<br />
    <input type="password" name="password" /><br /><br />

    Ad (User_Name):<br />
    <input type="text" name="User_Name" value="<%=Server.HTMLEncode("" & rs("User_Name"))%>" /><br /><br />

    Soyad (User_Surname):<br />
    <input type="text" name="User_Surname" value="<%=Server.HTMLEncode("" & rs("User_Surname"))%>" /><br /><br />

    Firma (Company_Name):<br />
    <input type="text" name="Company_Name" value="<%=Server.HTMLEncode("" & rs("Company_Name"))%>" /><br /><br />

    Yetki (member_type):<br />
    <input type="number" name="member_type" value="<%=CLng(0 & rs("member_type"))%>" /><br /><br />

    Allow:<br />
    <select name="allow">
      <option value="-1" <%If CBool(rs("allow")) Then Response.Write("selected")%>>Evet</option>
      <option value="0"  <%If Not CBool(rs("allow")) Then Response.Write("selected")%>>Hayır</option>
    </select><br /><br />

    Active (active_passive):<br />
    <select name="active_passive">
      <option value="-1" <%If CBool(rs("active_passive")) Then Response.Write("selected")%>>Aktif</option>
      <option value="0"  <%If Not CBool(rs("active_passive")) Then Response.Write("selected")%>>Pasif</option>
    </select><br /><br />

    Default Currency:<br />
    <select name="Default_Currency">
      <option value="TRY" <%If ""&rs("Default_Currency")="TRY" Then Response.Write("selected")%>>TRY</option>
      <option value="USD" <%If ""&rs("Default_Currency")="USD" Then Response.Write("selected")%>>USD</option>
      <option value="EUR" <%If ""&rs("Default_Currency")="EUR" Then Response.Write("selected")%>>EUR</option>
    </select><br /><br />

    Default Language:<br />
    <input type="number" name="Default_Language" value="<%=CLng(0 & rs("Default_Language"))%>" /><br /><br />

    Special Discount / Increasing:<br />
    Discount_Product: <input type="number" name="Special_Discount_Product" value="<%=CLng(0 & rs("Special_Discount_Product"))%>" />
    Discount_Spare: <input type="number" name="Special_Discount_Spare" value="<%=CLng(0 & rs("Special_Discount_Spare"))%>" />
    Discount_Mechanic: <input type="number" name="Special_Discount_Mechanic" value="<%=CLng(0 & rs("Special_Discount_Mechanic"))%>" /><br /><br />

    Increasing_Product: <input type="number" name="Special_Increasing_Product" value="<%=CLng(0 & rs("Special_Increasing_Product"))%>" />
    Increasing_Spare: <input type="number" name="Special_Increasing_Spare" value="<%=CLng(0 & rs("Special_Increasing_Spare"))%>" />
    Increasing_Mechanic: <input type="number" name="Special_Increasing_Mechanic" value="<%=CLng(0 & rs("Special_Increasing_Mechanic"))%>" /><br /><br />

    Açıklama (Description):<br />
    <textarea name="Description" rows="3" cols="60"><%=Server.HTMLEncode("" & rs("Description"))%></textarea><br /><br />

    <input type="submit" value="Güncelle" />
    <input type="button" value="Geri" onclick="location.href='uyeler.asp';" />
  </form>
</body>
</html>

<%
rs.Close : Set rs = Nothing
%>