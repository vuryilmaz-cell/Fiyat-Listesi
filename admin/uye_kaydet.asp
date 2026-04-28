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

'--------------- yardımcı fonksiyon ---------------
Function ToLong(v, d)
  Dim s
  s = Trim("" & v)
  If Len(s)=0 Then
     ToLong = d
  ElseIf IsNumeric(s) Then
     ToLong = CLng(s)
  Else
     ToLong = d
  End If
End Function
'--------------------------------------------------

Dim mode,id
Dim username,password,User_Name,User_Surname,Company_Name,Description
Dim member_type,allowVal,activeVal,Default_Language
Dim Default_Currency
Dim SDP,SDS,SDM,SIP,SIS,SIM

mode = LCase(Request.Form("mode"))

username      = Trim(Request.Form("username"))
password      = Trim(Request.Form("password"))
User_Name     = Trim(Request.Form("User_Name"))
User_Surname  = Trim(Request.Form("User_Surname"))
Company_Name  = Trim(Request.Form("Company_Name"))
Description   = Trim(Request.Form("Description"))

member_type        = ToLong(Request.Form("member_type"),3)
allowVal           = ToLong(Request.Form("allow"),-1)
activeVal          = ToLong(Request.Form("active_passive"),-1)
Default_Language   = ToLong(Request.Form("Default_Language"),1)

Default_Currency   = Trim(Request.Form("Default_Currency"))

SDP = ToLong(Request.Form("Special_Discount_Product"),0)
SDS = ToLong(Request.Form("Special_Discount_Spare"),0)
SDM = ToLong(Request.Form("Special_Discount_Mechanic"),0)
SIP = ToLong(Request.Form("Special_Increasing_Product"),0)
SIS = ToLong(Request.Form("Special_Increasing_Spare"),0)
SIM = ToLong(Request.Form("Special_Increasing_Mechanic"),0)

If Len(username)=0 Then
 Response.Write "Kullanıcı adı boş."
 Response.End
End If

Dim conn
Set conn = Server.CreateObject("ADODB.Connection")
conn.Open MM_stok_STRING


Dim cmd
Set cmd = Server.CreateObject("ADODB.Command")
cmd.ActiveConnection = conn
cmd.CommandType = 1


'==================== INSERT ====================

If mode="create" Then

cmd.CommandText = "INSERT INTO tblUsersCor_Personel (" & _
"username,password,User_Name,User_Surname,Company_Name,Description," & _
"member_type,allow,active_passive,last_visit,total_visit," & _
"Special_Discount_Product,Default_Currency,Default_Language," & _
"Special_Discount_Spare,Special_Discount_Mechanic," & _
"Special_Increasing_Spare,Special_Increasing_Product,Special_Increasing_Mechanic)" & _
" VALUES (?,?,?,?,?,?,?,?,?,Now(),0,?,?,?,?,?,?,?,?)"


cmd.Parameters.Append cmd.CreateParameter("@p1",200,1,255,username)
cmd.Parameters.Append cmd.CreateParameter("@p2",200,1,255,password)
cmd.Parameters.Append cmd.CreateParameter("@p3",200,1,255,User_Name)
cmd.Parameters.Append cmd.CreateParameter("@p4",200,1,255,User_Surname)
cmd.Parameters.Append cmd.CreateParameter("@p5",200,1,255,Company_Name)
cmd.Parameters.Append cmd.CreateParameter("@p6",203,1,Len(Description)+1,Description)

cmd.Parameters.Append cmd.CreateParameter("@p7",3,1,,member_type)
cmd.Parameters.Append cmd.CreateParameter("@p8",11,1,,(allowVal<>0))
cmd.Parameters.Append cmd.CreateParameter("@p9",11,1,,(activeVal<>0))

cmd.Parameters.Append cmd.CreateParameter("@p10",3,1,,SDP)
cmd.Parameters.Append cmd.CreateParameter("@p11",200,1,20,Default_Currency)
cmd.Parameters.Append cmd.CreateParameter("@p12",3,1,,Default_Language)

cmd.Parameters.Append cmd.CreateParameter("@p13",3,1,,SDS)
cmd.Parameters.Append cmd.CreateParameter("@p14",3,1,,SDM)

cmd.Parameters.Append cmd.CreateParameter("@p15",3,1,,SIS)
cmd.Parameters.Append cmd.CreateParameter("@p16",3,1,,SIP)
cmd.Parameters.Append cmd.CreateParameter("@p17",3,1,,SIM)

cmd.Execute

End If


'==================== UPDATE ====================

If mode="update" Then

id = CLng(Request.Form("id"))

cmd.CommandText = "UPDATE tblUsersCor_Personel SET " & _
"username=?,User_Name=?,User_Surname=?,Company_Name=?,Description=?," & _
"member_type=?,allow=?,active_passive=?," & _
"Special_Discount_Product=?,Default_Currency=?,Default_Language=?," & _
"Special_Discount_Spare=?,Special_Discount_Mechanic=?," & _
"Special_Increasing_Spare=?,Special_Increasing_Product=?,Special_Increasing_Mechanic=? " & _
"WHERE id=?"

cmd.Parameters.Append cmd.CreateParameter("@p1",200,1,255,username)
cmd.Parameters.Append cmd.CreateParameter("@p2",200,1,255,User_Name)
cmd.Parameters.Append cmd.CreateParameter("@p3",200,1,255,User_Surname)
cmd.Parameters.Append cmd.CreateParameter("@p4",200,1,255,Company_Name)
cmd.Parameters.Append cmd.CreateParameter("@p5",203,1,Len(Description)+1,Description)

cmd.Parameters.Append cmd.CreateParameter("@p6",3,1,,member_type)
cmd.Parameters.Append cmd.CreateParameter("@p7",11,1,,(allowVal<>0))
cmd.Parameters.Append cmd.CreateParameter("@p8",11,1,,(activeVal<>0))

cmd.Parameters.Append cmd.CreateParameter("@p9",3,1,,SDP)
cmd.Parameters.Append cmd.CreateParameter("@p10",200,1,20,Default_Currency)
cmd.Parameters.Append cmd.CreateParameter("@p11",3,1,,Default_Language)

cmd.Parameters.Append cmd.CreateParameter("@p12",3,1,,SDS)
cmd.Parameters.Append cmd.CreateParameter("@p13",3,1,,SDM)

cmd.Parameters.Append cmd.CreateParameter("@p14",3,1,,SIS)
cmd.Parameters.Append cmd.CreateParameter("@p15",3,1,,SIP)
cmd.Parameters.Append cmd.CreateParameter("@p16",3,1,,SIM)

cmd.Parameters.Append cmd.CreateParameter("@p17",3,1,,id)

cmd.Execute

End If


conn.Close
Set conn = Nothing

Response.Redirect "uyeler.asp"

%>