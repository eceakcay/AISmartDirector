
# 🎬 AISmartDirector

**AISmartDirector**, kullanıcıların ruh hallerine ve tercihlerine göre yapay zeka destekli film önerileri sunan, modern iOS teknolojileriyle geliştirilmiş akıllı bir film asistanıdır.

## ✨ Öne Çıkan Özellikler

* **🤖 AI Mood Analysis:** Google Gemini API entegrasyonu sayesinde doğal dil girdilerini analiz ederek kullanıcıya özel kategori eşleştirmeleri yapar.
* **⚡ Parallel Data Fetching:** Swift Concurrency (`TaskGroup`) kullanarak birden fazla kategorideki veriyi TMDB API üzerinden **paralel** şekilde çekerek maksimum performans sağlar.
* **🔍 Akıllı Arama:** Hem yapay zeka destekli ruh hali araması hem de doğrudan film ismiyle arama yapabilme imkanı sunar.
* **❤️ Favori Yönetimi:** Beğenilen filmleri takip etmek için `FavoritesManager` ile kurgulanmış özel bir favori sistemi içerir.
* **📱 Modern UI/UX:** SnapKit ile programatik Auto Layout, koyu tema desteği ve akıcı navigasyon yapısı.

## 🛠 Kullanılan Teknolojiler

| Kategori | Teknoloji |
| :--- | :--- |
| **Dil** | Swift (UIKit) |
| **Mimari** | MVVM + Coordinator Pattern |
| **AI Motoru** | Google Gemini (Generative AI) |
| **Veri Kaynağı** | TMDB API (The Movie Database) |
| **Layout** | SnapKit |
| **Resim İşleme** | Kingfisher (Caching & Blur Effects) |
| **Concurrency** | Async/Await & TaskGroup |

## 🏗 Mimari Yapı

Proje, sürdürülebilirlik ve test edilebilirlik prensiplerine uygun olarak **MVVM (Model-View-ViewModel)** deseniyle kurgulanmıştır. Navigasyon mantığı, ViewController'lardan tamamen soyutlanarak **Coordinator Pattern** ile merkezi bir noktadan yönetilmektedir.

```text
AISmartDirector/
├── Core/
│   ├── Network/          # NetworkManager & MovieService
│   ├── Models/           # Movie & API Models
│   └── Utilities/        # GenreMapper & Helpers
├── Screens/
│   ├── Home/             # Ana Ekran & Arama
│   ├── Detail/           # Film Detay & MVVM
│   └── AIAsistant/       # AI Prompt & Öneri Akışı
└── App/
    └── Coordinator/      # AppCoordinator (Navigasyon)
    
```

## 🚀 Kurulum

Projeyi klonlayın:
git clone https://github.com/eceakcay/AISmartDirector.git

Bağımlılıkları yükleyin (SPM veya CocoaPods).

Secrets.plist dosyasını oluşturun ve API anahtarlarınızı ekleyin:

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>GEMINI_API_KEY</key>
    <string>YOUR_API_KEY</string>
</dict>
</plist>

Projeyi Xcode üzerinden çalıştırın.

---

## 👩‍💻 Geliştirici

Ece Akçay - Bilgisayar Mühendisliği Öğrencisi & iOS Developer
