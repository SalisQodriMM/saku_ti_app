import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message; // Tambahkan variabel ini

  // Tambahkan 'this.message' di constructor
  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Indikator Putar
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2F6BFF)), 
          ),
          
          // Pesan Opsional (Hanya muncul jika message tidak null)
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
          ]
        ],
      ),
    );
  }
}