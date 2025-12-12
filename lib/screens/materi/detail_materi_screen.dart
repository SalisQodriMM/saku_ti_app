import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import ini
import '../../models/book_model.dart';

class DetailMateriScreen extends StatelessWidget {
  final BookModel book;

  const DetailMateriScreen({super.key, required this.book});

  // Fungsi untuk membuka link
  Future<void> _launchUrl() async {
    if (book.infoLink.isNotEmpty) {
      final Uri url = Uri.parse(book.infoLink);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF536DFE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Buku",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // HEADER: COVER BUKU
          SizedBox(
            height: 220,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    book.thumbnail,
                    width: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, _, __) =>
                        Container(width: 120, color: Colors.grey[300]),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // CONTAINER PUTIH (INFO LENGKAP)
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul
                          Text(
                            book.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Tabel Info (Termasuk ISBN)
                          _buildInfoRow("Penulis", book.authors.join(", ")),
                          _buildInfoRow("Kategori", book.categories.join(", ")),
                          _buildInfoRow("Terbit", book.publishedDate),
                          _buildInfoRow("ISBN", book.isbn), // Info Baru

                          const Divider(height: 30),

                          // Deskripsi
                          const Text(
                            "Deskripsi:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            book.description,
                            style: const TextStyle(
                              color: Colors.grey,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // TOMBOL LIHAT BUKU
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: book.infoLink.isNotEmpty ? _launchUrl : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF536DFE), // Warna Biru
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.open_in_browser,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Lihat di Google Books",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Text(":  "),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}
