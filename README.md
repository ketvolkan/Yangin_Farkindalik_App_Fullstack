# 🔥 FireAlert – Sosyal Yangın Farkındalık Platformu

FireAlert; vatandaşların gördükleri yangınları konum bilgisiyle anında bildirebildiği, bu bildirimlerin eş zamanlı olarak canlı harita üzerinde gösterildiği ve yangın güvenliği bilincini artıran açık kaynaklı bir **sosyal sorumluluk ve toplumsal dayanışma platformudur**.

> ⚠️ **Önemli Acil Durum & Yasal Uyarı:**  
> FireAlert resmi bir devlet itfaiye ihbar sistemi değildir. Kullanıcıların paylaştığı bildirimler doğrulanmış resmi yangın raporu niteliği taşımaz. Acil, tehlikeli ve hayati durumlarda lütfen vakit kaybetmeden derhal **112 Acil Çağrı Merkezi**'ni arayınız.

---

## 🌟 Temel Felsefe & Özellikler

- 🚫 **Kullanıcı Sistemi Yok**: Login, şifre, kayıt veya karmaşık roller bulunmaz.
- 📱 **Kolay Mobil Katılım**: Mobil uygulama ilk açılışta yalnızca **Ad Soyad** alır ve yerel depolamada (`GetStorage`) saklar.
- 🗺️ **Canlı Harita & Gerçek Zamanlı Takip**: Harita üzerinde yangın türüne özel ikonlar ve anlık bildirimler.
- ⚡ **SignalR Anlık Güncelleme**: Mobil uygulamadan ihbar gönderildiği anda Web Dashboard'da sayfa yenilenmeden marker eklenir, sayaçlar artar ve toast bildirimi gösterilir.
- 🚒 **İtfaiye Haftası & Yangın Güvenliği Rehberi**: Yangın anında yapılması gerekenler, söndürücü kullanımı (PASS kuralı) ve önleyici bilinç makaleleri.

---

## 🏗️ Gerçek Zamanlı Veri Akış Mimarisi

```text
       ┌────────────────────────┐
       │   Flutter Mobil App    │
       │ (Ad Soyad + GPS Konum) │
       └───────────┬────────────┘
                   │ POST /api/fire-reports
                   ▼
       ┌────────────────────────┐
       │   .NET 10 Web API      │
       │   (EF Core + Service)  │
       └─────┬────────────┬─────┘
             │            │
             ▼            ▼
 ┌───────────────┐   ┌────────────────────────┐
 │  PostgreSQL   │   │   SignalR FireHub      │
 │  / SQLite DB  │   │  (FireReportCreated)   │
 └───────────────┘   └────────────┬───────────┘
                                  │ WebSocket / SSE
                                  ▼
                     ┌────────────────────────┐
                     │ React + Vite Dashboard │
                     │  (Canlı Harita + Stats)│
                     └────────────────────────┘
```

---

## 🛠️ Teknoloji Yığını

### 📱 Mobil Uygulama (Mobile)
- **Framework**: Flutter 3.x & Dart 3.x
- **State Management**: GetX (Feature-based: Routes, Bindings, Controllers, Views)
- **Ağ İstemcisi**: Dio
- **Yerel Depolama**: GetStorage (`StorageService`)
- **Harita**: Flutter Map & LatLong2 (OSM / CartoDB Dark Tiles)
- **Konum & İzin**: Geolocator & Permission Handler
- **Medya**: Image Picker (Kamera & Galeri)
- **Acil Arama**: URL Launcher (`tel:112`)

### ⚙️ Backend Web API
- **Framework**: .NET 10 (ASP.NET Core Web API)
- **Mimari**: Clean / Layered Architecture (Domain, Application, Infrastructure, Api)
- **Veritabanı / ORM**: Entity Framework Core, PostgreSQL (Npgsql) & SQLite Fallback
- **Gerçek Zamanlı İletişim**: SignalR (`/hubs/fire`)
- **Dokümantasyon**: Swagger / OpenAPI
- **Birim Testleri**: xUnit & Moq

### 💻 Web Dashboard
- **Framework**: React 18, TypeScript, Vite
- **Stil & Tasarım**: Tailwind CSS (Dark Charcoal & Fire Palette)
- **Gerçek Zamanlı İstemci**: `@microsoft/signalr` Client
- **Harita**: Leaflet & React-Leaflet
- **İkonlar**: Lucide React

---

## 📁 Monorepo Dizin Yapısı

```text
FireAlert/
│
├── mobile/                  # Flutter Mobil Uygulaması (GetX Mimarisi)
│   ├── lib/
│   │   ├── app/             # Rotalar, Temalar, Global Binding
│   │   ├── core/            # Ağ, Depolama, Formatlayıcılar, Ortak Bileşenler
│   │   ├── data/            # Modeller, Sağlayıcılar, Repository'ler
│   │   └── modules/         # Onboarding, Home, Fire Report, Map, Blog
│   └── test/                # Flutter Birim & Widget Testleri
│
├── backend/                 # .NET 10 Web API
│   ├── src/
│   │   ├── FireAlert.Domain/          # Entity'ler ve Enum'lar
│   │   ├── FireAlert.Application/     # DTO'lar, Arayüzler ve Servisler
│   │   ├── FireAlert.Infrastructure/  # DbContext, Repository'ler, SignalR ve Seed Data
│   │   └── FireAlert.Api/             # Controller'lar, Hub'lar ve Program.cs
│   └── tests/
│       └── FireAlert.UnitTests/       # Backend xUnit Testleri
│
├── web/                     # React + TypeScript + Vite Web Dashboard
│   ├── src/
│   │   ├── components/      # Canlı Harita, İstatistik Kartları, Toast, Modal
│   │   ├── pages/           # Dashboard ve Blog Detay Sayfaları
│   │   ├── services/        # REST API & SignalR Servisleri
│   │   └── types/           # TypeScript Veri Tipleri
│   └── index.html
│
├── docs/                    # Mimari ve Dokümantasyon Dosyaları
├── .gitignore
└── README.md
```

---

## 📡 API Uç Noktaları (Endpoints)

### 🔴 Yangın İhbarları (Fire Reports)
| Metot | Uç Nokta | Açıklama |
| :--- | :--- | :--- |
| `GET` | `/api/fire-reports` | Kayıtlı tüm yangın bildirimlerini listeler |
| `GET` | `/api/fire-reports/active` | Aktif (Reported, Reviewed) yangınları listeler |
| `GET` | `/api/fire-reports/{id}` | Belirli bir bildirimin detayını getirir |
| `POST` | `/api/fire-reports` | Yeni yangın ihbarı oluşturur ve SignalR ile yayınlar |

**Yeni İhbar Gönderim Gövdesi (JSON):**
```json
{
  "reporterName": "Volkan Ket",
  "fireType": "Forest",
  "description": "Yoğun duman ve alevler görülüyor.",
  "latitude": 37.8636,
  "longitude": 27.2619,
  "imageUrl": null
}
```

### 📊 İstatistikler (Statistics)
| Metot | Uç Nokta | Açıklama |
| :--- | :--- | :--- |
| `GET` | `/api/statistics` | Bugün, Bu Hafta, Bu Ay ve Toplam ihbar sayıları |

**Yanıt Örneği:**
```json
{
  "today": 12,
  "thisWeek": 48,
  "thisMonth": 137,
  "total": 421
}
```

### 📰 Yangın Güvenliği & Blog
| Metot | Uç Nokta | Açıklama |
| :--- | :--- | :--- |
| `GET` | `/api/blog` | Yangın güvenliği ve bilinç makalelerini listeler |
| `GET` | `/api/blog/{slug}` | Slug değerine göre makale detayını getirir |

### ⚡ SignalR Hub
- **Hub URL**: `/hubs/fire`
- **Olaylar (Events)**:
  - `FireReportCreated`: Yeni bir yangın ihbarı eklendiğinde güncel istatistiklerle birlikte fırlatılır.
  - `StatisticsUpdated`: İstatistikler güncellendiğinde tüm bağlı istemcilere yayınlanır.

---

## 🚀 Kurulum ve Çalıştırma

### 1. Depoyu Klonlayın
```bash
git clone https://github.com/ketvolkan/Yangin_Farkindalik_App_Fullstack.git FireAlert
cd FireAlert
```

### 2. Backend API'yi Başlatın (.NET 10)
```bash
cd backend/src/FireAlert.Api
dotnet run
```
- API adresi: `http://localhost:5000`
- Swagger arayüzü: `http://localhost:5000/swagger`

### 3. Web Dashboard'u Başlatın (React + Vite)
```bash
cd web
npm install
npm run dev
```
- Web adresi: `http://localhost:3000`

### 4. Mobil Uygulamayı Başlatın (Flutter)
```bash
cd mobile
flutter pub get
flutter run
```

---

## 🧪 Testleri Çalıştırma

### Mobil Testleri (Flutter)
```bash
cd mobile
flutter test
```

### Backend Testleri (.NET xUnit)
```bash
cd backend
dotnet test
```

---

## 📜 Conventional Git Commit Geçmişi

1. `chore: initialize FireAlert monorepo`
2. `feat: initialize flutter getx architecture`
3. `feat: add local user onboarding`
4. `feat: initialize dotnet 10 api`
5. `feat: add fire report api`
6. `feat: add mobile fire reporting`
7. `feat: add mobile fire map`
8. `feat: add blog module`
9. `feat: initialize react dashboard`
10. `feat: add web fire map`
11. `feat: add fire statistics dashboard`
12. `feat: add realtime fire report updates`
13. `refactor: polish FireAlert user experience`
14. `test: add core FireAlert tests`
15. `docs: complete FireAlert documentation`

---

## 🤝 Katkıda Bulunma ve Lisans

Bu proje, açık kaynak topluluğunun yangın farkındalığını artırmak amacıyla geliştirilmiştir. MIT lisansı ile lisanslanmıştır.
