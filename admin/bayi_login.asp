<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.Charset="utf-8"
%>

<!--#include file="../../fiyat/Connections/uyeler.asp" -->

<%
' Sadece admin (UserAuthorization=1) çalıştırabilsin
If Session("MM_Username") = "" Or CLng(0 & Session("MM_UserAuthorization")) <> 1 Then
  Response.Write("Yetkisiz işlem")
  Response.End
End If

Dim user_id
user_id = Trim(Request.Form("user_id"))
If user_id = "" Or Not IsNumeric(user_id) Then
  Response.Redirect("uyeler.asp")
End If

' Admin oturumunu yedekle (bir kere)
If Session("IMPERSONATE_ACTIVE") <> True Then
  Session("IMPERSONATE_ACTIVE") = True
  Session("IMPERSONATE_ADMIN_MM_Username") = Session("MM_Username")
  Session("IMPERSONATE_ADMIN_MM_UserAuthorization") = Session("MM_UserAuthorization")
  Session("IMPERSONATE_ADMIN_last_visited_page") = Session("last_visited_page")
End If

Dim rsI, sqlI
sqlI = "SELECT id, username, member_type, allow, active_passive " & _
       "FROM tblUsersCor_Personel WHERE id=" & CLng(user_id)

Set rsI = Server.CreateObject("ADODB.Recordset")
rsI.Open sqlI, MM_stok_STRING, 1, 1

If rsI.EOF Then
  rsI.Close : Set rsI = Nothing
  Response.Redirect("uyeler.asp")
End If

' Güvenlik: sadece bayi (member_type=5) impersonate edilsin
If CLng(0 & rsI("member_type")) <> 5 Then
  rsI.Close : Set rsI = Nothing
  Response.Write("Bu kullanıcı bayi değil.")
  Response.End
End If

' Pasif veya allow değilse geçiş yaptırma
If (Not CBool(rsI("allow"))) Or (Not CBool(rsI("active_passive"))) Then
  rsI.Close : Set rsI = Nothing
  Response.Write("Bu kullanıcı pasif veya izinli değil.")
  Response.End
End If

' Bayi hesabına geçir (login.asp’ye dokunmadan)
Session("MM_Username") = "" & rsI("username")
Session("MM_UserAuthorization") = "" & rsI("member_type")

' Banner için bilgi
Session("IMPERSONATE_AS_USERNAME") = "" & rsI("username")
Session("IMPERSONATE_AS_USER_ID") = rsI("id")

rsI.Close : Set rsI = Nothing

' Bayinin giriş yapınca gideceği sayfa
Response.Redirect("../default.asp")
%>