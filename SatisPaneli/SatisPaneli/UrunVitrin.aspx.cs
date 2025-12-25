using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace SatisPaneli
{
    public partial class UrunVitrin : System.Web.UI.Page
    {
        SatisDBEntities db = new SatisDBEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                KategorileriGetir();
                UrunleriGetir();
            }
        }

        void KategorileriGetir()
        {
            var kategoriler = db.Kategoriler.ToList();
            rptKategoriler.DataSource = kategoriler;
            rptKategoriler.DataBind();
        }

        void UrunleriGetir()
        {
            var query = db.Urunler.AsQueryable();

            // Kategori Filtresi
            if (!string.IsNullOrEmpty(Request.QueryString["kat"]))
            {
                int katID = Convert.ToInt32(Request.QueryString["kat"]);
                query = query.Where(x => x.KategoriID == katID);
            }

            // Arama Filtresi
            if (!string.IsNullOrEmpty(txtSearch.Text))
            {
                string aranan = txtSearch.Text.ToLower();
                query = query.Where(x => x.UrunAdi.ToLower().Contains(aranan));
            }

            // Verileri Çek
            var urunler = query.ToList().Select(x => new
            {
                x.UrunID,
                x.UrunAdi,
                x.BirimFiyat,
                x.Stok,
                KategoriAdi = x.Kategoriler != null ? x.Kategoriler.KategoriAdi : "Genel",
                KisaAciklama = "En kaliteli teknoloji ürünü.",
                Aciklama = GetUrunAciklama(x.UrunID),
                ResimUrl = GetUrunResim(x.UrunID)
            }).ToList();

            rptUrunler.DataSource = urunler;
            rptUrunler.DataBind();

            lblUrunSayisi.Text = urunler.Count.ToString();
        }

        public string GetUrunAciklama(int id)
        {
            try
            {
                 return "Yeni nesil teknoloji.";
            }
            catch { return ""; }
        }

        public string GetUrunResim(int id)
        {
            try
            {
                string url = db.Database.SqlQuery<string>("SELECT UrunResim FROM Urunler WHERE UrunID=@p0", id).FirstOrDefault();
                if (string.IsNullOrEmpty(url)) return "https://via.placeholder.com/300x300.png?text=Urun";
                return url;
            }
            catch { return "https://via.placeholder.com/300x300.png?text=Urun"; }
        }


        protected void btnAra_Click(object sender, EventArgs e)
        {
            UrunleriGetir();
        }

        protected void rptUrunler_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SepeteEkle")
            {
                // Giriş kontrolü
                if (Session["Kullanici"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                int urunId = Convert.ToInt32(e.CommandArgument);

                // Sepet: Dictionary<UrunID, Adet>
                Dictionary<int, int> sepet;

                if (Session["Sepet"] == null)
                {
                    sepet = new Dictionary<int, int>();
                }
                else
                {
                    sepet = (Dictionary<int, int>)Session["Sepet"];
                }

                // Ürün varsa adeti artır, yoksa ekle
                if (sepet.ContainsKey(urunId))
                {
                    sepet[urunId]++;
                }
                else
                {
                    sepet.Add(urunId, 1);
                }

                // Session'ı güncelle
                Session["Sepet"] = sepet;

                // Kullanıcıya bilgi ver (Basit alert veya postback sonrası UI güncellemesi)
                // Şimdilik navbar güncellemesi yeterli, zaten postback oluyor.
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Ürün sepete eklendi!');", true);
            }
            else if (e.CommandName == "Detay")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                var urun = db.Urunler.Find(id);
                if(urun != null)
                {
                    string hamDetay = GetUrunAciklama(id);
                    string htmlTable = "";

                    // JSON Parsing
                    if (!string.IsNullOrEmpty(hamDetay) && hamDetay.Trim().StartsWith("{"))
                    {
                        try
                        {
                            var dict = JsonConvert.DeserializeObject<Dictionary<string, string>>(hamDetay);
                            htmlTable = "<table class='table table-sm table-striped modal-table mb-0'>";
                            foreach (var item in dict)
                            {
                                htmlTable += string.Format("<tr><td>{0}</td><td>{1}</td></tr>", item.Key, item.Value);
                            }
                            htmlTable += "</table>";
                        }
                        catch 
                        {
                            htmlTable = "<div class='p-3'>" + hamDetay + "</div>";
                        }
                    }
                    else
                    {
                        htmlTable = "<div class='p-3 text-muted'>" + (string.IsNullOrEmpty(hamDetay) ? "Detay bulunamadı." : hamDetay) + "</div>";
                    }

                    // Javascript fonksiyonunu çağır
                    string script = string.Format("openUrunModal('{0}', '{1:C}', `{2}`);", urun.UrunAdi, urun.BirimFiyat, htmlTable);
                    ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", script, true);
                }
            }
        }
    }
}
