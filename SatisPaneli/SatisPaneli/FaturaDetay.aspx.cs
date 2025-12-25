using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SatisPaneli
{
    public partial class FaturaDetay : System.Web.UI.Page
    {
        SatisDBEntities db = new SatisDBEntities();

        public int FisNo;
        public string MusteriAdi;
        public DateTime Tarih;
        public decimal GenelToplam;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Kullanici"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int id = Convert.ToInt32(Request.QueryString["id"]);
                    FaturayiGetir(id);
                }
                else
                {
                    Response.Write("Geçersiz Fatura ID.");
                    Response.End();
                }
            }
        }

        void FaturayiGetir(int satisID)
        {
            try 
            {
                // Ana Satış Bilgisi
                var satis = (from s in db.Satislar
                             join m in db.Musteriler on s.MusteriID equals m.MusteriID
                             where s.SatisID == satisID
                             select new { s.SatisID, s.Tarih, m.AdSoyad }).FirstOrDefault();

                if (satis != null)
                {
                    FisNo = satis.SatisID;
                    MusteriAdi = satis.AdSoyad;
                    Tarih = (DateTime)satis.Tarih;

                    // Detaylar (Ürünler)
                    var detaylar = (from d in db.SatisDetaylari
                                    join u in db.Urunler on d.UrunID equals u.UrunID
                                    where d.SatisID == satisID
                                    select new 
                                    {
                                        UrunAdi = u.UrunAdi,
                                        Adet = d.Adet,
                                        BirimFiyat = d.BirimFiyat,
                                        Tutar = d.Adet * d.BirimFiyat
                                    }).ToList();

                    rptFaturaDetay.DataSource = detaylar;
                    rptFaturaDetay.DataBind();

                    GenelToplam = (decimal)detaylar.Sum(x => x.Tutar);
                }
            }
            catch { }
        }
    }
}
