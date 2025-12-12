class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final List<String> categories;
  final String thumbnail;
  final String publishedDate;
  final String isbn; // Baru
  final String infoLink; // Baru

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.categories,
    required this.thumbnail,
    required this.publishedDate,
    required this.isbn,
    required this.infoLink,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final vol = json['volumeInfo'] ?? {};

    // Logika mengambil ISBN (Google Books API mengembalikan List)
    String getIsbn() {
      final identifiers = vol['industryIdentifiers'] as List<dynamic>?;
      if (identifiers != null && identifiers.isNotEmpty) {
        // Ambil identifier pertama (bisa ISBN_10 atau ISBN_13)
        return identifiers[0]['identifier']?.toString() ?? '-';
      }
      return '-';
    }

    return BookModel(
      id: json['id'] ?? '',
      title: vol['title'] ?? 'Tanpa Judul',
      authors:
          (vol['authors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['Penulis Tidak Diketahui'],
      description: vol['description'] ?? 'Tidak ada deskripsi.',
      categories:
          (vol['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['Umum'],
      thumbnail:
          vol['imageLinks']?['thumbnail']?.toString().replaceAll(
            'http://',
            'https://',
          ) ??
          'https://via.placeholder.com/150',
      publishedDate: vol['publishedDate'] ?? '-',
      isbn: getIsbn(), // Ambil ISBN
      infoLink: vol['infoLink'] ?? '', // Ambil Link
    );
  }
}
