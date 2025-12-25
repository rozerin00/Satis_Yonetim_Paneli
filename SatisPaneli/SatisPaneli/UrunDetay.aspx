<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UrunDetay.aspx.cs" Inherits="SatisPaneli.UrunDetay" %>

    <!DOCTYPE html>
    <html lang="tr">

    <head runat="server">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ürün Detayı | TeknoStore</title>
        <link href="https://fonts.googleapis.com/css?family=Inter:300,400,600,700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
        <link rel="stylesheet" href="dist/css/adminlte.min.css">
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f4f6f9;
            }

            .product-image-container {
                background: #fff;
                border-radius: 20px;
                padding: 20px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                text-align: center;
            }

            .product-image {
                max-width: 100%;
                height: auto;
                max-height: 400px;
            }

            .price-tag {
                font-size: 2rem;
                font-weight: 800;
                color: #764ba2;
            }

            .feature-card {
                border: none;
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.02);
            }

            .btn-add-cart {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                color: white;
                padding: 15px 30px;
                font-size: 1.1rem;
                border-radius: 50px;
                transition: all 0.3s;
            }

            .btn-add-cart:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(118, 75, 162, 0.3);
                color: white;
            }

            .spec-table th {
                width: 40%;
                color: #6c757d;
                font-weight: 600;
            }

            .btn-circle {
                width: 35px;
                height: 35px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white !important;
            }

            .transition-3d-hover:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
            }

            .spec-table td {
                font-weight: 600;
                color: #343a40;
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm mb-4 sticky-top">
                <div class="container">
                    <a class="navbar-brand font-weight-bold text-primary" href="UrunVitrin.aspx">
                        <span style="color:#764ba2"><i class="fas fa-bolt mr-1"></i>Tekno</span>Store
                    </a>
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav ml-auto">
                            <li class="nav-item">
                                <a class="nav-link font-weight-bold" href="UrunVitrin.aspx">
                                    <i class="fas fa-arrow-left mr-1"></i> Alışverişe Dön
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>

            <div class="container pb-5">
                <div class="row">
                    <!-- Sol: Ürün Resmi -->
                    <div class="col-lg-6 mb-4">
                        <div class="product-image-container mb-3">
                            <img src="https://via.placeholder.com/600x600?text=Urun+Resmi" id="imgUrun" runat="server"
                                class="product-image" alt="Ürün Resmi" />
                        </div>
                        <div class="row px-2">
                            <div class="col-3 p-1"><img src="https://via.placeholder.com/150"
                                    class="img-fluid rounded border cursor-pointer" style="opacity:0.7"></div>
                            <div class="col-3 p-1"><img src="https://via.placeholder.com/150"
                                    class="img-fluid rounded border cursor-pointer" style="opacity:0.7"></div>
                            <div class="col-3 p-1"><img src="https://via.placeholder.com/150"
                                    class="img-fluid rounded border cursor-pointer" style="opacity:0.7"></div>
                        </div>

                        <!-- Sosyal Paylaşım ve Favoriler -->
                        <div class="d-flex justify-content-between align-items-center mt-4 px-2">
                            <button type="button"
                                class="btn btn-outline-danger rounded-pill px-4 shadow-sm transition-3d-hover">
                                <i class="far fa-heart mr-2"></i>Favorilere Ekle
                            </button>

                            <div class="d-flex align-items-center">
                                <span class="text-muted small font-weight-bold mr-3">PAYLAŞ:</span>
                                <a href="#" class="btn btn-sm btn-circle btn-primary mr-2 shadow-sm"><i
                                        class="fab fa-facebook-f"></i></a>
                                <a href="#" class="btn btn-sm btn-circle btn-info mr-2 shadow-sm"><i
                                        class="fab fa-twitter"></i></a>
                                <a href="#" class="btn btn-sm btn-circle btn-success shadow-sm"><i
                                        class="fab fa-whatsapp"></i></a>
                            </div>
                        </div>
                    </div>

                    <!-- Sağ: Ürün Detayları -->
                    <div class="col-lg-6">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb bg-transparent p-0 mb-2">
                                <li class="breadcrumb-item"><a href="UrunVitrin.aspx" class="text-muted">Ana Sayfa</a>
                                </li>
                                <li class="breadcrumb-item">
                                    <asp:Label ID="lblKategori" runat="server" CssClass="text-muted"></asp:Label>
                                </li>
                                <li class="breadcrumb-item active text-primary" aria-current="page">Ürün Detayı</li>
                            </ol>
                        </nav>

                        <h1 class="font-weight-bold mb-2 text-dark display-5">
                            <asp:Label ID="lblUrunAdi" runat="server"></asp:Label>
                        </h1>

                        <div class="mb-3">
                            <span class="badge badge-success px-3 py-2 rounded-pill"><i
                                    class="fas fa-check-circle mr-1"></i>Stokta Var</span>
                            <span class="mx-2 text-muted">|</span>
                            <span class="text-warning">
                                <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i
                                    class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                                <span class="text-muted ml-1 small">(4.8/5 Puan)</span>
                            </span>
                        </div>

                        <div class="price-tag mb-4">
                            <asp:Label ID="lblFiyat" runat="server"></asp:Label>
                        </div>

                        <p class="text-muted mb-4 lead" id="pAciklama" runat="server">
                            Bu ürün için henüz kısa açıklama girilmemiştir.
                        </p>

                        <div class="feature-card p-4 mb-4">
                            <div class="d-flex align-items-center mb-3">
                                <div class="mr-3">
                                    <label class="font-weight-bold mb-0 text-muted">Adet:</label>
                                </div>
                                <div class="input-group w-25">
                                    <div class="input-group-prepend">
                                        <button class="btn btn-outline-secondary btn-sm" type="button">-</button>
                                    </div>
                                    <input type="text" class="form-control form-control-sm text-center" value="1">
                                    <div class="input-group-append">
                                        <button class="btn btn-outline-secondary btn-sm" type="button">+</button>
                                    </div>
                                </div>
                            </div>

                            <asp:LinkButton ID="btnSepeteEkle" runat="server"
                                CssClass="btn btn-add-cart w-100 shadow-lg" OnClick="btnSepeteEkle_Click">
                                <i class="fas fa-shopping-bag mr-2"></i> Hemen Sepete Ekle
                            </asp:LinkButton>
                        </div>

                        <div class="row text-center text-muted small mb-4">
                            <div class="col-4 border-right">
                                <i class="fas fa-truck fa-2x mb-2 text-primary opacity-50"></i><br>Hızlı Teslimat
                            </div>
                            <div class="col-4 border-right">
                                <i class="fas fa-shield-alt fa-2x mb-2 text-primary opacity-50"></i><br>Güvenli Ödeme
                            </div>
                            <div class="col-4">
                                <i class="fas fa-undo fa-2x mb-2 text-primary opacity-50"></i><br>İade Garantisi
                            </div>
                        </div>

                    </div>
                </div>

                <!-- Detaylı Özellikler -->
                <div class="row mt-5">
                    <div class="col-12">
                        <ul class="nav nav-tabs mb-4" id="myTab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active font-weight-bold" id="desc-tab" data-toggle="tab" href="#desc"
                                    role="tab">Ürün Özellikleri</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link font-weight-bold" id="reviews-tab" data-toggle="tab" href="#reviews"
                                    role="tab">Yorumlar (0)</a>
                            </li>
                        </ul>
                        <div class="tab-content bg-white p-4 rounded shadow-sm" id="myTabContent">
                            <div class="tab-pane fade show active" id="desc" role="tabpanel">
                                <h5 class="font-weight-bold mb-4">Teknik Özellikler</h5>
                                <div class="table-responsive">
                                    <asp:Literal ID="litOzellikler" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="reviews" role="tabpanel">
                                <p class="text-muted">Bu ürün için henüz yorum yapılmamış.</p>
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