<%
Option Explicit
Response.Charset = "utf-8"

Dim MM_authorizedUsers, MM_authFailedURL, MM_grantAccess
MM_authorizedUsers = "1"
MM_authFailedURL = "../login.asp?err=5"
MM_grantAccess = False
%>

<!--#include file="../access_security.asp" -->
<!--#include file="../Connections/uyeler.asp" -->

<%

Dim id
id = CLng(0 & Request.Form("id"))

' güvenlik: kendi hesabını silmesin
If id = CLng(0 & Session("MM_UserID")) Then
    Response.Write "Kendi hesabınızı silemezsiniz."
    Response.End
End If


Dim conn
Set conn = Server.CreateObject("ADODB.Connection")
conn.Open MM_stok_STRING


Dim cmd
Set cmd = Server.CreateObject("ADODB.Command")

cmd.ActiveConnection = conn
cmd.CommandType = 1
cmd.CommandText = "DELETE FROM tblUsersCor_Personel WHERE id=?"

cmd.Parameters.Append cmd.CreateParameter("@id",3,1,,id)

cmd.Execute


conn.Close
Set conn = Nothing


Response.Redirect "uyeler.asp"

%>