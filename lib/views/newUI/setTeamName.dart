import 'dart:async';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/base_response.dart';
import 'package:myrex11/repository/model/refer_code_response.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../appUtilities/app_constants.dart';
import '../../appUtilities/app_navigator.dart';
import '../../customWidgets/app_circular_loader.dart';
import '../../localStoage/AppPrefrences.dart';
import '../../repository/app_repository.dart';
import '../../repository/model/login_request.dart';
import '../../repository/retrofit/api_client.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class SetTeamName extends StatefulWidget {
  @override
  _SetTeamNameState createState() => _SetTeamNameState();
}

class _SetTeamNameState extends State<SetTeamName> {
  TextEditingController teamNameController = TextEditingController();
  TextEditingController refercodeController = TextEditingController();

  final tooltipController = JustTheController();
  String fcmToken = '';

  @override
  void initState() {
    super.initState();
    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    _messaging.getToken().then((token) {
      fcmToken = token!;
    });
    getPublicIP().then((value) => {getRefercode(value)});
  }

  void getRefercode(ip) async {
    GeneralRequest loginRequest = GeneralRequest(user_id: '', ip: ip);
    final client = ApiClient(AppRepository.dio);
    ReferCodeResponse referCodeResponse =
        await client.getRefercode(loginRequest);
    if (referCodeResponse.status == 1) {
      refercodeController.text =
          referCodeResponse.result!.refer_code.toString();
    }
    setState(() {});
  }

  Future<String> getPublicIP() async {
    try {
      const url = 'https://api.ipify.org';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Header Section with Gradient
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      // AppConstants.backButtonFunction(),
                      SizedBox(width: 0),
                      Text(
                        "Set Team Name",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Form Section
              Expanded(
                child: Container(
                  transform: Matrix4.translationValues(0, -30, 0),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),

                      // Team Name Field
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF6A0BF8).withOpacity(0.3),
                          ),
                        ),
                        child: TextFormField(
                          controller: teamNameController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9A-Za-z]')),
                          ],
                          maxLength: 9,
                          decoration: InputDecoration(
                            hintText: 'Team Name',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Validation Text
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Team name can be alphanumeric, must not contain any special characters (except for underscore) 3 to 9 characters long.',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Refer Code Field
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF6A0BF8).withOpacity(0.3),
                          ),
                        ),
                        child: TextFormField(
                          controller: refercodeController,
                          decoration: InputDecoration(
                            hintText: 'Refer Code',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      SizedBox(height: 50),

                      // Set Team Name Button
                      Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            transform: GradientRotation(52.61 * 3.14159 / 180),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [
                              0.1502,
                              0.1706,
                              0.2410,
                              0.2781,
                              0.3280,
                              0.3681,
                              0.5620,
                              0.6553,
                              0.7411,
                              0.7849,
                              0.8103
                            ],
                            colors: [
                              Color(0xFFB2B2AF),
                              Color(0xFFBEBEBB),
                              Color(0xFFE1E1E1),
                              Color(0xFFEFEFEF),
                              Color(0xFFF2F2F2),
                              Color(0xFFFCFCFC),
                              Color(0xFFD1D1D1),
                              Color(0xFFDBDBDB),
                              Color(0xFFE8E8E8),
                              Color(0xFFF5F5F5),
                              Color(0xFFFFFFFF),
                            ],
                          ),
                          border: Border.all(
                            color: Color(0xFF6A0BF8),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setTeamName();
                            },
                            borderRadius: BorderRadius.circular(26),
                            child: Center(
                              child: Text(
                                'SET TEAM NAME',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                          ),
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

  void setTeamName() async {
    if (teamNameController.text.isEmpty ||
        teamNameController.text.isBlank == true) {
      Fluttertoast.showToast(
          msg: 'Please enter Team Name.',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
      return;
    } else if (teamNameController.text.length < 3 ||
        teamNameController.text.length > 9) {
      Fluttertoast.showToast(
          msg: 'Team name should be between 3 and 9 characters long.',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
      return;
    }

    AppLoaderProgress.showLoader(context);

    try {
      // Get user data from SharedPreferences
      String? userId =
          await AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID);
      String? userReferCode = await AppPrefrence.getString(
          AppConstants.SHARED_PREFERENCE_USER_REFER_CODE);

      if (userId == null) {
        Fluttertoast.showToast(
            msg: 'User session not found. Please login again.',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1);
        AppLoaderProgress.hideLoader(context);
        return;
      }

      // Call the new team name API
      NewLoginRequest request = NewLoginRequest(
        user_id: userId,
        teamname: teamNameController.text.toString(),
        refer_code: refercodeController.text.toString(),
      );

      final client = ApiClient(AppRepository.dio);
      GeneralResponse response = await client.updateTeamNameNew(request);

      AppLoaderProgress.hideLoader(context);

      if (response.status == 1) {
        // Save team name to SharedPreferences
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_TEAM_NAME,
            teamNameController.text.toString());

        // Mark user as logged in
        AppPrefrence.putBoolean(
            AppConstants.SHARED_PREFERENCES_IS_LOGGED_IN, true);

        Fluttertoast.showToast(
            msg: response.message ?? 'Team name set successfully!',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1);

        // Navigate to HomePage
        navigateToHomePage(context);
      } else {
        Fluttertoast.showToast(
            msg: response.message ?? 'Failed to set team name.',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1);
      }
    } catch (e) {
      AppLoaderProgress.hideLoader(context);
      print('Error setting team name: $e');
      Fluttertoast.showToast(
          msg: 'Error setting team name. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
    }
  }
}
