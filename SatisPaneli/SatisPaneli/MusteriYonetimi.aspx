<%@ Page Title="Müşteri Yönetimi" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="MusteriYonetimi.aspx.cs" Inherits="SatisPaneli.MusteriYonetimi" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <section class="content-header">
            <div class="container">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1>Müşteri Yönetimi</h1>
                    </div>
                </div>
            </div>
        </section>

        <section class="content">
            <div class="container">

                <!-- Müşteri Ekleme Paneli -->
                <div class="card shadow-lg border-0">
                    <div class="card-header text-white"
                        style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                        <h3 class="card-title"><i class="fas fa-user-plus mr-2"></i> Yeni Müşteri Ekle</h3>
                    </div>
                    <div class="card-body">
                        <asp:HiddenField ID="hfMusteriID" runat="server" />

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="font-weight-bold">Ad Soyad</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    </div>
                                    <asp:TextBox ID="txtAdSoyad" runat="server" CssClass="form-control"
                                        placeholder="Müşteri Adı Soyadı"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="font-weight-bold">Telefon</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                    </div>
                                    <asp:TextBox ID="txtTelefon" runat="server" CssClass="form-control"
                                        placeholder="(5XX) XXX XX XX"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label class="font-weight-bold">Adres</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
                                    </div>
                                    <asp:TextBox ID="txtAdres" runat="server" CssClass="form-control"
                                        TextMode="MultiLine" Rows="2" placeholder="Müşteri Adresi"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 text-right">
                                <asp:Button ID="btnKaydet" runat="server" Text="Kaydet"
                                    CssClass="btn btn-success shadow-sm font-weight-bold" OnClick="btnKaydet_Click" />
                                <asp:Button ID="btnVazgec" runat="server" Text="Vazgeç"
                                    CssClass="btn btn-secondary shadow-sm font-weight-bold ml-2" Visible="false"
                                    OnClick="btnVazgec_Click" />
                            </div>
                        </div>
                        <asp:Label ID="lblMesaj" runat="server" CssClass="mt-2 d-block text-center font-weight-bold">
                        </asp:Label>
                    </div>
                </div>

                <!-- Müşteri Listesi -->
                <div class="card shadow-lg border-0 mt-4">
                    <div class="card-header bg-white border-bottom-0">
                        <h3 class="card-title text-primary"><i class="fas fa-users mr-2"></i> Kayıtlı Müşteriler</h3>
                    </div>
                    <div class="card-body p-0 table-responsive">
                        <asp:GridView ID="gvMusteriler" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-hover table-striped text-nowrap" GridLines="None"
                            DataKeyNames="MusteriID" OnRowDeleting="gvMusteriler_RowDeleting">
                            <Columns>
                                <asp:BoundField DataField="MusteriID" HeaderText="ID" ItemStyle-Width="5%" />
                                <asp:BoundField DataField="AdSoyad" HeaderText="Ad Soyad" />
                                <asp:BoundField DataField="Telefon" HeaderText="Telefon" />
                                <asp:BoundField DataField="Adres" HeaderText="Adres" />
                                <asp:TemplateField HeaderText="İşlemler" ItemStyle-Width="20%">
                                    <ItemTemplate>
                                        <asp:Button ID="btnDuzenle" runat="server" Text="Düzenle"
                                            CommandArgument='<%# Eval("MusteriID") %>'
                                            CssClass="btn btn-outline-primary btn-sm rounded-pill px-3 mr-1"
                                            OnClick="btnDuzenle_Click" />

                                        <asp:Button ID="btnSil" runat="server" CommandName="Delete" Text="Sil"
                                            CssClass="btn btn-outline-danger btn-sm rounded-pill px-3"
                                            OnClientClick="return confirm('Bu müşteriyi silmek satış kayıtlarını etkileyebilir. Emin misiniz?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="bg-light text-muted border-bottom" />
                            <EmptyDataTemplate>
                                <div class="p-4 text-center text-muted">Kayıtlı müşteri bulunamadı.</div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>

            </div>
        </section>
    </asp:Content>