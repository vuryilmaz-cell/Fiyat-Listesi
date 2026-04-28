<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../ick/Connections/fiyat.asp" -->
<% dim form_name
if(Request.QueryString("form_name")<>"") then
	form_name = Request.QueryString("form_name")
end if
%>
<% if(Request.QueryString("ana_grup_id") <> "") then
	dim ana_grup_id
	ana_grup_id = Request.QueryString("ana_grup_id")
	end if

%>
<%
Dim alt_katagori
Dim alt_katagori_cmd
Dim alt_katagori_numRows

Set alt_katagori_cmd = Server.CreateObject ("ADODB.Command")
alt_katagori_cmd.ActiveConnection = MM_stok_STRING
alt_katagori_cmd.CommandText = "SELECT * FROM alt_grup WHERE ana_grup_id="&ana_grup_id&"" 
alt_katagori_cmd.Prepared = true

Set alt_katagori = alt_katagori_cmd.Execute
alt_katagori_numRows = 0
%>


<%
Dim Repeat5__numRows
Dim Repeat5__index

Repeat5__numRows = -1
Repeat5__index = 0
alt_katagori_numRows = alt_katagori_numRows + Repeat5__numRows
%>

<% if (form_name ="edit_menu") then %> 
	<select name="alt_grup_id" id="alt_grup_id" onchange="ajaxcommand(this)" size="<% =(alt_katagori.Fields.Count) %>" class="required" >
<% else %>
	<select name="alt_grup_id" id="alt_grup_id" class="required" >
	<option value="">Seçiniz</option>
<% end if %>
	  
	  <% 
While ((Repeat5__numRows <> 0) AND (NOT alt_katagori.EOF)) 
%>
 
    <% if (form_name ="edit_menu") then %>    
    <option value="<%=(alt_katagori.Fields.Item("ID").Value)%>"><%=(alt_katagori.Fields.Item("siralama").Value)%>&nbsp;>>&nbsp;<%=(alt_katagori.Fields.Item("alt_grup_adi").Value)%></option>
    <% else %>
    <option value="<%=(alt_katagori.Fields.Item("ID").Value)%>"><%=(alt_katagori.Fields.Item("alt_grup_adi").Value)%></option>
  
  	<% end if %>
  <% 
  Repeat5__index=Repeat5__index+1
  Repeat5__numRows=Repeat5__numRows-1
  alt_katagori.MoveNext()
Wend
%>
</select>