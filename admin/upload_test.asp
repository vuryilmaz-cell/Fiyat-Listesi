<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html>
<html lang="tr">
<head>
<meta charset="utf-8"/>
<title>Upload Bileşen Testi</title>
<style>
  body{font-family:Arial,sans-serif;padding:30px;background:#f0f2f5}
  .card{background:#fff;border-radius:8px;padding:20px;margin-bottom:16px;box-shadow:0 1px 4px rgba(0,0,0,.1)}
  .ok{color:#27ae60;font-weight:700} .err{color:#e74c3c;font-weight:700}
  h2{margin:0 0 16px;font-size:15px;color:#2c3e50}
  table{border-collapse:collapse;width:100%;font-size:13px}
  td,th{padding:7px 12px;border:1px solid #eee;text-align:left}
  th{background:#ecf0f1;font-weight:600}
</style>
</head>
<body>

<h1 style="font-size:18px;color:#2c3e50;margin-bottom:20px">🔍 Sunucu Upload Bileşen Testi</h1>

<%
Sub TestComponent(name, progID)
  On Error Resume Next
  Dim obj : Set obj = Server.CreateObject(progID)
  If Err.Number = 0 Then
    Response.Write "<tr><td><strong>" & name & "</strong></td><td><code>" & progID & "</code></td><td class='ok'>✅ MEVCUT</td></tr>"
    Set obj = Nothing
  Else
    Response.Write "<tr><td><strong>" & name & "</strong></td><td><code>" & progID & "</code></td><td class='err'>❌ Yok (" & Err.Number & ")</td></tr>"
  End If
  Err.Clear
  On Error GoTo 0
End Sub
%>

<div class="card">
  <h2>📦 Upload Bileşenleri</h2>
  <table>
    <tr><th>Bileşen</th><th>ProgID</th><th>Durum</th></tr>
    <% TestComponent "Persits AspUpload",    "Persits.Upload" %>
    <% TestComponent "Persits AspUpload 3",  "Persits.Upload.3" %>
    <% TestComponent "SA-FileUp",            "SoftArtisans.FileUp" %>
    <% TestComponent "SA-FileUp SE",         "SoftArtisans.FileUpSE" %>
    <% TestComponent "W3 Total Upload",      "W3.Upload" %>
    <% TestComponent "ABCUpload",            "ABCUpload4.FileUpload" %>
    <% TestComponent "AspSmartUpload",       "AspSmartUpload.SmartUpload" %>
    <% TestComponent "ADODB.Stream",         "ADODB.Stream" %>
    <% TestComponent "Scripting.FSO",        "Scripting.FileSystemObject" %>
    <% TestComponent "MSXML2.XMLHTTP",       "MSXML2.ServerXMLHTTP" %>
  </table>
</div>

<div class="card">
  <h2>🖥️ Sunucu Bilgisi</h2>
  <table>
    <tr><th>Bilgi</th><th>Değer</th></tr>
    <tr><td>Sunucu Yazılımı</td><td><%=Request.ServerVariables("SERVER_SOFTWARE")%></td></tr>
    <tr><td>Script Engine</td><td><%=ScriptEngine & " " & ScriptEngineMajorVersion & "." & ScriptEngineMinorVersion%></td></tr>
    <tr><td>Max Request (bytes)</td><td><%=Response.Write("")%><%
      On Error Resume Next
      Dim cfg : Set cfg = GetObject("IIS://Localhost/W3SVC/1")
      If Err.Number=0 Then Response.Write cfg.AspMaxRequestEntityAllowed Else Response.Write "N/A"
      On Error GoTo 0
    %></td></tr>
    <tr><td>Temp Klasörü</td><td><%=Server.MapPath(".")%></td></tr>
  </table>
</div>

<div class="card" style="background:#fff8e1;border:1px solid #ffe082">
  <h2>📋 Sonuca Göre Yapılacak</h2>
  <ul style="font-size:13px;line-height:1.9;margin:0;padding-left:18px">
    <li><strong>Persits AspUpload ✅</strong> → En kolay yöntem, tek satırla upload</li>
    <li><strong>ADODB.Stream ✅ + FSO ✅</strong> → Pure ASP binary parse (hazırladığım <code>upload_gorsel.asp</code> çalışır)</li>
    <li><strong>Hiçbiri ✅ değil</strong> → Sunucuya bileşen kurulması gerekiyor</li>
  </ul>
</div>

</body>
</html>
