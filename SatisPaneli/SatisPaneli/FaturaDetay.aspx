<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FaturaDetay.aspx.cs" Inherits="SatisPaneli.FaturaDetay" %>

    <!DOCTYPE html>
    <html lang="tr">

    <head>
        <meta charset="utf-8">
        <title>Fatura #<%= FisNo %>
        </title>
        <!-- Stil: Basit bir fatura tasarımı -->
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                padding: 20px;
                color: #333;
            }

            .invoice-box {
                max-width: 800px;
                margin: auto;
                padding: 30px;
                border: 1px solid #eee;
                box-shadow: 0 0 10px rgba(0, 0, 0, .15);
            }

            .invoice-header {
                display: flex;
                justify-content: space-between;
                margin-bottom: 20px;
            }

            .company-info h2 {
                margin: 0;
                color: #333;
            }

            .invoice-details {
                text-align: right;
            }

            table {
                width: 100%;
                line-height: inherit;
                text-align: left;
                border-collapse: collapse;
                margin-top: 20px;
            }

            table th {
                background: #eee;
                border-bottom: 1px solid #ddd;
                font-weight: bold;
                padding: 10px;
            }

            table td {
                padding: 10px;
                border-bottom: 1px solid #eee;
            }

            .total-row td {
                border-top: 2px solid #333;
                font-weight: bold;
                font-size: 1.2em;
            }

            .footer {
                margin-top: 30px;
                text-align: center;
                font-size: 0.8em;
                color: #777;
            }

            /* Yazdırma ayarları */
            @media print {
                .no-print {
                    display: none;
                }

                .invoice-box {
                    border: none;
                    box-shadow: none;
                }
            }
        </style>
    </head>

    <body>
        <div class="no-print" style="text-align:center; margin-bottom: 20px;">
            <button onclick="window.print()"
                style="padding: 10px 20px; background: #007bff; color: white; border: none; cursor: pointer; border-radius: 5px; font-size: 16px;">Yazdır
                / PDF Kaydet</button>
            <button onclick="window.close()"
                style="padding: 10px 20px; background: #6c757d; color: white; border: none; cursor: pointer; border-radius: 5px; font-size: 16px; margin-left: 10px;">Kapat</button>
        </div>

        <div class="invoice-box">
            <div class="invoice-header">
                <div class="company-info">
                    <h2>SATIS PANELI</h2>
                    <p>Örnek Mahallesi, 123. Sokak No:1<br>İSTANBUL</p>
                </div>
                <div class="invoice-details">
                    <h3>SATIŞ FİŞİ</h3>
                    <p>
                        <strong>Fiş No:</strong> #<%= FisNo %><br>
                            <strong>Tarih:</strong>
                            <%= Tarih.ToString("dd.MM.yyyy HH:mm") %><br>
                                <strong>Müşteri:</strong>
                                <%= MusteriAdi %>
                    </p>
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Ürün</th>
                        <th style="text-align: center;">Adet</th>
                        <th style="text-align: right;">Birim Fiyat</th>
                        <th style="text-align: right;">Tutar</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptFaturaDetay" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <%# Eval("UrunAdi") %>
                                </td>
                                <td style="text-align: center;">
                                    <%# Eval("Adet") %>
                                </td>
                                <td style="text-align: right;">
                                    <%# Eval("BirimFiyat", "{0:C}" ) %>
                                </td>
                                <td style="text-align: right;">
                                    <%# Eval("Tutar", "{0:C}" ) %>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>

                    <tr class="total-row">
                        <td colspan="3" style="text-align: right;">GENEL TOPLAM:</td>
                        <td style="text-align: right;">
                            <%= string.Format("{0:C}", GenelToplam) %>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="footer">
                <p>Bizi tercih ettiğiniz için teşekkür ederiz.</p>
                <p>Bu belge bilgilendirme amaçlıdır.</p>
            </div>
        </div>
    </body>

    </html>