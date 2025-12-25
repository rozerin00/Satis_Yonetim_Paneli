<%@ Page Title="Satış ve Sepet İşlemleri" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="SatisYap.aspx.cs" Inherits="SatisPaneli.SatisYap" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <section class="content-header">
            <div class="container">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1>Satış Terminali (POS)</h1>
                    </div>
                </div>
            </div>
        </section>

        <section class="content">
            <asp:UpdatePanel ID="upSatis" runat="server">
                <ContentTemplate>
                    <div class="container">
                        <div class="row">
                            <!-- SOL KOLON: Ürün ve Müşteri Seçimi -->
                            <div class="col-md-5">
                                <div class="card shadow-lg border-0">
                                    <div class="card-header text-white"
                                        style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                                        <h3 class="card-title"><i class="fas fa-cart-plus mr-2"></i> Ürün Ekle</h3>
                                    </div>
                                    <div class="card-body">
                                        <!-- Müşteri Seçimi -->
                                        <h5 class="text-muted"><i class="fas fa-user mr-1"></i> Müşteri</h5>
                                        <hr />
                                        <div class="form-group">
                                            <label>Kayıtlı Müşteri</label>
                                            <asp:DropDownList ID="ddlMusteri" runat="server"
                                                CssClass="form-control select2">
                                            </asp:DropDownList>
                                        </div>
                                        <div class="form-group">
                                            <label>veya Yeni Müşteri Adı</label>
                                            <asp:TextBox ID="txtYeniMusteriAd" runat="server" CssClass="form-control"
                                                placeholder="Hızlı Müşteri Ekle..."></asp:TextBox>
                                        </div>

                                        <!-- Ürün Seçimi -->
                                        <h5 class="text-muted mt-4"><i class="fas fa-box-open mr-1"></i> Ürün</h5>
                                        <hr />
                                        <div class="form-group">
                                            <label>Kategori</label>
                                            <asp:DropDownList ID="ddlKategori" runat="server" CssClass="form-control"
                                                AutoPostBack="true"
                                                OnSelectedIndexChanged="ddlKategori_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                        <div class="form-group">
                                            <label>Ürün</label>
                                            <asp:DropDownList ID="ddlUrun" runat="server"
                                                CssClass="form-control select2">
                                            </asp:DropDownList>
                                        </div>
                                        <div class="form-group">
                                            <label>Adet</label>
                                            <div class="input-group">
                                                <div class="input-group-prepend">
                                                    <span class="input-group-text">#</span>
                                                </div>
                                                <asp:TextBox ID="txtAdet" runat="server" CssClass="form-control"
                                                    TextMode="Number" Text="1"></asp:TextBox>
                                            </div>
                                        </div>

                                        <asp:Button ID="btnSepeteEkle" runat="server" Text="Sepete Ekle"
                                            CssClass="btn btn-outline-success btn-block font-weight-bold mt-3"
                                            OnClick="btnSepeteEkle_Click" />

                                        <asp:Label ID="lblSatisMesaj" runat="server"
                                            CssClass="d-block mt-2 text-center font-weight-bold"></asp:Label>
                                    </div>
                                </div>
                            </div>

                            <!-- SAĞ KOLON: Sepet Özeti -->
                            <div class="col-md-7">
                                <asp:Panel ID="pnlSepet" runat="server" Visible="false">
                                    <div class="card shadow-lg border-0">
                                        <div class="card-header bg-dark text-white">
                                            <h3 class="card-title"><i class="fas fa-shopping-basket mr-2"></i> Sepetim
                                            </h3>
                                        </div>
                                        <div class="card-body p-0 table-responsive">
                                            <asp:GridView ID="gvSepet" runat="server" AutoGenerateColumns="False"
                                                CssClass="table table-striped table-hover mb-0" GridLines="None"
                                                DataKeyNames="UrunID" OnRowDeleting="gvSepet_RowDeleting">
                                                <Columns>
                                                    <asp:BoundField DataField="UrunAdi" HeaderText="Ürün" />
                                                    <asp:BoundField DataField="BirimFiyat" HeaderText="Fiyat"
                                                        DataFormatString="{0:C}" />
                                                    <asp:BoundField DataField="Adet" HeaderText="Adet" />
                                                    <asp:BoundField DataField="ToplamTutar" HeaderText="Toplam"
                                                        DataFormatString="{0:C}" ItemStyle-Font-Bold="true" />
                                                    <asp:CommandField ShowDeleteButton="True"
                                                        DeleteText="<i class='fas fa-trash-alt'></i>"
                                                        ControlStyle-CssClass="btn btn-danger btn-sm text-white">
                                                        <ItemStyle Width="50px" />
                                                    </asp:CommandField>
                                                </Columns>
                                                <EmptyDataTemplate>
                                                    <div class="p-3 text-center text-muted">Sepetiniz boş.</div>
                                                </EmptyDataTemplate>
                                            </asp:GridView>
                                        </div>
                                        <div class="card-footer bg-light">
                                            <div class="row align-items-center">
                                                <div class="col-6">
                                                    <h4>Toplam: <asp:Label ID="lblGenelToplam" runat="server"
                                                            Text="0.00 ₺" CssClass="text-success font-weight-bold">
                                                        </asp:Label>
                                                    </h4>
                                                </div>
                                                <div class="col-6 text-right">
                                                    <asp:Button ID="btnSatisTamamla" runat="server"
                                                        Text="Satışı Tamamla"
                                                        CssClass="btn btn-primary btn-lg shadow font-weight-bold"
                                                        OnClick="btnSatisTamamla_Click" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <% if (pnlSepet.Visible==false) { %>
                                    <div class="alert alert-info text-center mt-5 shadow-sm">
                                        <h4><i class="fas fa-info-circle"></i> Sepetiniz Boş</h4>
                                        <p>Sol taraftan ürün seçip sepete ekleyebilirsiniz.</p>
                                    </div>
                                    <% } %>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </section>
    </asp:Content>