<%@ Page Title="Proje Sunumu" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="Sunum.aspx.cs" Inherits="SatisPaneli.Sunum" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <style>
            .presentation-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 4rem 2rem;
                border-radius: 20px;
                margin-bottom: 3rem;
                box-shadow: 0 10px 30px rgba(118, 75, 162, 0.3);
                text-align: center;
                position: relative;
                overflow: hidden;
            }

            .presentation-header::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 60%);
                animation: rotate 20s linear infinite;
            }

            @keyframes rotate {
                from {
                    transform: rotate(0deg);
                }

                to {
                    transform: rotate(360deg);
                }
            }

            .section-title {
                text-align: center;
                font-weight: 700;
                color: #444;
                margin-bottom: 3rem;
                text-transform: uppercase;
                letter-spacing: 2px;
                position: relative;
            }

            .section-title::after {
                content: '';
                display: block;
                width: 50px;
                height: 3px;
                background: #764ba2;
                margin: 15px auto 0;
                border-radius: 2px;
            }

            .tech-card {
                background: white;
                border-radius: 15px;
                padding: 20px;
                text-align: center;
                transition: all 0.3s ease;
                height: 100%;
                border: 1px solid rgba(0, 0, 0, 0.05);
                cursor: pointer;
            }

            .tech-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            }

            .tech-icon {
                font-size: 2.5rem;
                margin-bottom: 15px;
                background: -webkit-linear-gradient(45deg, #667eea, #764ba2);
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .feature-item {
                display: flex;
                align-items: center;
                margin-bottom: 30px;
                background: white;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                transition: all 0.3s ease;
            }

            .feature-item:hover {
                transform: translateX(10px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            }

            .feature-icon-box {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 20px;
                font-size: 1.5rem;
                color: white;
                flex-shrink: 0;
            }

            .bg-gradient-blue {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            }

            .bg-gradient-green {
                background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            }

            .bg-gradient-purple {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }

            .bg-gradient-pink {
                background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 99%, #fecfef 100%);
            }

            .closing-card {
                background: #343a40;
                color: white;
                border-radius: 20px;
                padding: 3rem;
                text-align: center;
                margin-top: 4rem;
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <!-- Main Content -->
        <section class="content" style="padding-top: 20px;">
            <div class="container">

                <!-- Hero Section -->
                <div class="presentation-header">
                    <h1 class="font-weight-bold display-4">Sat&#305;&#351; Y&#246;netim Paneli</h1>
                    <p class="lead mt-3">Modern web teknolojileri ile geli&#351;tirilmi&#351;, kullan&#305;c&#305; dostu
                        stok ve sat&#305;&#351; takip
                        sistemi.</p>
                    <div class="mt-4">
                        <span class="badge badge-light badge-pill px-3 py-2 mr-2">v1.0.0</span>
                        <span class="badge badge-light badge-pill px-3 py-2">2025</span>
                    </div>
                </div>

                <!-- About Section -->
                <div class="row mb-5">
                    <div class="col-lg-8 mx-auto text-center">
                        <p class="lead text-muted">
                            Bu proje, i&#351;letmelerin &#252;r&#252;n envanterlerini y&#246;netmelerini,
                            h&#305;zl&#305; sat&#305;&#351; yapmalar&#305;n&#305;
                            ve detayl&#305; finansal raporlar almalar&#305;n&#305; sa&#287;lamak amac&#305;yla
                            tasarlanm&#305;&#351;t&#305;r.
                            Kullan&#305;c&#305; deneyimi ve performans odakl&#305; geli&#351;tirilmi&#351;tir.
                        </p>
                    </div>
                </div>

                <!-- Technologies -->
                <h2 class="section-title">Kullan&#305;lan Teknolojiler</h2>
                <div class="row mb-5">
                    <div class="col-md-2 col-sm-4 col-6 mb-3">
                        <div class="tech-card" data-toggle="modal" data-target="#techModal" data-title="ASP.NET"
                            data-desc="Projenin backend altyapısı için ASP.NET teknolojisi kullanılmıştır. Güçlü sunucu taraflı işlem yetenekleri, güvenlik mekanizmaları ve geniş kütüphane desteği sayesinde verimli bir uygulama geliştirme süreci sağlanmıştır.">
                            <i class="fab fa-microsoft tech-icon"></i>
                            <h6 class="font-weight-bold">ASP.NET</h6>
                        </div>
                    </div>
                    <div class="col-md-2 col-sm-4 col-6 mb-3">
                        <div class="tech-card" data-toggle="modal" data-target="#techModal" data-title="SQL Server"
                            data-desc="Verilerin güvenli ve düzenli bir şekilde saklanması için Microsoft SQL Server tercih edilmiştir. İlişkisel veritabanı yapısı, stored procedure'ler ve gelişmiş sorgulama yetenekleri ile veri bütünlüğü ve performansı optimize edilmiştir.">
                            <i class="fas fa-database tech-icon"></i>
                            <h6 class="font-weight-bold">SQL Server</h6>
                        </div>
                    </div>
                    <div class="col-md-2 col-sm-4 col-6 mb-3">
                        <div class="tech-card" data-toggle="modal" data-target="#techModal"
                            data-title="Entity Framework"
                            data-desc="Veritabanı işlemlerini nesne tabanlı (ORM) bir yaklaşımla yönetmek için Entity Framework kullanılmıştır. Bu sayede karmaşık SQL sorguları yerine LINQ teknolojisi ile daha okunaklı ve bakımı kolay bir kod yapısı oluşturulmuştur.">
                            <i class="fas fa-code tech-icon"></i>
                            <h6 class="font-weight-bold">Entity FX</h6>
                        </div>
                    </div>
                    <div class="col-md-2 col-sm-4 col-6 mb-3">
                        <div class="tech-card" data-toggle="modal" data-target="#techModal" data-title="Bootstrap 4"
                            data-desc="Kullanıcı arayüzünün (UI) her türlü cihazda (mobil, tablet, masaüstü) kusursuz görünmesi için Bootstrap 4 framework'ü kullanılmıştır. Grid sistemi ve hazır bileşenleri ile responsive bir tasarım elde edilmiştir.">
                            <i class="fab fa-bootstrap tech-icon"></i>
                            <h6 class="font-weight-bold">Bootstrap 4</h6>
                        </div>
                    </div>
                    <div class="col-md-2 col-sm-4 col-6 mb-3">
                        <div class="tech-card" data-toggle="modal" data-target="#techModal" data-title="HTML5 / CSS3"
                            data-desc="Modern web standartlarına uygun, semantik HTML yapısı ve CSS3 ile zenginleştirilmiş görsel efektler kullanılmıştır. Animasyonlar ve geçiş efektleri ile kullanıcı deneyimi iyileştirilmiştir.">
                            <i class="fab fa-html5 tech-icon"></i>
                            <h6 class="font-weight-bold">HTML5/CSS3</h6>
                        </div>
                    </div>
                    <div class="col-md-2 col-sm-4 col-6 mb-3">
                        <div class="tech-card" data-toggle="modal" data-target="#techModal" data-title="AdminLTE"
                            data-desc="Profesyonel ve kullanıcı dostu bir yönetim paneli arayüzü sağlamak amacıyla AdminLTE teması entegre edilmiştir. Bu tema, modern dashboard bileşenleri ve şık tasarımı ile projeye değer katmıştır.">
                            <i class="fas fa-layer-group tech-icon"></i>
                            <h6 class="font-weight-bold">AdminLTE</h6>
                        </div>
                    </div>
                </div>

                <!-- Modules -->
                <h2 class="section-title">Proje Mod&#252;lleri</h2>
                <div class="row">
                    <!-- 1. Dashboard -->
                    <div class="col-md-4">
                        <div class="feature-item">
                            <div class="feature-icon-box bg-gradient-blue">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div>
                                <h5 class="font-weight-bold">Dashboard & Analiz</h5>
                                <p class="text-muted mb-0">Anlık satış grafikleri, kategori dağılımı ve önemli
                                    istatistiklerin görsel özeti.</p>
                            </div>
                        </div>
                    </div>
                    <!-- 2. Stok & Kritik Uyarı -->
                    <div class="col-md-4">
                        <div class="feature-item">
                            <div class="feature-icon-box bg-danger"
                                style="background: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div>
                                <h5 class="font-weight-bold">Akıllı Stok Takibi</h5>
                                <p class="text-muted mb-0">Kritik seviyeye (10 altı) düşen ürünler için otomatik
                                    filtreleme ve uyarı sistemi.</p>
                            </div>
                        </div>
                    </div>
                    <!-- 3. Satış & Sepet -->
                    <div class="col-md-4">
                        <div class="feature-item">
                            <div class="feature-icon-box bg-gradient-green">
                                <i class="fas fa-shopping-basket"></i>
                            </div>
                            <div>
                                <h5 class="font-weight-bold">Satış & Sepet</h5>
                                <p class="text-muted mb-0">Dinamik sepet mantığı ile birden fazla ürünü tek seferde
                                    satma ve faturalandırma.</p>
                            </div>
                        </div>
                    </div>
                    <!-- 4. Müşteri -->
                    <div class="col-md-4">
                        <div class="feature-item">
                            <div class="feature-icon-box bg-gradient-purple">
                                <i class="fas fa-users"></i>
                            </div>
                            <div>
                                <h5 class="font-weight-bold">Müşteri (CRM)</h5>
                                <p class="text-muted mb-0">Müşteri kayıt, adres takibi ve geçmiş siparişlerin detaylı
                                    yönetimi.</p>
                            </div>
                        </div>
                    </div>
                    <!-- 5. Raporlama -->
                    <div class="col-md-4">
                        <div class="feature-item">
                            <div class="feature-icon-box bg-gradient-pink">
                                <i class="fas fa-file-excel"></i>
                            </div>
                            <div>
                                <h5 class="font-weight-bold">Gelişmiş Raporlama</h5>
                                <p class="text-muted mb-0">Satış verilerini filtreleme ve tek tıkla Excel formatında
                                    dışa aktarma (Export).</p>
                            </div>
                        </div>
                    </div>
                    <!-- 6. Güvenlik -->
                    <div class="col-md-4">
                        <div class="feature-item">
                            <div class="feature-icon-box bg-warning"
                                style="background: linear-gradient(135deg, #fce38a 0%, #f38181 100%);">
                                <i class="fas fa-user-shield"></i>
                            </div>
                            <div>
                                <h5 class="font-weight-bold">Rol Bazlı Güvenlik</h5>
                                <p class="text-muted mb-0">Yönetici ve Personel ayrımı ile sayfa ve işlem bazlı
                                    (Silme/Düzenleme) yetkilendirme.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Closing -->
                <div class="closing-card shadow-lg">
                    <h2 class="font-weight-light">Dinledi&#287;iniz i&#231;in Te&#351;ekk&#252;rler!</h2>
                    <hr class="border-secondary my-4 w-50 mx-auto">
                    <p class="lead">Sorularınız ve geri bildirimleriniz için hazırım.</p>
                </div>

            </div>
            <!-- Tech Details Modal -->
            <div class="modal fade" id="techModal" tabindex="-1" role="dialog" aria-labelledby="techModalLabel"
                aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
                        <div class="modal-header border-0 bg-gradient-purple text-white"
                            style="border-radius: 20px 20px 0 0;">
                            <h5 class="modal-title font-weight-bold" id="techModalLabel">Teknoloji Detayı</h5>
                            <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body p-4 text-center">
                            <div class="tech-icon-large mb-3" style="font-size: 3rem; color: #764ba2;">
                                <!-- Icon will be inserted here via JS -->
                            </div>
                            <p id="techModalDesc" class="lead text-muted"></p>
                        </div>
                        <div class="modal-footer border-0 justify-content-center">
                            <button type="button" class="btn btn-secondary px-4 rounded-pill"
                                data-dismiss="modal">Kapat</button>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                // Executed when the modal is about to show
                $('#techModal').on('show.bs.modal', function (event) {
                    var button = $(event.relatedTarget) // Button that triggered the modal
                    var title = button.data('title') // Extract info from data-* attributes
                    var desc = button.data('desc')
                    var iconClass = button.find('i').attr('class'); // Extract icon class

                    var modal = $(this)
                    modal.find('.modal-title').text(title)
                    modal.find('#techModalDesc').text(desc)

                    // Update large icon in modal
                    var largeIcon = modal.find('.tech-icon-large');
                    largeIcon.empty(); // Clear previous
                    largeIcon.append('<i class="' + iconClass + '"></i>');
                })
            </script>
        </section>
    </asp:Content>