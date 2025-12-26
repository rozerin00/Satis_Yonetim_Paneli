<%@ Page Title="Ürün Yönetimi" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="UrunYonetimi.aspx.cs" Inherits="SatisPaneli.UrunYonetimi" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <section class="content-header">
            <div class="container">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1>Ürün Yönetimi</h1>
                    </div>
                </div>
            </div>
        </section>

        <section class="content">
            <div class="container">
                <div class="card shadow-lg border-0">
                    <div class="card-header text-white"
                        style="background: linear-gradient(135deg, #2af598 0%, #009efd 100%);">
                        <h3 class="card-title"><i class="fas fa-plus-circle mr-2"></i> Yeni Ürün Ekle</h3>
                    </div>
                    <div class="card-body">
                        <!-- Gizli ID Saklayıcı (Güncelleme için) -->
                        <asp:HiddenField ID="hfUrunID" runat="server" />

                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <label class="font-weight-bold">Kategori</label>
                                <asp:DropDownList ID="ddlKategoriler" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="font-weight-bold">Ürün Adı</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-box"></i></span>
                                    </div>
                                    <asp:TextBox ID="txturunad" runat="server" CssClass="form-control"
                                        placeholder="Ürün adı giriniz..."></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-2 mb-3">
                                <label class="font-weight-bold">Birim Fiyat</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-lira-sign"></i></span>
                                    </div>
                                    <asp:TextBox ID="txtBirimFiyat" runat="server" CssClass="form-control"
                                        placeholder="0.00"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-2 mb-3">
                                <label class="font-weight-bold">Stok Adedi</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-layer-group"></i></span>
                                    </div>
                                    <asp:TextBox ID="txtStok" runat="server" CssClass="form-control" TextMode="Number"
                                        placeholder="0"></asp:TextBox>
                                </div>
                            </div>
                            <!-- Yeni Satır: Ürün Detayları -->
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <label class="font-weight-bold mb-0">Ürün Özellikleri</label>
                                        <button type="button" class="btn btn-sm btn-link text-info p-0 font-weight-bold"
                                            onclick="initDynamicForm()">
                                            <i class="fas fa-sync-alt mr-1"></i> Formu Sıfırla
                                        </button>
                                    </div>

                                    <div class="card bg-light border-0">
                                        <div class="card-body p-2" id="divDynamicAttributes">
                                            <!-- Dinamik Inputlar Buraya Gelecek -->
                                            <div class="text-center text-muted small py-3">
                                                Lütfen bir kategori seçiniz...
                                            </div>
                                        </div>
                                        <!-- Yeni Özellik Ekle Butonu -->
                                        <div class="card-footer bg-transparent border-0 pt-0 text-center">
                                            <button type="button" class="btn btn-sm btn-outline-secondary rounded-pill"
                                                onclick="addNewAttributeRow('', '')">
                                                <i class="fas fa-plus"></i> Özel Alan Ekle
                                            </button>
                                        </div>
                                    </div>

                                    <!-- JSON Verisini Tutacak Gizli Alan -->
                                    <asp:TextBox ID="txtAciklama" runat="server" CssClass="d-none"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <!-- Butonlar Alanı -->
                        <div class="col-md-2 mb-3 d-flex align-items-end">
                            <div class="w-100">
                                <asp:Button ID="btnkaydet" runat="server" Text="Kaydet"
                                    CssClass="btn btn-success btn-block shadow-sm font-weight-bold mb-2"
                                    OnClick="btnkaydet_Click" />

                                <asp:Button ID="btnVazgec" runat="server" Text="Vazgeç"
                                    CssClass="btn btn-secondary btn-block shadow-sm font-weight-bold" Visible="false"
                                    OnClick="btnVazgec_Click" />
                            </div>
                        </div>
                    </div>
                    <asp:Label ID="lblMesaj" runat="server" CssClass="mt-2 d-block text-center font-weight-bold">
                    </asp:Label>
                </div>
            </div>

            <div class="card shadow-lg border-0 mt-4">
                <div class="card-header bg-white border-bottom-0">
                    <h3 class="card-title text-primary"><i class="fas fa-list mr-2"></i> Mevcut Ürün
                        Listesi</h3>
                </div>
                <div class="card-body p-0 table-responsive">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover table-striped text-nowrap" GridLines="None" DataKeyNames="UrunID"
                        OnRowDeleting="GridView1_RowDeleting">
                        <Columns>
                            <asp:BoundField DataField="UrunID" HeaderText="Kayıt No" />
                            <asp:BoundField DataField="KategoriAdi" HeaderText="Kategori" />
                            <asp:BoundField DataField="UrunAdi" HeaderText="Ürün Adı" />
                            <asp:BoundField DataField="BirimFiyat" HeaderText="Birim Fiyat" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="Stok" HeaderText="Stok" />
                            <asp:TemplateField HeaderText="İşlemler" ItemStyle-Width="20%">
                                <ItemTemplate>
                                    <asp:Button ID="btnDetay" runat="server" Text="Detay"
                                        CommandArgument='<%# Eval("UrunID") %>'
                                        CssClass="btn btn-info btn-sm rounded-pill px-3 mr-1"
                                        OnClick="btnDetay_Click" />

                                    <asp:Button ID="btnDuzenle" runat="server" Text="Düzenle"
                                        CommandArgument='<%# Eval("UrunID") %>'
                                        CssClass="btn btn-outline-primary btn-sm rounded-pill px-3 mr-1"
                                        OnClick="btnDuzenle_Click" />

                                    <asp:Button ID="btnSil" runat="server" CommandName="Delete" Text="Sil"
                                        CssClass="btn btn-outline-danger btn-sm rounded-pill px-3"
                                        OnClientClick="return confirm('Bu ürünü silmek istediğinize emin misiniz?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle CssClass="bg-light text-muted border-bottom" />
                    </asp:GridView>
                </div>
            </div>
            </div>
        </section>

        <!-- Detay Modalı -->
        <div class="modal fade" id="detayModal" tabindex="-1" role="dialog" aria-labelledby="detayModalLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content border-0 shadow-lg">
                    <div class="modal-header bg-info text-white">
                        <h5 class="modal-title font-weight-bold" id="detayModalLabel">
                            <i class="fas fa-info-circle mr-2"></i>
                            <asp:Label ID="lblModalUrunAdi" runat="server"></asp:Label>
                        </h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body p-4">
                        <h6 class="font-weight-bold text-muted mb-2">Ürün Özellikleri / Detaylar:</h6>
                        <div class="p-3 bg-light rounded border">
                            <asp:Literal ID="litModalAciklama" runat="server"></asp:Literal>
                        </div>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <div>
                            <!-- Sol tarafa gerekirse başka buton konabilir, şimdilik boş -->
                        </div>
                        <div>
                            <asp:Button ID="btnModalDuzenle" runat="server" Text="Özellikleri Düzenle / Yeni Ekle"
                                CssClass="btn btn-warning font-weight-bold shadow-sm" OnClick="btnModalDuzenle_Click" />
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Kapat</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            // Sayfa yüklendiğinde ve PostBack olduğunda çalışır
            document.addEventListener("DOMContentLoaded", function () {
                var ddl = document.getElementById('<%= ddlKategoriler.ClientID %>');
                var hiddenField = document.getElementById('<%= txtAciklama.ClientID %>');
                var btnKaydet = document.getElementById('<%= btnkaydet.ClientID %>');

                // 1. Kategori değişince form yenilensin
                if (ddl) {
                    ddl.addEventListener("change", function () {
                        // Kategori değiştiğinde sıfırdan şablon yükle
                        loadTemplateByCategory(true);
                    });
                }

                // 2. Sayfa ilk açıldığında veya Düzenle moda girildiğinde mevcut veriyi yükle
                if (hiddenField && hiddenField.value.trim() !== "") {
                    // Eğer hidden field doluysa (Veritabanından gelmişse) onu parse edip formu oluştur
                    try {
                        var jsonData = JSON.parse(hiddenField.value);
                        renderFormFromJSON(jsonData);
                    } catch (e) {
                        // JSON değilse düz metindir, eski veridir.
                        // Onu da düzgün göstermek lazım (Tek bir satır gibi ya da uyarı vererek)
                        console.log("Eski veri formatı saptandı.");
                        addNewAttributeRow("Açıklama", hiddenField.value);
                    }
                } else {
                    // Boşsa ve kategori seçiliyse şablonu getir
                    loadTemplateByCategory(false);
                }

                // 3. Kaydet butonuna basılınca Formdaki verileri JSON yapıp HiddenField'a at
                if (btnKaydet) {
                    btnKaydet.addEventListener("click", function () {
                        updateHiddenJSON();
                    });
                }
            });

            // Kategoriye göre varsayılan şablonu yükle
            function loadTemplateByCategory(forceClear) {
                var ddl = document.getElementById('<%= ddlKategoriler.ClientID %>');
                var container = document.getElementById('divDynamicAttributes');

                if (!ddl || ddl.selectedIndex === 0) {
                    container.innerHTML = '<div class="text-center text-muted small py-3">Lütfen bir kategori seçiniz...</div>';
                    return;
                }

                if (forceClear) {
                    container.innerHTML = "";
                } else if (container.innerHTML.trim() !== "" && !container.innerText.includes("Lütfen")) {
                    // Zaten doluysa dokunma
                    return;
                } else {
                    container.innerHTML = "";
                }

                var secilenKategori = ddl.options[ddl.selectedIndex].text.toLowerCase();
                var sablon = [];

                if (secilenKategori.includes("bilgisayar") || secilenKategori.includes("laptop")) {
                    sablon = ["İşlemci", "RAM", "Ekran Kartı", "Depolama", "Ekran Boyutu"];
                } else if (secilenKategori.includes("telefon")) {
                    sablon = ["Ekran", "Kamera", "Pil", "İşlemci", "Hafıza"];
                } else if (secilenKategori.includes("giyim")) {
                    sablon = ["Kumaş Türü", "Beden", "Renk", "Kalıp"];
                } else {
                    sablon = ["Özellik 1", "Özellik 2"];
                }

                sablon.forEach(function (key) {
                    addNewAttributeRow(key, "");
                });
            }

            // JSON verisinden formu oluştur (Düzenleme modu için)
            // JSON verisinden formu oluştur (Düzenleme modu için)
            function renderFormFromJSON(jsonData) {
                var container = document.getElementById('divDynamicAttributes');
                container.innerHTML = "";
                for (var key in jsonData) {
                    if (jsonData.hasOwnProperty(key)) {
                        addNewAttributeRow(key, jsonData[key]);
                    }
                }
            }

            // Yeni Satır Ekleme Fonksiyonu
            function addNewAttributeRow(key, value) {
                var container = document.getElementById('divDynamicAttributes');

                // Eğer "Lütfen seçiniz" yazısı varsa temizle
                if (container.innerText.includes("Lütfen")) container.innerHTML = "";

                var div = document.createElement("div");
                div.className = "input-group mb-2 dynamic-row";

                // Sol taraf (Key)
                var inputKey = document.createElement("input");
                inputKey.type = "text";
                inputKey.className = "form-control form-control-sm font-weight-bold bg-light";
                inputKey.placeholder = "Özellik Adı";
                inputKey.value = key;
                inputKey.style.maxWidth = "35%";

                // Sağ Taraf (Value)
                var inputValue = document.createElement("input");
                inputValue.type = "text";
                inputValue.className = "form-control form-control-sm";
                inputValue.placeholder = "Değer Giriniz";
                inputValue.value = value;

                // Sil Butonu
                var divAppend = document.createElement("div");
                divAppend.className = "input-group-append";
                var btnDel = document.createElement("button");
                btnDel.className = "btn btn-sm btn-outline-danger";
                btnDel.type = "button";
                btnDel.innerHTML = "<i class='fas fa-times'></i>";
                btnDel.onclick = function () {
                    div.remove();
                    updateHiddenJSON();
                };

                divAppend.appendChild(btnDel);
                div.appendChild(inputKey);
                div.appendChild(inputValue);
                div.appendChild(divAppend);

                container.appendChild(div);
            }

            // Formu Sıfırla
            function initDynamicForm() {
                loadTemplateByCategory(true);
            }

            // Formdaki verileri toplayıp JSON yapıp HiddenField'a basan fonksiyon
            function updateHiddenJSON() {
                var container = document.getElementById('divDynamicAttributes');
                var rows = container.getElementsByClassName('dynamic-row');
                var data = {};

                for (var i = 0; i < rows.length; i++) {
                    var inputs = rows[i].getElementsByTagName('input');
                    var key = inputs[0].value.trim();
                    var val = inputs[1].value.trim();

                    if (key !== "") {
                        data[key] = val;
                    }
                }

                var jsonString = JSON.stringify(data);
                document.getElementById('<%= txtAciklama.ClientID %>').value = jsonString;
            }
        </script>
    </asp:Content>