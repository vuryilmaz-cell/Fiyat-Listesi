<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
' *** Logout the current user.
MM_logoutRedirectPage = "default.asp"
Session.Contents.Remove("MM_Username")
Session.Contents.Remove("MM_UserAuthorization")
Session.Contents.Remove("MM_Name")

Session.Contents.Remove("MM_Username")
Session.Contents.Remove("MM_UserAuthorization")
Session.Contents.Remove("MM_Name")

Session("IMPERSONATE_ACTIVE") = False
Session("IMPERSONATE_ADMIN_MM_Username") = ""
Session("IMPERSONATE_ADMIN_MM_UserAuthorization") = ""
Session("IMPERSONATE_ADMIN_last_visited_page") = ""
Session("IMPERSONATE_AS_USERNAME") = ""
Session("IMPERSONATE_AS_USER_ID") = ""

If (MM_logoutRedirectPage <> "") Then Response.Redirect(MM_logoutRedirectPage)
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Fiyat Listesi</title>
</head>

<body>
</body>
</html>
