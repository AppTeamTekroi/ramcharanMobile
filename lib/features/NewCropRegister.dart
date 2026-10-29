import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ramcharan/features/scanner_sreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ramcharan/ui/Buttons/button.dart';
import '../Login/login_controller.dart';
import '../ui/color/appColor.dart';
import '../ui/widgets/AppDateField.dart';
import '../ui/widgets/CommonWidget.dart';
import 'controllers/farmerController.dart';
import 'farmerList.dart';
import 'package:collection/collection.dart';
class NewCropRegister extends StatefulWidget {
  final Map<String, dynamic>? selectedFarmer;

  const NewCropRegister({
    super.key,
    this.selectedFarmer,
  });

  @override
  State<NewCropRegister> createState() => _RecieptState();
}

class _RecieptState extends State<NewCropRegister> {

  // ───────── Farmer Data ─────────
  var selectedFarmerData;
  int? _selectedFarmerId;
  int? _selectedFarmerMobile;
  String? _selectedFarmerName;
  String? _selectedFarmerCode;
  String? _selectedCollection;

  // ───────── UI State ─────────
  final updatedetails = false.obs;
  final weightcorrect = true.obs;
  final weightcorrectMsg = ''.obs;

  // ───────── Controllers ─────────
  final TextEditingController name = TextEditingController();
  final TextEditingController vehicalNo = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController grossController = TextEditingController();
  final TextEditingController tareController = TextEditingController();
  final TextEditingController rejectedController = TextEditingController();
  final TextEditingController netController = TextEditingController();
  final TextEditingController weightBridgeNo = TextEditingController();
  final TextEditingController finalController = TextEditingController();

  // ───────── Time ─────────
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // ───────── Controllers ─────────
  final FarmerController controller = Get.find();
  LoginController lc = Get.find();

  // ───────── Init ─────────
  @override
  void initState() {
    super.initState();
    _selectedCollection = lc.collectionCenter;

    if (widget.selectedFarmer != null) {
      selectedFarmerData = widget.selectedFarmer;
      _selectedFarmerId = int.tryParse(selectedFarmerData!['id'].toString());
      _selectedFarmerName = selectedFarmerData!['farmer_name'];
      _selectedFarmerCode = selectedFarmerData!['farmer_code'];
      _selectedFarmerMobile = int.tryParse(selectedFarmerData!['farmer_mobile'].toString());
    }
    weightcorrect.value = false;
  }

  @override
  void dispose() {
    name.dispose();
    vehicalNo.dispose();
    phoneController.dispose();
    grossController.dispose();
    tareController.dispose();
    rejectedController.dispose();
    netController.dispose();
    weightBridgeNo.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    weightcorrect.value = true;
    weightcorrectMsg.value = msg;
  }

  // ───────── Submit ─────────
  Future<void> _submitData() async {
    // Farmer
    if (_selectedFarmerId == null) {
      _showError("Please select a farmer");
      return;
    }

    // Driver details
    if (name.text.trim().isEmpty) {
      _showError("Driver name is required");
      return;
    }

    if (vehicalNo.text.trim().isEmpty) {
      _showError("Vehicle number is required");
      return;
    }

    // if (phoneController.text.trim().length < 10) {
    //   _showError("Enter valid driver mobile number");
    //   return;
    // }

    // Weigh bridge
    if (weightBridgeNo.text.trim().isEmpty) {
      _showError("Weigh bridge acknowledgement number is required");
      return;
    }

    // Time validation
    if (_startTime == null || _endTime == null) {
      _showError("Please select entry and exit time");
      return;
    }

    // Parse weights
    final double grossWt = double.tryParse(grossController.text) ?? 0;
    final double tareWt = double.tryParse(tareController.text) ?? 0;
    final double rejectedWt = double.tryParse(rejectedController.text) ?? 0;

    final double netWt = grossWt - tareWt;
    final double finalWt = netWt - rejectedWt;

    // Weight validations
    if (grossWt <= 0) {
      _showError("Gross weight must be greater than 0");
      return;
    }

    if (tareWt <= 0) {
      _showError("Tare weight must be greater than 0");
      return;
    }

    if (grossWt <= tareWt) {
      _showError("Gross weight must be greater than tare weight");
      return;
    }

    if (rejectedWt < 0) {
      _showError("Rejected weight cannot be negative");
      return;
    }

    if (rejectedWt > netWt) {
      _showError("Rejected weight cannot be greater than net weight");
      return;
    }

    if (finalWt <= 0) {
      _showError("Final weight must be greater than 0");
      return;
    }

    // ✅ Clear error if everything is valid
    weightcorrect.value = false;

    final pref = await SharedPreferences.getInstance();
    final loginId = pref.getInt('userId');

    final body = {
      "farmer_id": _selectedFarmerId,
      "farmer_code": _selectedFarmerCode,
      "field_officer": loginId,
      "farmer_mobile": _selectedFarmerMobile,
      "center": _selectedCollection,
      "gross_wt": grossWt,
      "tare_wt": tareWt,
      "net_wt": netWt,
      "rejection_wt": rejectedWt,
      "final_wt": finalWt,
      "startTime": _startTime!.format(context),
      "endTime": _endTime!.format(context),
      "driver_name": name.text.trim(),
      "vehicle_no": vehicalNo.text.trim(),
      "driver_mobile": phoneController.text.trim(),
      "weightBridgeNo": weightBridgeNo.text.trim(),
    };
    controller.submitCropData(context, body);
  }

  // ───────── Weight Calculation ─────────
  void _recalculateWeights() {
    final grossWt = double.tryParse(grossController.text) ?? 0;
    final tareWt = double.tryParse(tareController.text) ?? 0;
    final rejectedWt = double.tryParse(rejectedController.text) ?? 0;

    if (grossWt == 0 || tareWt == 0) {
      netController.clear();
      finalController.clear();
      return;
    }

    if (grossWt <= tareWt) {
      _showError("Gross must be greater than tare");
      netController.clear();
      finalController.clear();
      return;
    }

    final netWt = grossWt - tareWt;

    if (rejectedWt > netWt) {
      _showError("Rejected weight cannot exceed net weight");
      finalController.clear();
      return;
    }

    final finalWt = netWt - rejectedWt;

    weightcorrect.value = false;
    netController.text = netWt.toStringAsFixed(2);
    finalController.text = finalWt.toStringAsFixed(2);
    setState(() {});
  }

  // ───────── Time Pickers ─────────
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
  String _extractCodeFromQr(String raw) {
    final uri = Uri.tryParse(raw);
    if (uri != null && uri.queryParameters['farmer_code'] != null) {
      return uri.queryParameters['farmer_code']!;
    }
    return raw.trim();
  }

  Future<void> _scanFarmerQr() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const QrScanPage()),
    );

    if (result == null || result.isEmpty) return;

    if (controller.opplist.isEmpty) {
      Get.snackbar('No Data', 'Farmer list is empty',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final extracted = _extractCodeFromQr(result);
    if (extracted.isEmpty) {
      Get.snackbar('Invalid QR', 'Could not read farmer code',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final code = extracted.trim().toLowerCase();

    // 1. Find the farmer
    final match = controller.opplist.cast<Map<String, dynamic>>().firstWhereOrNull(
          (f) {
        final farmerCode = (f["farmer_code"]?.toString().trim().toLowerCase() ?? '');
        final farmerId   = (f["id"]?.toString().trim().toLowerCase() ?? '');
        return farmerCode == code || farmerId == code;
      },
    );

    if (match == null) {
      Get.snackbar(
        'Farmer not found',
        'No farmer with code/id "$code" in your list',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    // 2. Resolve the farmer's collection center against the dropdown's list
    //    so the dropdown can recognise it as a selected item.

    setState(() {
      _selectedFarmerId     = int.tryParse(match['id'].toString());
      _selectedFarmerName   = match['farmer_name']?.toString();
      _selectedFarmerCode   = match['farmer_code']?.toString() ?? '';
      _selectedFarmerMobile = int.tryParse(match['farmer_mobile'].toString());

      // Use the dropdown's value if found, otherwise fall back to farmer's value

    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("FFB Collection",
                style: GoogleFonts.openSans(
                    fontSize: 20, fontWeight: FontWeight.w500, wordSpacing: 0)),
        Text("Collection Center : $_selectedCollection",
          style: GoogleFonts.openSans(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.red)
        ),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.grey, // ✅ makes the back arrow white
        ),
        actions: [
        InkWell(
        onTap: _scanFarmerQr,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.qr_code_scanner,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 21),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () async {
                    selectedFarmerData = await Get.to(() => const Farmerlist(
                          fromCrop: true,
                        ));
                    if (selectedFarmerData != null &&
                        selectedFarmerData['farmer_code'] != '' && selectedFarmerData['status'] == 1) {
                      setState(() {
                        _selectedFarmerId = selectedFarmerData['id'];
                        _selectedFarmerName =
                            selectedFarmerData['farmer_name']; // new variable
                        _selectedFarmerCode =
                            selectedFarmerData['farmer_code'] ??
                                ''; // new variable
                        // new variable
                        _selectedFarmerMobile =
                            selectedFarmerData['farmer_mobile'] ?? '';
                        print("Selected Farmer ID: $_selectedFarmerId");
                      });
                    }
                  },
                  child: Container(
                    // height: 50,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.black12,
                        )
                      ],
                    ),

                    child: Row(
                      spacing: 10,
                      children: [
                        const Icon(Icons.add_circle_outline_rounded,
                            color: Colors.grey, size: 22),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _selectedFarmerName ?? "Select Farmer",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("tap to select/change farmer",
                                style: GoogleFonts.inter(
                                    fontSize: 10, color: Colors.grey)),
                            // Show aadhaar only if available
                            if (_selectedFarmerName != null)
                              Text(
                                "Farmer Code :${_selectedFarmerCode.toString()}",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.blueGrey[700]),
                                overflow: TextOverflow.ellipsis,
                              ),

                          ],
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Driver Details',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              FormCommonWidget(
                color: Colors.white,
                child: TextField(
                  controller: name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Driver Name',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                  ),
                ),
              ),
              FormCommonWidget(
                color: Colors.white,
                // width: h * 0.5,
                child: TextField(
                  controller: vehicalNo,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Vehicle Number',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                  ),
                ),
              ),
              FormCommonWidget(
                color: Colors.white,
                child: IntlPhoneField(
                  showDropdownIcon: false,
                  showCountryFlag: false,
                  disableLengthCheck: true, // we control it
                  flagsButtonPadding: const EdgeInsets.all(8),
                  dropdownIconPosition: IconPosition.trailing,
                  initialCountryCode: 'IN',
                  keyboardType: TextInputType.number,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter
                  //       .digitsOnly, // only numbers
                  //   LengthLimitingTextInputFormatter(
                  //       10), // max 10 digits
                  // ],
                  decoration: InputDecoration(
                    counterText: "", // hides the length counter
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    hintText: 'Driver Phone Number',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (phone) {
                    phoneController.text = phone.number;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    'Weight Bridge Acknowledgment Number',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              _buildFetchRowField(
                  "Weigh Bridge Acknowledgement No", weightBridgeNo, () {}),
              Row(
                children: [
                  Text(
                    'FFB Details',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              _timeRow("Weigh Bridge Entry Time", _startTime, _pickStartTime),
              _timeRow("Weigh Bridge Exit Time", _endTime, _pickEndTime),
              _buildRowField(
                  "Gross Weight", grossController, () => _recalculateWeights()),
              _buildRowField(
                  "Tare Weight", tareController, () => _recalculateWeights()),
              _buildRowField("Rejected Weight", rejectedController,
                  () => _recalculateWeights()),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _summaryRow("Net Weight", netController.text),
                      _summaryRow("Total Weight", finalController.text),
                    ],
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20),
                child: Obx(() => weightcorrect.value
                    ? Text("❌${weightcorrectMsg.value}")
                    : SizedBox.shrink()),
              ),
              ButtonBS(
                width: w,
                onPressed: _submitData,
                title: 'Store  FFB Collection',
                textColor: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                padding: 6.0,
                backgroundColor: AppColors.primary,
                borderRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.primary,
          ),
        ),
        Text(
          "$value   kg",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _timeRow(String title, TimeOfDay? time, VoidCallback onTap) {
    return FormCommonWidget(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(title,
                style: CommonStyles.requestTextStyle(
                    weight: FontWeight.normal, color: AppColors.text)
                //   fontSize: 14,
                //   color: AppColors.container,
                // ),
                ),
            const Spacer(),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  // border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  time?.format(Get.context!) ?? "00:00",
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
    );
  }

  Widget _buildRowField(
    String label,
    TextEditingController controller,
    VoidCallback onChanged,
  ) {
    return FormCommonWidget(
      color: Colors.white,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        onChanged: (_) => onChanged(),
      ),
    );
  }

  Widget _buildFetchRowField(
    String label,
    TextEditingController controller,
    VoidCallback onChanged,
  ) {
    return FormCommonWidget(
      color: Colors.white,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        onChanged: (_) => onChanged(),
      ),
    );
  }
}
