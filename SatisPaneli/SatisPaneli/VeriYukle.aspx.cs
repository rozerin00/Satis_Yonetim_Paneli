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
    }
}
