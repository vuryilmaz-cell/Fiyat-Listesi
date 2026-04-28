// JavaScript Document
var xmlHttp;
var target_area;
var url;
var xmlHttp;

// Validates that the input string is a valid date formatted as "mm/dd/yyyy"


function compare(dateTimeA, dateTimeB) {
    var momentA = moment(dateTimeA,"DD.MM.YYYY");
    var momentB = moment(dateTimeB,"DD.MM.YYYY");
    if (momentA > momentB) return 1;
    else if (momentA < momentB) return -1;
    else return 0;
}



function check_form(target)
{
var alert_flag = 0;	
var alert_text ="";
var required_form = document.getElementById(target.name);
var alert_div ;
var security_code =0;

		

	for (var i =0; i<required_form.length-1; i++)
	{
		
		alert_div = document.getElementById(required_form.elements[i].id+"_alert");
		
		
		
		if(required_form.elements[i].getAttribute("class")=="required")
		{
			
	
		
			if((trim(required_form.elements[i].value) == ""))
			{
				alert_div.innerHTML ="!";
				alert_text ="''!''ile işaretli alanları boş bırakmayınız.";
				alert_flag = 1;
			}
			
			
			else
			{
				alert_div.innerHTML ="";
			}
		
		}
		
		else if(required_form.elements[i].getAttribute("class")=="must_be_number")
		{
	
				if(isNaN(required_form.elements[i].value))
				{
					alert_div.innerHTML ="!";
					alert_text = alert_text + "İç Ölçüler, Dış Ölçüler, Taşıma Adetleri, Ağırlık bilgilerinin sayısal değerler kullanılarak girildiğinden ve nokta-virgül içermediğinden emin olunuz. ";
					alert_flag = 1;

				}
				else
				{
					alert_div.innerHTML ="";
				}
			

		}
		
		else if(required_form.elements[i].getAttribute("class")=="must_be_date")
		{
	
				if((trim(required_form.elements[i].value) == ""))
			{
				alert_div.innerHTML ="!";
				alert_text ="''!''ile işaretli alanları boş bırakmayınız.";
				alert_flag = 1;
			}
				
				
				else if(required_form.elements[i].value)
				{
					
					
					
					var str = required_form.elements[i].value;
					var res = str.replace(".","_");
					var res2 = res.replace(".","_");
					required_form.elements[i].value = res2;


				}
				
				else
				{
					alert_div.innerHTML ="";
				}
		
		
		
			

		}
		
		
		
		else if(required_form.elements[i].getAttribute("class")=="must_be_regular_date")
		{
	
			if((trim(required_form.elements[i].value) == ""))
			{
	
			}
				
				
			else if(required_form.elements[i].value)
			{
					
				
				var date_input = required_form.elements[i].value;

				
				
				
				if (moment(date_input, 'D/M/YYYY',true).isValid())
				{
						
				}
						
				else
				{
					alert_div.innerHTML ="!";
					alert_text ="Hatalı tarih formatı";
					alert_flag = 1;
				}

			}
				
			else
			{
				alert_div.innerHTML ="";
			}
		
		
		
			

		}
		
		
		else
		{
			
		}
		
		
		
	
	
	}
	
	
	if (alert_flag!=0)
	{

		alert(alert_text);
	}
	else
	{
	
	 if(required_form.name=="update_form")
		{
			var yanitt = confirm("Yapmış olduğunuz değişiklikleri kalıcı olarak kaydedilecektir?") 
				
			if(yanitt)
			{

				
				target.submit();
			}
		}
	
		else
		{
			target.submit();
		}
	}

}


















