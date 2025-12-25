<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SatisPaneli.Login" %>

    <!DOCTYPE html>
    <html lang="tr">

    <head runat="server">
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>TeknoStore | Giriş Yap</title>

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
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%), url('https://picsum.photos/1920/1080?grayscale');
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
                width: 450px;
                /* Sabit genişlik */
                display: flex;
                flex-direction: column;
                justify-content: center;
                padding: 40px;
                background: #ffffff;
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

            /* FORM ELEMANLARI */
            .nav-pills .nav-link {
                border-radius: 50px;
                padding: 10px 25px;
                font-weight: 600;
                color: #6c757d;
                background: #f8f9fa;
                margin-right: 10px;
            }

            .nav-pills .nav-link.active {
                background: #764ba2;
                color: #fff;
                box-shadow: 0 5px 15px rgba(118, 75, 162, 0.3);
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
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                border: none;
                transition: transform 0.2s;
            }

            .btn-giris:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(118, 75, 162, 0.3);
            }

            .logo-text {
                color: #333;
                font-weight: 900;
                letter-spacing: -1px;
                font-size: 1.8rem;
                margin-bottom: 30px;
            }

            .logo-text span {
                color: #764ba2;
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <div class="split-container">
                <!-- Sol Taraf -->
                <div class="left-side">
                    <h1>TEKNO<span style="font-weight:300">STORE</span></h1>
                    <p>En yeni teknolojileri, en uygun fiyatlarla yönetin ve müşterilerinizle buluşturun. Güvenli ve
                        hızlı altyapımızla işinizi büyütün.</p>
                </div>

                <!-- Sağ Taraf -->
                <div class="right-side">
                    <div class="text-center">
                        <div class="logo-text">Tekno<span>Store</span> Giriş</div>
                    </div>

                    <!-- Tab Menü -->
                    <ul class="nav nav-pills mb-4 justify-content-center" id="pills-tab" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="pills-admin-tab" data-toggle="pill" href="#pills-admin"
                                role="tab">
                                <i class="fas fa-user-shield mr-2"></i>Yönetici
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="pills-customer-tab" data-toggle="pill" href="#pills-customer"
                                role="tab">
                                <i class="fas fa-user mr-2"></i>Müşteri
                            </a>
                        </li>
                    </ul>

                    <div class="tab-content" id="pills-tabContent">
                        <!-- ADMIN GİRİŞİ -->
                        <div class="tab-pane fade show active" id="pills-admin" role="tabpanel">
                            <div class="form-group mb-3">
                                <label class="font-weight-bold text-muted small">KULLANICI ADI</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text bg-transparent border-0 pl-0"><i
                                                class="fas fa-user text-muted"></i></span>
                                    </div>
                                    <asp:TextBox ID="txtKullanici" runat="server" CssClass="form-control"
                                        placeholder="admin"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-group mb-4">
                                <label class="font-weight-bold text-muted small">ŞİFRE</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text bg-transparent border-0 pl-0"><i
                                                class="fas fa-lock text-muted"></i></span>
                                    </div>
                                    <asp:TextBox ID="txtSifre" runat="server" CssClass="form-control"
                                        TextMode="Password" placeholder="••••••"></asp:TextBox>
                                </div>
                            </div>
                            <asp:Button ID="btnGiris" runat="server" Text="Giriş Yap"
                                CssClass="btn btn-primary btn-block btn-giris" OnClick="btnGiris_Click" />
                        </div>

                        <!-- MÜŞTERİ GİRİŞİ -->
                        <div class="tab-pane fade" id="pills-customer" role="tabpanel">
                            <div class="form-group mb-3">
                                <label class="font-weight-bold text-muted small">E-POSTA</label>
                                <asp:TextBox ID="txtMusteriEmail" runat="server" CssClass="form-control"
                                    placeholder="ornek@email.com" TextMode="Email"></asp:TextBox>
                            </div>
                            <div class="form-group mb-4">
                                <label class="font-weight-bold text-muted small">ŞİFRE</label>
                                <asp:TextBox ID="txtMusteriSifre" runat="server" CssClass="form-control"
                                    TextMode="Password" placeholder="••••••"></asp:TextBox>
                            </div>

                            <asp:Button ID="btnMusteriGiris" runat="server" Text="Giriş Yap"
                                CssClass="btn btn-dark btn-block btn-giris" OnClick="btnMusteriGiris_Click" />

                            <div class="text-center mt-4">
                                <span class="text-muted">Hesabınız yok mu?</span>
                                <a href="Register.aspx" class="text-primary font-weight-bold ml-1">Hemen Kayıt Ol</a>
                            </div>
                        </div>
                    </div>

                    <div class="text-center mt-4">
                        <asp:Label ID="lblHata" runat="server" CssClass="text-danger small font-weight-bold">
                        </asp:Label>
                    </div>
                </div>
            </div>
        </form>

        <!-- Scripts -->
        <script src="plugins/jquery/jquery.min.js"></script>
        <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>