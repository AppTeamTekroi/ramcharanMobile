import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../ui/color/appColor.dart';
import '../ui/widgets/reportfilterWidget.dart';
import '../ui/widgets/richtext.dart';
import 'controllers/report_controller.dart';

class ReportListScreen extends StatefulWidget {
  ReportListScreen({
    super.key,
  });
  @override
  State<ReportListScreen> createState() => _QuatationListScreentate();
}

class _QuatationListScreentate extends State<ReportListScreen> {
  ReportController qc = Get.find();
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  late final TransformationController _zoomController;

  var totalrecords = "0".obs;
  var totalamt = "0".obs;
  var filterrecords = '0'.obs;
  List<dynamic> filteredList = [];

  DateTime? startDate;
  DateTime? endDate;
  static const tableWidth = 900.0;

//₹0.00

  @override
  void initState() {
    super.initState();

    // table width you used
    selectedFilter == 'This Month';
    totalamt.value = "";
    filterrecords.value = "0";
    applyFilter();
    // _fetchData();
    filteredList = qc.filteredcust;
    qc.searchQuery.value = '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;

      // calculate scale to fit table
      final scale = screenWidth / tableWidth;

      _zoomController = TransformationController(
        Matrix4.identity()..scale(scale < 1 ? scale : 1.0),
      );

      setState(() {});
    });
  }




  String selectedFilter = 'This Month';

  void applyFilter() {
    DateTime now = DateTime.now();

    setState(() {
      if (selectedFilter == 'This Day') {
        // Format as yyyy-MM-dd
        qc.date.value = DateFormat('yyyy-MM-dd').format(now);
        _fetchData();
      } else if (selectedFilter == 'This Month') {
        // Format as yyyy-MM for month filter
        qc.date.value = DateFormat('yyyy-MM').format(now);
        _fetchData();
      } else if (selectedFilter == 'This Year') {
        // Format as yyyy for year filter
        qc.date.value = DateFormat('yyyy').format(now);
        _fetchData();
      } else if (selectedFilter == 'Custom Range') {
        if (startDate != null && endDate != null) {
          // Format both dates properly
          final start = DateFormat('yyyy-MM-dd').format(startDate!);
          final end = DateFormat('yyyy-MM-dd').format(endDate!);
          qc.date.value =
              "$start,$end"; // or "$start - $end" depending on API requirement
          _fetchData();
        }
      }
    });
  }

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
        applyFilter();
      });
    }
  }

  Future<void> _fetchData() async {
    totalamt.value = "";
    filterrecords.value = "0";

    await qc.Reportlist(
      context,
      'FBB Report',
    );

    // switch (dropdownValue) {
    //   case 'Sales Report':
    //     await qc.Reportlist(context,dropdownValue);
    //     print("Sales Report selected");
    //     break;
    //
    //   // case 'Opportunity Report':
    //   //   await qc.Reportlist(context,dropdownValue);
    //   //   print("Opportunity Report selected");
    //   //   break;
    //
    //   case 'Consolation Report':
    //     await qc.Reportlist(context,dropdownValue);
    //     print("Consolation Report selected");
    //     break;
    //
    //   // case 'CT Report':
    //   //   await qc.Reportlist(context,dropdownValue);
    //   //   print("CT Report selected");
    //   //   break;
    //
    //   default:
    //   // Handle unexpected value
    //     print("Unknown report selected");
    // }

    // await qc.Reportlist(context);
    final list = qc.reportlist.value;

    if (list is Map) {
      totalrecords.value = (list['total_records'] ?? 0).toString();
      totalamt.value = (list['total_wt'] ?? 0).toString();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final screenWidth = MediaQuery.of(context).size.width;

        // calculate scale to fit table
        final scale = screenWidth / tableWidth;

        // _zoomController = TransformationController(
        //   Matrix4.identity()..scale(scale < 1 ? scale : 1.0),
        // );

        setState(() {});
      });
      // var value = list['Sales_return'];
      // saleAmount.value = value != null
      //     ? double.parse(value.toString()).toStringAsFixed(2)
      //     : '';
      // lineAmount.value = (list['line_total'].toStringAsFixed(2));
      // filterrecords.value = (list['recordsFiltered'] ?? 0).toString();

      // recordsFiltered
      // If total amount is returned from the API
      // final amount = list['totalAmount']; // Adjust key if different
      // if (amount != null) {
      //   lineAmount.value = "₹${amount.toStringAsFixed(2)}"; // format as needed
      // }
    }
  }

  // void filterByDate() {
  //   if (startDate == null || endDate == null) return;
  //
  //   final filteredList = qc.filteredcust.where((item) {
  //     final createdAt = DateTime.parse(item["created_at"]);
  //     return createdAt.isAfter(startDate!.subtract(Duration(days: 1))) &&
  //         createdAt.isBefore(endDate!.add(Duration(days: 1)));
  //   }).toList();
  //
  //   qc.filteredcust.assignAll(filteredList);
  //   setState(() {});
  // }

  // void _scrollListener() {
  //   if (_scrollController.position.pixels >=
  //           _scrollController.position.maxScrollExtent - 100 &&
  //       !qc.isLoadingMore.value &&
  //       !qc.isLastPage.value) {
  //     // _loadMoreItems();
  //   }
  // }

  // Future<void> _loadMoreItems() async {
  //   await qc.Reportlist(context, dropdownValue!, isPagination: true);
  // }

  List<String> list = <String>['FBB Report', 'Consolation Report'];

  String? dropdownValue;

  final searchCtrl = TextEditingController();

  final TextEditingController controller = TextEditingController();
  final ReportController rc = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          // backgroundColor: AppColors.blues,
          backgroundColor: Colors.grey[200],
          automaticallyImplyLeading: false,

          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    Get.back();
                    rc.district.value = '';
                    rc.mandal.value = '';
                    rc.village.value = '';
                    rc.farmerId.value = 0;
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              Expanded(
                child: Container(
                  height: height * 0.05,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15), // ✅ pill shape
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        // blurRadius: 10,
                        //  offset: const Offset(0, 3), // ✅ soft bottom shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 22, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onChanged: (val) {
                            if (val.isNotEmpty && val.length > 2) {
                              final query = val.toLowerCase();

                              qc.filteredcust.value =
                                  qc.filteredcust.where((item) {
                                final a = item["receipt_id"]
                                        ?.toString()
                                        .toLowerCase() ??
                                    '';
                                final b = item["weightBridgeNo"]
                                        .toString()
                                        .toLowerCase() ??
                                    '';
                                return a.contains(query) || b.contains(query);
                              }).toList();
                            } else {
                              qc.filteredcust.value = qc.reportlist['data'];
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Receipt No",
                            contentPadding: EdgeInsets.only(bottom: 8),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () async {
                  final updatedSelection =
                      await showModalBottomSheet<Map<String, dynamic>>(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: ReportDrawerScreen(),
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.filter_alt_rounded,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        body:



        Column(
            children: [
          Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
            //  height: height * 0.15,
            width: MediaQuery.of(context).size.width * 0.94,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromARGB(255, 193, 193, 193),
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: height * 0.015, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///totals
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Amount:',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 147, 147, 147)),
                                ),
                                Text(
                                  "₹${totalamt.value}",
                                  style: TextStyle(
                                      fontSize: height * 0.015,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Records:',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 147, 147, 147)),
                                ),
                                Text(
                                  "${totalrecords.value}",
                                  style: TextStyle(
                                      fontSize: height * 0.015,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),

                          ],
                        );
                      }),
                      // const Divider(

                    ],
                  ),

                  Divider(
                    color: Colors.grey.shade300,
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          final RenderBox overlay = Overlay.of(context)
                              .context
                              .findRenderObject() as RenderBox;
                          showMenu(
                            context: context,
                            position: RelativeRect.fromRect(
                              details.globalPosition & const Size(40, 40),
                              Offset.zero & overlay.size,
                            ),
                            items: const [
                              PopupMenuItem(
                                  value: 'This Day', child: Text('This Day')),
                              PopupMenuItem(
                                  value: 'This Month',
                                  child: Text('This Month')),
                              PopupMenuItem(
                                  value: 'This Year', child: Text('This Year')),
                              PopupMenuItem(
                                  value: 'Custom Range',
                                  child: Text('Custom Date')),
                            ],
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                selectedFilter = value;
                              });
                              applyFilter();
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              selectedFilter,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.02,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            const Icon(CupertinoIcons.pen, size: 18),
                          ],
                        ), // ⬅️ No padding at all
                      ),
                      if (selectedFilter == "Custom Range")
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => pickStartDate(),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                    //border: Border.all(color: Colors.grey),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          startDate == null
                                              ? "Start Date"
                                              : "${startDate!.day}-${startDate!.month}-${startDate!.year}",
                                          style: const TextStyle(fontSize: 12)),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 11,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () => pickEndDate(),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                    //border: Border.all(color: Colors.grey),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          endDate == null
                                              ? "End Date"
                                              : "${endDate!.day}-${endDate!.month}-${endDate!.year}",
                                          style: const TextStyle(fontSize: 12)),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 11,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

    Expanded(
    child: Obx(() {
    if (qc.filteredcust.isEmpty) {
    return const Center(child: Text("No records found"));
    }

    final isMobile = MediaQuery.of(context).size.width < 600;
    final textStyle = TextStyle(fontSize: isMobile ? 10 : 12);
    final headerStyle = TextStyle(fontSize: isMobile ? 10 : 12);

    return Padding(
    padding: const EdgeInsets.all(8),
    child: Container(
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey.shade300),
    ),

    // ✅ IMPORTANT: Constrain height
    child: LayoutBuilder(
    builder: (context, constraints) {
    return DataTable2(
    minWidth: width * 2,
    fixedLeftColumns: 1,

    columnSpacing: 0,
    horizontalMargin: 12,

    headingRowHeight: isMobile ? 38 : 46,
    dataRowHeight: isMobile ? 36 : 44,

    headingRowColor: WidgetStateProperty.all(
    Colors.grey.shade300,
    ),

    columns:  [
    DataColumn(label: Text('Receipt',style: headerStyle)),
    DataColumn(label: Text('Farmer',style: headerStyle)),
    DataColumn(label: Text('Mandal',style: headerStyle)),
    DataColumn(label: Text('Village',style: headerStyle)),
    DataColumn(label: Text('Weight Slip\n Number',style: headerStyle)),
    DataColumn(label: Text('Final Wt',style: headerStyle)),
    DataColumn(label: Text('Unit Price',style: headerStyle)),
    DataColumn(label: Text('Govt Price',style: headerStyle)),
    DataColumn(label: Text('Govt\nAnnounced',style: headerStyle)),
    DataColumn(label: Text('Recorded At',style: headerStyle)),

    ],

    rows: List.generate(
    qc.filteredcust.length,
    (index) {
    final item = qc.filteredcust[index];
    final farmer = item['farmer'] ?? {};

    return DataRow(
    color: MaterialStateProperty.all(
    index.isEven
    ? Colors.grey.shade50
        : Colors.white,
    ),
    cells: [
    DataCell(Text(item['receipt_id'].toString(), style: headerStyle)),
    DataCell(Text(farmer['farmer_name'] ?? '--', style: textStyle)),
    DataCell(Text(farmer['mandal'] ?? '--', style: textStyle)),
    DataCell(Text(farmer['village'] ?? '--', style: textStyle)),
    DataCell(Text(item['weightBridgeNo'] ?? '--', style: textStyle)),
    DataCell(Text(item['total_final_wt'].toString(), style: textStyle)),
    DataCell(Text(item['unit_price'].toString(), style: textStyle)),
    DataCell(Text(item['govt_price'].toString(), style: textStyle)),
    DataCell(Text(item['govt_price_announce_date'] ?? '--', style: textStyle)),
      DataCell(Text(item['receipt_date'] ?? '--', style: textStyle)),

    ],
    );
    },
    ),
    );
    },
    ),
    ),
    );
    }),
    ),
            ]),
    );
  }
}

