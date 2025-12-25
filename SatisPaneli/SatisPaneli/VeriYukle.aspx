<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VeriYukle.aspx.cs" Inherits="SatisPaneli.VeriYukle" %>

    <!DOCTYPE html>
    <html lang="tr">

    <head runat="server">
        <title>Veri Yükleme Aracı</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    </head>

    <body>
        <form id="form1" runat="server">
            <div class="container mt-5">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h3>Otomatik Ürün Bilgisi Doldurma Aracı</h3>
                    </div>
                    <div class="card-body">
                        <p>Bu araç, veritabanındaki mevcut ürünleri analiz eder ve kategori/isimlerine göre uygun teknik
                            özellikler (JSON) ve açıklamalar oluşturup kaydeder.</p>
                        <asp:Button ID="btnYukle" runat="server" Text="Ürün Bilgilerini Otomatik Doldur"
                            CssClass="btn btn-success btn-lg btn-block" OnClick="btnYukle_Click" />

                        <hr />

                        <div class="mt-4">
                            <h5>İşlem Sonuçları:</h5>
                            <asp:GridView ID="gvSonuc" runat="server" CssClass="table table-bordered table-striped"
                                AutoGenerateColumns="true">
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </body>

    </html>