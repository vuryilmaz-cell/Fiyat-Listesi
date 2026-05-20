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

<%' Fiyat Listeleri dropdown %>
    <div class="nav_dropdown" id="nav_listeler_dropdown">
      <button class="nav_item nav_dropdown_btn" onclick="toggleNavDropdown('nav_listeler_dropdown'); return false;" type="button">
        <i class="fa-solid fa-list"></i>
        <span><%if language<>2 then Response.Write("Fiyat Listeleri") else Response.Write("Price Lists") end if%></span>
        <i class="fa-solid fa-chevron-down nav_dd_arrow"></i>
      </button>
      <div class="nav_dropdown_menu">

        <% if Session("MM_UserAuthorization") <> bayi then %>
        <a href="default.asp?list=1&lng=<%=language%>" class="nav_dd_item<%if list="1" then Response.Write(" nav_dd_active") end if%>">
          <i class="fa-solid fa-tags"></i>
          <span><%if language<>2 then Response.Write("Fiyat Listesi Ürünler") else Response.Write("Price List Products") end if%></span>
        </a>
        <% end if %>

        <a href="default.asp?list=3&lng=<%=language%>" class="nav_dd_item<%if list="3" then Response.Write(" nav_dd_active") end if%>">
          <i class="fa-solid fa-handshake-angle"></i>
          <span><%if language<>2 then Response.Write("Bayi Listesi Ürünler") else Response.Write("Dealer List Products") end if%></span>
        </a>

        <a href="default.asp?list=4&lng=<%=language%>" class="nav_dd_item<%if list="4" then Response.Write(" nav_dd_active") end if%>">
          <i class="fa-solid fa-screwdriver-wrench"></i>
          <span><%if language<>2 then Response.Write("Bayi Listesi Yedek Parça") else Response.Write("Dealer List Spare Parts") end if%></span>
        </a>

        <a href="default.asp?list=5&lng=<%=language%>" class="nav_dd_item<%if list="5" then Response.Write(" nav_dd_active") end if%>">
          <i class="fa-solid fa-cog"></i>
          <span><%if language<>2 then Response.Write("Bayi Listesi Mekanik") else Response.Write("Dealer List Mechanic") end if%></span>
        </a>

      </div>
    </div>

    <%' Ayarlar dropdown — sadece yönetici/super_yönetici %>
<% if Session("MM_UserAuthorization") = yonetici Or Session("MM_UserAuthorization") = super_yonetici then %>
<div class="nav_dropdown nav_settings_dropdown" id="nav_settings_dropdown">
  <button class="nav_item nav_dropdown_btn" onclick="toggleNavDropdown('nav_settings_dropdown'); return false;" type="button">
    <i class="fa-solid fa-sliders"></i>
    <span><%if language<>2 then Response.Write("Ayarlar") else Response.Write("Settings") end if%></span>
    <i class="fa-solid fa-chevron-down nav_dd_arrow"></i>
  </button>
  <div class="nav_dropdown_menu nav_settings_panel">

    <div class="settings_grid">

      <div class="settings_section">
        <p class="settings_section_title"><%if language<>2 then Response.Write("GÖRÜNÜM") else Response.Write("VIEW MODE") end if%></p>
        <label class="settings_radio_row">
          <input type="radio" onclick="adjust_liste(this.id)" name="adjust_liste" id="maliyet_liste" value="maliyet_liste">
          <span><%if language<>2 then Response.Write("Maliyetli Görünüm") else Response.Write("Show Costs") end if%></span>
        </label>
        <label class="settings_radio_row">
          <input type="radio" onclick="adjust_liste(this.id)" name="adjust_liste" id="fiyat_liste" value="fiyat_liste" checked>
          <span><%if language<>2 then Response.Write("Liste Fiyatı Görünümü") else Response.Write("List Price View") end if%></span>
        </label>
        <label class="settings_radio_row">
          <input type="radio" onclick="adjust_liste(this.id)" name="adjust_liste" id="kirilim_liste" value="kirilim_liste">
          <span><%if language<>2 then Response.Write("Kırılımlı Görünüm") else Response.Write("Breakdown View") end if%></span>
        </label>
      </div>

      <div class="settings_section">
        <p class="settings_section_title"><%if language<>2 then Response.Write("PARA BİRİMİ") else Response.Write("CURRENCY") end if%></p>
        <select id="cur_type" name="cur_type" onchange="downloading_product(this)">
          <option value="DEF" <%if cur="DEF" then Response.Write("selected")end if%>><%if language<>2 then Response.Write("Karma Fiyat Listesi") else Response.Write("Mixed Price List") end if%></option>
          <option value="USD" <%if cur="USD" then Response.Write("selected")end if%>>USD</option>
          <option value="EUR" <%if cur="EUR" then Response.Write("selected")end if%>>EUR</option>
        </select>
        <label class="settings_field_row">
          <span><%if language<>2 then Response.Write("USD/EUR Parite") else Response.Write("USD/EUR Parity") end if%></span>
          <input id="parity_type" name="parity_type" value="<%=parity%>" onchange="downloading_product(this)"/>
        </label>
        <p class="settings_note"><%if language<>2 then Response.Write("Farklı para birimleri arasındaki dönüşümlerde parite doğruluğundan emin olunuz.") else Response.Write("Ensure parity accuracy when converting between currencies.") end if%></p>
      </div>

      <% if price_list_type = 3 then %>
      <div class="settings_section">
        <p class="settings_section_title">BAYİ ÜRÜN ORANLARI</p>
        <%if sdp <>"" then%>
        <label class="settings_field_row">
          <span>İndirim Oranı</span>
          <input id="sdp_type" name="sdp_type" value="<%=sdp%>" onchange="downloading_product(this)"/>
        </label>
        <%end if%>
        <%if sip <>"" then%>
        <label class="settings_field_row">
          <span>Arttırma Oranı</span>
          <input id="sip_type" name="sip_type" value="<%=sip%>" onchange="downloading_product(this)"/>
        </label>
        <%end if%>
      </div>
      <% end if %>

      <% if price_list_type = 5 then %>
      <div class="settings_section">
        <p class="settings_section_title">BAYİ MEKANİK ORANLARI</p>
        <%if sdm <>"" then%>
        <label class="settings_field_row">
          <span>İndirim Oranı</span>
          <input id="sdm_type" name="sdm_type" value="<%=sdm%>" onchange="downloading_product(this)"/>
        </label>
        <%end if%>
        <%if sim <>"" then%>
        <label class="settings_field_row">
          <span>Arttırma Oranı</span>
          <input id="sim_type" name="sim_type" value="<%=sim%>" onchange="downloading_product(this)"/>
        </label>
        <%end if%>
      </div>
      <% end if %>

      <% if price_list_type = 4 then %>
      <div class="settings_section">
        <p class="settings_section_title">BAYİ YEDEK PARÇA ORANLARI</p>
        <%if sds <>"" then%>
        <label class="settings_field_row">
          <span>İndirim Oranı</span>
          <input id="sds_type" name="sds_type" value="<%=sds%>" onchange="downloading_product(this)"/>
        </label>
        <%end if%>
        <%if sis <>"" then%>
        <label class="settings_field_row">
          <span>Arttırma Oranı</span>
          <input id="sis_type" name="sis_type" value="<%=sis%>" onchange="downloading_product(this)"/>
        </label>
        <%end if%>
      </div>
      <% end if %>

    </div><!-- /settings_grid -->

  </div><!-- /nav_settings_panel -->
</div>
<% end if %>

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

<script>
function toggleNavDropdown(id) {
  var el = document.getElementById(id);
  var isOpen = el.classList.contains('open');
  document.querySelectorAll('.nav_dropdown.open').forEach(function(d){ d.classList.remove('open'); });
  if (!isOpen) el.classList.add('open');
}
document.addEventListener('click', function(e) {
  if (!e.target.closest('.nav_dropdown')) {
    document.querySelectorAll('.nav_dropdown.open').forEach(function(d){ d.classList.remove('open'); });
  }
});
</script>