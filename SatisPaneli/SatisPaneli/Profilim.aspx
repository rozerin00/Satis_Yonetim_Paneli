<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Profilim.aspx.cs" Inherits="SatisPaneli.Profilim" %>

    <!DOCTYPE html>
    <html lang="tr">

    <head runat="server">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Profilim | TeknoStore</title>
        <link href="https://fonts.googleapis.com/css?family=Inter:300,400,600,700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
        <link rel="stylesheet" href="dist/css/adminlte.min.css">
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f4f6f9;
            }

            .profile-card {
                border: none;
                border-radius: 15px;
                overflow: hidden;
            }

            .profile-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                padding: 40px;
                text-align: center;
                color: white;
            }

            .profile-img {
                width: 100px;
                height: 100px;
                background: white;
                border-radius: 50%;
                padding: 5px;
                margin-bottom: 10px;
                object-fit: contain;
            }

            .btn-update {
                background: #764ba2;
                border: none;
            }

            .btn-update:hover {
                background: #5e3b83;
            }

            .nav-link.active {
                font-weight: bold;
                color: #764ba2 !important;
                border-bottom: 2px solid #764ba2;
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm mb-4">
                <div class="container">
                    <a class="navbar-brand font-weight-bold text-primary" href="UrunVitrin.aspx">
                        <i class="fas fa-chevron-left mr-2"></i> Mağazaya Dön
                    </a>
                    <span class="navbar-text font-weight-bold">Hesabım</span>
                </div>
            </nav>

            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="card profile-card shadow">
                            <div class="profile-header">
                                <img src="https://via.placeholder.com/100?text=USER" class="profile-img shadow"
                                    alt="User" />
                                <h3 class="font-weight-bold">
                                    <%= Session["Kullanici"] %>
                                </h3>
                                <p class="mb-0 opacity-75">Müşteri Hesabı</p>
                            </div>

                            <div class="card-body p-4">
                                <!-- Sekmeler -->
                                <ul class="nav nav-tabs mb-4" id="myTab" role="tablist">
                                    <li class="nav-item">
                                        <a class="nav-link active" id="home-tab" data-toggle="tab" href="#home"
                                            role="tab"><i class="fas fa-user-edit mr-2"></i>Bilgilerim</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="orders-tab" data-toggle="tab" href="#orders"
                                            role="tab"><i class="fas fa-box-open mr-2"></i>Sipariş Geçmişi</a>
                                    </li>
                                </ul>

                                <div class="tab-content" id="myTabContent">
                                    <!-- BİLGİLER -->
                                    <div class="tab-pane fade show active" id="home" role="tabpanel">
                                        <asp:Label ID="lblMesaj" runat="server" CssClass="d-none" Text=""></asp:Label>

                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label class="font-weight-bold text-muted small">Ad Soyad</label>
                                                <asp:TextBox ID="txtAdSoyad" runat="server" CssClass="form-control" />
                                            </div>
                                            <div class="form-group col-md-6">
                                                <label class="font-weight-bold text-muted small">Telefon</label>
                                                <asp:TextBox ID="txtTelefon" runat="server" CssClass="form-control" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="font-weight-bold text-muted small">E-Posta Adresi</label>
                                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                                                TextMode="Email" />
                                        </div>
                                        <div class="form-group">
                                            <label class="font-weight-bold text-muted small">Teslimat Adresi</label>
                                            <asp:TextBox ID="txtAdres" runat="server" CssClass="form-control"
                                                TextMode="MultiLine" Rows="3" />
                                        </div>

                                        <div class="text-right">
                                            <asp:Button ID="btnGuncelle" runat="server" Text="Bilgilerimi Güncelle"
                                                CssClass="btn btn-primary btn-update shadow px-4"
                                                OnClick="btnGuncelle_Click" />
                                        </div>
                                    </div>

                                    <!-- SİPARİŞLER -->
                                    <div class="tab-pane fade" id="orders" role="tabpanel">
                                        <asp:Panel ID="pnlSiparisYok" runat="server">
                                            <div class="text-center py-5 text-muted">
                                                <i class="fas fa-box-open fa-3x mb-3 opacity-50"></i>
                                                <p>Henüz bir siparişiniz bulunmuyor.</p>
                                                <a href="UrunVitrin.aspx"
                                                    class="btn btn-sm btn-outline-primary rounded-pill">Alışverişe
                                                    Başla</a>
                                            </div>
                                        </asp:Panel>

                                        <div class="table-responsive">
                                            <asp:Repeater ID="rptSiparisler" runat="server">
                                                <HeaderTemplate>
                                                    <table class="table table-hover">
                                                        <thead>
                                                            <tr>
                                                                <th>Sipariş No</th>
                                                                <th>Tarih</th>
                                                                <th>Ürünler</th>
                                                                <th>Tutar</th>
                                                                <th>Durum</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td class="font-weight-bold">#<%# Eval("SatisID") %>
                                                        </td>
                                                        <td>
                                                            <%# Eval("Tarih", "{0:dd.MM.yyyy HH:mm}" ) %>
                                                        </td>
                                                        <td>
                                                            <div class="text-truncate" style="max-width: 300px;"
                                                                title='<%# Eval("UrunAdlari") %>'>
                                                                <%# Eval("UrunAdlari") %>
                                                            </div>
                                                            <small class="text-muted">
                                                                <%# Eval("UrunSayisi") %> Parça
                                                            </small>
                                                        </td>
                                                        <td class="text-primary font-weight-bold">
                                                            <%# Eval("ToplamTutar", "{0:C}" ) %>
                                                        </td>
                                                        <td><span class="badge badge-success px-2 py-1">Teslim
                                                                Edildi</span></td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate>
                                                    </tbody>
                                                    </table>
                                                </FooterTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </form>

        <script src="plugins/jquery/jquery.min.js"></script>
        <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>