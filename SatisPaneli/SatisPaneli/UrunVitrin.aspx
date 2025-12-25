<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UrunVitrin.aspx.cs" Inherits="SatisPaneli.UrunVitrin" %>

    <!DOCTYPE html>
    <html lang="tr">

    <head runat="server">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Mağaza Vitrini | Teknoloji & Elektronik</title>

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css?family=Inter:300,400,600,700&display=swap" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
        <!-- AdminLTE / Bootstrap -->
        <link rel="stylesheet" href="dist/css/adminlte.min.css">

        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f4f6f9;
            }

            .hero-section {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 80px 0;
                margin-bottom: 40px;
                border-radius: 0 0 50px 50px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }

            .product-card {
                transition: all 0.3s ease;
                border: none;
                border-radius: 15px;
                overflow: hidden;
                background: white;
            }

            .product-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
            }

            .card-img-top {
                height: 200px;
                object-fit: contain;
                background: #f8f9fa;
                padding: 20px;
            }

            .price-tag {
                font-size: 1.25rem;
                color: #28a745;
                font-weight: 700;
            }

            .category-badge {
                position: absolute;
                top: 15px;
                right: 15px;
                background: rgba(0, 0, 0, 0.6);
                color: white;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.8rem;
            }

            .btn-custom-primary {
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                border: none;
                color: white;
            }

            .btn-custom-primary:hover {
                background: linear-gradient(90deg, #764ba2 0%, #667eea 100%);
                color: white;
            }

            /* Detay Modal Tablo */
            .modal-table td:first-child {
                font-weight: 600;
                color: #555;
                width: 35%;
                background-color: #f8f9fa;
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
                <div class="container">
                    <a class="navbar-brand font-weight-bold text-primary" href="#">
                        <i class="fas fa-bolt mr-2"></i>TeknoStore
                    </a>
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav ml-auto">
                            <li class="nav-item active"><a class="nav-link" href="#">Ana Sayfa</a></li>

                            <li class="nav-item dropdown">
                                <% if (Session["Kullanici"]==null) { %>
                                    <a class="nav-link btn btn-outline-primary btn-sm px-3 ml-2 rounded-pill"
                                        href="Login.aspx">
                                        <i class="fas fa-user mr-1"></i> Giriş Yap
                                    </a>
                                    <% } else { %>
                                        <a class="nav-link btn btn-outline-primary btn-sm px-3 ml-2 rounded-pill dropdown-toggle"
                                            href="#" id="navbarDropdown" role="button" data-toggle="dropdown"
                                            aria-haspopup="true" aria-expanded="false">
                                            <i class="fas fa-user mr-1"></i>
                                            <%= Session["Kullanici"] %>
                                        </a>
                                        <div class="dropdown-menu dropdown-menu-right shadow border-0"
                                            aria-labelledby="navbarDropdown">
                                            <a class="dropdown-item" href="Profilim.aspx"><i
                                                    class="fas fa-id-card mr-2 text-primary"></i>Profilim</a>
                                            <a class="dropdown-item" href="Profilim.aspx"><i
                                                    class="fas fa-box mr-2 text-info"></i>Siparişlerim</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item text-danger" href="Logout.aspx"><i
                                                    class="fas fa-sign-out-alt mr-2"></i>Çıkış Yap</a>
                                        </div>
                                        <% } %>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link btn btn-warning btn-sm px-3 ml-2 rounded-pill font-weight-bold text-dark"
                                    href="Sepet.aspx">
                                    <i class="fas fa-shopping-basket mr-1"></i> Sepetim
                                    <span class="badge badge-light ml-1" style="background: rgba(255,255,255,0.8);">
                                        <% var sepet=Session["Sepet"] as System.Collections.Generic.Dictionary<int, int>
                                            ;
                                            Response.Write(sepet != null ? sepet.Count : 0);
                                            %>
                                    </span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>

            <!-- Hero Section -->
            <div class="hero-section text-center">
                <div class="container">
                    <h1 class="display-4 font-weight-bold mb-3">En Yeni Teknolojileri Keşfet</h1>
                    <p class="lead mb-4" style="opacity: 0.9;">Bilgisayarlardan telefonlara, en premium ürünler burada.
                    </p>
                    <div class="input-group mb-3 mx-auto" style="max-width: 500px;">
                        <asp:TextBox ID="txtSearch" runat="server"
                            CssClass="form-control rounded-pill border-0 shadow py-4 pl-4" placeholder="Ürün ara...">
                        </asp:TextBox>
                        <div class="input-group-append pt-1" style="margin-left: -50px; z-index: 10;">
                            <asp:Button ID="btnAra" runat="server" Text="Ara"
                                CssClass="btn btn-primary rounded-pill px-4 shadow-sm" OnClick="btnAra_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Ürünler -->
            <section class="container pb-5">
                <div class="row">
                    <!-- Filtreler -->
                    <div class="col-md-3 mb-4">
                        <div class="card shadow-sm border-0 sticky-top" style="top: 90px;">
                            <div class="card-header bg-white font-weight-bold">
                                <i class="fas fa-filter mr-2 text-muted"></i> Kategori Filtrele
                            </div>
                            <div class="list-group list-group-flush">
                                <asp:Repeater ID="rptKategoriler" runat="server">
                                    <ItemTemplate>
                                        <a href='UrunVitrin.aspx?kat=<%# Eval("KategoriID") %>'
                                            class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                            <%# Eval("KategoriAdi") %>
                                                <span
                                                    class="badge badge-primary badge-pill bg-light text-primary border"><i
                                                        class="fas fa-chevron-right small"></i></span>
                                        </a>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <a href="UrunVitrin.aspx"
                                    class="list-group-item list-group-item-action text-danger font-weight-bold">Filtreyi
                                    Temizle</a>
                            </div>
                        </div>
                    </div>

                    <!-- Ürün Listesi -->
                    <div class="col-md-9">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="font-weight-bold mb-0 text-dark">Tüm Ürünler</h4>
                            <span class="text-muted small">
                                <asp:Label ID="lblUrunSayisi" runat="server"></asp:Label> ürün listeleniyor
                            </span>
                        </div>

                        <div class="row">
                            <asp:Repeater ID="rptUrunler" runat="server" OnItemCommand="rptUrunler_ItemCommand">
                                <ItemTemplate>
                                    <div class="col-md-4 col-sm-6 mb-4">
                                        <div class="card product-card h-100">
                                            <div class="category-badge shadow-sm">
                                                <%# Eval("KategoriAdi") %>
                                            </div>
                                            <img src='<%# Eval("ResimUrl") %>' class="card-img-top" alt="Urun Resmi"
                                                style="height: 250px; object-fit: contain; padding: 10px;">

                                            <div class="card-body d-flex flex-column">
                                                <h5 class="card-title font-weight-bold text-dark">
                                                    <%# Eval("UrunAdi") %>
                                                </h5>
                                                <p class="card-text text-muted small">
                                                    <%# Eval("KisaAciklama") %>
                                                </p>

                                                <div class="mt-auto">
                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                        <span class="price-tag">
                                                            <%# Eval("BirimFiyat", "{0:C}" ) %>
                                                        </span>
                                                        <small class="text-muted">
                                                            <%# Eval("Stok") %> Adet Stok
                                                        </small>
                                                    </div>
                                                    <div class="btn-group w-100 shadow-sm rounded-pill overflow-hidden">
                                                        <a href='UrunDetay.aspx?id=<%# Eval("UrunID") %>'
                                                            class="btn btn-light border-right font-weight-bold text-muted w-50">
                                                            <i class="fas fa-search mr-1"></i> İncele
                                                        </a>
                                                        <asp:LinkButton ID="btnSepeteEkle" runat="server"
                                                            CommandName="SepeteEkle"
                                                            CommandArgument='<%# Eval("UrunID") %>'
                                                            CssClass="btn btn-custom-primary font-weight-bold w-50">
                                                            <i class="fas fa-shopping-cart mr-1"></i> Sepete At
                                                        </asp:LinkButton>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Footer -->
            <footer class="bg-dark text-white py-4 mt-5">
                <div class="container text-center">
                    <p class="mb-0">&copy; <%= DateTime.Now.Year %> TeknoStore. Tüm Hakları Saklıdır.</p>
                    <small class="text-white-50">AdminLTE ve Bootstrap ile tasarlanmıştır.</small>
                </div>
            </footer>

            <!-- Modal (Ürün Detay) -->
            <div class="modal fade" id="urunModal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                    <div class="modal-content border-0 shadow-lg" style="border-radius: 20px; overflow: hidden;">
                        <div class="modal-header border-0 bg-light">
                            <h5 class="modal-title font-weight-bold text-primary" id="modalUrunAdi">Ürün Adı</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body p-0">
                            <div class="row no-gutters">
                                <div class="col-md-5 bg-white d-flex align-items-center justify-content-center p-4">
                                    <img src="https://via.placeholder.com/300" class="img-fluid rounded" alt="Ürün">
                                </div>
                                <div class="col-md-7 p-4 bg-light">
                                    <h6 class="font-weight-bold text-muted mb-3">Teknik Özellikler</h6>
                                    <div id="modalUrunDetaylari"
                                        class="table-responsive bg-white rounded shadow-sm p-3 border">
                                        <!-- Dinamik Tablo Buraya -->
                                    </div>
                                    <div class="mt-4 pt-3 border-top">
                                        <h3 class="text-success font-weight-bold mb-3" id="modalUrunFiyat">0.00 TL</h3>
                                        <button
                                            class="btn btn-custom-primary btn-block btn-lg rounded-pill shadow">Sepete
                                            Ekle</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </form>

        <!-- Scripts -->
        <script src="plugins/jquery/jquery.min.js"></script>
        <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>

        <script>
            function openUrunModal(ad, fiyat, detayHtml) {
                $('#modalUrunAdi').text(ad);
                $('#modalUrunFiyat').text(fiyat);
                $('#modalUrunDetaylari').html(detayHtml);
                $('#urunModal').modal('show');
            }
        </script>
    </body>

    </html>