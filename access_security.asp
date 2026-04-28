<%
' *** Restrict Access To Page: Grant or deny access to this page
MM_authorizedUsers=""
MM_authFailedURL="../admin/login.asp"
MM_grantAccess=false
If Session("MM_Username") <> "" Then
  If  Session("MM_UserAuthorization")=1 Then
    MM_grantAccess = true
  else
  	MM_authFailedURL="../admin/login.asp?err=5"
  End If
else
	MM_authFailedURL="../admin/login.asp"
End If
If Not MM_grantAccess Then
  Session("last_visited_page") = Request.ServerVariables("URL")
  Response.Redirect(MM_authFailedURL)
End If
%>
﻿<%
' *** Restrict Access To Page: Grant or deny access to this page
MM_authorizedUsers=""
MM_authFailedURL="../admin/login.asp"
MM_grantAccess=false
If Session("MM_Username") <> "" Then
  If  Session("MM_UserAuthorization")=1 Then
    MM_grantAccess = true
  else
  	MM_authFailedURL="../admin/login.asp?err=5"
  End If
else
	MM_authFailedURL="../admin/login.asp"
End If
If Not MM_grantAccess Then
  Session("last_visited_page") = Request.ServerVariables("URL")
  Response.Redirect(MM_authFailedURL)
End If
%>
