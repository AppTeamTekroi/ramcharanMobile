import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../core/API/URLConst.dart';
import '../core/headerfiles.dart';
import '../ui/color/appColor.dart';

class LedgerScreen extends StatefulWidget {
  final String? bpCode;
  const LedgerScreen({super.key, this.bpCode});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  final _dateFmt = DateFormat('yyyy-MM-dd');
  final _displayFmt = DateFormat('dd-MMM-yyyy');

  late DateTime _fromDate;
  late DateTime _toDate;
  late TextEditingController _bpCtrl;

  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _data;
  List<dynamic> _rows = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _fromDate = DateTime(now.year, 1, 1);
    _toDate = DateTime(now.year, 12, 31);
    _bpCtrl = TextEditingController(text: widget.bpCode ?? '');
    if ((widget.bpCode ?? '').isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetch());
    }
  }

  @override
  void dispose() {
    _bpCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial = isFrom ? _fromDate : _toDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  Future<void> _fetch() async {
    final bp = _bpCtrl.text.trim();
    if (bp.isEmpty) {
      setState(() => _error = 'Enter a BP Code');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _data = null;
      _rows = [];
    });
    try {
      final headers = await ApiHelper.getHeaders();
      final qp = {
        'fromdate': _dateFmt.format(_fromDate),
        'todate': _dateFmt.format(_toDate),
        'bpcode': bp,
      };
      final url = Uri.parse('${URLConst.baseURL}${URLConst.vendorLedger}')
          .replace(queryParameters: qp);
      print('Ledger URL: $url');
      final resp = await http.get(url, headers: headers);
      if (resp.statusCode == 200) {
        final decoded = json.decode(resp.body);
        Map<String, dynamic> body = {};
        List<dynamic> rows = [];
        if (decoded is Map<String, dynamic>) {
          body = decoded;
          final d = decoded['data'] ??
              decoded['ledger'] ??
              decoded['rows'] ??
              decoded['result'] ??
              decoded['records'];
          if (d is List) {
            rows = d;
          } else if (d is Map && d['rows'] is List) {
            rows = d['rows'];
          }
        } else if (decoded is List) {
          rows = decoded;
        }
        setState(() {
          _data = body;
          _rows = rows;
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Failed (${resp.statusCode}): ${resp.body}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString().replaceAll(',', '')) ?? 0;
  }

  String _str(Map row, List<String> keys) {
    for (final k in keys) {
      final v = row[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return '';
  }

  String _formatDate(String raw) {
    try {
      final d = DateTime.parse(raw);
      return DateFormat('dd/MM/yyyy').format(d);
    } catch (_) {
      return raw;
    }
  }

  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    final doc = pw.Document();
    final qtyFmt = NumberFormat('#,##0.0000');
    final amtFmt = NumberFormat('#,##0.00');
    final rateFmt = NumberFormat('#,##0.000');

    final tableRows = <List<String>>[];
    double totalQty = 0;
    double totalAmount = 0;
    Map? first;
    for (var i = 0; i < _rows.length; i++) {
      final r = _rows[i];
      if (r is! Map) continue;
      first ??= r;
      final sno = _str(r, ['S.no', 'Sno', 'sno']);
      final receiptNo = _str(r, ['Receipt No', 'ReceiptNo', 'receipt_no']);
      final date = _str(r, ['DATE', 'Date', 'date']);
      final remarks = _str(r, ['REMARKS', 'Remarks', 'remarks']);
      final rate = _toDouble(r['RATE'] ?? r['Rate'] ?? r['rate']);
      final qty = _toDouble(
          r['QTY (MTS)'] ?? r['QTY(MTS)'] ?? r['Qty'] ?? r['qty']);
      final amount = _toDouble(r['Amount'] ?? r['amount']);
      totalQty += qty;
      totalAmount += amount;
      tableRows.add([
        sno.isNotEmpty ? sno : '${i + 1}',
        receiptNo,
        date.isNotEmpty ? _formatDate(date) : '',
        remarks,
        rateFmt.format(rate),
        qtyFmt.format(qty),
        amtFmt.format(amount),
      ]);
    }

    final farmerCode = first?['Farmer Code']?.toString() ?? _bpCtrl.text.trim();
    final farmerName = first?['Farmer Name']?.toString() ?? '';
    final bankName = first?['Bank Name']?.toString() ?? '';
    final bankAccount = first?['Bank Account']?.toString() ?? '';
    final ifsc = first?['IFSC Code']?.toString() ?? '';
    final village = first?['Village']?.toString() ?? '';
    final oilpalmLand = first?['Oilpalm Land']?.toString() ?? '';

    // Prefer totals from API if present
    final apiTotalQty =
        _toDouble(first?['Total Qty'] ?? first?['TotalQty']);
    final apiTotalAmt =
        _toDouble(first?['Total Amount'] ?? first?['TotalAmount']);
    final showTotalQty = apiTotalQty > 0 ? apiTotalQty : totalQty;
    final showTotalAmt = apiTotalAmt > 0 ? apiTotalAmt : totalAmount;

    pw.Widget labelRow(String label, String value, {double labelW = 90}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 2),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
                width: labelW,
                child: pw.Text(label,
                    style: const pw.TextStyle(fontSize: 10))),
            pw.Expanded(
                child: pw.Text(value,
                    style: const pw.TextStyle(fontSize: 10))),
          ],
        ),
      );
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 28),
        footer: (ctx) => pw.Container(
          padding: const pw.EdgeInsets.only(top: 12),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('${ctx.pageNumber}',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Authorised Signature',
                  style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
        ),
        build: (ctx) => [
          pw.Center(
            child: pw.Text(
              'RAMCHARAN OIL INDUSTRIES',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(0xFFC01818),
              ),
            ),
          ),

          pw.SizedBox(height: 6),
          pw.Center(
            child: pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.black, width: 0.8)),
              ),
              child: pw.Text('Farmer Ledger',
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    labelRow('Farmer Code', farmerCode),
                    labelRow('Farmer Name', farmerName),
                    if (oilpalmLand.isNotEmpty)
                      labelRow('Oilpalm Land :', oilpalmLand)
                    else if (village.isNotEmpty)
                      labelRow('District', village),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    labelRow('Bank Name', bankName),
                    labelRow('Branch Name', ifsc),
                    labelRow('Bank Account', bankAccount),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
            headers: [
              'S.no',
              'Receipt No',
              'DATE',
              'REMARKS',
              'RATE',
              'QTY (KG)',
              'Amount',
            ],
            data: tableRows,
            headerStyle: pw.TextStyle(
                fontSize: 10, fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.white),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.center,
              3: pw.Alignment.centerLeft,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
              6: pw.Alignment.centerRight,
            },
            headerAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.center,
              3: pw.Alignment.centerLeft,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
              6: pw.Alignment.centerRight,
            },
            columnWidths: {
              0: const pw.FlexColumnWidth(0.6),
              1: const pw.FlexColumnWidth(1.2),
              2: const pw.FlexColumnWidth(1.3),
              3: const pw.FlexColumnWidth(2.2),
              4: const pw.FlexColumnWidth(1.1),
              5: const pw.FlexColumnWidth(1.3),
              6: const pw.FlexColumnWidth(1.5),
            },
          ),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 0.5),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 54,
                  child: pw.Padding(
                    padding:
                        const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: pw.Center(
                      child: pw.Text('TOTAL',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                ),
                pw.Container(width: 0.5, color: PdfColors.black, height: 18),
                pw.Expanded(
                  flex: 11,
                  child: pw.Padding(
                    padding:
                        const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text('',
                          style: const pw.TextStyle(fontSize: 10)),
                    ),
                  ),
                ),
                pw.Container(width: 0.5, color: PdfColors.black, height: 18),
                pw.Expanded(
                  flex: 13,
                  child: pw.Padding(
                    padding:
                        const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(qtyFmt.format(showTotalQty),
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                ),
                pw.Container(width: 0.5, color: PdfColors.black, height: 18),
                pw.Expanded(
                  flex: 15,
                  child: pw.Padding(
                    padding:
                        const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(amtFmt.format(showTotalAmt),
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return doc.save();
  }

  Future<void> _downloadPdf() async {
    final bytes = await _buildPdf(PdfPageFormat.a4);
    final fname =
        'ledger_${_bpCtrl.text.trim()}_${_dateFmt.format(_fromDate)}_${_dateFmt.format(_toDate)}.pdf';
    await Printing.sharePdf(bytes: bytes, filename: fname);
  }

  Future<void> _printPdf() async {
    await Printing.layoutPdf(onLayout: (format) => _buildPdf(format));
  }

  @override
  Widget build(BuildContext context) {
    final hasData = _data != null;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Vendor Ledger',
            style: TextStyle(color: Colors.white)),
        actions: [
          if (hasData) ...[
            IconButton(
              tooltip: 'Print',
              icon: const Icon(Icons.print, color: Colors.white),
              onPressed: _printPdf,
            ),
            IconButton(
              tooltip: 'Download / Share',
              icon: const Icon(Icons.download, color: Colors.white),
              onPressed: _downloadPdf,
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          _filters(),
          const Divider(height: 1),
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget _filters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _bpCtrl,
            decoration: const InputDecoration(
              labelText: 'BP Code',
              hintText: 'e.g. FR0011',
              prefixIcon: Icon(Icons.badge_outlined),
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _dateField('From', _fromDate, true)),
              const SizedBox(width: 10),
              Expanded(child: _dateField('To', _toDate, false)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: _loading ? null : _fetch,
              icon: const Icon(Icons.search),
              label: const Text('Fetch Ledger'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateField(String label, DateTime val, bool isFrom) {
    return InkWell(
      onTap: () => _pickDate(isFrom: isFrom),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today, size: 18),
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        child: Text(_displayFmt.format(val)),
      ),
    );
  }

  Widget _body() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(_error!, style: const TextStyle(color: Colors.red))));
    }
    if (_data == null) {
      return const Center(
          child: Text('Enter filters and tap Fetch Ledger to view PDF.'));
    }
    return PdfPreview(
      build: (format) => _buildPdf(format),
      canChangePageFormat: false,
      canChangeOrientation: false,
      canDebug: false,
      allowPrinting: false,
      allowSharing: false,
      useActions: false,
      pdfFileName:
          'ledger_${_bpCtrl.text.trim()}_${_dateFmt.format(_fromDate)}_${_dateFmt.format(_toDate)}.pdf',
    );
  }
}
