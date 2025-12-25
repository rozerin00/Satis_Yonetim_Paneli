using System;
using System.Linq;
using System.Web.UI.WebControls;

namespace SatisPaneli
{
    public partial class Login : System.Web.UI.Page
    {
        // Manuel Kontrol Tanımları (Designer dosyası eksik/bozuk olduğu için)
        // Sadece designer dosyasında OLMAYANLARI buraya ekliyoruz.
        protected Button btnMusteriGiris;
        protected TextBox txtMusteriEmail;
        protected TextBox txtMusteriSifre;
        
        protected void btnGiris_Click(object sender, EventArgs e)
        {
            string kAdi = txtKullanici.Text.Trim();
            string sifre = txtSifre.Text.Trim();

            if (kAdi == "admin" && sifre == "123")
            {
                Session["Kullanici"] = kAdi;
                Session["Rol"] = "Yonetici"; // Tam Yetkili
                Response.Redirect("Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            else if (kAdi == "kasiyer" && sifre == "123")
            {
                Session["Kullanici"] = kAdi;
                Session["Rol"] = "Personel"; // Kısıtlı Yetki (Sadece Satış)
                Response.Redirect("SatisYap.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            else
            {
                lblHata.Text = "Kullanıcı adı veya şifre hatalı!";
            }
        }

        protected void btnMusteriGiris_Click(object sender, EventArgs e)
        {
            // Veri tabanı bağlantısını kullanacağız (SatisDBEntities context'i class içinde 'db' olarak tanımlı değilse burada tanımlayacağız)
            // Ama yukarıda tanımlamamışız, bu dosyada da 'db' lazım. login partial oldugu için göremeyebiliriz, private field eklesem iyi olur.
            // Ama method içinde tanımlayalım garanti olsun.
            using (SatisDBEntities db = new SatisDBEntities())
            {
                string email = txtMusteriEmail.Text.Trim();
                string sifre = txtMusteriSifre.Text.Trim();

                if (!string.IsNullOrEmpty(email) && !string.IsNullOrEmpty(sifre))
                {
                    // Şifreli giriş kontrolü (Raw SQL)
                    // Kullanici var mı?
                    var musteriAdi = db.Database.SqlQuery<string>("SELECT AdSoyad FROM Musteriler WHERE Email = @p0 AND Sifre = @p1", email, sifre).FirstOrDefault();

                    if (!string.IsNullOrEmpty(musteriAdi))
                    {
                        // Giriş Başarılı
                        Session["Kullanici"] = musteriAdi;
                        Session["Rol"] = "Musteri";
                        Response.Redirect("UrunVitrin.aspx", false);
                        Context.ApplicationInstance.CompleteRequest();
                    }
                    else
                    {
                        lblHata.Text = "E-posta veya şifre hatalı!";
                    }
                }
                else
                {
                    lblHata.Text = "Lütfen bilgileri doldurunuz.";
                }
            }
        }
    }
}