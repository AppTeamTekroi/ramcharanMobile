import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

import '../../features/customerNavBar.dart';

class pdfview extends StatefulWidget {
  final String pdf;

  const pdfview({Key? key, required this.pdf}) : super(key: key);

  @override
  State<pdfview> createState() => _pdfviewState();
}

class _pdfviewState extends State<pdfview> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  String? pdfUrl;
  @override
  void initState() {
    super.initState();
    pdfUrl = Uri.encodeFull(widget.pdf);
  }

  @override
  Widget build(BuildContext context) {
    print(pdfUrl);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.offAll(()=>BottomNav()),
        ),
        title: const Text('FFb Collection Receipt'),
        actions: [
          IconButton(
            onPressed: () {
              _launchInBrowser(Uri.parse(widget.pdf));
            },
            icon: const Icon(Icons.download),
          ),
          IconButton(
            onPressed: () {
              // Uncomment this if you want to enable sharing
              // Share.share(widget.pdf);
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SfPdfViewer.network(
        Uri.encodeFull(widget.pdf),
      ),

    );
  }

}

Future<void> _launchInBrowser(Uri url) async {
  print(url);
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw Exception('Could not launch $url');
  }
}
