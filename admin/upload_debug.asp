<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.CharSet = "utf-8"
Response.ContentType = "application/json"

' Form ile küçük veri okuyabiliyor muyuz test et
Dim testVal : testVal = Request.Form("test")
Dim totalBytes : totalBytes = Request.TotalBytes
Dim contentLen : contentLen = Request.ServerVariables("CONTENT_LENGTH")

Response.Write "{""totalBytes"":" & totalBytes
Response.Write ",""contentLength"":""" & contentLen & """"
Response.Write ",""testVal"":""" & testVal & """"
Response.Write ",""formCount"":" & Request.Form.Count
Response.Write "}"
%>
