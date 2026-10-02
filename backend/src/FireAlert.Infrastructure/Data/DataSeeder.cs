using FireAlert.Domain.Entities;
using FireAlert.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace FireAlert.Infrastructure.Data;

public static class DataSeeder
{
    public static async Task SeedAsync(FireAlertDbContext context)
    {
        // Seed Blog Posts
        if (!await context.BlogPosts.AnyAsync())
        {
            var blogPosts = new List<BlogPost>
            {
                new()
                {
                    Title = "Yangın Anında Ne Yapmalıyız? Hayati Adımlar",
                    Slug = "yangin-aninda-ne-yapmaliyiz",
                    Content = "Yangın anında sükunetinizi korumak en önemli adımdır. İlk olarak çevrenizdekileri uyarın ve derhal 112 Acil Çağrı Merkezi'ni arayarak tam adres ve yangın türü bilgisini verin. Duman yükseldiğinde yere yakın durarak emekleyin, çünkü temiz hava tabana yakındır. Asansörleri kesinlikle kullanmayın, yangın merdivenlerine yönelin. Kapı kollarını açmadan önce elinizin tersiyle sıcaklığını kontrol edin.",
                    CreatedAt = DateTime.UtcNow.AddDays(-10)
                },
                new()
                {
                    Title = "Orman Yangınlarını Önlemek İçin Bireysel Sorumluluklarımız",
                    Slug = "orman-yanginlarini-onlemek",
                    Content = "Orman yangınlarının %90'a yakını insan kaynaklı ihmallerden ortaya çıkmaktadır. Yaz aylarında ormanlık alanlarda kesinlikle ateş yakılmamalı, sigara izmariti ve cam şişeler doğaya atılmamalıdır. Cam kırıkları büyüteç etkisi yaparak kuru otları tutuşturabilir. Ormanda duman veya alev gördüğünüz anda FireAlert ve 112 üzerinden bildirim yapın.",
                    CreatedAt = DateTime.UtcNow.AddDays(-8)
                },
                new()
                {
                    Title = "Elektrik Yangınlarında Dikkat Edilmesi Gerekenler",
                    Slug = "elektrik-yanginlarinda-dikkat-edilmesi-gerekenler",
                    Content = "Elektrik tesisatından kaynaklanan yangınlara ASLA SU İLE MÜDAHALE EDİLMEMELİDİR. Su elektriği iletir ve elektrik çarpması riskini doğurur. İlk yapılması gereken ana sigortayı kapatmaktır. Müdahale için Kuru Kimyevi Tozlu (KKT) veya Karbondioksitli (CO2) yangın söndürücüler kullanılmalıdır.",
                    CreatedAt = DateTime.UtcNow.AddDays(-5)
                },
                new()
                {
                    Title = "Yangın Söndürücü Kullanımı: PASS Kuralı",
                    Slug = "yangin-sondurucu-kullanimi-pass-kurali",
                    Content = "Yangın tüpü kullanımında uluslararası standart olan PASS kuralını uygulayın: P (Pull/Pimi çek) - A (Aim/Alevin köküne yönelt) - S (Squeeze/Mandalı sık) - S (Sweep/Süpürür gibi sağa-sola hareket ettir). Yangın söndürücüyü alevlerin üstüne değil, doğrudan yanan maddenin dip noktasına yöneltmelisiniz.",
                    CreatedAt = DateTime.UtcNow.AddDays(-3)
                },
                new()
                {
                    Title = "İtfaiyecilerin Görevleri ve Toplumsal Rolü",
                    Slug = "itfaiyecilerin-gorevleri",
                    Content = "İtfaiye teşkilatı yalnızca yangın söndürme görevini değil; trafik kazalarında kurtarma, su baskınları, deprem ve göçük arama-kurtarma operasyonları gibi tüm afetlerde 7/24 kesintisiz hizmet vermektedir. Her yıl 25 Eylül - 1 Ekim tarihleri arasında kutlanan İtfaiye Haftası'nda kahraman itfaiyecilerimize şükranlarımızı sunuyoruz.",
                    CreatedAt = DateTime.UtcNow.AddDays(-1)
                },
                new()
                {
                    Title = "Ev ve İş Yerlerinde Yangın Güvenliği İçin Temel Bilgiler",
                    Slug = "yangin-guvenligi-icin-temel-bilgiler",
                    Content = "Her evde en az bir adet duman detektörü ve 6 kg'lık ABC tipi kuru kimyevi tozlu yangın söndürme cihazı bulunmalıdır. Yangın kaçış yolları ve acil çıkış kapıları asla kilitlenmemeli veya eşya ile kapatılmamalıdır. Ailenizle birlikte yılda en az bir kez yangın tahliye tatbikatı yapınız.",
                    CreatedAt = DateTime.UtcNow
                }
            };

            await context.BlogPosts.AddRangeAsync(blogPosts);
        }

        // Seed Sample Fire Reports
        if (!await context.FireReports.AnyAsync())
        {
            var reports = new List<FireReport>
            {
                new()
                {
                    ReporterName = "Volkan Ket",
                    FireType = FireType.Forest,
                    Description = "Dilek Yarımadası eteklerinde yoğun duman ve alevler görülüyor.",
                    Latitude = 37.8636,
                    Longitude = 27.2619,
                    Status = FireReportStatus.Reported,
                    CreatedAt = DateTime.UtcNow.AddMinutes(-35)
                },
                new()
                {
                    ReporterName = "Ahmet Yılmaz",
                    FireType = FireType.Building,
                    Description = "Sanayi sitesinde ahşap atölyesinde duman çıkışı var.",
                    Latitude = 38.4237,
                    Longitude = 27.1428,
                    Status = FireReportStatus.Reported,
                    CreatedAt = DateTime.UtcNow.AddHours(-2)
                },
                new()
                {
                    ReporterName = "Ayşe Kaya",
                    FireType = FireType.Vehicle,
                    Description = "Otoyol kenarında araç motor kısmından alev aldı.",
                    Latitude = 36.8969,
                    Longitude = 30.7133,
                    Status = FireReportStatus.Reported,
                    CreatedAt = DateTime.UtcNow.AddHours(-5)
                },
                new()
                {
                    ReporterName = "Mehmet Demir",
                    FireType = FireType.Electric,
                    Description = "Trafo patlaması sonucu küçük çaplı kıvılcım ve alevlenme var.",
                    Latitude = 41.0082,
                    Longitude = 28.9784,
                    Status = FireReportStatus.Reported,
                    CreatedAt = DateTime.UtcNow.AddDays(-1)
                },
                new()
                {
                    ReporterName = "Canan Öztürk",
                    FireType = FireType.Forest,
                    Description = "Kırsal alanda anız yakımı kontrolden çıkmış durumda.",
                    Latitude = 37.0662,
                    Longitude = 37.3833,
                    Status = FireReportStatus.Reported,
                    CreatedAt = DateTime.UtcNow.AddDays(-2)
                }
            };

            await context.FireReports.AddRangeAsync(reports);
        }

        await context.SaveChangesAsync();
    }
}
