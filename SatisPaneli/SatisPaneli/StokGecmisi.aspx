<%@ Page Title="Stok Hareket Geçmişi" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="StokGecmisi.aspx.cs" Inherits="SatisPaneli.StokGecmisi" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <section class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1>Stok Hareket Geçmişi</h1>
                    </div>
                </div>
            </div>
        </section>

        <section class="content">
            <div class="container-fluid">
                <div class="card shadow-lg border-0">
                    <div class="card-header bg-primary text-white">
                        <h3 class="card-title"><i class="fas fa-exchange-alt mr-2"></i> Son İşlemler</h3>
                    </div>
                    <div class="card-body table-responsive p-0">
                        <table class="table table-hover table-striped text-nowrap">
                            <thead class="bg-light">
                                <tr>
                                    <th>Tarih</th>
                                    <th>Ürün Adı</th>
                                    <th>İşlem Türü</th>
                                    <th>Miktar</th>
                                    <th>İlgili Kişi (Müşteri)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="Repeater1" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <%# Eval("IslemTarihi", "{0:dd.MM.yyyy HH:mm}" ) %>
                                            </td>
                                            <td class="font-weight-bold">
                                                <%# Eval("UrunAdi") %>
                                            </td>
                                            <td>
                                                <span class="badge badge-danger px-3 py-2">
                                                    <i class="fas fa-arrow-down mr-1"></i>
                                                    <%# Eval("IslemTuru") %>
                                                </span>
                                            </td>
                                            <td class="font-weight-bold text-danger">-<%# Eval("Miktar") %>
                                            </td>
                                            <td>
                                                <%# Eval("IlgiliKisi") %>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>

                        <div class="p-3 text-center">
                            <asp:Label ID="lblMesaj" runat="server" CssClass="text-muted font-italic" Visible="false">
                            </asp:Label>
                        </div>
                    </div>
                </div>

                <div class="alert alert-info mt-3 shadow-sm">
                    <h5><i class="icon fas fa-info"></i> Bilgi</h5>
                    Şu an sadece satış kaynaklı stok düşüşleri listelenmektedir. Stok giriş modülü eklendiğinde giriş
                    hareketleri de burada görünecektir.
                </div>
            </div>
        </section>
    </asp:Content>