# 🎓 SAKTI (Saku TI)
**Aplikasi Asisten Akademik Mahasiswa Teknik Informatika**

Aplikasi ini adalah "Academic Hub" berbasis mobile yang dibangun menggunakan **Flutter**. Tujuan utamanya adalah membantu mahasiswa Teknik Informatika mengelola materi kuliah, catatan, tugas, dan timeline proyek dalam satu aplikasi terintegrasi.

Aplikasi ini menerapkan konsep **Pemisahan Logika & UI** (Service-Repository Pattern), serta menggunakan **HTTP Request** manual (REST API) untuk semua pertukaran data guna memenuhi standar pemahaman backend yang mendalam.

---

## 📱 Fitur Utama

🔐 **Lazy Login (Google Auth)**
Akses cepat sebagai Tamu atau Login via Google Sign-In untuk sinkronisasi data antar perangkat secara aman.

📚 **Materi (Smart Search)**
Mencari referensi buku belajar dari Google Books API yang **otomatis difilter** khusus untuk kategori Komputer & Teknologi.

📝 **Catatan (CRUD)**
Membuat, mengedit, dan menghapus catatan kuliah dengan indikator warna untuk kemudahan visual.

✅ **List Tugas (To-Do)**
Mencatat tugas kuliah dengan deadline dan status ceklis (Pending/Selesai).

🚀 **Project Saya (Complex CRUD)**
Memantau proyek besar dengan fitur *nested timeline* (daftar tugas bertingkat) yang dinamis.

---

## 🔗 Daftar Endpoint API

Aplikasi ini menggunakan dua sumber data berbeda dengan protokol HTTP Request:

### 1. API Publik (Materi)
Menggunakan **Google Books API**. Sistem backend aplikasi secara otomatis menyisipkan parameter `subject:computers` agar hasil pencarian relevan untuk mahasiswa TI.

* **Base URL:** `https://www.googleapis.com/books/v1/volumes`
* **Endpoint:** `GET /?q={kata_kunci}+subject:computers`

### 2. API Pribadi (Firebase Database)
Menggunakan **Firebase REST API**. Data disimpan secara terisolasi berdasarkan User ID (UID) Google.

#### 📝 Modul Catatan (`/notes`)
| Method | Endpoint | Fungsi |
| :--- | :--- | :--- |
| `GET` | `/users/{uid}/notes.json` | Mengambil semua catatan. |
| `POST` | `/users/{uid}/notes.json` | Menambah catatan baru. |
| `PATCH` | `/users/{uid}/notes/{id}.json` | Mengupdate judul/isi catatan. |
| `DELETE` | `/users/{uid}/notes/{id}.json` | Menghapus catatan. |

#### ✅ Modul Tugas (`/todos`)
| Method | Endpoint | Fungsi |
| :--- | :--- | :--- |
| `GET` | `/users/{uid}/todos.json` | Mengambil daftar tugas. |
| `POST` | `/users/{uid}/todos.json` | Menambah tugas baru. |
| `PATCH` | `/users/{uid}/todos/{id}.json` | Update status checklist (`isCompleted`). |
| `DELETE` | `/users/{uid}/todos/{id}.json` | Menghapus tugas. |

#### 📂 Modul Project (`/projects`)
| Method | Endpoint | Fungsi |
| :--- | :--- | :--- |
| `GET` | `/users/{uid}/projects.json` | Mengambil daftar proyek. |
| `POST` | `/users/{uid}/projects.json` | Menambah proyek & timeline. |
| `PATCH` | `/users/{uid}/projects/{id}.json` | Update data proyek & timeline. |
| `DELETE` | `/users/{uid}/projects/{id}.json` | Menghapus proyek. |

---

##🛠️ Panduan Instalasi & Setup SAKTI

Dokumen ini berisi langkah-langkah lengkap untuk menjalankan *source code* aplikasi **SAKTI (Saku TI)** di komputer lokal Anda (Localhost).

---

#####📋 Prasyarat (Requirements)

Sebelum memulai, pastikan komputer Anda sudah terinstal:
1.  **Flutter SDK** (Versi 3.0 atau lebih baru).
2.  **Editor Code** (VS Code atau Android Studio).
3.  **JDK (Java Development Kit)** (Diperlukan untuk generate SHA-1).

---

## 🚀 Langkah Instalasi

Ikuti urutan langkah di bawah ini dengan teliti.

1. Clone Repository

```bash
git clone https://github.com/SalisQodriMM/saku_ti_app.git
cd sakti_app
```

2. Instal Dependencies

```bash
flutter pub get
```

3. Jalankan Aplikasi
Pastikan Emulator Android sudah menyala atau HP fisik sudah terhubung (Mode Debugging aktif).

```bash
flutter run
```