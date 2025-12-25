using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SatisPaneli
{
    public partial class Register : System.Web.UI.Page
    {
        SatisDBEntities db = new SatisDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnGoogleLogin_Click(object sender, EventArgs e)
        {
            // Google Login Simülasyonu
            // Gerçek projede burada OAuth2 işlemleri yapılır.
            // Biz burada örnek bir Google kullanıcısı varmış gibi davranacağız.

            string googleUserEmail = "google_demo@teknostore.com";
            string googleUserName = "Google Kullanıcısı";

            // Bu kullanıcı veritabanında var mı?
            var userCount = db.Database.SqlQuery<int>("SELECT COUNT(*) FROM Musteriler WHERE Email = @p0", googleUserEmail).FirstOrDefault();

            if (userCount == 0)
            {
                // Yoksa otomatik oluştur (Şifreyi rastgele karmaşık bir şey yapalım)
                string sql = "INSERT INTO Musteriler (AdSoyad, Telefon, Adres, Email, Sifre) VALUES (@p0, @p1, @p2, @p3, @p4)";
                db.Database.ExecuteSqlCommand(sql, googleUserName, "-", "-", googleUserEmail, Guid.NewGuid().ToString().Substring(0, 8));
            }

            // Doğrudan giriş yap
            Session["Kullanici"] = googleUserName;
            Session["Rol"] = "Musteri";
            Response.Redirect("UrunVitrin.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnKayit_Click(object sender, EventArgs e)
        {
            string ad = txtAdSoyad.Text.Trim();
            string email = txtEmail.Text.Trim();
            string tel = txtTelefon.Text.Trim();
            string sifre = txtSifre.Text.Trim();
            
            // ... (rest of the code)
            {
                lblMesaj.Text = "Lütfen tüm zorunlu alanları doldurunuz!";
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                return;
            }

            try
            {
                // Önce Email kontrolü (Raw SQL)
                var mevcutMu = db.Database.SqlQuery<int>("SELECT COUNT(*) FROM Musteriler WHERE Email = @p0", email).FirstOrDefault();
                if (mevcutMu > 0)
                {
                    lblMesaj.Text = "Bu e-posta adresi zaten kayıtlı!";
                    lblMesaj.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                // Yeni Müşteri Ekle (EF + Raw SQL hibrit)
                // EF modelimizde Email/Sifre yok, o yüzden önce EF ile temel kaydı atıp ID'yi alacağız
                // VEYA direkt Raw SQL insert yapacağız. Raw SQL daha temiz burada.
                
                string sql = "INSERT INTO Musteriler (AdSoyad, Telefon, Adres, Email, Sifre) VALUES (@p0, @p1, @p2, @p3, @p4)";
                db.Database.ExecuteSqlCommand(sql, ad, tel, "-", email, sifre);

                lblMesaj.Text = "Kayıt başarılı! Giriş sayfasına yönlendiriliyorsunuz...";
                lblMesaj.ForeColor = System.Drawing.Color.Green;

                // 2 saniye sonra login'e at (Meta refresh yok ama kullanıcı okusun diye bekleyebiliriz veya direkt atabiliriz)
                Response.AddHeader("REFRESH", "2;URL=Login.aspx");
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Hata oluştu: " + ex.Message;
                lblMesaj.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}
