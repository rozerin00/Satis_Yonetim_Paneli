<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Sepet.aspx.cs" Inherits="SatisPaneli.Sepet" %>

    <!DOCTYPE html>
    <html lang="tr">

    <head runat="server">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Sepetim | TeknoStore</title>
        <!-- Google Fonts & Icons -->
        <link href="https://fonts.googleapis.com/css?family=Inter:300,400,600,700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
        <link rel="stylesheet" href="dist/css/adminlte.min.css">

        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f8f8f8;
            }

            .navbar {
                border-bottom: 3px solid #f27a1a;
            }

            /* Trendyol Turuncusu */
            .cart-header {
                font-size: 1.5rem;
                font-weight: 600;
                color: #333;
                margin-bottom: 20px;
            }

            /* Sol taraf: Ürün Listesi */
            .cart-item {
                background: white;
                border-radius: 8px;
                border: 1px solid #e6e6e6;
                padding: 20px;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            }

            .cart-img {
                width: 80px;
                height: 80px;
                object-fit: contain;
                border: 1px solid #eee;
                border-radius: 6px;
                padding: 5px;
            }

            .cart-details {
                flex-grow: 1;
                padding-left: 20px;
            }

            .cart-title {
                font-weight: 600;
                color: #333;
                margin-bottom: 5px;
                font-size: 1.1rem;
            }

            .cart-price {
                font-size: 1.2rem;
                font-weight: 700;
                color: #f27a1a;
            }

            /* Adet Kontrolü */
            .quantity-control {
                display: flex;
                align-items: center;
                border: 1px solid #ddd;
                border-radius: 5px;
                width: fit-content;
            }

            .btn-qty {
                border: none;
                background: #fff;
                color: #999;
                width: 30px;
                height: 30px;
                font-weight: bold;
                cursor: pointer;
            }

            .btn-qty:hover {
                background: #f0f0f0;
                color: #333;
            }

            .qty-val {
                width: 30px;
                text-align: center;
                font-weight: 600;
                font-size: 0.9rem;
            }

            /* Sağ taraf: Özet */
            .summary-card {
                background: white;
                border-radius: 8px;
                border: 1px solid #e6e6e6;
                padding: 20px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
                position: sticky;
                top: 20px;
            }

            .summary-title {
                font-size: 1.2rem;
                font-weight: 600;
                margin-bottom: 20px;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
                font-size: 0.95rem;
                color: #555;
            }

            .total-row {
                font-size: 1.3rem;
                color: #f27a1a;
                font-weight: 700;
                margin-top: 20px;
                border-top: 1px solid #eee;
                padding-top: 15px;
            }

            .btn-checkout {
                background-color: #f27a1a;
                color: white;
                font-weight: 600;
                padding: 12px;
                border-radius: 8px;
                margin-top: 20px;
                width: 100%;
                border: none;
                transition: 0.3s;
            }

            .btn-checkout:hover {
                background-color: #d86208;
                color: white;
                box-shadow: 0 5px 15px rgba(242, 122, 26, 0.3);
            }

            .btn-remove {
                color: #999;
                font-size: 0.9rem;
                text-decoration: none;
                margin-left: auto;
            }

            .btn-remove:hover {
                color: #dc3545;
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <!-- Navbar (Basit) -->
            <nav class="navbar navbar-light bg-white mb-4">
                <div class="container">
                    <a class="navbar-brand font-weight-bold" href="UrunVitrin.aspx" style="color: #f27a1a;">
                        <i class="fas fa-chevron-left mr-2"></i> Alışverişe Dön
                    </a>
                    <span class="navbar-text font-weight-bold text-dark">
                        <i class="fas fa-shopping-basket mr-2"></i> Sepetim
                    </span>
                </div>
            </nav>

            <div class="container pb-5">
                <asp:Panel ID="pnlDoluSepet" runat="server">
                    <div class="row">
                        <!-- Sol Kolon: Ürünler -->
                        <div class="col-lg-8">
                            <div class="cart-header">Sepetinizdeki Ürünler</div>

                            <asp:Repeater ID="rptSepet" runat="server" OnItemCommand="rptSepet_ItemCommand">
                                <ItemTemplate>
                                    <div class="cart-item">
                                        <img src="<%# Eval(" UrunResim") %>" class="cart-img" alt="Ürün" />
                                        <div class="cart-details">
                                            <div class="cart-title">
                                                <%# Eval("UrunAdi") %>
                                            </div>
                                            <div class="text-muted small mb-2">Tahmini Teslimat: 3 Gün içinde</div>
                                            <div class="cart-price">
                                                <%# Eval("Tutar", "{0:C}" ) %>
                                            </div>
                                        </div>

                                        <div class="d-flex flex-column align-items-end ml-3">
                                            <div class="quantity-control mb-2">
                                                <asp:LinkButton ID="btnAzalt" runat="server" CssClass="btn-qty" Text="-"
                                                    CommandName="Azalt" CommandArgument='<%# Eval("UrunID") %>'>
                                                </asp:LinkButton>
                                                <span class="qty-val">
                                                    <%# Eval("Adet") %>
                                                </span>
                                                <asp:LinkButton ID="btnArtir" runat="server" CssClass="btn-qty" Text="+"
                                                    CommandName="Artir" CommandArgument='<%# Eval("UrunID") %>'>
                                                </asp:LinkButton>
                                            </div>
                                            <asp:LinkButton ID="btnSil" runat="server" CssClass="btn-remove"
                                                CommandName="Sil" CommandArgument='<%# Eval("UrunID") %>'>
                                                <i class="fas fa-trash-alt mr-1"></i> Sil
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

                        <!-- Sağ Kolon: Özet -->
                        <div class="col-lg-4">
                            <div class="summary-card">
                                <div class="summary-title">Sipariş Özeti</div>
                                <div class="summary-row">
                                    <span>Ara Toplam</span>
                                    <asp:Label ID="lblAraToplam" runat="server" Text="0,00 TL"></asp:Label>
                                </div>
                                <div class="summary-row">
                                    <span>Kargo Toplam</span>
                                    <asp:Label ID="lblKargo" runat="server" Text="29,99 TL"></asp:Label>
                                </div>
                                <div class="summary-row text-success small">
                                    <span><i class="fas fa-check-circle mr-1"></i> 100 TL üzeri Kargo Bedava</span>
                                </div>

                                <div class="summary-row total-row">
                                    <span>Genel Toplam</span>
                                    <asp:Label ID="lblGenelToplam" runat="server" Text="0,00 TL"></asp:Label>
                                </div>

                                <asp:Button ID="btnSiparisiTamamla" runat="server" Text="SEPETİ ONAYLA"
                                    CssClass="btn-checkout" OnClick="btnSiparisiTamamla_Click" />

                                <div class="text-center mt-3 small text-muted">
                                    <i class="fas fa-lock mr-1"></i> Güvenli Alışveriş
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <!-- Boş Sepet Paneli -->
                <asp:Panel ID="pnlBosSepet" runat="server" Visible="false" CssClass="text-center py-5">
                    <div
                        style="background: white; padding: 50px; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); display: inline-block;">
                        <i class="fas fa-shopping-cart text-muted mb-4" style="font-size: 4rem; opacity: 0.3;"></i>
                        <h3 class="font-weight-bold text-dark">Sepetinizde ürün bulunmamaktadır.</h3>
                        <p class="text-muted mb-4">Hemen alışverişe başlayarak sepetinizi doldurabilirsiniz.</p>
                        <a href="UrunVitrin.aspx" class="btn btn-warning btn-lg px-5 font-weight-bold text-white shadow"
                            style="background-color: #f27a1a; border:none;">Alışverişe Başla</a>
                    </div>
                </asp:Panel>
            </div>
        </form>
    </body>

    </html>