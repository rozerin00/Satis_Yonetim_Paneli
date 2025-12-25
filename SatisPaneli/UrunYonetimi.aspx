<%@ Page Title="Ürün Yönetimi" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UrunYonetimi.aspx.cs" Inherits="SatisPaneli.UrunYonetimi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container mt-4">
        <h3>Ürün Yönetimi</h3>
        <hr />

        <div class="card mb-4 shadow-sm">
            <div class="card-header bg-primary text-white">
                <i class="fas fa-plus-circle"></i> Yeni Ürün Ekle
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-5 mb-3">
                        <label class="form-label">Ürün Adı</label>
                        <asp:TextBox ID="txturunad" runat="server" CssClass="form-control" placeholder="Ürün adını giriniz"></asp:TextBox>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Birim Fiyatı</label>
                        <asp:TextBox ID="txtBirimFiyat" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                    </div>
                    <div class="col-md-3 mb-3 d-flex align-items-end">
                        <asp:Button ID="btnkaydet" runat="server" Text="Kaydet" CssClass="btn btn-success w-100" OnClick="btnkaydet_Click" />
                    </div>
                </div>
                <asp:Label ID="lblMesaj" runat="server" Text="" CssClass="mt-2 d-block"></asp:Label>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-dark text-white">
                <i class="fas fa-table"></i> Mevcut Ürün Listesi
            </div>
            <div class="card-body">
                <asp:GridView ID="GridView1" runat="server" 
                    AutoGenerateColumns="True" 
                    CssClass="table table-bordered table-hover table-striped" 
                    GridLines="None">
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>