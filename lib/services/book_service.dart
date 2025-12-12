import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/book_model.dart';

class BookService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  Future<List<BookModel>> searchBooks(String query) async {
    if (query.isEmpty) return [];

    // dibatasi hanya untuk buku-buku kategori Komputer/Teknologi.
    final String restrictedQuery = '$query+subject:computers';

    // Request HTTP GET dengan parameter query (q=)
    final url = Uri.parse('$_baseUrl?q=$restrictedQuery');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Ambil list dari key 'items'
        final List<dynamic> items = data['items'] ?? [];

        // Konversi JSON ke List<BookModel>
        return items.map((json) => BookModel.fromJson(json)).toList();
      } else {
        debugPrint('Gagal memuat buku: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error koneksi buku: $e');
      return [];
    }
  }
}
