using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SatisPaneli
{
    public partial class UrunYonetimi : System.Web.UI.Page
    {
        // Manuel Kontrol Tanımları
        // Sadece designer dosyasında OLMAYANLARI buraya ekliyoruz.
        protected HiddenField hfUrunID;
        protected DropDownList ddlKategoriler;
        protected TextBox txtAciklama;
        protected Button btnVazgec;
        protected Label lblModalUrunAdi;
        protected Literal litModalAciklama;

        SatisDBEntities db = new SatisDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            // --- GÜVENLİK KONTROLÜ ---
            if (Session["Kullanici"] == null) {
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            // Sayfa ilk kez yükleniyorsa verileri getir
            if (!IsPostBack) {
                KategorileriGetir();
                VerileriYukle();
                
                // --- YETKİ KONTROLÜ ---
                // Eğer Kasiyer/Personel ise ekleme/silme yapamasın
                if (Session["Rol"] != null && Session["Rol"].ToString() == "Personel")
                {
                    btnkaydet.Visible = false; // Ekleme butonunu gizle (Formu doldursa bile basamaz)
                    // Paneli komple gizlemek için panel kontrolü gerekirdi ama bu yeterli şimdilik.
                }
            }
        }

        // Kategorileri DropDownList'e doldur
        void KategorileriGetir()
        {
            var kategoriler = db.Kategoriler.Select(x => new { x.KategoriID, x.KategoriAdi }).ToList();
            ddlKategoriler.DataSource = kategoriler;
            ddlKategoriler.DataTextField = "KategoriAdi";
            ddlKategoriler.DataValueField = "KategoriID";
            ddlKategoriler.DataBind();

            // "Seçiniz" opsiyonu ekle
            ddlKategoriler.Items.Insert(0, new ListItem("Seçiniz", "0"));
        }

        // Listeleme Metodu
        public void VerileriYukle()
        {
            // İlişkili tablodan (Kategoriler) veri çekerek listeleme
            var query = db.Urunler.AsQueryable();

            // Eğer URL'den "kritik=1" parametresi gelmişse, sadece kritik stokları filtrele
            if (Request.QueryString["kritik"] == "1")
            {
                // Stok miktarı 10'un altında olanlar (veya istediğiniz eşik değer)
                query = query.Where(u => u.Stok < 10);
            }

            var liste = (from u in query
                         select new
                         {
                             u.UrunID,
                             u.UrunAdi,
                             u.BirimFiyat,
                             u.Stok,
                             // Eğer kategori silinmişse veya yoksa boş göster
                             KategoriAdi = u.Kategoriler != null ? u.Kategoriler.KategoriAdi : "-"
                         }).ToList();

            GridView1.DataSource = liste;
            GridView1.DataBind();
            
            // --- YETKİ KONTROLÜ (Görünüm) ---
            if (Session["Rol"] != null && Session["Rol"].ToString() == "Personel")
            {
                // GridView'daki "İşlemler" sütununu (son sütun) gizle
                if (GridView1.Columns.Count > 0)
                {
                     GridView1.Columns[GridView1.Columns.Count - 1].Visible = false;
                }
            }
        }

        // Kaydetme ve Güncelleme Butonu
        protected void btnkaydet_Click(object sender, EventArgs e)
        {
            try {
                // Hidden Field'dan ID kontrolü (Boşsa Yeni Ekleme, Doluysa Güncelleme)
                int urunID = 0;
                if (!string.IsNullOrEmpty(hfUrunID.Value)) {
                    urunID = Convert.ToInt32(hfUrunID.Value);
                }

                Urunler urun;
                if (urunID > 0) {
                    // -- GÜNCELLEME İŞLEMİ --
                    urun = db.Urunler.Find(urunID);
                    lblMesaj.Text = "Ürün başarıyla güncellendi!";
                }
                else {
                    // -- YENİ EKLEME İŞLEMİ --
                    urun = new Urunler();
                    db.Urunler.Add(urun);
                    lblMesaj.Text = "Ürün başarıyla eklendi!";
                }

                // Ortak Alanlar (Hem ekleme hem güncelleme için)
                urun.UrunAdi = txturunad.Text;
                urun.BirimFiyat = decimal.Parse(txtBirimFiyat.Text);

                int stokMiktari = 0;
                int.TryParse(txtStok.Text, out stokMiktari);
                urun.Stok = stokMiktari;

                int secilenKategori = Convert.ToInt32(ddlKategoriler.SelectedValue);
                if (secilenKategori > 0) {
                    urun.KategoriID = secilenKategori;
                }
                else {
                    urun.KategoriID = null; // Seçilmezse boş bırak
                }

                db.SaveChanges();

                // Ürün Açıklamasını kaydet (Raw SQL ile - Modele dokunmadan)
                db.Database.ExecuteSqlCommand("UPDATE Urunler SET UrunAciklama = @p0 WHERE UrunID = @p1", txtAciklama.Text, urun.UrunID);
                lblMesaj.ForeColor = System.Drawing.Color.Green;

                FormuTemizle();
                VerileriYukle();
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Hata oluştu: " + ex.Message;
                lblMesaj.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Düzenle Butonuna Basılınca (Grid İçinden)
        protected void btnDuzenle_Click(object sender, EventArgs e)
        {
            // Butona tıklandığında CommandArgument'tan ID'yi al
            Button btn = (Button)sender;
            int urunID = Convert.ToInt32(btn.CommandArgument);

            // O ürünü veritabanından bul
            var urun = db.Urunler.Find(urunID);
            if (urun != null) {
                // Bilgileri Form Alanlarına Doldur
                txturunad.Text = urun.UrunAdi;
                txtBirimFiyat.Text = urun.BirimFiyat.ToString();
                txtStok.Text = urun.Stok.ToString();

                // Detay Bilgisini Çek (Raw SQL)
                string detay = db.Database.SqlQuery<string>("SELECT UrunAciklama FROM Urunler WHERE UrunID = @p0", urunID).FirstOrDefault();
                txtAciklama.Text = detay;


                if (urun.KategoriID != null)
                    ddlKategoriler.SelectedValue = urun.KategoriID.ToString();
                else
                    ddlKategoriler.SelectedIndex = 0;

                // ID'yi Gizli Alana (HiddenField) yaz ki kaydederken bunun güncelleme olduğunu anlayalım
                hfUrunID.Value = urunID.ToString();

                // Butonun yazısını ve rengini değiştir (Kullanıcı anlasın)
                btnkaydet.Text = "Güncelle";
                btnkaydet.CssClass = "btn btn-primary btn-block shadow-sm font-weight-bold";

                // Vazgeç butonunu göster
                btnVazgec.Visible = true;

                // Forma odaklan (Yukarı kaydır)
                txturunad.Focus();
            }
        }

        // Detay Butonu (Modalı Açar)
        protected void btnDetay_Click(object sender, EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;
                int urunID = Convert.ToInt32(btn.CommandArgument);

                var urun = db.Urunler.Find(urunID);
                if (urun != null)
                {
                    lblModalUrunAdi.Text = urun.UrunAdi;

                    // Detayı Çek
                    string detay = db.Database.SqlQuery<string>("SELECT UrunAciklama FROM Urunler WHERE UrunID = @p0", urunID).FirstOrDefault();
                    
                    if (string.IsNullOrEmpty(detay))
                    {
                        litModalAciklama.Text = "Bu ürün için detay bilgisi girilmemiştir.";
                    }
                    else
                    {
                        // JSON mu diye kontrol et (Basitçe { ile başlıyorsa)
                        if (detay.Trim().StartsWith("{"))
                        {
                            try
                            {
                                // JSON'ı HTML tablosuna çevir
                                var tableHtml = "<table class='table table-sm table-bordered table-striped'>";
                                var dict = Newtonsoft.Json.JsonConvert.DeserializeObject<System.Collections.Generic.Dictionary<string, string>>(detay);

                                foreach (var item in dict)
                                {
                                    tableHtml += string.Format("<tr><td class='font-weight-bold text-muted w-25'>{0}</td><td>{1}</td></tr>", item.Key, item.Value);
                                }
                                tableHtml += "</table>";
                                litModalAciklama.Text = tableHtml;
                            }
                            catch
                            {
                                // JSON bozuksa düz yaz
                                litModalAciklama.Text = detay.Replace(Environment.NewLine, "<br />");
                            }
                        }
                        else
                        {
                            // Eski usül düz metin
                            litModalAciklama.Text = detay.Replace(Environment.NewLine, "<br />");
                        }
                    }

                    // Modalı Aç (Javascript Tetikle)
                    ClientScript.RegisterStartupScript(this.GetType(), "Pop", "$('#detayModal').modal('show');", true);
                }
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Detay hatası: " + ex.Message;
            }
        }

        // Vazgeç Butonu
        public void btnVazgec_Click(object sender, EventArgs e)
        {
            FormuTemizle();
        }

        void FormuTemizle()
        {
            txturunad.Text = "";
            txtBirimFiyat.Text = "";
            txtStok.Text = "";
            txtAciklama.Text = "";
            ddlKategoriler.SelectedIndex = 0;

            // Gizli olan ID'yi temizle
            hfUrunID.Value = "";

            // Butonları eski haline getir
            btnkaydet.Text = "Kaydet";
            btnkaydet.CssClass = "btn btn-success btn-block shadow-sm font-weight-bold";
            btnVazgec.Visible = false;
            lblMesaj.Text = "";
        }

        // Silme İşlemi
        protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try {
                int urunID = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);
                var silinecekUrun = db.Urunler.Find(urunID);

                if (silinecekUrun != null) {
                    db.Urunler.Remove(silinecekUrun);
                    db.SaveChanges();

                    lblMesaj.Text = "Ürün silindi.";
                    lblMesaj.ForeColor = System.Drawing.Color.Orange;

                    // Eğer düzenleme modundaysa ve sildiğimiz o ürünü düzenliyorsak, formu da temizle
                    if (hfUrunID.Value == urunID.ToString()) {
                        FormuTemizle();
                    }

                    VerileriYukle();
                }
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Hata: " + ex.Message;
            }
        }
    }
}