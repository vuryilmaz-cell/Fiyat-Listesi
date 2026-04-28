<%
' *** Restrict Access To Page: Grant or deny access to this page
MM_authorizedUsers=""
MM_authFailedURL="../../fiyat/admin/login.asp?err=4"
MM_grantAccess=false
If Session("MM_Username") <> "" Then
   If (Not CStr(Session("MM_UserAuthorization"))="") or (Not CStr(Session("MM_Username"))="") Then
    MM_grantAccess = true
  End If
End If
If Not MM_grantAccess Then
  'Session("last_visited_page") = Request.ServerVariables("URL")&"?"&Request.ServerVariables("QUERY_STRING")
  'Session("last_visited_page") = getURL
  Response.Redirect(MM_authFailedURL)
End If
%>

<%

    Function getURL()
        Dim sTemp
        sTemp = Request.Querystring
        ' the next line removes the HTTP status code that IIS sends, in the form "404;" or "403;" or whatever, depending on the captured error
        'sTemp = Right(sTemp, len(sTemp) - 4)
        ' the next two lines remove both types of server names that IIS includes in the querystring
        sTemp = replace(sTemp, "http://" & Request.ServerVariables("HTTP_HOST") & ":80/", "")
        sTemp = replace(sTemp, "http://" & Request.ServerVariables("HTTP_HOST") & "/", "")
        sTemp = replace(sTemp, "https://" & Request.ServerVariables("HTTP_HOST") & "/", "")
        sTemp = replace(sTemp, "https://" & Request.ServerVariables("HTTP_HOST") & ":443/", "")
        ' the next bit of code will force our array to have at least 1 element
        getURL = sTemp
    End Function

%>