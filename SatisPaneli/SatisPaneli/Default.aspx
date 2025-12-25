<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="SatisPaneli._Default" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <!-- ChartJS -->
        <script src="plugins/chart.js/Chart.min.js"></script>

        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0 text-dark">Genel Bakış</h1>
                    </div>
                </div>
            </div>
        </div>

        <section class="content">
            <div class="container-fluid">
                <!-- 1. İSTATİSTİK KARTLARI -->
                <div class="row">
                    <!-- Toplam Kazanç -->
                    <div class="col-lg-3 col-6">
                        <div class="small-box bg-success shadow-sm">
                            <div class="inner">
                                <h3>
                                    <%= ToplamSatisTutar %>
                                </h3>
                                <p>Toplam Kazanç</p>
                            </div>
                            <div class="icon">
                                <i class="ion ion-cash"></i>
                            </div>
                            <a href="SatisRaporu.aspx" class="small-box-footer">Detaylar <i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <!-- Sipariş Sayısı -->
                    <div class="col-lg-3 col-6">
                        <div class="small-box bg-info shadow-sm">
                            <div class="inner">
                                <h3>
                                    <%= ToplamSiparis %>
                                </h3>
                                <p>Toplam Sipariş</p>
                            </div>
                            <div class="icon">
                                <i class="ion ion-bag"></i>
                            </div>
                            <a href="SatisRaporu.aspx" class="small-box-footer">Detaylar <i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <!-- Müşteri Sayısı -->
                    <div class="col-lg-3 col-6">
                        <div class="small-box bg-warning shadow-sm">
                            <div class="inner">
                                <h3>
                                    <%= ToplamMusteri %>
                                </h3>
                                <p>Kayıtlı Müşteri</p>
                            </div>
                            <div class="icon">
                                <i class="ion ion-person-add"></i>
                            </div>
                            <a href="MusteriYonetimi.aspx" class="small-box-footer">Detaylar <i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <!-- Kritik Stok -->
                    <div class="col-lg-3 col-6">
                        <div class="small-box bg-danger shadow-sm">
                            <div class="inner">
                                <h3>
                                    <%= KritikStok %>
                                </h3>
                                <p>Kritik Stok</p>
                            </div>
                            <div class="icon">
                                <i class="ion ion-pie-graph"></i>
                            </div>
                            <a href="UrunYonetimi.aspx?kritik=1" class="small-box-footer">Stokları Gör <i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                </div>

                <!-- 2. GRAFİKLER VE SON SATIŞLAR -->
                <div class="row">
                    <!-- Sol Kolon -->
                    <section class="col-lg-7 connectedSortable">
                        <div class="card shadow-sm">
                            <div class="card-header border-0">
                                <h3 class="card-title">
                                    <i class="fas fa-chart-line mr-1"></i>
                                    Son Satış Trendi
                                </h3>
                            </div>
                            <div class="card-body">
                                <canvas id="sales-chart" style="height: 300px;"></canvas>
                            </div>
                        </div>

                        <!-- Son Satışlar Tablosu -->
                        <div class="card shadow-sm mt-3">
                            <div class="card-header border-0">
                                <h3 class="card-title"><i class="fas fa-table mr-1"></i> Son 5 İşlem</h3>
                            </div>
                            <div class="card-body table-responsive p-0">
                                <table class="table table-striped table-valign-middle">
                                    <thead>
                                        <tr>
                                            <th>Müşteri</th>
                                            <th>Ürün</th>
                                            <th>Fiyat</th>
                                            <th>Tarih</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptSonSatislar" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td>
                                                        <%# Eval("Musteri") %>
                                                    </td>
                                                    <td>
                                                        <%# Eval("Urun") %>
                                                    </td>
                                                    <td class="text-success font-weight-bold">
                                                        <%# Eval("Toplam", "{0:C}" ) %>
                                                    </td>
                                                    <td>
                                                        <%# Eval("Tarih", "{0:dd.MM.yyyy}" ) %>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>

                    <!-- Sağ Kolon -->
                    <section class="col-lg-5 connectedSortable">
                        <!-- Kategori Grafiği -->
                        <div class="card shadow-sm bg-gradient-white">
                            <div class="card-header border-0">
                                <h3 class="card-title">
                                    <i class="fas fa-chart-pie mr-1"></i>
                                    Ürün Dağılımı
                                </h3>
                            </div>
                            <div class="card-body">
                                <canvas id="pie-chart" style="height: 300px;"></canvas>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </section>

        <!-- Grafik Scriptleri -->
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Verileri önce değişkenlere alıyoruz (IDE hatalarını önlemek için)
                var chartLabels = <%= ChartLabels %>;
                var chartData = <%= ChartData %>;
                var pieLabels = <%= PieLabels %>;
                var pieData = <%= PieData %>;

                // Line Chart (Satış Trendi)
                var ctx = document.getElementById('sales-chart').getContext('2d');
                var salesChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: chartLabels,
                        datasets: [{
                            label: 'Satış Tutarı (TL)',
                            data: chartData,
                            backgroundColor: 'rgba(60,141,188,0.2)',
                            borderColor: 'rgba(60,141,188,1)',
                            pointRadius: 4,
                            pointBackgroundColor: '#3b8bba',
                            pointBorderColor: 'rgba(60,141,188,1)',
                            pointHoverRadius: 5,
                            fill: true
                        }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        responsive: true,
                        scales: {
                            xAxes: [{ gridLines: { display: false } }],
                            yAxes: [{ gridLines: { display: true } }]
                        }
                    }
                });

                // Pie Chart (Kategori Dağılımı)
                var ctxPie = document.getElementById('pie-chart').getContext('2d');
                var pieChart = new Chart(ctxPie, {
                    type: 'doughnut',
                    data: {
                        labels: pieLabels,
                        datasets: [{
                            data: pieData,
                            backgroundColor: ['#f56954', '#00a65a', '#f39c12', '#00c0ef', '#3c8dbc', '#d2d6de'],
                        }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        responsive: true,
                    }
                });
            });
        </script>
    </asp:Content>