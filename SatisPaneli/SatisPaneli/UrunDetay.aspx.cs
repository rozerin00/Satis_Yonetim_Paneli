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
                
                // 1. DİNAMİK AÇIKLAMA OLUŞTURMA
                // Ürün adı ve kategorisinden yola çıkarak pazarlama metni oluşturuyoruz.
                string kategoriAdi = lblKategori.Text;
                string marka = urun.UrunAdi.Split(' ')[0]; // İlk kelimeyi marka varsayalım
                
                string metin = string.Format(
                    "<strong>{0}</strong>, {1} kategorisinin en çok tercih edilen modellerinden biridir. <br><br>" +
                    "Üstün performans özellikleri, şık <strong>{2}</strong> tasarımı ve dayanıklı yapısı ile hem günlük kullanım hem de profesyonel ihtiyaçlar için idealdir. " +
                    "Fiyat/performans avantajıyla öne çıkan bu ürünü, <strong>TeknoStore</strong> güvencesiyle ve hızlı teslimat avantajıyla hemen sipariş verebilirsiniz.",
                    urun.UrunAdi, kategoriAdi, marka);

                pAciklama.InnerHtml = metin;

                
                // 2. RESİM GETİRME (Raw SQL ile)
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
                
                // 3. TEKNİK ÖZELLİKLER (JSON Parse)
                string aciklamaJson = "";
                try {
                     aciklamaJson = db.Database.SqlQuery<string>("SELECT UrunAciklama FROM Urunler WHERE UrunID=@p0", id).FirstOrDefault();
                } catch {}

                if (!string.IsNullOrEmpty(aciklamaJson))
                {
                    try
                    {
                        var serializer = new JavaScriptSerializer();
                        // JSON bazen {} gelebilir, kontrol et
                        if (aciklamaJson.Trim() == "{}") throw new Exception("Empty JSON");

                        var attributes = serializer.Deserialize<Dictionary<string, string>>(aciklamaJson);

                        if (attributes != null && attributes.Count > 0)
                        {
                            string html = "<table class='table table-striped spec-table'><tbody>";
                            foreach (var attr in attributes)
                            {
                                html += "<tr><th>" + attr.Key + "</th><td>" + attr.Value + "</td></tr>";
                            }
                            html += "</tbody></table>";
                            litOzellikler.Text = html;
                        }
                        else 
                        {
                             throw new Exception("Empty Attributes");
                        }
                    }
                    catch
                    {
                        // JSON değilse veya parse edilemediyse, belki düz metindir.
                        // Metindeki her satırı veya virgülü bir özellik gibi göstermeye çalış.
                        string html = "<table class='table table-striped spec-table'><tbody>";
                        var lines = aciklamaJson.Split(new[] { ',', '\n' }, StringSplitOptions.RemoveEmptyEntries);
                        
                        foreach (var line in lines)
                        {
                            var parts = line.Split(':');
                            if (parts.Length == 2)
                            {
                                html += "<tr><th>" + parts[0].Trim().Replace("\"", "").Replace("{", "").Replace("}", "") + 
                                        "</th><td>" + parts[1].Trim().Replace("\"", "").Replace("{", "").Replace("}", "") + "</td></tr>";
                            }
                            else
                            {
                                html += "<tr><th>Özellik</th><td>" + line.Replace("\"", "").Replace("{", "").Replace("}", "") + "</td></tr>";
                            }
                        }
                        
                        // Eğer yine de çok kısa ise varsayılanı çağır
                        if (html.Length < 60)
                             litOzellikler.Text = VarsayilanOzellikUret(urun.UrunAdi, kategoriAdi);
                        else
                        {
                            html += "</tbody></table>";
                            litOzellikler.Text = html;
                        }
                    }
                }
                else
                {
                    litOzellikler.Text = VarsayilanOzellikUret(urun.UrunAdi, kategoriAdi);
                }
            }
            else
            {
                Response.Redirect("UrunVitrin.aspx");
            }
        }

        // Eğer JSON yoksa kategoriye veya isme göre sahte tablo üret
        private string VarsayilanOzellikUret(string urunAdi, string kategori)
        {
            string html = "<table class='table table-striped spec-table'><tbody>";
            
            // Markayı üründen tahmin et
            string marka = urunAdi.Split(' ')[0];
            html += "<tr><th>Marka</th><td>" + marka + "</td></tr>";
            html += "<tr><th>Model</th><td>" + urunAdi + "</td></tr>";
            html += "<tr><th>Garanti Süresi</th><td>2 Yıl (Resmi Distribütör)</td></tr>";
            html += "<tr><th>Kutu İçeriği</th><td>Ürün, Garanti Belgesi, Kullanım Kılavuzu</td></tr>";

            // Kategoriye özel eklemeler
            if (kategori.Contains("Bilgisayar") || kategori.Contains("Laptop"))
            {
                html += "<tr><th>İşlemci Tipi</th><td>Intel / AMD</td></tr>";
                html += "<tr><th>İşletim Sistemi</th><td>Windows 11 / FreeDOS</td></tr>";
            }
            else if (kategori.Contains("Telefon"))
            {
                html += "<tr><th>Ekran Teknolojisi</th><td>AMOLED / IPS LCD</td></tr>";
                html += "<tr><th>Kamera Çözünürlüğü</th><td>Yüksek Çözünürlüklü Yapay Zeka Destekli</td></tr>";
            }
             else if (kategori.Contains("Ev") || kategori.Contains("Elektronik"))
            {
                html += "<tr><th>Enerji Sınıfı</th><td>A+++</td></tr>";
                html += "<tr><th>Bağlantı</th><td>Wi-Fi / Bluetooth</td></tr>";
            }

            html += "</tbody></table>";
            return html;
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
            // Sepet Mantığı
            Dictionary<int, int> sepet = Session["Sepet"] as Dictionary<int, int>;

            // Eğer Sepet null ise VEYA session'da başka tipte veri varsa (çakışma), sepeti sıfırla
            if (sepet == null)
            {
                sepet = new Dictionary<int, int>();
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
