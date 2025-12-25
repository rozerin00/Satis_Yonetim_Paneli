<%@ Page Title="Gelişmiş Satış Raporu" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="SatisRaporu.aspx.cs" Inherits="SatisPaneli.SatisRaporu" EnableEventValidation="false" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0 text-dark">Detaylı Satış Raporu</h1>
                    </div>
                </div>
            </div>
        </div>

        <section class="content">
            <asp:UpdatePanel ID="upRapor" runat="server">
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnExcel" />
                </Triggers>
                <ContentTemplate>
                    <div class="container-fluid">

                        <!-- ÖZET KARTLAR -->
                        <div class="row">
                            <div class="col-md-4 col-sm-6 col-12">
                                <div class="info-box shadow-sm">
                                    <span class="info-box-icon bg-success"><i class="fas fa-lira-sign"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Toplam Tutar</span>
                                        <span class="info-box-number">
                                            <%= OzetToplamTutar %>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 col-sm-6 col-12">
                                <div class="info-box shadow-sm">
                                    <span class="info-box-icon bg-info"><i class="fas fa-cubes"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Satılan Ürün Adedi</span>
                                        <span class="info-box-number">
                                            <%= OzetToplamAdet %>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 col-sm-6 col-12">
                                <div class="info-box shadow-sm">
                                    <span class="info-box-icon bg-warning"><i class="fas fa-file-invoice"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">İşlem Sayısı</span>
                                        <span class="info-box-number">
                                            <%= OzetIslemSayisi %>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- FİLTRELEME -->
                        <div class="card shadow-sm collapsed-card1">
                            <%-- İstersen varsayılan açık olsun --%>
                                <div class="card-header bg-light">
                                    <h3 class="card-title"><i class="fas fa-filter mr-1"></i> Filtreleme Seçenekleri
                                    </h3>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <!-- Tarih Aralığı -->
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Tarih Aralığı</label>
                                                <div class="input-group">
                                                    <asp:TextBox ID="txtBaslangic" runat="server" TextMode="Date"
                                                        CssClass="form-control"></asp:TextBox>
                                                    <div class="input-group-prepend input-group-append">
                                                        <span class="input-group-text"> - </span>
                                                    </div>
                                                    <asp:TextBox ID="txtBitis" runat="server" TextMode="Date"
                                                        CssClass="form-control"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Müşteri -->
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>Müşteri</label>
                                                <asp:DropDownList ID="ddlMusteriFiltre" runat="server"
                                                    CssClass="form-control select2" AppendDataBoundItems="true">
                                                    <asp:ListItem Text="Tümü" Value="0"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <!-- Ürün -->
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>Ürün</label>
                                                <asp:DropDownList ID="ddlUrunFiltre" runat="server"
                                                    CssClass="form-control select2" AppendDataBoundItems="true">
                                                    <asp:ListItem Text="Tümü" Value="0"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <!-- Butonlar -->
                                        <div class="col-md-2 d-flex align-items-end mb-3">
                                            <div class="btn-group w-100">
                                                <asp:Button ID="btnFiltrele" runat="server" Text="Uygula"
                                                    CssClass="btn btn-primary" OnClick="btnFiltrele_Click" />
                                                <asp:Button ID="btnTemizle" runat="server" Text="Temizle"
                                                    CssClass="btn btn-secondary" OnClick="btnTemizle_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        </div>

                        <!-- RAPOR TABLOSU -->
                        <div class="card shadow border-0 mt-3">
                            <div class="card-header border-0 d-flex justify-content-between align-items-center"
                                style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color:white;">
                                <h3 class="card-title"><i class="fas fa-list mr-1"></i> Satış Listesi</h3>
                                <div class="card-tools">
                                    <asp:LinkButton ID="btnExcel" runat="server"
                                        CssClass="btn btn-success btn-sm font-weight-bold" OnClick="btnExcel_Click">
                                        <i class="fas fa-file-excel mr-1"></i> Excel'e Aktar
                                    </asp:LinkButton>
                                </div>
                            </div>
                            <div class="card-body p-0 table-responsive">
                                <asp:GridView ID="gvSatisRaporu" runat="server" AutoGenerateColumns="False"
                                    CssClass="table table-hover table-striped text-nowrap" GridLines="None"
                                    EmptyDataText="Kriterlere uygun kayıt bulunamadı."
                                    EmptyDataRowStyle-CssClass="p-4 text-center text-muted">
                                    <Columns>
                                        <asp:BoundField DataField="DetayID" HeaderText="#" />
                                        <asp:BoundField DataField="Tarih" HeaderText="Tarih"
                                            DataFormatString="{0:dd.MM.yyyy HH:mm}" />
                                        <asp:BoundField DataField="MusteriAdSoyad" HeaderText="Müşteri" />
                                        <asp:BoundField DataField="UrunAd" HeaderText="Ürün" />
                                        <asp:BoundField DataField="Adet" HeaderText="Adet"
                                            ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="BirimFiyat" HeaderText="Birim Fiyat"
                                            DataFormatString="{0:C}" />
                                        <asp:BoundField DataField="ToplamTutar" HeaderText="Toplam"
                                            DataFormatString="{0:C}"
                                            ItemStyle-CssClass="text-success font-weight-bold" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>

                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </section>
    </asp:Content>