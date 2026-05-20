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

    <%' Yardım %>
    <a href="#" class="nav_item" onclick="play_video('yardim','600','400','mail_form'); return false;">
      <i class="fa-solid fa-circle-question"></i>
      <span><%if language<>2 then Response.Write("Yardım") else Response.Write("Help") end if%></span>
    </a>

    <%'Admin dropdown — sadece yetkili kullanıcıya göster %>
    <% if Session("MM_UserAuthorization") = 1 then %>
    <div class="nav_dropdown" id="nav_admin_dropdown">
      <button class="nav_item nav_dropdown_btn" onclick="toggleNavDropdown('nav_admin_dropdown'); return false;" type="button">
        <i class="fa-solid fa-shield-halved"></i>
        <span><%if language<>2 then Response.Write("Yönetim") else Response.Write("Admin") end if%></span>
        <i class="fa-solid fa-chevron-down nav_dd_arrow"></i>
      </button>
      <div class="nav_dropdown_menu">
        <a href="../../fiyat/default.asp" class="nav_dd_item">
          <i class="fa-solid fa-tags"></i>
          <span><%if language<>2 then Response.Write("Fiyat Listesi") else Response.Write("Price List") end if%></span>
        </a>
        <a href="../../fiyat/admin/urun_listesi.asp" class="nav_dd_item">
          <i class="fa-solid fa-calculator"></i>
          <span><%if language<>2 then Response.Write("Maliyet Listesi") else Response.Write("Cost List") end if%></span>
        </a>
        <a href="../../fiyat/admin/Uyeler.asp" class="nav_dd_item">
          <i class="fa-solid fa-users-gear"></i>
          <span><%if language<>2 then Response.Write("Bayi Yönetimi") else Response.Write("Dealer Mgmt") end if%></span>
        </a>
      </div>
    </div>
    <% end if %>

    <div class="nav_spacer"></div>

    <div id="top_user">
      <% If Session("IMPERSONATE_ACTIVE") = True Then %>
        <div id="top_user_impersonate">
          <i class="fa-solid fa-user-secret"></i>
          <span><%=Session("MM_Username")%> &rarr; <b><%=Session("IMPERSONATE_USERNAME")%></b></span>
          <a href="?impersonate_stop=1" class="btn_geri_don">
            <i class="fa-solid fa-arrow-left"></i>
            <%if language<>2 then Response.Write("Geri Dön") else Response.Write("Back") end if%>
          </a>
        </div>
      <% Else %>
        <div id="top_user_normal">
          <i class="fa-solid fa-circle-user"></i>
          <span><%=Session("MM_Username")%></span>
          <span class="top_user_sep"></span>
          <a href="logout.asp" class="top_cikis">
            <%if language<>2 then Response.Write("Çıkış") else Response.Write("Logout") end if%>
          </a>
        </div>
      <% End If %>
    </div>

  </div><!-- /top_nav -->

</div><!-- /top_div -->

<script>
function toggleNavDropdown(id) {
  var el = document.getElementById(id);
  var isOpen = el.classList.contains('open');
  // Tüm açık dropdownları kapat
  document.querySelectorAll('.nav_dropdown.open').forEach(function(d){ d.classList.remove('open'); });
  if (!isOpen) el.classList.add('open');
}
// Dışarı tıklanınca kapat
document.addEventListener('click', function(e) {
  if (!e.target.closest('.nav_dropdown')) {
    document.querySelectorAll('.nav_dropdown.open').forEach(function(d){ d.classList.remove('open'); });
  }
});
</script>
