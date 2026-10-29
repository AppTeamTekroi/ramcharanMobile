import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:ramcharan/ui/widgets/AddTime.dart';
import '../ui/Buttons/button.dart';
import '../ui/color/appColor.dart';
import '../ui/widgets/CommonWidget.dart';

class GovtPriceManagementPage extends StatefulWidget {
  @override
  _GovtPriceManagementPageState createState() =>
      _GovtPriceManagementPageState();
}

class _GovtPriceManagementPageState extends State<GovtPriceManagementPage> {
  // Form controllers
  TextEditingController govtPriceController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController announceDateController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  // Dummy history list
  List<Map<String, String>> priceHistory = [
    {
      'price': '185.50',
      'status': 'Active',
      'range': '05 Oct - 30 Oct 2023',
      'announce': '01 Oct 2023',
      'remarks':
          'Quarterly adjustment based on global crude oil fluctuations and local distribution taxes...'
    },
    {
      'price': '178.25',
      'status': 'Expired',
      'range': '01 Sep - 30 Sep 2023',
      'announce': '28 Aug 2023',
      'remarks':
          'Standard monthly review. No major changes reported in supply chain costs.'
    },
    {
      'price': '175.00',
      'status': 'Expired',
      'range': '01 Aug - 31 Aug 2023',
      'announce': '25 Jul 2023',
      'remarks': ''
    },
  ];
  void _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  void _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _endTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF8F6F6), // background-light
      // appBar: AppBar(
      //   title: Column(
      //     children: [
      //       Text('Govt Price Management', style: TextStyle(fontSize: 18)),
      //       Text('Ramcharan Oil Industries',
      //           style: TextStyle(fontSize: 10, color: Colors.redAccent)),
      //     ],
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black,
      //   elevation: 1,
      //   actions: [
      //     IconButton(
      //         onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.black))
      //   ],
      //   leading: IconButton(
      //       icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
      //       onPressed: () {}),
      // ),
      appBar: AppBar(
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Govt Price Management",
                style: GoogleFonts.openSans(
                    fontSize: 20, fontWeight: FontWeight.w500, wordSpacing: 0)),
            Text("Ramcharan Oil Industries",
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    wordSpacing: 0,
                    color: Colors.grey)),
          ],
        ),
        centerTitle: true,
        // iconTheme: const IconThemeData(
        //   color: Colors.black, // ✅ makes the back arrow white
        // ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildForm(w),

            // Price Configuration Form

            SizedBox(height: 24),

            // Price History Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(
                    Icons.history,
                    color: Colors.red,
                    weight: 44,
                  ),
                  SizedBox(width: 8),
                  Text('Price History',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                ]),
                PriceWidgets.highlightContainer(
                    '${priceHistory.length} Records', AppColors.primary),
              ],
            ),
            SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: priceHistory.length,
              itemBuilder: (context, index) {
                var item = priceHistory[index];
                return Card(
                  color: Colors.white,
                  // margin: EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Row(
                    children: [
                      Container(
                        height: 70,
                        width: 3,
                        color:

                        item['status'] == 'Active'
                            ? AppColors.primary
                            : AppColors.deepred
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          item['status'] == 'Active'
                                              ? 'CURRENT PRICE'
                                              : 'PREVIOUS PRICE',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.deepred
                                          )),
                                      Text('₹${item['price']}',
                                          style: CommonStyles.requestTextStyle(fontSize: 20,weight: FontWeight.bold,color: item['status'] == 'Active'
                                                    ? AppColors.primary
                                                    : AppColors.text )
                                      ),
                                    ]),

                                PriceWidgets.highlightContainer(
                                    '${item['status']}',
                                    item['status'] == 'Active'
                                        ? Colors.green[700]
                                        : AppColors.deepred
                                ),
                              ],
                            ),
                            Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Start - End Range',
                                          style: TextStyle(
                                              fontSize: 10, color: AppColors.deepred)),
                                      Text(item['range']!,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Announced On',
                                          style: TextStyle(
                                              fontSize: 10, color: AppColors.deepred)),
                                      Text(item['announce']!,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                              ],
                            ),
                            // if (item['remarks']!.isNotEmpty) ...[
                            //   SizedBox(height: 8),
                            //   Text('Remarks',
                            //       style:
                            //           TextStyle(fontSize: 10, color: AppColors.deepred)),
                            //   Text(item['remarks']!,
                            //       style: TextStyle(
                            //           fontSize: 12, color: Colors.black87)),
                            // ]
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildForm(double w) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // _profileSection(),
      const SizedBox(height: 20),
      _sectionTitle("Price Configuration"),
      PriceWidgets.input("Govt.Price *", govtPriceController),
      FormCommonWidget(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text("Date Range",
                  style: CommonStyles.requestTextStyle(
                      weight: FontWeight.normal, color: AppColors.text)),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    // border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    startDateController.text ,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    // border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    startDateController.text ,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      PriceWidgets.time("Govt Announced Date *", _endTime, _pickEndTime),
      PriceWidgets.inputRemarks("Remarks ", remarksController),
      ButtonBS(
        width: w,
        onPressed: () {},
        title: 'Save Price',
        textColor: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        padding: 6.0,
        backgroundColor: AppColors.primary,
        borderRadius: 10,
      ),
    ]);
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C757D)),
      ),
    );
  }
}
