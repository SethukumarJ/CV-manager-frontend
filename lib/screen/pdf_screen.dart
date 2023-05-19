import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class PDFScreen extends StatefulWidget {
  final String pdfUrl;

  const PDFScreen({super.key, required this.pdfUrl});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  String? pdfPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    downloadPDF();
  }

  void downloadPDF() async {
    try {
      var response = await http.get(Uri.parse(widget.pdfUrl));
      var bytes = response.bodyBytes;
      var dir = await getTemporaryDirectory();
      var file = File('${dir.path}/document.pdf');
      await file.writeAsBytes(bytes);
      if (mounted) {
        setState(() {
          pdfPath = file.path;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : pdfPath != null
          ? PDFView(
        filePath: pdfPath!,
        enableSwipe: true,

        autoSpacing: false,
        pageSnap: true,
        onViewCreated: (PDFViewController controller) {

        },
      )
          : const Center(
        child: Text('Failed to load PDF'),
      ),
    );
  }
}
