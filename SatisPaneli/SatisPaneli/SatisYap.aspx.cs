using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SatisPaneli
{
    // Sepet Öğesi Sınıfı
    [Serializable]
    public class SepetOgesi
    {
        public int UrunID { get; set; }
        public string UrunAdi { get; set; }
        public int Adet { get; set; }
        public decimal BirimFiyat { get; set; }
        public decimal ToplamTutar { get { return Adet * BirimFiyat; } }
    }

    public partial class SatisYap : System.Web.UI.Page
    {
        // Kontrol Tanımları
        protected global::System.Web.UI.WebControls.DropDownList ddlKategori;
        protected global::System.Web.UI.WebControls.GridView gvSepet;
        protected global::System.Web.UI.WebControls.Label lblGenelToplam;
        protected global::System.Web.UI.WebControls.Button btnSatisTamamla;
        protected global::System.Web.UI.WebControls.Panel pnlSepet;
        // Kontrol Tanımları (Designer senkron sorunu için manuel eklendi)


        SatisDBEntities db = new SatisDBEntities();

        // Sepet Listesi (Session üzerinden yönetilecek)
        public List<SepetOgesi> MevcutSepet
        {
            get
            {
                if (Session["Sepet"] == null)
                    Session["Sepet"] = new List<SepetOgesi>();
                return (List<SepetOgesi>)Session["Sepet"];
            }
            set
            {
                Session["Sepet"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Kullanici"] == null)
            {
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                KategorileriYukle();
                MusterileriYukle();
                // Sepeti temizle veya mevcut sepeti yükle (Yeni girişte temizlemek mantıklı olabilir)
                Session["Sepet"] = new List<SepetOgesi>();
                SepetiGuncelle();
            }
        }

        public void KategorileriYukle()
        {
            var kategoriler = db.Kategoriler.Select(x => new { x.KategoriID, x.KategoriAdi }).ToList();
            ddlKategori.DataSource = kategoriler;
            ddlKategori.DataTextField = "KategoriAdi";
            ddlKategori.DataValueField = "KategoriID";
            ddlKategori.DataBind();
            ddlKategori.Items.Insert(0, new ListItem("--- Kategori Seçin ---", "0"));
        }

        public void MusterileriYukle()
        {
            var musteriler = db.Musteriler
                               .GroupBy(m => m.AdSoyad)
                               .Select(g => g.FirstOrDefault())
                               .Select(x => new { x.MusteriID, x.AdSoyad })
                               .ToList();
            ddlMusteri.DataSource = musteriler;
            ddlMusteri.DataTextField = "AdSoyad";
            ddlMusteri.DataValueField = "MusteriID";
            ddlMusteri.DataBind();
            ddlMusteri.Items.Insert(0, new ListItem("--- Müşteri Seçin ---", "0"));
        }

        protected void ddlKategori_SelectedIndexChanged(object sender, EventArgs e)
        {
            int secilenKategoriID = 0;
            int.TryParse(ddlKategori.SelectedValue, out secilenKategoriID);

            if (secilenKategoriID > 0)
            {
                // Stokta olan ürünleri getir
                var urunler = db.Urunler.Where(x => x.KategoriID == secilenKategoriID && x.Stok > 0).ToList();
                ddlUrun.DataSource = urunler;
                ddlUrun.DataTextField = "UrunAdi";
                ddlUrun.DataValueField = "UrunID";
                ddlUrun.DataBind();
                ddlUrun.Items.Insert(0, new ListItem("--- Ürün Seçin ---", "0"));
            }
            else
            {
                ddlUrun.Items.Clear();
                ddlUrun.Items.Insert(0, new ListItem("--- Önce Kategori Seçin ---", "0"));
            }
        }

        protected void btnSepeteEkle_Click(object sender, EventArgs e)
        {
            try
            {
                int urunID = 0;
                int.TryParse(ddlUrun.SelectedValue, out urunID);

                int adet = 0;
                int.TryParse(txtAdet.Text, out adet);

                if (urunID <= 0)
                {
                    MesajGoster("Lütfen bir ürün seçiniz.", false);
                    return;
                }

                if (adet <= 0)
                {
                    MesajGoster("Geçerli bir adet giriniz.", false);
                    return;
                }

                var urun = db.Urunler.Find(urunID);
                if (urun == null) return;

                // Stok Kontrolü (Sepetteki miktar + yeni miktar kontrolü)
                var sepettekiUrun = MevcutSepet.FirstOrDefault(x => x.UrunID == urunID);
                int sepettekiAdet = sepettekiUrun != null ? sepettekiUrun.Adet : 0;

                if (urun.Stok < (sepettekiAdet + adet))
                {
                    MesajGoster("Yetersiz stok! Mevcut Stok: " + urun.Stok, false);
                    return;
                }

                // Sepete Ekle veya Güncelle
                if (sepettekiUrun != null)
                {
                    sepettekiUrun.Adet += adet;
                }
                else
                {
                    MevcutSepet.Add(new SepetOgesi
                    {
                        UrunID = urun.UrunID,
                        UrunAdi = urun.UrunAdi,
                        BirimFiyat = (decimal)urun.BirimFiyat,
                        Adet = adet
                    });
                }

                SepetiGuncelle();
                MesajGoster("Ürün sepete eklendi.", true);
                
                // Formu temizle ama kategoriyi bozma
                txtAdet.Text = "1";
            }
            catch (Exception ex)
            {
                MesajGoster("Hata: " + ex.Message, false);
            }
        }

        protected void gvSepet_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int urunID = Convert.ToInt32(gvSepet.DataKeys[e.RowIndex].Value);
            var silinecek = MevcutSepet.FirstOrDefault(x => x.UrunID == urunID);
            
            if (silinecek != null)
            {
                MevcutSepet.Remove(silinecek);
                SepetiGuncelle();
            }
        }

        void SepetiGuncelle()
        {
            gvSepet.DataSource = MevcutSepet;
            gvSepet.DataBind();

            decimal toplam = MevcutSepet.Sum(x => x.ToplamTutar);
            lblGenelToplam.Text = string.Format("{0:C}", toplam);

            // Sepet boşsa Tamamla butonunu gizle
            if (MevcutSepet.Count > 0)
            {
                pnlSepet.Visible = true;
                btnSatisTamamla.Visible = true;
            }
            else
            {
                pnlSepet.Visible = false;
                btnSatisTamamla.Visible = false;
            }
        }

        protected void btnSatisTamamla_Click(object sender, EventArgs e)
        {
            // Transaction başlat (Veri bütünlüğü için)
            using (var transaction = db.Database.BeginTransaction())
            {
                try
                {
                    if (MevcutSepet.Count == 0) return;

                    // Müşteri Belirle
                    int musteriID = 0;
                    if (!string.IsNullOrEmpty(txtYeniMusteriAd.Text))
                    {
                        Musteriler yeniMusteri = new Musteriler { AdSoyad = txtYeniMusteriAd.Text };
                        db.Musteriler.Add(yeniMusteri);
                        db.SaveChanges();
                        musteriID = yeniMusteri.MusteriID;
                    }
                    else
                    {
                        int.TryParse(ddlMusteri.SelectedValue, out musteriID);
                    }

                    if (musteriID == 0)
                    {
                        MesajGoster("Lütfen bir müşteri seçiniz.", false);
                        return;
                    }

                    // Ana Satış Kaydı
                    Satislar satis = new Satislar
                    {
                        MusteriID = musteriID,
                        Tarih = DateTime.Now
                    };
                    db.Satislar.Add(satis);
                    db.SaveChanges(); // ID almak için kaydet

                    // Detayları Kaydet ve Stok Düş
                    foreach (var item in MevcutSepet)
                    {
                        var urun = db.Urunler.Find(item.UrunID);
                        if (urun == null || urun.Stok < item.Adet)
                        {
                            throw new Exception("Stok hatası! Ürün: " + item.UrunAdi);
                        }

                        // Stok Güncelle
                        urun.Stok -= item.Adet;

                        // Detay Ekle
                        SatisDetaylari detay = new SatisDetaylari
                        {
                            SatisID = satis.SatisID,
                            UrunID = item.UrunID,
                            Adet = item.Adet,
                            BirimFiyat = item.BirimFiyat
                        };
                        db.SatisDetaylari.Add(detay);
                    }

                    db.SaveChanges();
                    transaction.Commit();

                    // Başarılı
                    MesajGoster("Satış başarıyla tamamlandı! Fiş No: " + satis.SatisID, true);
                    
                    // Faturayı Yeni Sekmede Aç
                    string script = "window.open('FaturaDetay.aspx?id=" + satis.SatisID + "', '_blank');";
                    ClientScript.RegisterStartupScript(this.GetType(), "FaturaAc", script, true);
                    
                    // Temizlik
                    Session["Sepet"] = null;
                    SepetiGuncelle();
                    txtYeniMusteriAd.Text = "";
                    ddlMusteri.SelectedIndex = 0;
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    MesajGoster("Satış sırasında hata oluştu: " + ex.Message, false);
                }
            }
        }

        void MesajGoster(string mesaj, bool basarili)
        {
            lblSatisMesaj.Text = mesaj;
            lblSatisMesaj.ForeColor = basarili ? System.Drawing.Color.Green : System.Drawing.Color.Red;
        }
    }
}