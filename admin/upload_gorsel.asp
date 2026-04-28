<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../Connections/fiyat2.asp" -->
<!--#include file="../member_security.asp" -->
<%
Response.CharSet = "utf-8"
Response.ContentType = "application/json"

Dim yonetici, super_yonetici
super_yonetici = "1"
yonetici       = "2"
If Session("MM_UserAuthorization") <> yonetici And _
   Session("MM_UserAuthorization") <> super_yonetici Then
  Response.Write "{""ok"":false,""err"":""Yetkisiz erisim""}"
  Response.End
End If

On Error Resume Next

'================================================================
' JSON body'yi oku (Content-Type: application/json)
' MSXML2 ile raw stream okuma - BinaryRead kullanmaz
'================================================================
Dim jsonStr : jsonStr = ""

Dim stm : Set stm = Server.CreateObject("ADODB.Stream")
stm.Type = 2         ' text
stm.Charset = "utf-8"
stm.Open

' Gelen binary'yi text stream'e yaz
Dim binStm : Set binStm = Server.CreateObject("ADODB.Stream")
binStm.Type = 1      ' binary
binStm.Open
binStm.Write Request.BinaryRead(Request.TotalBytes)
binStm.Position = 0
binStm.CopyTo stm
binStm.Close : Set binStm = Nothing

stm.Position = 0
jsonStr = stm.ReadText
stm.Close : Set stm = Nothing

If Err.Number <> 0 Then
  Response.Write "{""ok"":false,""err"":""Stream okuma: " & Replace(Err.Description,"'","") & " (" & Err.Number & ")""}"
  Response.End
End If

'================================================================
' Basit JSON parse - sadece fileName ve fileData alanlarını çıkar
'================================================================
Function JsonGetString(json, key)
  Dim searchKey : searchKey = """" & key & """:"
  Dim pos : pos = InStr(json, searchKey)
  If pos = 0 Then JsonGetString = "" : Exit Function
  pos = pos + Len(searchKey)
  ' boşlukları atla
  Do While Mid(json, pos, 1) = " " : pos = pos + 1 : Loop
  ' açılış tırnağı
  If Mid(json, pos, 1) <> """" Then JsonGetString = "" : Exit Function
  pos = pos + 1
  Dim endPos : endPos = pos
  Do
    Dim ch : ch = Mid(json, endPos, 1)
    If ch = "\" Then
      endPos = endPos + 2  ' escape karakteri atla
    ElseIf ch = """" Then
      Exit Do
    Else
      endPos = endPos + 1
    End If
  Loop
  JsonGetString = Mid(json, pos, endPos - pos)
End Function

Dim fileName : fileName = JsonGetString(jsonStr, "fileName")
Dim fileData : fileData = JsonGetString(jsonStr, "fileData")

If fileName = "" Or fileData = "" Then
  Response.Write "{""ok"":false,""err"":""Veri eksik - jsonLen:" & Len(jsonStr) & ",file:" & fileName & ",dataLen:" & Len(fileData) & """}"
  Response.End
End If

' Uzantı kontrolü
Dim fileExt : fileExt = LCase(Mid(fileName, InStrRev(fileName, ".") + 1))
If fileExt <> "jpg" And fileExt <> "jpeg" And fileExt <> "png" And _
   fileExt <> "gif" And fileExt <> "webp" Then
  Response.Write "{""ok"":false,""err"":""Gecersiz dosya turu: ." & fileExt & """}"
  Response.End
End If

If Len(fileData) > 7000000 Then
  Response.Write "{""ok"":false,""err"":""Dosya cok buyuk (max 5 MB)""}"
  Response.End
End If

' Base64 decode
Dim xml : Set xml = CreateObject("MSXML2.DOMDocument.3.0")
Dim node : Set node = xml.createElement("b64")
node.dataType = "bin.base64"
node.text = fileData
Dim binData : binData = node.nodeTypedValue
Set node = Nothing : Set xml = Nothing

If Err.Number <> 0 Then
  Response.Write "{""ok"":false,""err"":""Base64 decode: " & Replace(Err.Description,"'","") & """}"
  Response.End
End If

' Benzersiz dosya adı
Dim newName : newName = "img_" & Year(Now) & Right("0"&Month(Now),2) & Right("0"&Day(Now),2) & _
                        Right("0"&Hour(Now),2) & Right("0"&Minute(Now),2) & Right("0"&Second(Now),2) & _
                        "_" & Int(Rnd()*9000+1000) & "." & fileExt

' Hedef klasör
Dim savePath : savePath = Server.MapPath("../fiyat/images/urunler/")

Dim fso : Set fso = Server.CreateObject("Scripting.FileSystemObject")
If Not fso.FolderExists(savePath) Then fso.CreateFolder(savePath)
Set fso = Nothing

' Kaydet
Dim outStm : Set outStm = Server.CreateObject("ADODB.Stream")
outStm.Type = 1
outStm.Open
outStm.Write binData
outStm.SaveToFile savePath & "\" & newName, 2
outStm.Close : Set outStm = Nothing

If Err.Number <> 0 Then
  Response.Write "{""ok"":false,""err"":""Kayit hatasi: " & Replace(Err.Description,"'","") & """}"
  Response.End
End If

Response.Write "{""ok"":true,""path"":""../../fiyat/images/urunler/" & newName & """}"
On Error GoTo 0
%>
