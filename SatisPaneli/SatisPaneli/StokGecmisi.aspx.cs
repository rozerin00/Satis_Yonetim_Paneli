using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SatisPaneli
{
    public partial class StokGecmisi : System.Web.UI.Page
    {
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
                HareketleriListele();
            }
        }

        void HareketleriListele()
        {
            // Şimdilik sadece Satışları (Stok Çıkış) 'Hareket' olarak kabul ediyoruz.
            // İleride 'StokGiris' tablosu yapılırsa Union ile birleştirilebilir.
            
            var hareketler = (from d in db.SatisDetaylari
                              join s in db.Satislar on d.SatisID equals s.SatisID
                              join u in db.Urunler on d.UrunID equals u.UrunID
                              join m in db.Musteriler on s.MusteriID equals m.MusteriID
                              orderby s.Tarih descending
                              select new
                              {
                                  IslemTarihi = s.Tarih,
                                  UrunAdi = u.UrunAdi,
                                  IslemTuru = "Satış (Çıkış)",
                                  Miktar = d.Adet,
                                  IlgiliKisi = m.AdSoyad,
                                  Tutar = d.Adet * d.BirimFiyat
                              }).ToList();

            if (hareketler.Count > 0)
            {
                Repeater1.DataSource = hareketler;
                Repeater1.DataBind();
            }
            else
            {
                lblMesaj.Text = "Henüz kaydedilmiş bir stok hareketi bulunmuyor.";
                lblMesaj.Visible = true;
            }
        }
    }
}
