<div id="top_div">

  <div id="top_bar">
    <div id="top_logo">
      <img src="../../fiyat/images/logo.png" alt="Tunaylar"/>
    </div>
    <div id="top_site">www.tunaylar.com</div>
    <div id="top_lang">
      <i class="fa-solid fa-earth-europe"></i>
      <a href="default.asp?lng=1">TR</a>
      <span class="top_lang_sep">|</span>
      <a href="default.asp?lng=2">ENG</a>
    </div>
    <div id="top_title"><%
      if price_list_type = 1 then
        if language<>2 then Response.Write("Fiyat Listesi") else Response.Write("Price List") end if
      elseif price_list_type = 3 then
        if language<>2 then Response.Write("Bayi Fiyat Listesi &mdash; Ürünler") else Response.Write("Dealer Price List &mdash; Products") end if
      elseif price_list_type = 4 then
        if language<>2 then Response.Write("Bayi Fiyat Listesi &mdash; Yedek Parça") else Response.Write("Dealer Price List &mdash; Spare Parts") end if
      elseif price_list_type = 5 then
        if language<>2 then Response.Write("Bayi Fiyat Listesi &mdash; Mekanik") else Response.Write("Dealer Price List &mdash; Mechanic") end if
      end if
    %></div>
  </div>

  <div id="top_nav">

    <a href="#" class="nav_item" onclick="play_video('yardim','600','400','mail_form'); return false;">
      <i class="fa-solid fa-circle-question"></i>
      <span><%if language<>2 then Response.Write("Yardım") else Response.Write("Help") end if%></span>
    </a>

    <% if Session("MM_UserAuthorization") = 1 then %>
    <a href="../../fiyat/admin/Uyeler.asp" class="nav_item">
      <i class="fa-solid fa-users-gear"></i>
      <span><%if language<>2 then Response.Write("Bayi Yönetimi") else Response.Write("Dealer Mgmt") end if%></span>
    </a>
    <a href="../../fiyat/default.asp" class="nav_item">
      <i class="fa-solid fa-list-check"></i>
      <span><%if language<>2 then Response.Write("Fiyat Listesi") else Response.Write("Price List") end if%></span>
    </a>

      <a href="../../fiyat/admin/urun_listesi.asp" class="nav_item">
      <i class="fa-solid fa-list-check"></i>
      <span><%if language<>2 then Response.Write("Maliyet Listesi") else Response.Write("Cost List") end if%></span>
    </a>
    <% end if %>

    <div class="nav_spacer"></div>

    <div id="top_user">
      <% If Session("IMPERSONATE_ACTIVE") = True Then %>
        <div id="top_user_impersonate">
          <i class="fa fa-user-secret"></i>
          <span><b><%=Server.HTMLEncode("" & Session("IMPERSONATE_AS_USERNAME"))%></b> hesabı ile görüntülüyorsunuz</span>
          <a href="/fiyat/admin/admin_geri_don.asp" class="btn_geri_don">
            <i class="fa fa-arrow-left"></i>
            <%=Session("MM_Name")%> Hesabına Geri Dön
          </a>
          <%if Session("MM_Name") <>"" then%>
          <a href="../../fiyat/logout.asp" class="top_cikis">
            <i class="fa fa-right-from-bracket"></i>
            <%if language<>2 then Response.Write("Çıkış") else Response.Write("Log Out") end if%>
          </a>
          <%end if%>
        </div>
      <% Else %>
        <div id="top_user_normal">
          <i class="fa fa-user-circle"></i>
          <a href=""><%=Session("MM_Name")%></a>
          <%if Session("MM_Name") <>"" then%>
          <span class="top_user_sep"></span>
          <a href="../../fiyat/logout.asp" class="top_cikis">
            <%if language<>2 then Response.Write("Çıkış") else Response.Write("Log Out") end if%>
          </a>
          <%end if%>
        </div>
      <% End If %>
    </div>

  </div>

</div>
