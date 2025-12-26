using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SatisPaneli
{
    public partial class Profilim : System.Web.UI.Page
    {
        SatisDBEntities db = new SatisDBEntities();

        // CodeFile modunda kontroller runtime'da otomatik tanımlanır.
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Kullanici"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                MusteriBilgileriniGetir();
                SiparisleriGetir();
            }
        }

        void MusteriBilgileriniGetir()
        {
            string kullaniciAdi = Session["Kullanici"].ToString();
            // Basitçe isimden buluyoruz (Gerçekte ID ile çalışmalı)
            var musteri = db.Musteriler.FirstOrDefault(x => x.AdSoyad == kullaniciAdi);

            if (musteri != null)
            {
                txtAdSoyad.Text = musteri.AdSoyad;
                txtTelefon.Text = musteri.Telefon;
                
                // Email ve Adres modelde yoksa Raw SQL ile veya null kontrolüyle
                // Modelinizde bu alanlar ekli değilse hata almamak için şimdilik boş geçiyor veya catch bloğu koyuyoruz.
                try
                {
                   // Gerçek projede 'Email', 'Adres' propertyleri varsa:
                   // txtEmail.Text = musteri.Email;
                   // txtAdres.Text = musteri.Adres;
                   
                   // Raw SQL ile Email çekme örneği (Register'da eklemiştik):
                   string email = db.Database.SqlQuery<string>("SELECT Email FROM Musteriler WHERE MusteriID=@p0", musteri.MusteriID).FirstOrDefault();
                   txtEmail.Text = email;
                   
                   string adres = db.Database.SqlQuery<string>("SELECT Adres FROM Musteriler WHERE MusteriID=@p0", musteri.MusteriID).FirstOrDefault();
                   txtAdres.Text = adres;
                }
                catch { }
            }
        }

        protected void btnGuncelle_Click(object sender, EventArgs e)
        {
            try
            {
                string kullaniciAdi = Session["Kullanici"].ToString();
                var musteri = db.Musteriler.FirstOrDefault(x => x.AdSoyad == kullaniciAdi);

                if (musteri != null)
                {
                    musteri.AdSoyad = txtAdSoyad.Text;
                    musteri.Telefon = txtTelefon.Text;
                    
                    // EF tarafında save
                    db.SaveChanges();

                    // Manuel eklenen kolonları Raw SQL ile güncelle
                    string sql = "UPDATE Musteriler SET Email = @p0, Adres = @p1 WHERE MusteriID = @p2";
                    db.Database.ExecuteSqlCommand(sql, txtEmail.Text, txtAdres.Text, musteri.MusteriID);

                    // Session'ı da güncelle ki üstbar değişsin
                    Session["Kullanici"] = musteri.AdSoyad;

                    lblMesaj.Text = "Bilgileriniz başarıyla güncellendi.";
                    lblMesaj.CssClass = "alert alert-success d-block";
                }
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Hata: " + ex.Message;
                lblMesaj.CssClass = "alert alert-danger d-block";
            }
        }

        void SiparisleriGetir()
        {
            string kullaniciAdi = Session["Kullanici"].ToString();
            var musteri = db.Musteriler.FirstOrDefault(x => x.AdSoyad == kullaniciAdi);

            if (musteri != null)
            {
                // Müşterinin siparişlerini çek (Bellekte işlem yapacağız string.Join için)
                var rawSiparisler = db.Satislar
                                  .Where(s => s.MusteriID == musteri.MusteriID)
                                  .OrderByDescending(s => s.Tarih)
                                  .ToList();

                var siparisler = rawSiparisler.Select(s => new
                {
                    s.SatisID,
                    s.Tarih,
                    UrunSayisi = s.SatisDetaylari.Sum(x => (int?)x.Adet) ?? 0,
                    ToplamTutar = s.SatisDetaylari.Sum(x => (decimal?)(x.Adet * x.BirimFiyat)) ?? 0,
                    // Ürünlerin isimlerini virgülle birleştir
                    UrunAdlari = string.Join(", ", s.SatisDetaylari.Select(d => d.Urunler != null ? d.Urunler.UrunAdi : "Bilinmeyen Ürün").Distinct())
                }).ToList();

                if (siparisler.Count > 0)
                {
                    rptSiparisler.DataSource = siparisler;
                    rptSiparisler.DataBind();
                    pnlSiparisYok.Visible = false;
                }
                else
                {
                    pnlSiparisYok.Visible = true;
                }
            }
        }
    }
}
