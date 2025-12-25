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
    }
}
