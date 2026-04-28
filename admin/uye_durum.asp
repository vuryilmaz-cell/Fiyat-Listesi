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
Dim id, action
id = CLng(0 & Request.Form("id"))
action = LCase(Trim(Request.Form("action")))

Dim allowBool, activeBool

Select Case action
  Case "aktif"
    activeBool = True
    ' allow aynen kalsın
    allowBool = Null
  Case "pasif"
    activeBool = False
    allowBool = False
  Case "allow_on"
    allowBool = True
    activeBool = Null
  Case "allow_off"
    allowBool = False
    activeBool = Null
  Case Else
    Response.Write "Geçersiz işlem."
    Response.End
End Select

Dim conn : Set conn = Server.CreateObject("ADODB.Connection")
conn.Open MM_stok_STRING

Dim cmd : Set cmd = Server.CreateObject("ADODB.Command")
cmd.ActiveConnection = conn
cmd.CommandType = 1

If IsNull(activeBool) Then
  cmd.CommandText = "UPDATE tblUsersCor_Personel SET allow=? WHERE id=?"
  cmd.Parameters.Append cmd.CreateParameter("@a", 11, 1, , allowBool)
  cmd.Parameters.Append cmd.CreateParameter("@id",3,  1, , id)
ElseIf IsNull(allowBool) Then
  cmd.CommandText = "UPDATE tblUsersCor_Personel SET active_passive=? WHERE id=?"
  cmd.Parameters.Append cmd.CreateParameter("@ap",11, 1, , activeBool)
  cmd.Parameters.Append cmd.CreateParameter("@id",3,  1, , id)
Else
  cmd.CommandText = "UPDATE tblUsersCor_Personel SET allow=?, active_passive=? WHERE id=?"
  cmd.Parameters.Append cmd.CreateParameter("@a", 11, 1, , allowBool)
  cmd.Parameters.Append cmd.CreateParameter("@ap",11, 1, , activeBool)
  cmd.Parameters.Append cmd.CreateParameter("@id",3,  1, , id)
End If

cmd.Execute

conn.Close : Set conn = Nothing
Response.Redirect "uyeler.asp"
%>