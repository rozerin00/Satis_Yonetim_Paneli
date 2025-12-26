using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SatisPaneli
{
    public partial class Sepet : System.Web.UI.Page
    {
        SatisDBEntities db = new SatisDBEntities();
        
        // Sepet öğelerini tutacak sınıf
        public class SepetItem
        {
            public int UrunID { get; set; }
            public string UrunAdi { get; set; }
            public string UrunResim { get; set; }
            public decimal Fiyat { get; set; }
            public int Adet { get; set; }
            public decimal Tutar { get { return Fiyat * Adet; } }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Kullanici"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                SepetiGetir();
            }
        }

        void SepetiGetir()
        {
            if (Session["Sepet"] != null)
            {
                var sessionSepet = (Dictionary<int, int>)Session["Sepet"];
                if (sessionSepet.Count > 0)
                {
                    // Sepetteki ürünlerin detaylarını veritabanından çek
                    var urunIds = sessionSepet.Keys.ToList();
                    var urunler = db.Urunler.Where(x => urunIds.Contains(x.UrunID)).ToList();

                    // View Model oluştur
                    List<SepetItem> sepetListesi = new List<SepetItem>();
                    decimal genelToplam = 0;

                    foreach (var u in urunler)
                    {
                        var adet = sessionSepet[u.UrunID];

                        // Resim Çek (Raw SQL)
                        string imgUrl = "";
                        try {
                             imgUrl = db.Database.SqlQuery<string>("SELECT UrunResim FROM Urunler WHERE UrunID=@p0", u.UrunID).FirstOrDefault();
                        } catch {}
                        
                        if(string.IsNullOrEmpty(imgUrl)) imgUrl = "https://via.placeholder.com/100x100.png?text=" + u.UrunAdi;

                        var item = new SepetItem
                        {
                            UrunID = u.UrunID,
                            UrunAdi = u.UrunAdi,
                            UrunResim = imgUrl, 
                            Fiyat = u.BirimFiyat.HasValue ? u.BirimFiyat.Value : 0,
                            Adet = adet
                        };
                        sepetListesi.Add(item);
                        genelToplam += item.Tutar;
                    }

                    // Repeater'a bağla
                    rptSepet.DataSource = sepetListesi;
                    rptSepet.DataBind();

                    // Özeti Güncelle
                    lblAraToplam.Text = string.Format("{0:C}", genelToplam);
                    lblKargo.Text = genelToplam > 100 ? "0,00 TL" : "29,99 TL"; // 100 TL üzeri kargo bedava
                    
                    decimal kargo = genelToplam > 100 ? 0 : 29.99m;
                    lblGenelToplam.Text = string.Format("{0:C}", genelToplam + kargo);

                    pnlBosSepet.Visible = false;
                    pnlDoluSepet.Visible = true;
                }
                else
                {
                    SepetBosGoster();
                }
            }
            else
            {
                SepetBosGoster();
            }
        }

        void SepetBosGoster()
        {
            pnlBosSepet.Visible = true;
            pnlDoluSepet.Visible = false;
        }

        // Sepet İşlemleri (Sil, Artır, Azalt)
        protected void rptSepet_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            var sessionSepet = (Dictionary<int, int>)Session["Sepet"];
            int urunId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Sil")
            {
                if (sessionSepet.ContainsKey(urunId))
                {
                    sessionSepet.Remove(urunId);
                }
            }
            else if (e.CommandName == "Artir")
            {
                if (sessionSepet.ContainsKey(urunId))
                {
                    sessionSepet[urunId]++;
                }
            }
            else if (e.CommandName == "Azalt")
            {
                if (sessionSepet.ContainsKey(urunId))
                {
                    if (sessionSepet[urunId] > 1)
                        sessionSepet[urunId]--;
                    else
                        sessionSepet.Remove(urunId);
                }
            }

            Session["Sepet"] = sessionSepet;
            SepetiGetir();
        }

        // Siparişi Tamamla
        protected void btnSiparisiTamamla_Click(object sender, EventArgs e)
        {
            try
            {
                var sessionSepet = (Dictionary<int, int>)Session["Sepet"];
                string kullaniciAdi = Session["Kullanici"].ToString();
                
                // Müşteri ID Bul (İsimden buluyoruz, normalde ID tutulmalı sessionda ama yapımız böyle şu an)
                var musteri = db.Musteriler.FirstOrDefault(x => x.AdSoyad == kullaniciAdi);
                if (musteri == null) return; // Hata

                // 1. Satış Kaydı Oluştur
                Satislar yeniSatis = new Satislar();
                yeniSatis.MusteriID = musteri.MusteriID;
                yeniSatis.Tarih = DateTime.Now;
                // PersonelID null olabilir veya varsayılan bir personel atanabilir
                
                db.Satislar.Add(yeniSatis);
                db.SaveChanges(); // ID oluşması için kaydet

                // 2. Satış Detaylarını Ekle
                var urunIds = sessionSepet.Keys.ToList();
                var urunler = db.Urunler.Where(x => urunIds.Contains(x.UrunID)).ToList();

                foreach (var u in urunler)
                {
                    SatisDetaylari detay = new SatisDetaylari();
                    detay.SatisID = yeniSatis.SatisID;
                    detay.UrunID = u.UrunID;
                    detay.Adet = (short)sessionSepet[u.UrunID];
                    detay.BirimFiyat = u.BirimFiyat ?? 0;

                    db.SatisDetaylari.Add(detay);

                    // Stok Düş (Opsiyonel ama gerekli)
                    if (u.Stok >= detay.Adet)
                    {
                        u.Stok = (short)(u.Stok - detay.Adet);
                    }
                    else
                    {
                        // Stok yetersizse ne yapılacağı: Şimdilik eksiye düşmesine izin verme veya işlemden çık
                        // u.Stok = 0; yaparak devam ediyoruz basitlik için
                    }
                }

                db.SaveChanges();

                // 3. Sepeti Temizle ve Yönlendir
                Session["Sepet"] = null;
                
                // Başarılı uyarısı ile profile git
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Siparişiniz başarıyla alındı!'); window.location.href='Profilim.aspx';", true);
            }
            catch (Exception ex)
            {
                // Hata logla
                ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('Hata oluştu: " + ex.Message.Replace("'", "") + "');", true);
            }
        }
    }
}
