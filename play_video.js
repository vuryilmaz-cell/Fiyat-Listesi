var img_div = document.getElementById("my_video_img");
var my_banner_timer;
var my_banner_width;
var my_banner_height;
var _counter = 0;
var y_pos = 0;
var my_banner_slide;



function centra(obj)
 {
    obj.style.top = parseInt((WindowHeight() / 2) + getScrollY())   + "px";
    obj.style.left = parseInt((WindowWidth() / 2) + getScrollX())  + "px";
 }


function WindowHeight() {
  var myHeight = 0;
  if( typeof( window.innerWidth ) == 'number' ) {
    //Non-IE
    myHeight = window.innerHeight;
  } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
    //IE 6+ in 'standards compliant mode'
    myHeight = document.documentElement.clientHeight;
  } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
    //IE 4 compatible
    myHeight = document.body.clientHeight;
  }
  return myHeight;
}
function WindowWidth() {
  var myWidth = 0;
  if( typeof( window.innerWidth ) == 'number' ) {
    //Non-IE
    myWidth = window.innerWidth;
  } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
    //IE 6+ in 'standards compliant mode'
    myWidth = document.documentElement.clientWidth;
  } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
    //IE 4 compatible
    myWidth = document.body.clientWidth;
  }
  return myWidth;
}
function getScrollY() {
  var scrOfY = 0;
  if( typeof( window.pageYOffset ) == 'number' ) {
    //Netscape compliant
    scrOfY = window.pageYOffset;
  } else if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) {
    //DOM compliant
    scrOfY = document.body.scrollTop;
  } else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) {
    //IE6 standards compliant mode
    scrOfY = document.documentElement.scrollTop;
  }
  return scrOfY;
}
 
function getScrollX() {
  var scrOfX = 0;
  if( typeof( window.pageYOffset ) == 'number' ) {
    //Netscape compliant
    scrOfX = window.pageXOffset;
  } else if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) {
    //DOM compliant
    scrOfX = document.body.scrollLeft;
  } else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) {
    //IE6 standards compliant mode
    scrOfX = document.documentElement.scrollLeft;
  }
  return scrOfX;
}







document.addEventListener("scroll", video_scroll_event, true);
//document.attachEvent("scroll", video_scroll_event);



function video_scroll_event(e)
{
	
	var y_pos = getScrollY();
	
	if(document.getElementById("my_video"))
	{
		document.getElementById("my_video").style.top =y_pos+"px";
		document.getElementById("my_video_container").style.top =y_pos+"px";
			//check_object();
			close_icon_action("show");
	}
}


function close_icon_action(action)
{

	var my_video = document.getElementById("my_video");
	var my_video_close = document.getElementById("my_video_close");

	if(my_video.style.display == "block" & action == "show")
	{
		my_video_close.style.top = parseInt(my_video.offsetTop)-10+"px";
		my_video_close.style.left = parseInt(my_video.offsetLeft)+parseInt(my_video.style.width)-10+"px";
		my_video_close.style.display="block";
	}
	
	else if(action=="hide")
	{
		my_video_close.style.display="none";
	}
}







function my_video_hide()
{
	var my_video = document.getElementById("my_video");
	var my_video_container = document.getElementById("my_video_container");
	my_video_container.style.backgroundColor= "rgb(255,255,255)";	
	my_video_container.style.opacity=0;
	my_video.style.marginLeft =0+"px";
	my_video.style.marginTop =0+"px";
	document.getElementById("my_video_img").innerHTML = "";
	document.getElementById("my_video_container").style.display="none";
	document.getElementById("my_video").style.display="none";
	close_icon_action("hide");
	
}






function set_top_cat()
{


	
}










function set_my_video()
{
	var my_video = document.getElementById("my_video");
	var mb_div_width = my_video.style.width;
	var mb_div_height = my_video.style.height;
	my_video.style.marginLeft = (WindowWidth()-mb_div_width.split("px")[0])/2+"px";		
	my_video.style.marginTop=(WindowHeight()-mb_div_height.split("px")[0])/2+"px";
	document.getElementById("my_video_container").style.width = WindowWidth()+"px";
	document.getElementById("my_video_container").style.height = WindowHeight()+"px";  
	
	close_icon_action("show");

}




function play_video(target_url,video_width, video_height, object_type, object_value)
{
		
		
		clearInterval(my_banner_height);
		clearInterval(my_banner_width);	
		clearInterval(my_banner_slide);
		clearInterval(my_banner_timer);
			
		document.getElementById("my_video_img").innerHTML = "";
		close_icon_action("hide");
		var my_video_container = document.getElementById("my_video_container");
		var my_video = document.getElementById("my_video");
			my_video.style.width= 80+"px";
			my_video.style.height=80+"px";
		var my_video_top = document.getElementById("my_video_top");
			my_video_top.style.width=60+"px"
			my_video_top.style.height=10+"px"			
		var my_video_lshd = document.getElementById("my_video_lshd");
			my_video_lshd.style.height= 60+"px"
			my_video_lshd.style.width= 10+"px"
		var my_video_rshd = document.getElementById("my_video_rshd");
			my_video_rshd.style.width=10+"px"
			my_video_rshd.style.height= 60+"px"			
		var my_video_img = document.getElementById("my_video_img");
			my_video_img.style.width = 60+"px";
			my_video_img.style.height = 60+"px";
		var my_video_bottom = document.getElementById("my_video_bottom");
			my_video_bottom.style.width =60+"px";
			my_video_bottom.style.height =10+"px";
	
		//my_video_container.style.height = document.body.clientHeight+10+"px";
		my_video_container.style.height = WindowHeight()-17+"px";
		my_video_container.style.width = WindowWidth()-17+"px"
		my_video_container.style.display = "block";
		my_video.style.display = "block";
		my_video.style.marginLeft = (WindowWidth()-80)/2+"px";
		my_banner_timer = setInterval(function(){ change_container_opicity(target_url,video_width, video_height, object_type, object_value)},10);	
 	
 }
 

function change_container_opicity(target_url,video_width, video_height, object_type, object_value)
{		
	
	var my_video_container = document.getElementById("my_video_container");
	var my_video = document.getElementById("my_video");
	
	
	_counter =_counter+1;
	
	
	if(typeof my_video_container.style.opacity != 'undefined')
	{
		if(my_video_container.style.opacity<0.8)
		{
			my_video_container.style.backgroundColor = "rgb("+(255-_counter*20)+","+(255-_counter*20)+","+(255-_counter*20)+")";
			my_video_container.style.opacity=_counter*0.10;
		}	
	}
	
	else
		{
			my_video_container.style.backgroundColor = "rgb("+(255-_counter*20)+","+(255-_counter*20)+","+(255-_counter*20)+")";
			my_video_container.style.filter= "alpha(opacity="+_counter*10+")"; 
		
		}
	
	
	if (_counter ==8)
	{
		clearInterval(my_banner_timer);
		
		var my_loadimg_div = document.createElement("div");
		my_loadimg_div.setAttribute("id","loadimg_div");
		my_loadimg_div.setAttribute("style","position:relative; width:32px; height:32px; display:none");		
		var my_loader_img = document.createElement("img");
		my_loader_img.setAttribute("src","../../ick/images/imLoad.gif");
		my_loader_img.setAttribute("width","32");
		my_loader_img.setAttribute("height","32");
		my_loader_img.setAttribute("height","32");
		my_loadimg_div.appendChild(my_loader_img);	
		document.getElementById("my_video_img").appendChild(my_loadimg_div);
		var loadimg_div = document.getElementById("loadimg_div");
		loadimg_div.style.marginLeft = (my_video_img.style.width.split("px")[0]-32)/2+"px";
		loadimg_div.style.marginTop = (my_video_img.style.height.split("px")[0]-32)/2+"px";	
		loadimg_div.style.display="block"; 
		
		my_banner_slide = setInterval(function (){my_bannerdiv_slide_down(target_url, video_width, video_height, object_type, object_value)},10);
		_counter =0;
	
	}
}


function my_bannerdiv_slide_down(target_url, video_width, video_height, object_type, object_value)
{
	y_pos = y_pos+1;
	var my_video = document.getElementById("my_video");
	my_video.style.marginTop=(WindowHeight()- (video_height)/y_pos*1)/2+"px";	
	 
	 
	if (y_pos == 8)
	{
		clearInterval(my_banner_slide);
		my_banner_width = setInterval(function (){my_bannerdiv_open_width(target_url, video_width, video_height, object_type, object_value)},3);
		y_pos =0;
	}

}

function my_bannerdiv_open_width(target_url, video_width, video_height, object_type, object_value)
{
	
	if(object_type!="mail_form")
	{
		if(video_height > WindowHeight()-60)
		{
			video_width = video_width*(WindowHeight()/video_height);
			video_width = video_width*0.8; 
			video_height = WindowHeight()*0.8;
		}
	}
	
	var my_video = document.getElementById("my_video");
	var my_video_top = document.getElementById("my_video_top");
	var my_video_bottom = document.getElementById("my_video_bottom");
	var my_video_img = document.getElementById("my_video_img");
	my_video.style.width = parseInt(my_video.style.width)+20+"px";
	my_video_top.style.width = parseInt(my_video_top.style.width)+20+"px";
	my_video_bottom.style.width = parseInt(my_video_bottom.style.width)+20+"px";
	my_video_img.style.width  = parseInt(my_video_img.style.width)+20+"px";
	var loadimg_div = document.getElementById("loadimg_div");
	loadimg_div.style.marginLeft = (my_video.style.width.split("px")[0]-32)/2+"px";
	
	set_my_video();	
	
	if( parseInt(my_video.style.width) -20 >= video_width)
	{
		clearInterval(my_banner_width);		
		my_banner_height = setInterval(function() {my_bannerdiv_open_height(target_url, video_width, video_height, object_type, object_value)},3);	
	}
}
		
function my_bannerdiv_open_height(target_url, video_width, video_height, object_type, object_value)
{
	
	
	var my_video = document.getElementById("my_video");
	var my_video_lshd = document.getElementById("my_video_lshd");
	var my_video_rshd = document.getElementById("my_video_rshd");
	var my_video_img = document.getElementById("my_video_img");
	
	my_video.style.height = parseInt(my_video.style.height)+20+"px";
	my_video_lshd.style.height = parseInt(my_video_lshd.style.height)+20+"px";
	my_video_rshd.style.height = parseInt(my_video_rshd.style.height)+20+"px";
	my_video_img.style.height  = parseInt(my_video_img.style.height)+20+"px";
	

	var loadimg_div = document.getElementById("loadimg_div");
	loadimg_div.style.marginTop = (my_video.style.height.split("px")[0]-32)/2+"px";
	set_my_video();		
	
	if( parseInt(my_video.style.height)-20 >=video_height)
	{
		
		clearInterval(my_banner_height);			
	
		if (object_type == "mail_form")
		{
			get_html_element(target_url, video_width, video_height, object_type, object_value);
		}
		
	}

}
		





function get_html_element(target_url, video_width, video_height, object_type, object_value)
{
	


	
	if(target_url=="edit_div")
	{

		if(object_value!="")
		{
		
			if(document.getElementById("edit_div") != null)
			{
	
				document.getElementById("active_id").innerHTML = object_value.id;
			}
		
		}
	}
	
	
	if(target_url=="detaylar")
	{

		if(object_value!="")
		{
		
			if(document.getElementById("detaylar") != null)
			{
	
				document.getElementById("active_id").innerHTML = object_value;
			}
		
		}
	}
	
	
	
		if(target_url=="reserved_div")
	{

		if(object_value!="")
		{
		
			if(document.getElementById("reserved_div") != null)
			{
	
				document.getElementById("active_id").innerHTML = object_value.id;
			}
		
		}
	}
	
	
			if(target_url=="shipped_div")
	{

		if(object_value!="")
		{
		
			if(document.getElementById("shipped_div") != null)
			{
	
				document.getElementById("active_id").innerHTML = object_value.id;
			}
		
		}
	}
	
	
	
	if(trim(target_url)!="")
	{
		var my_video_img = document.getElementById("my_video_img");
		var my_form_div = document.getElementById(target_url);
		my_video_img.innerHTML = my_form_div.innerHTML;
	}
	
	if(document.getElementById("temporary_div"))
	{
		document.getElementById("temporary_div").innerHTML ="";
	}
	//alert(document.getElementById("my_video_img").innerHTML);
}








function kurumsal_img_border_a(active_div)
{
	
	active_div.style.cursor="pointer";
	active_div.style.borderColor="#09C";
}

function kurumsal_img_border_h(active_div)
{
	active_div.style.borderColor="#CCC";
}

function show_nav(nav_type)
{

	nav_type.style.cursor ="pointer"
}



function hide_nav(nav_type)
{
	nav_type.style.cursor ="auto"
}
