<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../../fiyat/Connections/uyeler.asp" -->

<%Session.Timeout=180%>

<%
  dim referer_
  referer_ = "../default.asp"
%>

<%
  Dim err_msg, status_msg
  err_msg    = ""
  status_msg = ""

  If Request.QueryString("err") <> "" Then
    Dim err_code : err_code = Request.QueryString("err")
    If err_code = 1 Then err_msg = "Geçersiz kullanıcı adı veya parola. Lütfen bilgilerinizi kontrol ederek tekrar deneyiniz."
    If err_code = 2 Then err_msg = "Üyeliğiniz henüz onaylanmamıştır. Detaylı bilgi için site yöneticinize danışınız."
    If err_code = 3 Then err_msg = "Bu sayfayı görüntülemeye yetkiniz bulunmamaktadır."
    If err_code = 4 Then err_msg = "Bu sayfayı görüntülemek için giriş yapmanız gerekmektedir."
    If err_code = 5 Then err_msg = "Mevcut üyelik yetkileriniz bu sayfaya erişime izin vermemektedir."
    If err_code = 6 Then err_msg = "Üyeliğiniz geçici olarak askıya alınmıştır. Detaylı bilgi için site yöneticinize danışınız."
    If err_code = 7 Then err_msg = "Uzun süre işlem yapılmadığı için oturum sona erdirilmiştir. Lütfen tekrar giriş yapınız."
  End If

  If Request.QueryString("status") <> "" Then
    If Request.QueryString("status") = 1 Then
      status_msg = "Üyelik işlemi başarıyla tamamlandı. E-posta ve şifrenizle giriş yapabilirsiniz."
    End If
  End If
%>

<%
  MM_LoginAction = Request.ServerVariables("URL")
  If Request.QueryString <> "" Then MM_LoginAction = MM_LoginAction & "?" & Server.HTMLEncode(Request.QueryString)

  'MM_valUsername = CStr(Request.Form("user_name"))
  MM_valUsername = "Oguzhan"

  If MM_valUsername <> "" Then
    Dim MM_fldUserAuthorization
    Dim MM_redirectLoginSuccess
    Dim MM_redirectLoginFailed
    Dim MM_loginSQL
    Dim MM_rsUser
    Dim MM_rsUser_cmd

    MM_fldUserAuthorization  = "member_type"
    MM_redirectLoginSuccess  = referer_
    MM_redirectLoginFailed   = "login.asp?err=1"

    MM_loginSQL = "SELECT id, username, User_Name, User_Surname, password, allow, active_passive, total_visit, " & _
                  "Special_Discount_Product, Special_Discount_Spare, Special_Discount_Mechanic, " & _
                  "Special_Increasing_Spare, Special_Increasing_Product, Special_Increasing_Mechanic, " & _
                  "Default_Currency, Company_Name, Default_Language, " & MM_fldUserAuthorization & _
                  " FROM tblUsersCor_Personel WHERE username = ? AND password = ?"

    Set MM_rsUser_cmd = Server.CreateObject("ADODB.Command")
    MM_rsUser_cmd.ActiveConnection = MM_stok_STRING
    MM_rsUser_cmd.CommandText = MM_loginSQL
    MM_rsUser_cmd.Parameters.Append MM_rsUser_cmd.CreateParameter("param1", 200, 1, 255, MM_valUsername)
    'MM_rsUser_cmd.Parameters.Append MM_rsUser_cmd.CreateParameter("param2", 200, 1, 255, Request.Form("pass"))
    MM_rsUser_cmd.Parameters.Append MM_rsUser_cmd.CreateParameter("param2", 200, 1, 255, "Ot1981")

    MM_rsUser_cmd.Prepared = True
    Set MM_rsUser = MM_rsUser_cmd.Execute

    If Not MM_rsUser.EOF Or Not MM_rsUser.BOF Then
      If MM_rsUser.Fields.Item("allow").Value = True Then
        If MM_rsUser.Fields.Item("active_passive").Value = True Then
          Session("MM_Username")               = MM_valUsername
          Session("MM_Name")                   = MM_rsUser.Fields.Item("User_Name").Value & " " & MM_rsUser.Fields.Item("User_Surname").Value
          Session("Company_Name")              = MM_rsUser.Fields.Item("Company_Name").Value
          Session("Special_Discount_Product")  = MM_rsUser.Fields.Item("Special_Discount_Product").Value
          Session("Special_Discount_Spare")    = MM_rsUser.Fields.Item("Special_Discount_Spare").Value
          Session("Special_Discount_Mechanic") = MM_rsUser.Fields.Item("Special_Discount_Mechanic").Value
          Session("Special_Increasing_Product")  = MM_rsUser.Fields.Item("Special_Increasing_Product").Value
          Session("Special_Increasing_Spare")    = MM_rsUser.Fields.Item("Special_Increasing_Spare").Value
          Session("Special_Increasing_Mechanic") = MM_rsUser.Fields.Item("Special_Increasing_Mechanic").Value
          Session("Default_Currency")          = MM_rsUser.Fields.Item("Default_Currency").Value
          Session.Timeout = 180

          If MM_fldUserAuthorization <> "" Then
            Session("MM_UserAuthorization") = CStr(MM_rsUser.Fields.Item(MM_fldUserAuthorization).Value)
            Call update_user_table(MM_rsUser.Fields.Item("id").Value, MM_rsUser.Fields.Item("total_visit").Value)
          Else
            Session("MM_UserAuthorization") = ""
          End If

          Session("last_visited_page") = ""
          Response.Redirect(MM_redirectLoginSuccess & "?lng=" & MM_rsUser.Fields.Item("Default_Language").Value)
          MM_rsUser.Close
        Else
          MM_rsUser.Close
          Response.Redirect("login.asp?err=6")
        End If
      Else
        MM_rsUser.Close
        Response.Redirect("login.asp?err=2")
      End If
    End If

    MM_rsUser.Close
    Response.Redirect(MM_redirectLoginFailed)
  End If
%>

<%
  Sub update_user_table(userid, totalvisit)
    Dim MM_editCmd
    Set MM_editCmd = Server.CreateObject("ADODB.Command")
    MM_editCmd.ActiveConnection = MM_stok_STRING
    MM_editCmd.CommandText = "UPDATE tblUsersCor_Personel SET last_visit=?, total_visit=? WHERE id=" & userid
    MM_editCmd.Prepared = True
    MM_editCmd.Parameters.Append MM_editCmd.CreateParameter("param1", 135, 1, 135, Now)
    MM_editCmd.Parameters.Append MM_editCmd.CreateParameter("param2", 5,   1,  -1, totalvisit + 1)
    MM_editCmd.Execute
    MM_editCmd.ActiveConnection.Close
  End Sub
%>

<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Giriş — Tunaylar Fiyat Listesi</title>
  <link href="../screen.css" media="screen" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
  <link href="https://fonts.googleapis.com/css2?family=Barlow:wght@300;400;500;600;700&family=Barlow+Condensed:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Barlow', Arial, sans-serif;
      background: #0f1923;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }

    /* ── Arka plan desen ── */
    body::before {
      content: '';
      position: fixed;
      inset: 0;
      background:
        repeating-linear-gradient(
          90deg,
          transparent,
          transparent 80px,
          rgba(55,194,228,.03) 80px,
          rgba(55,194,228,.03) 81px
        ),
        repeating-linear-gradient(
          180deg,
          transparent,
          transparent 80px,
          rgba(55,194,228,.03) 80px,
          rgba(55,194,228,.03) 81px
        );
      pointer-events: none;
      z-index: 0;
    }

    .login_wrap {
      position: relative;
      z-index: 1;
      width: 100%;
      max-width: 420px;
    }

    /* ── Logo / Başlık ── */
    .login_brand {
      text-align: center;
      margin-bottom: 32px;
    }
    .login_brand .brand_logo {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 64px;
      height: 64px;
      background: linear-gradient(135deg, #37c2e4, #1a9bbf);
      border-radius: 16px;
      margin-bottom: 16px;
      box-shadow: 0 8px 24px rgba(55,194,228,.35);
    }
    .login_brand .brand_logo i {
      font-size: 28px;
      color: #fff;
    }
    .login_brand h1 {
      font-family: 'Barlow Condensed', sans-serif;
      font-size: 22px;
      font-weight: 700;
      color: #fff;
      letter-spacing: 1px;
      text-transform: uppercase;
    }
    .login_brand p {
      font-size: 13px;
      color: rgba(255,255,255,.45);
      margin-top: 4px;
      letter-spacing: .5px;
    }

    /* ── Kart ── */
    .login_card {
      background: rgba(255,255,255,.04);
      border: 1px solid rgba(255,255,255,.08);
      border-radius: 16px;
      padding: 36px 32px;
      backdrop-filter: blur(12px);
      box-shadow: 0 24px 64px rgba(0,0,0,.4);
    }

    /* ── Form elemanları ── */
    .field_group {
      margin-bottom: 18px;
    }
    .field_group label {
      display: block;
      font-size: 11px;
      font-weight: 600;
      color: rgba(255,255,255,.5);
      text-transform: uppercase;
      letter-spacing: .8px;
      margin-bottom: 8px;
    }
    .field_input {
      position: relative;
    }
    .field_input i {
      position: absolute;
      left: 14px;
      top: 50%;
      transform: translateY(-50%);
      font-size: 14px;
      color: rgba(255,255,255,.3);
      pointer-events: none;
    }
    .field_input input {
      width: 100%;
      background: rgba(255,255,255,.07);
      border: 1px solid rgba(255,255,255,.1);
      border-radius: 8px;
      padding: 12px 14px 12px 40px;
      font-size: 14px;
      font-family: 'Barlow', sans-serif;
      color: #fff;
      outline: none;
      transition: border-color .2s, background .2s;
    }
    .field_input input::placeholder { color: rgba(255,255,255,.25); }
    .field_input input:focus {
      border-color: #37c2e4;
      background: rgba(55,194,228,.08);
    }
    .field_input input:-webkit-autofill {
      -webkit-box-shadow: 0 0 0 50px #1a2332 inset;
      -webkit-text-fill-color: #fff;
    }

    /* ── Giriş butonu ── */
    .btn_giris {
      width: 100%;
      padding: 13px;
      margin-top: 8px;
      background: linear-gradient(135deg, #37c2e4, #1a9bbf);
      border: none;
      border-radius: 8px;
      font-family: 'Barlow Condensed', sans-serif;
      font-size: 16px;
      font-weight: 700;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      color: #fff;
      cursor: pointer;
      transition: opacity .2s, box-shadow .2s;
      box-shadow: 0 4px 16px rgba(55,194,228,.3);
    }
    .btn_giris:hover {
      opacity: .9;
      box-shadow: 0 6px 24px rgba(55,194,228,.45);
    }
    .btn_giris i { margin-right: 8px; }

    /* ── Hata / Başarı mesajı ── */
    .alert_box {
      border-radius: 8px;
      padding: 12px 16px;
      font-size: 13px;
      line-height: 1.5;
      margin-bottom: 20px;
      display: flex;
      align-items: flex-start;
      gap: 10px;
    }
    .alert_box i { flex-shrink: 0; margin-top: 1px; }
    .alert_hata {
      background: rgba(231,76,60,.15);
      border: 1px solid rgba(231,76,60,.3);
      color: #ff8a80;
    }
    .alert_ok {
      background: rgba(46,204,113,.12);
      border: 1px solid rgba(46,204,113,.25);
      color: #69f0ae;
    }

    /* ── Alt bilgi ── */
    .login_footer {
      text-align: center;
      margin-top: 24px;
      font-size: 12px;
      color: rgba(255,255,255,.2);
      letter-spacing: .3px;
    }
    .login_footer a {
      color: rgba(55,194,228,.6);
      text-decoration: none;
    }
    .login_footer a:hover { color: #37c2e4; }

    /* ── Responsive ── */
    @media (max-width: 460px) {
      .login_card { padding: 28px 20px; }
    }
  </style>
</head>
<body>

<div class="login_wrap">

  <!-- Marka -->
  <div class="login_brand">
    <div class="brand_logo">
      <i class="fa-solid fa-scale-balanced"></i>
    </div>
    <h1>Tunaylar Fiyat Listesi</h1>
    <p>TUNAYLAR BASKÜL SANAYİ VE TİCARET A.Ş.</p>
  </div>

  <!-- Kart -->
  <div class="login_card">

    <!-- Hata mesajı -->
    <% If err_msg <> "" Then %>
    <div class="alert_box alert_hata">
      <i class="fa-solid fa-circle-exclamation"></i>
      <span><%=err_msg%></span>
    </div>
    <% End If %>

    <!-- Başarı mesajı -->
    <% If status_msg <> "" Then %>
    <div class="alert_box alert_ok">
      <i class="fa-solid fa-circle-check"></i>
      <span><%=status_msg%></span>
    </div>
    <% End If %>

    <form method="post" action="<%=MM_LoginAction%>" autocomplete="off">

      <div class="field_group">
        <label for="user_name">Kullanıcı Adı</label>
        <div class="field_input">
          <i class="fa-solid fa-user"></i>
          <input type="text" id="user_name" name="user_name"
                 placeholder="Kullanıcı adınızı giriniz"
                 autocomplete="username" autofocus/>
        </div>
      </div>

      <div class="field_group">
        <label for="pass">Şifre</label>
        <div class="field_input">
          <i class="fa-solid fa-lock"></i>
          <input type="password" id="pass" name="pass"
                 placeholder="Şifrenizi giriniz"
                 autocomplete="current-password"/>
        </div>
      </div>

      <button type="submit" class="btn_giris">
        <i class="fa-solid fa-right-to-bracket"></i>Giriş Yap
      </button>

    </form>

  </div>

  <div class="login_footer">
    &copy; <%=Year(Date())%> Tunaylar &nbsp;·&nbsp;
    <a href="../default.asp">Fiyat Listesine Dön</a>
  </div>

</div>

</body>
</html>
