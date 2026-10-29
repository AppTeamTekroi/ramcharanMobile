import 'package:flutter/material.dart';
import 'package:ramcharan/ui/color/appColor.dart';

import '../Login/login_controller.dart';
import 'package:get/get.dart';

import '../ui/Buttons/button.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

LoginController controller = Get.find();

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      body: Padding(
        padding:  EdgeInsets.only(top: h*0.1),
        child: Container(
          width: double.infinity,
          child: Column(
            spacing: 14,

            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 14,
                    children: [
                      _buildProfileCard(context),
                      _buildLogoutButton(context),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: _buildDetailRow(
                          context,
                          label: '',
                          value: 'RAM.V0.04',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // color: appTheme.color190000,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileAvatar(context),
          SizedBox(height: 16),
          _buildProfileName(context),
          SizedBox(height: 4),
          _buildProfileTeam(context),
          SizedBox(height: 24),
          _buildProfileDetails(context),

        ],
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    final name = controller.Name.trim();


    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
         color: Colors.blueGrey.shade900,
        borderRadius: BorderRadius.circular(48),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0]: '?',
          style: TextStyle(color: Colors.white,fontSize: 25),
        ),
      ),
    );
  }

  Widget _buildProfileName(BuildContext context) {

    return Text(
      controller.Name,
      style: TextStyle(
         color: Colors.blueGrey.shade900),
    );
  }

  Widget _buildProfileTeam(BuildContext context) {
    return Text(
      '${controller.collectionCenter} Collection Center',
      // style: TextStyleHelper.instance.body14RegularInter
      //     .copyWith(color: appTheme.blue_gray_500),
    );
  }

  Widget _buildProfileDetails(BuildContext context) {
    final email = "";

    return Column(
      children: [
        _buildDetailRow(
          context,
          label: 'Email',
          value: email.isNotEmpty ? email : '--',
        ),
        SizedBox(height: 10),
        _buildDetailRow(
          context,
          label: 'Phone',
          value: '+91 ${controller.phone }',
        ),
        SizedBox(height: 10),
        _buildDetailRow(
          context,
          label: 'Role',
          value: controller.loginType == 2 ?'Collection Agent':'Super Admin',
        ),
        SizedBox(height: 10),
        _buildDetailRow(
          context,
          label: 'Area',
          value: controller.district,
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context,
      {required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:TextStyle(color: Colors.blueGrey.shade700),
          ),
          Text(
            value,
            // style: TextStyleHelper.instance.title16RegularInter
            //     .copyWith(color: appTheme.blue_gray_900),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: ButtonBS(
        height: 50,
        title: 'Logout',
        width: double.infinity,
        backgroundColor: AppColors.primary,
        textColor: AppColors.secondary,
        fontSize: 16,
        borderRadius: 14,
        // padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        onPressed: () => controller.logOutUser(),
      ),
    );
  }
}





