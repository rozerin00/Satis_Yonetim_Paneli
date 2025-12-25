<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="SatisPaneli.Register" %>

    <!DOCTYPE html>
    <html lang="tr">

    <head runat="server">
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>TeknoStore | Kayıt Ol</title>

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css?family=Inter:300,400,600,700&display=swap" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
        <!-- Bootstrap -->
        <link rel="stylesheet" href="dist/css/adminlte.min.css">

        <style>
            body {
                margin: 0;
                padding: 0;
                font-family: 'Inter', sans-serif;
                overflow: hidden;
                height: 100vh;
                background: #fff;
            }

            .split-container {
                display: flex;
                height: 100vh;
                width: 100%;
            }

            /* SOL TARAF (GÖRSEL) */
            .left-side {
                flex: 1;
                background: linear-gradient(135deg, #764ba2 0%, #667eea 100%), url('https://picsum.photos/1920/1080?grayscale');
                background-blend-mode: multiply;
                background-size: cover;
                background-position: center;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                color: white;
                padding: 50px;
                position: relative;
            }

            .left-side h1 {
                font-weight: 800;
                font-size: 3.5rem;
                margin-bottom: 20px;
            }

            .left-side p {
                font-size: 1.2rem;
                opacity: 0.9;
                max-width: 500px;
                text-align: center;
                line-height: 1.6;
            }

            /* SAĞ TARAF (FORM) */
            .right-side {
                width: 500px;
                /* Biraz daha geniş */
                display: flex;
                flex-direction: column;
                justify-content: center;
                padding: 40px;
                background: #ffffff;
                overflow-y: auto;
                /* Form uzun olursa kaydır */
                box-shadow: -10px 0 30px rgba(0, 0, 0, 0.05);
                z-index: 10;
            }

            @media (max-width: 900px) {
                .left-side {
                    display: none;
                }

                .right-side {
                    width: 100%;
                }
            }

            .form-control {
                border-radius: 10px;
                height: 50px;
                border: 2px solid #f1f3f5;
                background-color: #fcfcfc;
                padding-left: 20px;
                font-size: 1rem;
                transition: all 0.3s;
            }

            .form-control:focus {
                border-color: #764ba2;
                box-shadow: 0 0 0 4px rgba(118, 75, 162, 0.1);
                background: #fff;
            }

            .btn-giris {
                height: 50px;
                border-radius: 10px;
                font-size: 1rem;
                font-weight: 700;
                letter-spacing: 0.5px;
                background: linear-gradient(90deg, #764ba2 0%, #667eea 100%);
                border: none;
                transition: transform 0.2s;
                color: white;
            }

            .btn-giris:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(118, 75, 162, 0.3);
                color: white;
            }

            .logo-text {
                color: #333;
                font-weight: 900;
                letter-spacing: -1px;
                font-size: 1.8rem;
                margin-bottom: 10px;
            }

            .logo-text span {
                color: #764ba2;
            }

            .register-link {
                color: #667eea;
                font-weight: 600;
                text-decoration: none;
            }

            .register-link:hover {
                text-decoration: underline;
            }

            /* Google Button & Divider */
            .btn-google {
                background: white;
                color: #555;
                border: 1px solid #ddd;
                font-weight: 600;
                font-size: 0.95rem;
                border-radius: 50px;
                padding: 10px;
                transition: all 0.3s;
            }

            .btn-google:hover {
                background: #f8f9fa;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1) !important;
                color: #333;
            }

            .divider {
                display: flex;
                align-items: center;
                text-align: center;
                color: #999;
                font-size: 0.8rem;
                font-weight: 600;
            }

            .divider::before,
            .divider::after {
                content: '';
                flex: 1;
                border-bottom: 1px solid #eee;
            }

            .divider::before {
                margin-right: 15px;
            }

            .divider::after {
                margin-left: 15px;
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <div class="split-container">
                <!-- Sol Taraf -->
                <div class="left-side">
                    <h1>ARAMIZA<br />KATILIN</h1>
                    <p>TeknoStore ailesine katılarak yüzlerce kampanyadan, size özel indirimlerden ve premium alışveriş
                        deneyiminden yararlanın.</p>
                </div>

                <!-- Sağ Taraf -->
                <div class="right-side">
                    <div class="text-center mb-4">
                        <div class="logo-text">Tekno<span>Store</span> Kayıt</div>
                        <p class="text-muted">Hızlıca hesabınızı oluşturun</p>
                    </div>

                    <!-- Google Login Button -->
                    <asp:LinkButton ID="btnGoogleLogin" runat="server"
                        CssClass="btn btn-google btn-block mb-4 shadow-sm" OnClick="btnGoogleLogin_Click">
                        <img src="https://www.svgrepo.com/show/475656/google-color.svg" width="20" class="mr-2" />
                        Google ile Devam Et
                    </asp:LinkButton>

                    <div class="divider mb-4">
                        <span>VEYA E-POSTA İLE</span>
                    </div>

                    <div class="form-group mb-3">
                        <label class="font-weight-bold text-muted small">AD SOYAD</label>
                        <asp:TextBox ID="txtAdSoyad" runat="server" CssClass="form-control"
                            placeholder="Adınız Soyadınız"></asp:TextBox>
                    </div>

                    <div class="form-group mb-3">
                        <label class="font-weight-bold text-muted small">E-POSTA</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"
                            placeholder="ornek@email.com"></asp:TextBox>
                    </div>

                    <div class="form-group mb-3">
                        <label class="font-weight-bold text-muted small">TELEFON</label>
                        <asp:TextBox ID="txtTelefon" runat="server" CssClass="form-control"
                            placeholder="05XX XXX XX XX"></asp:TextBox>
                    </div>

                    <div class="form-group mb-4">
                        <label class="font-weight-bold text-muted small">ŞİFRE</label>
                        <asp:TextBox ID="txtSifre" runat="server" CssClass="form-control" TextMode="Password"
                            placeholder="••••••"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnKayit" runat="server" Text="Hesap Oluştur"
                        CssClass="btn btn-primary btn-block btn-giris" OnClick="btnKayit_Click" />

                    <div class="text-center mt-4">
                        <span class="text-muted">Zaten hesabınız var mı?</span>
                        <a href="Login.aspx" class="register-link ml-1">Giriş Yap</a>
                    </div>

                    <div class="text-center mt-3">
                        <asp:Label ID="lblMesaj" runat="server" CssClass="small font-weight-bold"></asp:Label>
                    </div>
                </div>
            </div>
        </form>
    </body>

    </html>