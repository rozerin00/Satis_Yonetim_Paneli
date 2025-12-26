# 📦 Satış Yönetim Paneli (Sales Management Panel)

**Satış Yönetim Paneli**, işletmelerin ürün, stok, müşteri ve satış süreçlerini dijital ortamda verimli bir şekilde yönetmelerini sağlayan kapsamlı bir **ASP.NET Web Forms** uygulamasıdır. Modern arayüzü ve gelişmiş özellikleri ile işletme sahiplerine tam kontrol sağlar.

## 🚀 Proje Hakkında

Bu proje, stok takibinden satış raporlamaya, müşteri yönetiminden faturalandırmaya kadar bir işletmenin temel ihtiyaçlarını karşılamak üzere geliştirilmiştir. Kullanıcı dostu arayüzü için **AdminLTE** şablonu entegre edilmiş ve modern web standartlarına uygun hale getirilmiştir.

## ✨ Temel Özellikler

### 🛡️ Stok ve Ürün Yönetimi
*   **Ürün Listeleme & Düzenleme:** Ürünlerinizi kategorize edin, fiyatlandırın ve stok durumlarını anlık olarak takip edin.
*   **Kritik Stok Uyarıları:** Stok miktarı azalan ürünler için otomatik uyarı sistemi (`Default.aspx` paneli üzerinde).
*   **Teknik Özellikler:** Ürünlere JSON formatında detaylı teknik özellikler ekleyebilme (`UrunDetay.aspx`).
*   **Toplu Veri Yükleme:** `VeriYukle.aspx` aracı ile hızlıca örnek veri seti oluşturma.

### 👥 Müşteri Yönetimi (CRM)
*   **Müşteri Kayıtları:** Müşteri iletişim bilgileri, adres ve geçmiş işlem kayıtlarını saklayın.
*   **Adres Yönetimi:** Müşteriler için detaylı adres tanımlama.

### 💰 Satış ve Fatura İşlemleri
*   **Hızlı Satış Ekranı:** `SatisYap.aspx` üzerinden kolay ve hızlı satış işlemleri.
*   **Sepet Uygulaması:** Müşterilerin ürünleri sepete ekleyip sipariş oluşturabilmesi.
*   **Fatura Detayları:** Satışlara ait faturaların görüntülenmesi.

### 📊 Raporlama ve Analiz
*   **Satış Raporları:** Tarih, ürün veya kategori bazlı detaylı satış raporları.
*   **Stok Geçmişi:** Ürün hareketlerinin zaman çizelgesi.

### 👤 Kullanıcı ve Profil İşlemleri
*   **Güvenli Giriş/Kayıt:** Rol tabanlı kimlik doğrulama.
*   **Profil Yönetimi:** Kullanıcıların kendi bilgilerini güncelleyebileceği `Profilim.aspx`.

### 🖥️ Arayüz ve Sunum
*   **Modern Tasarım:** AdminLTE tabanlı, responsive (mobil uyumlu) yönetim paneli.
*   **Sunum Modu:** Projenin teknik detaylarını ve modüllerini anlatan interaktif `Sunum.aspx` sayfası.

## 🛠️ Kullanılan Teknolojiler

*   **Backend:** C# (.NET Framework), ASP.NET Web Forms
*   **Veritabanı:** Microsoft SQL Server, Entity Framework (ORM)
*   **Frontend:** HTML5, CSS3, JavaScript, Bootstrap, AdminLTE
*   **Veri Formatı:** JSON (Ürün teknik özellikleri için)

## ⚙️ Kurulum ve Çalıştırma

1.  **Projeyi Klonlayın/İndirin:** Dosyaları bilgisayarınıza kaydedin.
2.  **Visual Studio ile Açın:** `SatisPaneli.sln` dosyasını çift tıklayarak projeyi açın.
3.  **Veritabanı Ayarları:**
    *   SQL Server'ınızda veritabanını oluşturun veya Entity Framework'ün oluşturmasına izin verin.
    *   `Web.config` dosyasındaki `connectionStrings` bölümünü kendi veritabanı sunucunuza göre güncelleyin.
4.  **Paketleri Yükleyin:** "NuGet Package Manager" kullanarak eksik paketleri restore edin.
5.  **Projeyi Başlatın:** `IIS Express` butonuna tıklayarak veya `F5` tuşu ile uygulamayı tarayıcıda çalıştırın.

---
*Geliştirici Notu: Bu proje eğitim ve geliştirme amaçlı hazırlanmıştır. Katkıda bulunmak için Pull Request gönderebilirsiniz.*
