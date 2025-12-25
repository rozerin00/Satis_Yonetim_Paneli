using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SatisPaneli
{
    public partial class MusteriYonetimi : System.Web.UI.Page
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
                MusterileriYukle();
                
                // Yetki Kontrolü: Personel düzenleme/silme yapamaz
                if (Session["Rol"] != null && Session["Rol"].ToString() == "Personel")
                {
                    btnKaydet.Visible = false;
                }
            }
        }

        void MusterileriYukle()
        {
            // Mükerrer kayıtları engellemek için AdSoyad'a göre grupluyoruz
            var liste = db.Musteriler
                          .GroupBy(m => m.AdSoyad)
                          .Select(g => g.FirstOrDefault())
                          .Select(x => new 
                          {
                              x.MusteriID,
                              x.AdSoyad,
                              Telefon = x.Telefon ?? "-",
                              Adres = x.Adres ?? "-"
                          }).ToList();

            gvMusteriler.DataSource = liste;
            gvMusteriler.DataBind();

            // Yetki Kontrolü: Personel ise GridView butonlarını gizle
            if (Session["Rol"] != null && Session["Rol"].ToString() == "Personel")
            {
                 if (gvMusteriler.Columns.Count > 0)
                 {
                     gvMusteriler.Columns[gvMusteriler.Columns.Count - 1].Visible = false;
                 }
            }
        }

        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            try
            {
                int id = 0;
                if (!string.IsNullOrEmpty(hfMusteriID.Value))
                    int.TryParse(hfMusteriID.Value, out id);

                Musteriler musteri;
                if (id > 0)
                {
                    musteri = db.Musteriler.Find(id);
                    lblMesaj.Text = "Müşteri güncellendi.";
                }
                else
                {
                    musteri = new Musteriler();
                    db.Musteriler.Add(musteri);
                    lblMesaj.Text = "Müşteri eklendi.";
                }

                musteri.AdSoyad = txtAdSoyad.Text;
                musteri.Telefon = txtTelefon.Text;
                musteri.Adres = txtAdres.Text;

                db.SaveChanges();
                lblMesaj.ForeColor = System.Drawing.Color.Green;
                
                FormuTemizle();
                MusterileriYukle();
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Hata: " + ex.Message;
                lblMesaj.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnDuzenle_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int id = Convert.ToInt32(btn.CommandArgument);

            var musteri = db.Musteriler.Find(id);
            if (musteri != null)
            {
                txtAdSoyad.Text = musteri.AdSoyad;
                txtTelefon.Text = musteri.Telefon;
                txtAdres.Text = musteri.Adres;
                hfMusteriID.Value = id.ToString();

                btnKaydet.Text = "Güncelle";
                btnKaydet.CssClass = "btn btn-primary btn-block shadow-sm font-weight-bold mb-2";
                btnVazgec.Visible = true;
            }
        }

        // ... (btnVazgec_Click and gvMusteriler_RowDeleting omitted as they don't change much except FormuTemizle call) ...

        protected void btnVazgec_Click(object sender, EventArgs e)
        {
            FormuTemizle();
        }

        protected void gvMusteriler_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int id = Convert.ToInt32(gvMusteriler.DataKeys[e.RowIndex].Value);
                var musteri = db.Musteriler.Find(id);
                
                if (musteri != null)
                {
                    if (musteri.Satislar.Count > 0)
                    {
                        lblMesaj.Text = "Bu müşteriye ait satış kayıtları var, silinemez!";
                        lblMesaj.ForeColor = System.Drawing.Color.Red;
                        return;
                    }

                    db.Musteriler.Remove(musteri);
                    db.SaveChanges();
                    lblMesaj.Text = "Müşteri silindi.";
                    lblMesaj.ForeColor = System.Drawing.Color.Orange;
                    MusterileriYukle();
                }
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Silinemedi: " + ex.Message;
                lblMesaj.ForeColor = System.Drawing.Color.Red;
            }
        }

        void FormuTemizle()
        {
            txtAdSoyad.Text = "";
            txtTelefon.Text = "";
            txtAdres.Text = "";
            hfMusteriID.Value = "";
            btnKaydet.Text = "Kaydet";
            btnKaydet.CssClass = "btn btn-success btn-block shadow-sm font-weight-bold mb-2";
            btnVazgec.Visible = false;
            lblMesaj.Text = "";
        }
    }
}
