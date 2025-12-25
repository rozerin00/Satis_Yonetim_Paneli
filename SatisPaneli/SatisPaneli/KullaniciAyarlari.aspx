<%@ Page Title="Kullanıcı Ayarları" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="KullaniciAyarlari.aspx.cs" Inherits="SatisPaneli.KullaniciAyarlari" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <section class="content-header">
            <div class="container">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1>Ayarlar</h1>
                    </div>
                </div>
            </div>
        </section>

        <section class="content">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 mx-auto">
                        <div class="card shadow-lg border-0">
                            <div class="card-header text-white text-center py-3"
                                style="background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);">
                                <h4 class="mb-0 card-title float-none font-weight-bold"><i
                                        class="fas fa-user-shield mr-2"></i> Profil Ayarları</h4>
                            </div>
                            <div class="card-body p-4">
                                <div class="form-group mb-3">
                                    <label class="font-weight-bold">Kullanıcı Adı</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                                        </div>
                                        <asp:TextBox ID="txtKullaniciAdi" runat="server" CssClass="form-control"
                                            ReadOnly="true"></asp:TextBox>
                                    </div>
                                    <small class="text-muted"><i class="fas fa-info-circle"></i> Kullanıcı adı
                                        değiştirilemez.</small>
                                </div>

                                <div class="form-group mb-3">
                                    <label class="font-weight-bold">Yeni Şifre</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                        </div>
                                        <asp:TextBox ID="txtYeniSifre" runat="server" CssClass="form-control"
                                            TextMode="Password" placeholder="Yeni şifrenizi girin"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="form-group mb-4">
                                    <label class="font-weight-bold">Şifre Tekrar</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-check-double"></i></span>
                                        </div>
                                        <asp:TextBox ID="txtSifreTekrar" runat="server" CssClass="form-control"
                                            TextMode="Password" placeholder="Şifrenizi tekrar girin"></asp:TextBox>
                                    </div>
                                </div>

                                <asp:Button ID="btnSifreGuncelle" runat="server" Text="Şifremi Güncelle"
                                    CssClass="btn btn-warning btn-block shadow font-weight-bold text-white"
                                    OnClick="btnSifreGuncelle_Click"
                                    style="background: linear-gradient(135deg, #f6d365 0%, #fda085 100%); border:none;" />

                                <div class="mt-3 text-center">
                                    <asp:Label ID="lblProfilMesaj" runat="server" CssClass="font-weight-bold">
                                    </asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </asp:Content>