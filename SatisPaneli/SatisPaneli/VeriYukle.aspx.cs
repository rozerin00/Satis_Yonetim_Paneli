using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using System.Data;

namespace SatisPaneli
{
    public partial class VeriYukle : System.Web.UI.Page
    {
        SatisDBEntities db = new SatisDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnYukle_Click(object sender, EventArgs e)
        {
            // 1. UrunResim kolonu yoksa ekle
            try
            {
                db.Database.ExecuteSqlCommand("IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Urunler]') AND name = 'UrunResim') BEGIN ALTER TABLE Urunler ADD UrunResim NVARCHAR(MAX) END");
            }
            catch { }

            var urunler = db.Urunler.ToList();
            var serializer = new JavaScriptSerializer();
            
            DataTable dt = new DataTable();
            dt.Columns.Add("ID");
            dt.Columns.Add("Ürün Adı");
            dt.Columns.Add("Resim");
            dt.Columns.Add("Özellikler");
            
            foreach (var urun in urunler)
            {
                string ad = urun.UrunAdi.ToLower();
                string kategori = urun.Kategoriler != null ? urun.Kategoriler.KategoriAdi.ToLower() : "";
                
                Dictionary<string, string> ozellikler = new Dictionary<string, string>();
                string resimUrl = "https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=600&q=80"; // Varsayılan (Elektronik)

                // Mantıksal Özellik ve Resim Atama
                if (ad.Contains("laptop") || ad.Contains("bilgisayar") || ad.Contains("macbook") || kategori.Contains("bilgisayar"))
                {
                    ozellikler.Add("İşlemci", "Intel Core i7 13. Nesil / M2");
                    ozellikler.Add("RAM", "16 GB DDR5");
                    ozellikler.Add("Depolama", "512 GB NVMe SSD");
                    ozellikler.Add("Ekran Kartı", "RTX 4060 / Tümleşik");
                    ozellikler.Add("Ekran", "15.6 inç FHD IPS");
                    resimUrl = "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=600&q=80";
                }
                else if (ad.Contains("telefon") || ad.Contains("iphone") || ad.Contains("galaxy") || ad.Contains("redmi") || kategori.Contains("telefon"))
                {
                    ozellikler.Add("Ekran", "6.1 inç OLED");
                    ozellikler.Add("Hafıza", "128 GB");
                    ozellikler.Add("Kamera", "48 MP + 12 MP");
                    ozellikler.Add("Pil", "5000 mAh");
                    resimUrl = "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600&q=80";
                }
                else if (ad.Contains("kulaklık") || ad.Contains("airpods") || ad.Contains("buds"))
                {
                    ozellikler.Add("Tür", "Kablosuz Kulak İçi");
                    ozellikler.Add("Pil Ömrü", "24 Saat");
                    ozellikler.Add("Bağlantı", "Bluetooth 5.3");
                    resimUrl = "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&q=80";
                }
                 else if (ad.Contains("saat") || ad.Contains("watch"))
                {
                    ozellikler.Add("Kasa Çapı", "45mm");
                    ozellikler.Add("Suya Dayanıklılık", "50m");
                    ozellikler.Add("Ekran", "Always-on Retina");
                    resimUrl = "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&q=80";
                }
                else if (ad.Contains("televizyon") || ad.Contains("tv"))
                {
                    ozellikler.Add("Ekran Boyutu", "55 İnç");
                    ozellikler.Add("Çözünürlük", "4K Ultra HD");
                    ozellikler.Add("Panel", "LED / QLED");
                    resimUrl = "https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=600&q=80";
                }
                else if (ad.Contains("kamera") || ad.Contains("fotoğraf"))
                {
                    ozellikler.Add("Çözünürlük", "24 MP");
                    ozellikler.Add("Lens", "18-55mm Kit");
                    resimUrl = "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600&q=80";
                }
                else if (ad.Contains("klavye") || ad.Contains("mouse"))
                {
                     ozellikler.Add("Bağlantı", "Kablolu / Kablosuz");
                     ozellikler.Add("Aydınlatma", "RGB");
                     resimUrl = "https://images.unsplash.com/photo-1587829741301-dc798b91add4?w=600&q=80";
                }

                // JSON'a çevir
                string json = serializer.Serialize(ozellikler);
                
                // Veritabanını Güncelle
                try
                {
                    // UrunAciklama ve UrunResim kolonuna update atıyoruz
                    string sql = "UPDATE Urunler SET UrunAciklama = @p0, UrunResim = @p1 WHERE UrunID = @p2";
                    db.Database.ExecuteSqlCommand(sql, json, resimUrl, urun.UrunID);
                    
                    dt.Rows.Add(urun.UrunID, urun.UrunAdi, resimUrl, json);
                }
                catch (Exception ex)
                {
                    dt.Rows.Add(urun.UrunID, urun.UrunAdi, "Hata", "Hata: " + ex.Message);
                }
            }
            
            gvSonuc.DataSource = dt;
            gvSonuc.DataBind();
        }

        protected void btnTeknoDonusum_Click(object sender, EventArgs e)
        {
            // 1. Kategorileri Kontrol Et ve Sabitle (Yoksa Oluştur)
            // Önce mevcutları standart isimlere çevir, eksikse ekle.
            string[] standartKategoriler = { "Elektronik", "Bilgisayar & Tablet", "Telefon & Aksesuar", "TV & Görüntü", "Oyun & Konsol", "Foto & Kamera", "Akıllı Ev" };
            
            var mevcutKategoriler = db.Kategoriler.ToList();
            
            // Mevcutları sırasıyla rename et (böylece ID'ler korunur, ürünler kaybolmaz)
            for (int i = 0; i < mevcutKategoriler.Count; i++)
            {
                if (i < standartKategoriler.Length)
                {
                    mevcutKategoriler[i].KategoriAdi = standartKategoriler[i];
                }
                else
                {
                    mevcutKategoriler[i].KategoriAdi = "Diğer Fırsatlar";
                }
            }
            db.SaveChanges();

            // Eksik kategori varsa ekle
            if (mevcutKategoriler.Count < standartKategoriler.Length)
            {
                for (int i = mevcutKategoriler.Count; i < standartKategoriler.Length; i++)
                {
                    Kategoriler yeniKat = new Kategoriler();
                    yeniKat.KategoriAdi = standartKategoriler[i];
                    db.Kategoriler.Add(yeniKat);
                }
                db.SaveChanges();
            }

            // Kategorileri ID'leriyle haritala: "Elektronik" -> 1 gibi
            var kategoriMap = db.Kategoriler.ToDictionary(k => k.KategoriAdi, k => k.KategoriID);

            // 2. Ürünleri Mantıklı Bir Şekilde Dağıt ve Kategorilerini Güncelle
            var urunler = db.Urunler.ToList();
            Random rnd = new Random();

            DataTable dt = new DataTable();
            dt.Columns.Add("ID");
            dt.Columns.Add("Yeni Ad");
            dt.Columns.Add("Yeni Kategori");

            // GLOBAL ÜRÜN HAVUZU: (Ürün Adı -> Hedef Kategori)
            // Bu havuzdan her ürüne rastgele bir kimlik vereceğiz ve KATEGORİSİNİ DE ONA GÖRE GÜNCELLEYECEĞİZ.
            var globalHavuz = new List<Tuple<string, string>>
            {
                Tuple.Create("Sony Gürültü Engelleyici Kulaklık", "Elektronik"),
                Tuple.Create("JBL Bluetooth Hoparlör", "Elektronik"),
                Tuple.Create("Anker Powerbank 20000mAh", "Telefon & Aksesuar"),
                Tuple.Create("Logitech MX Master 3 Mouse", "Bilgisayar & Tablet"),
                Tuple.Create("MacBook Pro 14 M3", "Bilgisayar & Tablet"),
                Tuple.Create("Asus ROG Strix G16", "Bilgisayar & Tablet"),
                Tuple.Create("Lenovo ThinkPad X1", "Bilgisayar & Tablet"),
                Tuple.Create("iPad Air 5. Nesil", "Bilgisayar & Tablet"),
                Tuple.Create("iPhone 15 Pro Max", "Telefon & Aksesuar"),
                Tuple.Create("Samsung Galaxy S24 Ultra", "Telefon & Aksesuar"),
                Tuple.Create("Xiaomi 13T Pro", "Telefon & Aksesuar"),
                Tuple.Create("Apple Watch Series 9", "Telefon & Aksesuar"),
                Tuple.Create("Samsung 55' 4K QLED TV", "TV & Görüntü"),
                Tuple.Create("LG OLED 65' Smart TV", "TV & Görüntü"),
                Tuple.Create("PlayStation 5 Slim", "Oyun & Konsol"),
                Tuple.Create("Xbox Series X", "Oyun & Konsol"),
                Tuple.Create("Nintendo Switch OLED", "Oyun & Konsol"),
                Tuple.Create("Canon EOS R50", "Foto & Kamera"),
                Tuple.Create("GoPro Hero 12 Black", "Foto & Kamera"),
                Tuple.Create("Xiaomi Robot Süpürge", "Akıllı Ev"),
                Tuple.Create("Philips Hue Başlangıç Seti", "Akıllı Ev")
            };

            foreach (var urun in urunler)
            {
                // Rastgele bir teknoloji kimliği seç
                var yeniKimlik = globalHavuz[rnd.Next(globalHavuz.Count)];
                
                string yeniAd = yeniKimlik.Item1;
                string hedefKategoriAdi = yeniKimlik.Item2;

                // 1. İsim ve Fiyat Güncelle
                urun.UrunAdi = yeniAd;
                urun.BirimFiyat = rnd.Next(10, 800) * 100; // 1000 - 80000 TL
                urun.Stok = (short)rnd.Next(5, 100);

                // 2. KATEGORİSİNİ GÜNCELLE (En Önemli Kısım)
                if (kategoriMap.ContainsKey(hedefKategoriAdi))
                {
                    urun.KategoriID = kategoriMap[hedefKategoriAdi];
                }

                dt.Rows.Add(urun.UrunID, yeniAd, hedefKategoriAdi);
            }

            db.SaveChanges();

            // 3. Özellikleri ve Resimleri Yenile
            btnYukle_Click(sender, e); // Özellikleri isme göre atayan fonksiyon

             ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Dönüşüm Tamamlandı! Ürünler doğru kategorilere (Mouse->Bilgisayar, Kulaklık->Elektronik vb.) taşındı.');", true);
        }
    }
}
