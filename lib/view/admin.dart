import 'package:flutter/material.dart';

import '../component/my_container.dart';
import '../utils/pdf_generate.dart';


class PdfPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Export Data to PDF'),
      ),
      body: GradientContainer(
        child: Center(
          child: IconButton(
            icon: Icon(Icons.picture_as_pdf, size: 50,color: Colors.white,),
            onPressed: () async {
              await generateAndSharePdf();
            },
          ),
        ),
      ),
    );
  }
}

