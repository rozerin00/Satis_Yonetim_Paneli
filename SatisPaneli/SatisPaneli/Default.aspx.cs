using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Web.Script.Serialization;

namespace SatisPaneli
{
    public partial class _Default : Page
    {
        // Kontrol Tanımları
        protected global::System.Web.UI.WebControls.Repeater rptSonSatislar;
        
        // Değişkenler (Grafik verileri için public field olarak tanımlıyoruz)
        public string ChartLabels = "[]";
        public string ChartData = "[]";
        public string PieLabels = "[]";
        public string PieData = "[]";

        // İstatistik Değişkenleri
        public string ToplamSatisTutar = "0";
        public string ToplamSiparis = "0";
        public string ToplamMusteri = "0";
        public string KritikStok = "0";

        SatisDBEntities db = new SatisDBEntities();

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
                IstatistikleriGetir();
                GrafikVerileriniGetir();
                SonSatislarGetir();
            }
        }

        void IstatistikleriGetir()
        {
            try
            {
                // 1. Toplam Tutarı Hesapla
                // SatisDetaylari tablosunda "Adet * BirimFiyat" toplamı
                var tutar = db.SatisDetaylari.Any() ? db.SatisDetaylari.Sum(x => x.Adet * x.BirimFiyat) : 0;
                ToplamSatisTutar = string.Format("{0:C}", tutar);

                // 2. Toplam Sipariş Sayısı
                ToplamSiparis = db.Satislar.Count().ToString();

                // 3. Toplam Müşteri
                ToplamMusteri = db.Musteriler.Count().ToString();

                // 4. Kritik Stok
                int kritikStokSayisi = db.Urunler.Where(x => x.Stok < 10 && x.Stok > 0).Count();
                KritikStok = kritikStokSayisi.ToString();
            }
            catch { }
        }

        void GrafikVerileriniGetir()
        {
            try
            {
                // Pasta Grafik: Kategori Dağılımı
                var kategoriDagilimi = (from u in db.Urunler
                                        join k in db.Kategoriler on u.KategoriID equals k.KategoriID
                                        group u by k.KategoriAdi into g
                                        select new
                                        {
                                            Kategori = g.Key,
                                            Adet = g.Count()
                                        }).ToList();

                JavaScriptSerializer js = new JavaScriptSerializer();
                PieLabels = js.Serialize(kategoriDagilimi.Select(x => x.Kategori));
                PieData = js.Serialize(kategoriDagilimi.Select(x => x.Adet));

                // Çizgi Grafik: Son yapılan 10 siparişin toplam tutarları
                var sonSatislar = db.Satislar
                    .OrderByDescending(x => x.SatisID)
                    .Take(10) // Son 10 siparişi al
                    .OrderBy(x => x.SatisID) // Grafikte soldan sağa ID sırasıyla göster
                    .Select(x => new
                    {
                        Tarih = "Sipariş " + x.SatisID,
                        // Siparişin içindeki ürünlerin toplam tutarını hesapla
                        Tutar = x.SatisDetaylari.Sum(d => (decimal?)(d.Adet * d.BirimFiyat)) ?? 0
                    }).ToList();

                ChartLabels = js.Serialize(sonSatislar.Select(x => x.Tarih));
                ChartData = js.Serialize(sonSatislar.Select(x => x.Tutar));
            }
            catch { }
        }

        void SonSatislarGetir()
        {
            try
            {
                var liste = (from d in db.SatisDetaylari
                             join s in db.Satislar on d.SatisID equals s.SatisID
                             join m in db.Musteriler on s.MusteriID equals m.MusteriID
                             join u in db.Urunler on d.UrunID equals u.UrunID
                             orderby s.Tarih descending
                             select new
                             {
                                 Musteri = m.AdSoyad,
                                 Urun = u.UrunAdi,
                                 Fiyat = d.BirimFiyat,
                                 Adet = d.Adet,
                                 Toplam = d.Adet * d.BirimFiyat,
                                 Tarih = s.Tarih
                             }).Take(5).ToList();

                rptSonSatislar.DataSource = liste;
                rptSonSatislar.DataBind();
            }
            catch { }
        }
    }
}