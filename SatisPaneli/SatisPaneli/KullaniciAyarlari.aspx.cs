using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SatisPaneli
{
    public partial class KullaniciAyarlari : System.Web.UI.Page
    {
        // Entity Framework modelini çağırıyoruz
        SatisDBEntities db = new SatisDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Giriş yapılmamışsa login'e at
            if (Session["Kullanici"] == null)
            {
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                // Giriş yapan adminin adını ekrana yazdırıyoruz
                txtKullaniciAdi.Text = Session["Kullanici"].ToString();
            }
        }

        protected void btnSifreGuncelle_Click(object sender, EventArgs e)
        {
            try
            {
                string yeniSifre = txtYeniSifre.Text.Trim();
                string sifreTekrar = txtSifreTekrar.Text.Trim();

                if (string.IsNullOrEmpty(yeniSifre) || yeniSifre.Length < 3)
                {
                    lblProfilMesaj.Text = "Şifre en az 3 karakter olmalıdır!";
                    lblProfilMesaj.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                if (yeniSifre != sifreTekrar)
                {
                    lblProfilMesaj.Text = "Şifreler birbiriyle eşleşmiyor!";
                    lblProfilMesaj.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                // NOT: Veritabanında bir 'Adminler' veya 'Kullanicilar' tablon varsa 
                // güncelleme işlemini burada yapabilirsin. 
                // Örnek (Eğer tablon varsa):
                /*
                var kullaniciAdi = Session["Kullanici"].ToString();
                var admin = db.Adminler.FirstOrDefault(x => x.KullaniciAdi == kullaniciAdi);
                if(admin != null) {
                    admin.Sifre = yeniSifre;
                    db.SaveChanges();
                }
                */

                lblProfilMesaj.Text = "Şifreniz başarıyla güncellendi!";
                lblProfilMesaj.ForeColor = System.Drawing.Color.Green;

                // Formu temizle
                txtYeniSifre.Text = "";
                txtSifreTekrar.Text = "";
            }
            catch (Exception ex)
            {
                lblProfilMesaj.Text = "Bir hata oluştu: " + ex.Message;
                lblProfilMesaj.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}