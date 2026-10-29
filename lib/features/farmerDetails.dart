import 'dart:io';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ramcharan/features/controllers/farmerController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ui/color/appColor.dart';

import '../ui/widgets/CommonWidget.dart';
import '../ui/widgets/pdfview.dart';
import '../ui/widgets/richtext.dart';

class Farmerdetails extends StatefulWidget {
  final Map<String, dynamic> data;
  final int farmerId;

  const Farmerdetails({
    super.key,
    required this.data,
    required this.farmerId,
  });

  @override
  State<Farmerdetails> createState() => _FarmerdetailsState();
}

class _FarmerdetailsState extends State<Farmerdetails> {
  final FarmerController fc = Get.find();

  @override
  void initState() {
    super.initState();
    fc.farmerCropDetails(context, widget.farmerId, "farmer");
  }
  final GlobalKey _qrKey = GlobalKey();

  String get _upiPayload {
    final params = <String, String>{
      'id': widget.data["id"].toString(),
      'farmer_code': widget.data["farmer_code"],
    };
    final query = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    return 'upi://pay?$query';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Farmer Overview',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _qrSection(),
            _sectionHeader("Farmer"),
            _card(_farmerInfo()),
            _sectionHeader("Lands"),
            _landsSection(width),
            _sectionHeader("FFB Collection"),
            _cropSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _qrSection() {
    final farmerName = widget.data['farmer_name']?.toString() ?? 'Farmer';
    final farmerCode = widget.data['farmer_code']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ---- Compact QR (this is what gets captured & shared) ----
          RepaintBoundary(
            key: _qrKey,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(
                data: _upiPayload,
                version: QrVersions.auto,
                size: 100,
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Color(0xFF1A237E),
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // ---- Name + prominent share buttons ----
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  farmerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (farmerCode.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Code: $farmerCode',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
                const SizedBox(height: 12),
                _shareBtn(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  bgColor: const Color(0xFF1A73E8),
                  onTap: _shareQr,
                ),
                // Big, filled share buttons — UPI-app style
                // Row(
                //   children: [
                //     Expanded(
                //       child: _shareBtn(
                //         icon: Icons.chat_bubble_rounded,
                //         label: 'WhatsApp',
                //         bgColor: const Color(0xFF25D366),
                //         onTap: _shareToWhatsApp,
                //       ),
                //     ),
                //     const SizedBox(width: 8),
                //     Expanded(
                //       child: _shareBtn(
                //         icon: Icons.share_rounded,
                //         label: 'Share',
                //         bgColor: const Color(0xFF1A73E8),
                //         onTap: _shareQr,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shareBtn({
    required IconData icon,
    required String label,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Captures the QR widget as a PNG file in temp dir
  Future<File> _captureQr() async {
    final boundary =
    _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Generic share — opens system share sheet with the QR image
  Future<void> _shareQr() async {
    try {
      final file = await _captureQr();
      final name = widget.data['farmer_name']?.toString() ?? 'Farmer';
      final code = widget.data['farmer_code']?.toString() ?? '';

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Farmer: $name\nCode: $code',
        subject: 'Farmer QR',
      );
    } catch (e) {
      _showError('Could not share QR: $e');
    }
  }

  /// WhatsApp-targeted share. WhatsApp deep link only supports text,
  /// so for images we route through the share sheet (WhatsApp shows up there).

  Future<void> _shareToWhatsApp() async {
    // try {
    //   final file = await _captureQr();
    //   final name = widget.data['farmer_name']?.toString() ?? 'Farmer';
    //   final code = widget.data['farmer_code']?.toString() ?? '';
    //
    //   String phone = widget.data['farmer_mobile']?.toString() ?? '';
    //   phone = phone.replaceAll(RegExp(r'\D'), '');
    //   if (phone.length == 10) phone = '91$phone';
    //
    //   await WhatsappShare.shareFile(
    //     text: 'Farmer: $name\nCode: $code',
    //     phone: phone,
    //     filePath: [file.path],
    //   );
    // } catch (e) {
    //   _showError('Could not share to WhatsApp: $e');
    // }
  }



  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }


  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black)),
          const SizedBox(width: 5),
          const Icon(Icons.info, size: 18, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(10),
      child: child,
    );
  }

  Widget _farmerInfo() {
    final d = widget.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonRichText(label: 'Farmer', value: d['farmer_name'] ?? '--'),
        CommonRichText(
            label: 'Aadhaar', value: d['aadhaar_no']?.toString() ?? '--'),
        CommonRichText(label: 'Mobile', value: d['farmer_mobile'].toString()),
        CommonRichText(
          label: 'Address',
          value:
          "${d['village'] ?? ''}, ${d['mandal'] ?? ''}, ${d['district'] ?? ''}",
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text("Linked Bank :"),
        ),
        CommonRichText(label: 'Bank Name', value: d['bank_name'] ?? '--'),
        CommonRichText(label: 'A/c No', value: d['account_no'].toString() ?? '--'),
        CommonRichText(label: 'IFSC Code', value: d['ifsc_code'] ?? '--'),
      ],
    );
  }

  Widget _landsSection(double width) {
    final lands = widget.data['lands'] as List? ?? [];

    if (lands.isEmpty) return const SizedBox();

    return _card(ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lands.length,
      itemBuilder: (_, index) {
        final land = lands[index];
        return Column(
          children: [
            if (index != 0) Divider(color: Colors.grey.shade300),
            CommonRichText(label: 'Survey No', value: land['survey_no'] ?? ''),
            CommonRichText(label: 'Acres', value: land['acers'] ?? ''),
            CommonRichText(
              label: 'Location',
              value:
              "${land['village'] ?? ''}, ${land['mandal'] ??
                  ''}, ${land['district'] ?? ''}",
            ),
          ],
        );
      },
    ));
  }

  Widget _cropSection() {
    return _card(
      Obx(() {
        if (fc.isLoading5.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (fc.errorMessage5.isNotEmpty) {
          return Text(fc.errorMessage5.value,
              style: const TextStyle(color: Colors.red));
        }

        if (fc.cropData.isEmpty) return const SizedBox();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: fc.cropData.length,
          itemBuilder: (_, index) {
            final crop = fc.cropData[index];
            final pdf = crop['pdf']?.toString() ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index != 0) Divider(color: Colors.grey.shade300),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(crop['receipt_id'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),

                    if (pdf.isNotEmpty)
                      InkWell(
                        onTap: () => Get.to(() => pdfview(pdf: pdf)),
                        child:
            Container(
            padding: EdgeInsets.symmetric(
            horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius:
            BorderRadius.circular(8)),
                                child: Text("View PDF",style: TextStyle(color: Colors.red,fontSize: 12),)),
                      ),
                    Spacer(),
                    Text("${crop['final_wt'].toString()} kg"),
                  ],
                ),
                _row("Weight Bridge No", crop['weightBridgeNo']),
                // _row("Gross Wt", crop['gross_wt']),
                // _row("Tare Wt", crop['tare_wt']),
                // _row("Net Wt", crop['net_wt']),
                // _row("Rejected Wt", crop['rejection_wt']),
                _row("Driver", crop['driver_name']),
                _row("Driver Contact", crop['driver_mobile']),
                _row("Vehicle No", crop['vehicle_no']),
                CommonRichText(
                    label: 'Collection Center',
                    value: crop['collection_center'] ?? '--'),
              ],
            );
          },
        );
      }),
    );
  }

  Widget _row(String label, dynamic value) {
    return
      CommonRichText(label: label,
          value: value?.toString() ?? '--',
      );
  }
}