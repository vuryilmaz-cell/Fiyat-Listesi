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
    body{background:#f5f6f8;font-family:Arial,Helvetica,sans-serif;margin:0;padding:0;}
    .page{max-width:1100px;margin:40px auto;padding:0 16px;}
    .card{background:#fff;border:1px solid #e6e8ee;border-radius:10px;box-shadow:0 6px 24px rgba(0,0,0,.06);padding:18px;}
    .title{margin:0 0 14px 0;font-size:20px;color:#222;}
    .toolbar{display:flex;gap:10px;align-items:center;flex-wrap:wrap;margin-bottom:14px;}
    .toolbar input[type="text"]{height:36px;padding:0 10px;border:1px solid #d7dbe6;border-radius:8px;min-width:280px;}
    .btn{height:36px;padding:0 12px;border:1px solid #cfd5e3;border-radius:8px;background:#fff;cursor:pointer;}
    .btn-primary{border-color:#2f6fed;background:#2f6fed;color:#fff;}
    .btn:disabled{opacity:.45;cursor:not-allowed;}
    .table-wrap{overflow:auto;border:1px solid #e6e8ee;border-radius:10px;}
    table{width:100%;border-collapse:collapse;background:#fff;}
    th,td{padding:10px;border-bottom:1px solid #eef0f5;text-align:left;white-space:nowrap;font-size:13px;}
    th{background:#fafbfe;color:#333;font-weight:bold;}
    tr:hover td{background:#fbfcff;}
    .actions{display:flex;gap:8px;align-items:center;flex-wrap:wrap;}
    .actions a{color:#2f6fed;text-decoration:none;font-weight:bold;}
    .actions form{display:inline;margin:0;}
    .btn-danger{border-color:#e25555;background:#fff;color:#e25555;}
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

      <div class="page">
        <div class="card">
          <h2 class="title">BAYİ YÖNETİMİ</h2>

          <form method="get" action="uyeler.asp" class="toolbar">
            <input type="text" name="q" value="<%=Server.HTMLEncode(q)%>" placeholder="Ara: kullanıcı / ad / soyad / firma" />
            <input type="submit" class="btn" value="Ara" />
            <input type="button" class="btn btn-primary" value="Yeni Üye" onclick="location.href='uye_yeni.asp';" />
          </form>

          <div class="table-wrap">
            <table>
              <tr>
                <th>ID</th>
                <th>Kullanıcı</th>
                <th>Ad</th>
                <th>Soyad</th>
                <th>Firma</th>
                <th>Yetki</th>
                <th>Allow</th>
                <th>Active</th>
                <th>Kur</th>
                <th>Dil</th>
                <th>İşlem</th>
                <th>Bayi Olarak</th>
              </tr>

              <%
              Do Until rs.EOF
              %>
              <tr>
                <td><%=rs("id")%></td>
                <td><%=Server.HTMLEncode("" & rs("username"))%></td>
                <td><%=Server.HTMLEncode("" & rs("User_Name"))%></td>
                <td><%=Server.HTMLEncode("" & rs("User_Surname"))%></td>
                <td><%=Server.HTMLEncode("" & rs("Company_Name"))%></td>
                <td><%=RoleText(rs("member_type"))%></td>
                <td><%=YesNoText(rs("allow"))%></td>
                <td><%=YesNoText(rs("active_passive"))%></td>
                <td><%=Server.HTMLEncode("" & rs("Default_Currency"))%></td>
                <td><%=rs("Default_Language")%></td>

                <td>
                  <div class="actions">
                    <a href="uye_duzenle.asp?id=<%=rs("id")%>">Düzenle</a>

                    <form method="post" action="uye_durum.asp">
                      <input type="hidden" name="id" value="<%=rs("id")%>">
                      <input type="hidden" name="action" value="aktif">
                      <input type="submit" class="btn" value="Aktif" <% If CBool(rs("active_passive")) Then Response.Write("disabled") %> >
                    </form>

                    <form method="post" action="uye_durum.asp" onsubmit="return confirm('Kullanıcı pasif yapılsın mı?');">
                      <input type="hidden" name="id" value="<%=rs("id")%>">
                      <input type="hidden" name="action" value="pasif">
                      <input type="submit" class="btn" value="Pasif" <% If Not CBool(rs("active_passive")) Then Response.Write("disabled") %> >
                    </form>

                    <form method="post" action="uye_sil.asp" onsubmit="return confirm('Bu kullanıcı tamamen silinecek. Emin misiniz?');">
                      <input type="hidden" name="id" value="<%=rs("id")%>">
                      <input type="submit" class="btn btn-danger" value="Sil">
                    </form>
                  </div>
                </td>

                <td>
                  <% If CLng(0 & rs("member_type")) = 5 Then %>
                    <form method="post" action="bayi_login.asp" style="margin:0;">
                      <input type="hidden" name="user_id" value="<%=rs("id")%>">
                      <input type="submit" class="btn btn-primary" value="BAYİ OLARAK GİR">
                    </form>
                  <% Else %>
                    -
                  <% End If %>
                </td>

              </tr>
              <%
                rs.MoveNext
              Loop
              rs.Close : Set rs = Nothing
              %>

            </table>
          </div>

        </div>
      </div>

    </div>
    <div style="clear:both"></div>

  </div>
</div>

<div id="bottom_container_div"><!--#include file="../bottom_temp.html" --></div>
</body>
</html>