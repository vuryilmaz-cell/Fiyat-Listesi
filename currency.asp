
<%
    Function VeriAl(strGelen)  
        Set objVeriAl = Server.CreateObject("MSXML2.ServerXMLHTTP")
		'Set objVeriAl = Server.CreateObject("Microsoft.XMLHTTP" )  
        objVeriAl.Open "GET" , strGelen, FALSE
        objVeriAl.sEnd  
        VeriAl = objVeriAl.Responsetext  
        SET objVeriAl = Nothing
    End Function 
 
    strAdres = "https://www.tcmb.gov.tr/kurlar/today.xml"  
    strVeri = VeriAL(strAdres)  
    
	iDolar=InStr(strVeri,"<CurrencyName>US DOLLAR</CurrencyName>" )  
    strDolarAlis=Mid(strVeri,iDolar+56,6)
    'strDolarAlis = Replace(strDolarAlis, ".", ",")
	strDolarSatis=Mid(strVeri,iDolar+96,6)
	'strDolarSatis = Replace(strDolarSatis, ".", ",")
 
    iEuro=InStr(strVeri,"<CurrencyName>EURO</CurrencyName>" ) 
 
    strEuroAlis=Mid(strVeri,iEuro+51,6) 'alis
	'strEuroAlis = Replace(strEuroAlis, ".", ",")
	
    strEuroSatis=Mid(strVeri,iEuro+91,6) 'satis
	'strEuroSatis=Replace(strEuroSatis, ".", ",") 'satis
	EurUsdPrty = strDolarSatis / strEuroSatis   

%>