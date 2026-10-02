# 🔥 FireAlert – Sosyal Yangın Farkındalık Platformu

FireAlert; insanların gördükleri yangınları konum bilgisiyle bildirebildiği, bu bildirimlerin canlı olarak harita üzerinde gösterildiği ve yangın güvenliği konusunda toplumsal farkındalık oluşturan açık ve şeffaf bir sosyal sorumluluk platformudur.

> ⚠️ **Yasal Uyarı / Acil Durum Notu:** Bu proje bir resmi itfaiye sistemi değildir. Kullanıcıların oluşturduğu bildirimler doğrulanmış resmi yangın ihbarları değildir. Acil durumlarda lütfen derhal **112 Acil Çağrı Merkezi**'ni arayınız.

---

## 🏗️ Proje Mimarisi

- **Mobile App**: Flutter, Dart, GetX, Dio, GetStorage, Geolocator, Flutter Map
- **Backend API**: .NET 10, ASP.NET Core Web API, Entity Framework Core, PostgreSQL, SignalR, Swagger
- **Web Dashboard**: React, TypeScript, Vite, Tailwind CSS, SignalR Client, Leaflet

---

## 📁 Monorepo Klasör Yapısı

```text
FireAlert/
│
├── mobile/         # Flutter Mobil Uygulaması (GetX Mimarisi)
├── backend/        # .NET 10 Web API & SignalR Hub
├── web/            # React + Vite + Tailwind Canlı Web Dashboard
├── docs/           # Mimari dokümanları ve diyagramlar
├── .gitignore
└── README.md
```
