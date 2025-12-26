using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace SatisPaneli
{
    public partial class SatisRaporu : System.Web.UI.Page
    {
        // Kontrol Tanımları (Designer'da olmayanlar)
        protected global::System.Web.UI.WebControls.TextBox txtBaslangic;
        protected global::System.Web.UI.WebControls.TextBox txtBitis;
        protected global::System.Web.UI.WebControls.DropDownList ddlMusteriFiltre;
        protected global::System.Web.UI.WebControls.DropDownList ddlUrunFiltre;
        protected global::System.Web.UI.WebControls.Button btnFiltrele;
        protected global::System.Web.UI.WebControls.Button btnTemizle;
        protected global::System.Web.UI.WebControls.LinkButton btnExcel;
        protected global::System.Web.UI.WebControls.DropDownList ddlGruplama;

        // Özet Veriler (Public yaparak aspx sayfasından erişilebilir hale getiriyoruz)
        public string OzetToplamTutar = "0.00 ₺";
        public string OzetToplamAdet = "0";
        public string OzetIslemSayisi = "0";

        SatisDBEntities db = new SatisDBEntities();

        // GridView Excel Export hatasını önlemek için override
        public override void VerifyRenderingInServerForm(Control control)
        {
            
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
                MusterileriGetir();
                UrunleriGetir();
                // Varsayılan olarak son 30 günü getir
                txtBaslangic.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
                txtBitis.Text = DateTime.Now.ToString("yyyy-MM-dd");
                RaporuYukle();
            }
        }

        void MusterileriGetir()
        {
            var musteriler = (from x in db.Musteriler
                              select x.AdSoyad)
                              .Distinct()
                              .OrderBy(x => x)
                              .ToList();

            ddlMusteriFiltre.DataSource = musteriler;
            ddlMusteriFiltre.DataBind();
        }

        void UrunleriGetir()
        {
            var urunler = (from x in db.Urunler
                           select new { x.UrunID, x.UrunAdi }).ToList();

            ddlUrunFiltre.DataSource = urunler;
            ddlUrunFiltre.DataTextField = "UrunAdi";
            ddlUrunFiltre.DataValueField = "UrunID";
            ddlUrunFiltre.DataBind();
        }

        // Dropdown değiştiğinde tetiklenir
        protected void ddlGruplama_SelectedIndexChanged(object sender, EventArgs e)
        {
            RaporuYukle();
        }

        void RaporuYukle()
        {
            try
            {
                DateTime baslangicTarihi = DateTime.Now;
                DateTime bitisTarihi = DateTime.Now;

                bool bTarih = DateTime.TryParse(txtBaslangic.Text, out baslangicTarihi);
                bool fTarih = DateTime.TryParse(txtBitis.Text, out bitisTarihi);
                bool tarihSecildi = bTarih && fTarih;

                if (tarihSecildi) bitisTarihi = bitisTarihi.Date.AddDays(1).AddTicks(-1);

                string seciliMusteri = ddlMusteriFiltre.SelectedValue;
                if (seciliMusteri == null) seciliMusteri = "0";

                int seciliUrun = 0;
                if (ddlUrunFiltre.SelectedValue != null)
                    int.TryParse(ddlUrunFiltre.SelectedValue, out seciliUrun);

                var sorgu = (from d in db.SatisDetaylari
                             join u in db.Urunler on d.UrunID equals u.UrunID
                             join s in db.Satislar on d.SatisID equals s.SatisID
                             join m in db.Musteriler on s.MusteriID equals m.MusteriID
                             select new
                             {
                                 d.DetayID,
                                 MusteriID = m.MusteriID,
                                 UrunID = u.UrunID,
                                 MusteriAdSoyad = m.AdSoyad,
                                 UrunAd = u.UrunAdi,
                                 d.Adet,
                                 d.BirimFiyat,
                                 ToplamTutar = d.Adet * d.BirimFiyat,
                                 Tarih = s.Tarih
                             });

                if (seciliMusteri != "0") sorgu = sorgu.Where(x => x.MusteriAdSoyad == seciliMusteri);
                if (seciliUrun > 0) sorgu = sorgu.Where(x => x.UrunID == seciliUrun);
                if (tarihSecildi) sorgu = sorgu.Where(x => x.Tarih >= baslangicTarihi && x.Tarih <= bitisTarihi);

                // --- GRUPLAMA / SIRALAMA MANTIĞI ---
                // Dropdown'dan gelen değere göre sorguyu sıralıyoruz (Grouping mantığı görsel olarak Grid'de zor olsa da sıralama ile gruplanmış gibi görünür)
                string gruplamaTuru = ddlGruplama.SelectedValue;
                
                System.Collections.Generic.List<dynamic> raporListesi;

                if (gruplamaTuru == "Musteri")
                {
                    // Müşteriye göre sırala (Önce isim, sonra tarih)
                    raporListesi = sorgu.OrderBy(x => x.MusteriAdSoyad).ThenByDescending(x => x.Tarih).ToList<dynamic>();
                }
                else if (gruplamaTuru == "Urun")
                {
                    // Ürüne göre sırala
                    raporListesi = sorgu.OrderBy(x => x.UrunAd).ThenByDescending(x => x.Tarih).ToList<dynamic>();
                }
                else if (gruplamaTuru == "Tarih")
                {
                    // Tarihe göre sırala
                    raporListesi = sorgu.OrderByDescending(x => x.Tarih).ToList<dynamic>();
                }
                else
                {
                    // Varsayılan (Tarih Desc)
                    raporListesi = sorgu.OrderByDescending(x => x.Tarih).ToList<dynamic>();
                }


                if (raporListesi.Any())
                {
                    OzetToplamTutar = string.Format("{0:C}", raporListesi.Sum(x => (decimal)x.ToplamTutar));
                    OzetToplamAdet = raporListesi.Sum(x => (short)x.Adet).ToString();
                    OzetIslemSayisi = raporListesi.Count.ToString();
                }
                else
                {
                    OzetToplamTutar = "0.00 ₺";
                    OzetToplamAdet = "0";
                    OzetIslemSayisi = "0";
                }

                gvSatisRaporu.DataSource = raporListesi;
                gvSatisRaporu.DataBind();
            }
            catch (Exception)
            {
            }
        }
        protected void btnFiltrele_Click(object sender, EventArgs e)
        {
            RaporuYukle();
        }

        protected void btnTemizle_Click(object sender, EventArgs e)
        {
            try
            {
                ddlMusteriFiltre.ClearSelection();
                if (ddlMusteriFiltre.Items.FindByValue("0") != null)
                    ddlMusteriFiltre.Items.FindByValue("0").Selected = true;

                ddlUrunFiltre.ClearSelection();
                if (ddlUrunFiltre.Items.FindByValue("0") != null)
                    ddlUrunFiltre.Items.FindByValue("0").Selected = true;

                txtBaslangic.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
                txtBitis.Text = DateTime.Now.ToString("yyyy-MM-dd");

                RaporuYukle();
            }
            catch { }
        }
    }
}