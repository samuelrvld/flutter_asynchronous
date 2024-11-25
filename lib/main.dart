import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future Demo - Samuel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FuturePage(),
    );
  }
}

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  String result = '';
  bool isLoading = false; // Menandakan status loading

  // Fungsi untuk mendapatkan data dari API
  Future<http.Response> getData() async {
    const authority = 'www.googleapis.com';
    const path = '/books/v1/volumes/junbDwAAQBAJ';
    Uri url = Uri.https(authority, path);
    return http.get(url);
  }

  // Fungsi asinkron untuk mengembalikan angka
  Future<int> returnOneAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 1;
  }

  Future<int> returnTwoAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 2;
  }

  Future<int> returnThreeAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 3;
  }

  // Fungsi untuk menghitung total
  Future<void> count() async {
    setState(() {
      isLoading = true; // Set loading menjadi true
    });
    
    int total = 0;
    total = await returnOneAsync();
    total += await returnTwoAsync();
    total += await returnThreeAsync();
    
    setState(() {
      result = total.toString();
      isLoading = false; // Set loading menjadi false
    });
  }

  // Fungsi untuk menangani error
  Future<void> returnError() async {
    setState(() {
      isLoading = true; // Set loading menjadi true
    });
    
    await Future.delayed(const Duration(seconds: 2));
    throw Exception('Something terrible happened!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back from the Future'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Menyusun kolom di tengah
          children: [
            ElevatedButton(
              child: const Text('GO!'),
              onPressed: () {
                // Panggil returnError dan tangani hasilnya
                returnError()
                    .then((value) {
                      setState(() {
                        result = 'Success';
                      });
                    })
                    .catchError((onError) {
                      setState(() {
                        result = onError.toString(); // Menampilkan pesan error
                      });
                    })
                    .whenComplete(() {
                      print('Complete'); // Mencetak 'Complete' di konsol
                      setState(() {
                        isLoading = false; // Set loading menjadi false setelah selesai
                      });
                    });
              },
            ),
            const SizedBox(height: 20), // Jarak antara tombol dan teks
            Text(result),
            const SizedBox(height: 20), // Jarak antara teks dan indikator loading
            if (isLoading) // Menampilkan indikator loading hanya saat loading
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}