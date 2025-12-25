using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;

namespace SatisPaneli
{
    public partial class UrunDetay : System.Web.UI.Page
    {
        SatisDBEntities db = new SatisDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int id;
                    if (int.TryParse(Request.QueryString["id"], out id))
                    {
                        UrunuGetir(id);
                    }
                }
                else
                {
                    Response.Redirect("UrunVitrin.aspx");
                }
            }
        }

        void UrunuGetir(int id)
        {
            var urun = db.Urunler.Find(id);
            if (urun != null)
            {
                lblUrunAdi.Text = urun.UrunAdi;
                lblFiyat.Text = string.Format("{0:C}", urun.BirimFiyat);
                lblKategori.Text = urun.Kategoriler != null ? urun.Kategoriler.KategoriAdi : "Genel";
                
                
                // Resim Getir (Raw SQL ile çünkü modelde olmayabilir)
                string resimUrl = "";
                try {
                     resimUrl = db.Database.SqlQuery<string>("SELECT UrunResim FROM Urunler WHERE UrunID=@p0", id).FirstOrDefault();
                } catch {}

                if (!string.IsNullOrEmpty(resimUrl))
                {
                    imgUrun.Src = resimUrl;
                }
                else
                {
                    imgUrun.Src = "https://via.placeholder.com/600x600?text=" + urun.UrunAdi.Replace(" ", "+");
                }
                
                // Detaylı Açıklama (JSON Parse)
                // UrunAciklama Property'si modelde yoksa Raw SQL ile çekmeliyiz
                string aciklamaJson = "";
                try {
                     aciklamaJson = db.Database.SqlQuery<string>("SELECT UrunAciklama FROM Urunler WHERE UrunID=@p0", id).FirstOrDefault();
                } catch {}

                if (!string.IsNullOrEmpty(aciklamaJson))
                {
                    try
                    {
                        var serializer = new JavaScriptSerializer();
                        var attributes = serializer.Deserialize<Dictionary<string, string>>(aciklamaJson);

                        string html = "<table class='table table-striped spec-table'><tbody>";
                        foreach (var attr in attributes)
                        {
                            html += "<tr><th>" + attr.Key + "</th><td>" + attr.Value + "</td></tr>";
                        }
                        html += "</tbody></table>";
                        
                        litOzellikler.Text = html;
                    }
                    catch
                    {
                        // JSON değilse düz metin bas
                        litOzellikler.Text = "<p>" + aciklamaJson + "</p>";
                    }
                }
                else
                {
                    litOzellikler.Text = "<p class='text-muted'>Bu ürün için teknik özellik girilmemiştir.</p>";
                }
            }
            else
            {
                Response.Redirect("UrunVitrin.aspx");
            }
        }

        protected void btnSepeteEkle_Click(object sender, EventArgs e)
        {
            // Kullanıcı girişi kontrolü
            if (Session["Kullanici"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int urunId = int.Parse(Request.QueryString["id"]);
            
            // Sepet Mantığı
            Dictionary<int, int> sepet;
            if (Session["Sepet"] == null)
            {
                sepet = new Dictionary<int, int>();
            }
            else
            {
                sepet = (Dictionary<int, int>)Session["Sepet"];
            }

            if (sepet.ContainsKey(urunId))
            {
                sepet[urunId]++;
            }
            else
            {
                sepet.Add(urunId, 1);
            }

            Session["Sepet"] = sepet;
            Response.Redirect("Sepet.aspx");
        }
    }
}
