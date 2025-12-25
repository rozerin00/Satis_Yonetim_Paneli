using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SatisPaneli
{
    public partial class UrunYonetimi : System.Web.UI.Page
    {
        // Veritabanı modelimizi çağırıyoruz
        SatisDBEntities db = new SatisDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                VerileriListele();
            }
        }

        // Tabloyu veritabanından çekip listeleyen metod
        void VerileriListele()
        {
            var urunler = db.Urunler.ToList();
            GridView1.DataSource = urunler;
            GridView1.DataBind();
        }

        // Kaydet butonuna tıklandığında çalışan kodlar
        protected void btnkaydet_Click(object sender, EventArgs e)
        {
            try
            {
                Urunler yeniUrun = new Urunler();
                yeniUrun.UrunAdi = txturunad.Text;
                yeniUrun.BirimFiyati = decimal.Parse(txtBirimFiyat.Text);

                db.Urunler.Add(yeniUrun);
                db.SaveChanges();

                lblMesaj.Text = "Ürün başarıyla eklendi!";
                lblMesaj.ForeColor = System.Drawing.Color.Green;

                // Formu temizle ve listeyi güncelle
                txturunad.Text = "";
                txtBirimFiyat.Text = "";
                VerileriListele();
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Hata oluştu: " + ex.Message;
                lblMesaj.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}