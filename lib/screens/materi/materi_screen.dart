import 'package:flutter/material.dart';
import '../../services/book_service.dart';
import '../../models/book_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/loading_widget.dart';
import 'detail_materi_screen.dart';

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<BookModel> _books = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  void _searchBooks() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      List<BookModel> results = await BookService().searchBooks(query);
      setState(() {
        _books = results;
      });
    } catch (e) {
      // Handle error diam-diam atau tampilkan snackbar
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Custom AppBar dengan logo
      appBar: const CustomAppBar(title: "Materi"),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: "Cari Buku (cth: Algoritma)...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _searchBooks,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _searchBooks(),
            ),
          ),

          // HASIL PENCARIAN
          Expanded(
            child: _isLoading
                ? const LoadingWidget(message: "Mencari referensi...")
                : _books.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book,
                          size: 60,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _hasSearched
                              ? "Buku tidak ditemukan."
                              : "Cari buku untuk mulai belajar.",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _books.length,
                    itemBuilder: (context, index) {
                      final book = _books[index];
                      return _buildBookCard(book);
                    },
                  ),
          ),
          SizedBox(height: 140), // Spasi di bawah
        ],
      ),
    );
  }

  Widget _buildBookCard(BookModel book) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke Detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailMateriScreen(book: book),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Cover
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book.thumbnail,
                width: 70,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (ctx, _, __) => Container(
                  width: 70,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Info Buku
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Penulis: ${book.authors.join(", ")}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Terbit: ${book.publishedDate}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
