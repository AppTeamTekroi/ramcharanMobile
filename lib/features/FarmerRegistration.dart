import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ramcharan/Login/login_controller.dart';
import '../core/API/URLConst.dart';
import '../core/error/unauth_dilogbox.dart';
import '../core/headerfiles.dart';
import '../ui/CaseFormatter.dart';
import '../ui/color/appColor.dart';
import '../ui/loading.dart';
import '../ui/widgets/CommonWidget.dart';
import '../ui/widgets/add_address_widget.dart';
import 'controllers/farmerController.dart';
import 'customerNavBar.dart';

enum AddressType { farmer, land }

class FarmerRegistrationScreen extends StatefulWidget {
  const FarmerRegistrationScreen({super.key});

  @override
  State<FarmerRegistrationScreen> createState() =>
      _FarmerRegistrationScreenState();
}

class _FarmerRegistrationScreenState extends State<FarmerRegistrationScreen> {
  int selectedTab = 0;
  FarmerController cc = Get.find();
  LoginController lc = Get.find();
  final fullNameController = TextEditingController();
  final aadharNumberController = TextEditingController();
  final mobileController = TextEditingController();
  final villageController = TextEditingController();
  final pincodeController = TextEditingController();
  final areaController = TextEditingController();
  final surveyController = TextEditingController();

  TextEditingController accountNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController ifsc = TextEditingController();

  final farmerAddress = <String>[].obs;
  String? farmerDistrict;
  String? farmerMandal;
  String? farmerVillage;
  final landAddress = <String>[].obs;
  String? landDistrict;
  String? landMandal;
  String? landVillage;
  String? selectedCenter;
  final ImagePicker _picker = ImagePicker();
  XFile? farmerImage;

  String? validateAadhar(String value) {

    if (value.isEmpty) {
      return "Enter Aadhaar Number";
    }

    if (value.length != 12) {
      return "Aadhaar number must be 12 digits";
    }

    // Prevent repeated digits
    if (RegExp(r'(\d)\1{5,}').hasMatch(value)) {
      return "Invalid Aadhaar Number";
    }

    return null;
  }

  bool validateForm() {

    // Required text fields
    if (fullNameController.text.trim().isEmpty) {
      _showError(context,"Please enter full name");
      return false;
    }
    if (aadharNumberController.text.trim().isEmpty) {
      _showError(context,"Please enter Aadhaar number");
      return false;
    }

    final aadharError =
    validateAadhar(aadharNumberController.text.trim());

    if (aadharError != null) {
      _showError(context, aadharError);
      return false;
    }

    if (mobileController.text.trim().isEmpty ||
        mobileController.text.trim().length != 10) {
      _showError(context,"Please enter a valid mobile number");
      return false;
    }

    // Farmer address
    if (farmerDistrict == null ||
        farmerMandal == null ||
        farmerVillage == null) {
      _showError(context,"Please add farmer address");
      return false;
    }

    // Collection center
    if (selectedCenter == null || selectedCenter!.isEmpty) {
      _showError(context,"Please select collection center");
      return false;
    }

    // Bank details
    if (accountNumber.text.trim().isEmpty) {
      _showError(context,"Please enter bank account number");
      return false;
    }

    if (bankName.text.trim().isEmpty) {
      _showError(context,"Please enter bank name");
      return false;
    }

    if (ifsc.text.trim().isEmpty) {
      _showError(context,"Please enter IFSC code");
      return false;
    }

    // Land details
    if (areaController.text.trim().isEmpty) {
      _showError(context,"Please enter land area");
      return false;
    }
    if (surveyController.text.trim().isEmpty) {
      _showError(context,"Please enter survey number");
      return false;
    }

    if (landDistrict == null ||
        landMandal == null ||
        landVillage == null) {
      _showError(context,"Please add land address");
      return false;
    }

    // Image (optional – enable if required)
    // if (farmerImage == null) {
    //   _showError(context,"Please upload farmer photo");
    //   return false;
    // }

    return true; // ✅ all validations passed
  }
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }



  // void _showError(String message) {
  //   CommonStyles.showSnackbar(
  //     status: false,
  //     message: message,
  //   );
  // }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        farmerImage = image;
      });
    }
  }

  Future<void> registerFarmer() async {
    LoadingOverlay.show('Processing ...');
    // ${URLConst.baseURL}
    // final url = Uri.parse("");
    final url = Uri.parse("${URLConst.baseURL}farmer-register");

    final body = {
      "farmer_name": fullNameController.text.trim(),
      "farmer_mobile": mobileController.text.trim(),
      "aadhaar_no": aadharNumberController.text.trim(),
      "mandal": farmerMandal ?? "",
      "district": farmerDistrict ?? "",
      "village": farmerVillage ?? "",
      "bank_name": bankName.text.trim(),
      "account_no": accountNumber.text.trim(),
      "ifsc_code": ifsc.text.trim(),
      "collection_centre": selectedCenter,
      "lands":  [
      {
        "acers": areaController.text.trim(),
        "village": landVillage ?? "",
        "mandal": landMandal ?? "",
        "district": landDistrict ?? "",
        "survey_no": surveyController.text.trim(),
      },
      ],
    };

    final headers = await ApiHelper.getHeaders();
    print("Registration Posting Data $body");

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      final result = jsonDecode(response.body); // now it's a Map
      LoadingOverlay.hide();
      if (response.statusCode == 401) {
        UnauthDilogbox(context); // Call your custom dialog here if needed.
      }
      if (response.statusCode == 200) {
        print("✅ Farmer Registered Successfully");
        print(response.body);
        if (result['success'] == true) {
          Get.offAll(() => BottomNav());

          if(result['success'] == true){
            _showSuccess(context, "Farmer registered successfully!\n Farmer Code :${result['farmer_code']}");
            cc.farmerList(context);
          }else{
            _showError(context, "Found Some Error While processing:${result['message']}");
          }
          // clear();
        }
      } else {
        print("❌ Failed: ${response.statusCode}");
        print(response.body);

        _showError(context, "Found Some Error While processing:${result['message']}");

      }
    } catch (e) {
      _showError(context, "Something went wrong. Please try again.");

    }
  }

  @override
  void initState() {
    super.initState();
    selectedCenter = lc.collectionCenter;
    // cc.districtList(context);
    // cc.collectionCenter(context);
    // landdetails.add({
    //   "name": "",
    //   "community": "",
    //   "area": "",
    //   "quality": "",
    //   "district": "",
    //   "mandal": "",
    //   "state": "",
    //   "survey_no": "",
    //   "village": "",
    //   "location": "",
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        // backgroundColor: Color(0xFFF1F1F1),
        backgroundColor: AppColors.white,

        // elevation: 1,
        title:  Column(
          children: [
            Text("Farmers Registration",
                style: GoogleFonts.openSans(fontSize: 20,fontWeight: FontWeight.w500,wordSpacing: 0)
            ),

            Text("Collection Center : $selectedCenter",
                style: GoogleFonts.openSans(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.red)
            ),
          ],
        ),
        centerTitle: true,

      ),

      ///  Body
      body: _buildForm(),
      ///  Bottom Submit Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: () {
            if (!validateForm()){
              return;
            }else {
              registerFarmer();
            }
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text("Submit Registration",style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            // minimumSize: const Size.fromHeight(56),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }
  /// 🔹 Form Content
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _profileSection(),
          const SizedBox(height: 20),
          _sectionTitle("Basic Information"),
          _input("Full Name *", fullNameController,
          ),
          // _input("Aadhaar Number", aadharNumberController,
          //     keyboard: TextInputType.phone,inputLength: 12),
          _input(
            "Aadhaar Number",
            aadharNumberController,
            keyboard: TextInputType.phone,
            inputLength: 12,
            inputFormatters: [ FilteringTextInputFormatter.digitsOnly,]
          ),
          // const SizedBox(height: 10),
          // _sectionTitle("Contact & Address"),
          _input("Mobile Number *", mobileController,
              keyboard: TextInputType.phone,inputLength: 10,
          ),
          _addressPicker(
            context,
            title: "Farmer Address",
            addressList: farmerAddress,
            onTap: () =>
                _openAddressSheet(context, AddressType.farmer),
          ),
          // const SizedBox(height: 12),
          // _collectionCenterDropdown(),
          const SizedBox(height: 12),
          _sectionTitle("Bank Information"),
          _input("Bank Account Number *", accountNumber,
              keyboard: TextInputType.phone,
          ),

          _input("Bank Name", bankName,),
          const SizedBox(width: 12),
          _input("IFSC Code", ifsc,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              UpperCaseTextFormatter(),
            ],
          ),

          const SizedBox(height: 20),

          _landInfo(),
        ],
      ),
    );
  }
  Widget _profileSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Stack(
            children: [
              /// 📷 Camera click → Open Camera
              GestureDetector(
                onTap: () => _pickImage(ImageSource.camera),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: farmerImage != null
                      ? FileImage(File(farmerImage!.path))
                      : null,
                  child: farmerImage == null
                      ? const Icon(Icons.person,
                      size: 30, color: Colors.white)
                      : null,
                ),
              ),

              /// ➕ Plus click → Open Gallery
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.add,
                        size: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Farmer Photo",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Text(
                  "Tap to take picture",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          /// 📷 Camera icon → Also open camera
          GestureDetector(
            onTap: () => _pickImage(ImageSource.camera),
            child: const Icon(Icons.camera_alt, color: Colors.grey),
          ),
        ],
      ),
    );
  }
  /// 🔹 Land Section
  Widget _landInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Icon(Icons.agriculture, color: Colors.red),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Please verify land documents before entry.",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),

        _sectionTitle("Land Details"),
        _input("Survey Number", surveyController),
        // const SizedBox(height: 12),
        _input("Total Area (Acres)", areaController,
            keyboard: TextInputType.number),
        _addressPicker(
          context,
          title: "Land Address",
          addressList: landAddress,
          onTap: () =>
              _openAddressSheet(context, AddressType.land),
        ),

      ],
    );
  }

  Widget _input(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text,int? inputLength,
        List<TextInputFormatter>? inputFormatters,

      }) {
    return FormCommonWidget(
      color: AppColors.form,
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLength: inputLength,
        inputFormatters: inputFormatters,         // ← and this

        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFFB1C0CC),fontSize: 14),
            border: InputBorder.none,
            counterText: "",
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C757D)),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          blurRadius: 6,
          color: Colors.black12,
        )
      ],
    );
  }
  Widget _addressPicker(
      BuildContext context, {
        required String title,
        required RxList<String> addressList,
        required VoidCallback onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.form,
          boxShadow: const [
            BoxShadow(blurRadius: 6, color: Colors.black12),
          ],
        ),
        child: Obx(() {
          return addressList.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                addressList.join(", "),
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onTap,
                child: const Text(
                  "Edit",
                  style: TextStyle(
                      color: Color(0xFF007BFF),
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          )
              : SizedBox(
            height: 30,
            child: GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Icon(Icons.add_circle,
                      size: 18, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(title,
                      style:
                      TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
  Future<void> _openAddressSheet(
      BuildContext context, AddressType type) async {
    final result =
    await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddAddressWidget(
          district:
          type == AddressType.farmer ? farmerDistrict : landDistrict,
          mandal:
          type == AddressType.farmer ? farmerMandal : landMandal,
          village:
          type == AddressType.farmer ? farmerVillage : landVillage,
        ),
      ),
    );

    if (result == null) return;

    setState(() {
      if (type == AddressType.farmer) {
        farmerAddress.value = [
          result["village"],
          result["mandal"],
          result["district"]
        ];
        farmerVillage = result["village"];
        farmerMandal = result["mandal"];
        farmerDistrict = result["district"];

        ///
        landAddress.value = [
          result["village"],
          result["mandal"],
          result["district"]
        ];
        landVillage = result["village"];
        landMandal = result["mandal"];
        landDistrict = result["district"];

      } else {
        landAddress.value = [
          result["village"],
          result["mandal"],
          result["district"]
        ];
        landVillage = result["village"];
        landMandal = result["mandal"];
        landDistrict = result["district"];
      }
    });
  }
  // Widget _collectionCenterDropdown() {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 8.0),
  //     child: Container(
  //       height: 50,
  //       width:  MediaQuery.of(context).size.width,
  //       // padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
  //       decoration: BoxDecoration(
  //         // border: Border.all(color: Colors.grey.shade400),
  //         borderRadius: BorderRadius.circular(10),
  //         color:  Colors.transparent,
  //         boxShadow: const [
  //           BoxShadow(
  //             blurRadius: 6,
  //             color: Colors.black12,
  //           )
  //         ],
  //       ),
  //
  //       child: Obx(() {
  //         if (cc.isLoading11.value) {
  //           return const Center(child: CircularProgressIndicator());
  //         }
  //
  //         final items = cc.collectionList.isNotEmpty
  //             ? cc.collectionList
  //             .map((v) => DropdownMenuItem<String>(
  //           value: v['collection_centre'],
  //           child: Text(v['collection_centre']),
  //         ))
  //             .toList()
  //             : [
  //           DropdownMenuItem<String>(
  //             value: "0",
  //             child: Text(
  //               "No Collection Center",
  //               style: TextStyle(color: Colors.grey.shade400),
  //             ),
  //           )
  //         ];
  //
  //         return DropdownButtonFormField<String>(
  //           value: selectedCenter,
  //           items: items,
  //           onChanged: (val) {
  //             setState(() {
  //               selectedCenter = val!;
  //             });
  //           },
  //           decoration: InputDecoration(
  //             labelText: "Collection Center",
  //             labelStyle: TextStyle(fontWeight: FontWeight.w500,color: Color(
  //                 0xFFB1C0CC),fontSize: 14),
  //
  //             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(12),
  //               borderSide: BorderSide.none,
  //             ),
  //
  //             filled: true,
  //             fillColor: AppColors.form,
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }

}
