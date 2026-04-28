<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.Charset="utf-8"

' no-cache
Response.Expires = -1
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.AddHeader "Cache-Control", "no-store, no-cache, must-revalidate, max-age=0"
%>

<%
' Impersonation aktif değilse direkt listeye dön
If Session("IMPERSONATE_ACTIVE") <> True Then
  Response.Redirect("uyeler.asp")
End If

' Admin oturumunu geri yükle
Session("MM_Username") = Session("IMPERSONATE_ADMIN_MM_Username")
Session("MM_UserAuthorization") = Session("IMPERSONATE_ADMIN_MM_UserAuthorization")

' Opsiyonel: son ziyaret edilen sayfayı geri koy
Session("last_visited_page") = Session("IMPERSONATE_ADMIN_last_visited_page")

' Temizle
Session("IMPERSONATE_ACTIVE") = False
Session("IMPERSONATE_ADMIN_MM_Username") = ""
Session("IMPERSONATE_ADMIN_MM_UserAuthorization") = ""
Session("IMPERSONATE_ADMIN_last_visited_page") = ""
Session("IMPERSONATE_AS_USERNAME") = ""
Session("IMPERSONATE_AS_USER_ID") = ""

' Admin sayfasına geri dön
Response.Redirect("uyeler.asp")
%>