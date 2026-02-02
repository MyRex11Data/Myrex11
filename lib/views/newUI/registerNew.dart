import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/refer_code_response.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../hardwereInfoList/hardwereInfo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../appUtilities/app_constants.dart';
import '../../appUtilities/app_images.dart';
import '../../appUtilities/app_navigator.dart';
import '../../buildType/buildType.dart';
import '../../customWidgets/app_circular_loader.dart';
import '../../localStoage/AppPrefrences.dart';
import '../../main.dart';
import '../../repository/app_repository.dart';
import '../../repository/model/data.dart';
import '../../repository/model/login_request.dart';
import '../../repository/model/register_request.dart';
import '../../repository/retrofit/api_client.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class RegisterNew extends StatefulWidget {
  @override
  _RegisterNewState createState() => _RegisterNewState();
}

class _RegisterNewState extends State<RegisterNew> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isMobileLogin = true;

  TextEditingController codeController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();
  TextEditingController refercodeController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();

  final tooltipController = JustTheController();
  TextEditingController emailEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  String currentText = "";
  bool checkedValue = false;
  var userLocation = '';
  var states = '';
  var state = '';
  TextEditingController stateOrCountryController = TextEditingController();
  bool locationtap = false;
  var countryname = '';
  String? locationMessage;

  // OTP related variables
  bool isOtpSent = false;
  int _secondsRemaining = 60; // 3 minutes = 180 seconds
  Timer? _timer;
  String? userId;
  int? newUser;
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  List<FocusNode> otpFocusNodes = List.generate(6, (index) => FocusNode());
  String selectedCountry = 'India';
  String selectedCountryCode = '+91';

  int mobileMaxLength = 10;

  String fcmToken = '';
  String? latitude;
  String? longitude;
  bool locationallow = false;
  int version = 0;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    _messaging.getToken().then((token) {
      fcmToken = token!;
    });
    getPublicIP().then((value) => {getRefercode(value)});
    deviceVersion();
  }

  void deviceVersion() async {
    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      setState(() {
        version = int.parse(iosInfo.systemVersion.split('.')[0]);
      });
    }
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
    return GestureDetector(
      onTap: () {
        Focus.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: primaryColor
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     Color(0xFF6A0BF8),
                //     Color(0xFF9C44FF),
                //     Colors.white,
                //   ],
                //   stops: [0.0, 0.3, 0.4],
                // ),
                ),
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // GestureDetector(
                      //     // onTap: () {
                      //     //   Navigator.pushAndRemoveUntil(
                      //     //       context,
                      //     //       MaterialPageRoute(
                      //     //           builder: (context) => MyApp()),
                      //     //           (route) => false);
                      //     // },
                      //     onTap: () {
                      //       // Navigator.pop(context);
                      //     },
                      //     child: Container(
                      //       height: 30,
                      //       child: Image.asset(
                      //         AppImages.backImageURL,
                      //         fit: BoxFit.fill,
                      //       ),
                      //     )),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Log In / Register",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Welcome to MyRex11",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )
                        ],
                      ),
                      // Spacer(),
                      // Icon(
                      //   Icons.help_outlined,
                      //   color: Colors.white,
                      //   size: 32,
                      // ),
                    ],
                  ),
                ),

                // Form Section
                Expanded(
                  child: Container(
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

                        // Mobile Section
                        Text(
                          'Mobile',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            // Country Dropdown
                            GestureDetector(
                              onTap: () => _showCountryPicker(context),
                              child: Container(
                                width: 110,
                                // height: 57,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 19.5),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F5FF),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12)),
                                  border: Border.all(
                                    color: Color(0xFF6A0BF8).withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '$selectedCountry ($selectedCountryCode)',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: secondaryTextColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey[600],
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Mobile Number Field
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F5FF),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12)),
                                  border: Border.all(
                                    color: Color(0xFF6A0BF8).withOpacity(0.3),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: mobileController,
                                  keyboardType: TextInputType.number,
                                  maxLength: mobileMaxLength,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(
                                        mobileMaxLength),
                                  ],
                                  decoration: InputDecoration(
                                    hintText: 'Mobile Number',
                                    hintStyle: TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                    counterText: '',
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Email Section
                        Text(
                          'Enter Email Address',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F5FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF6A0BF8).withOpacity(0.3),
                            ),
                          ),
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Email Address',
                              hintStyle: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Email OTP Section - Dynamic
                        if (!isOtpSent) ...[
                          // Send OTP Button
                          Container(
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: sendEmailOTP,
                                borderRadius: BorderRadius.circular(12),
                                child: Center(
                                  child: Text(
                                    'Send OTP',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          // Email OTP Fields
                          Text(
                            'Email OTP',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 0),
                            child: PinCodeTextField(
                              focusNode: otpFocusNode, // 🔥 add this

                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly, // Only digits
                              ],
                              length: 6,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(10),
                                fieldHeight: 50,
                                fieldWidth: 50,
                                activeFillColor: primaryColor.withOpacity(0.05),
                                inactiveFillColor:
                                    primaryColor.withOpacity(0.05),
                                inactiveColor: primaryColor.withOpacity(0.3),
                                inactiveBorderWidth: 1,
                                selectedColor: primaryColor.withOpacity(0.3),
                                selectedFillColor:
                                    primaryColor.withOpacity(0.05),
                                selectedBorderWidth: 1,
                                activeColor: primaryColor,
                                activeBorderWidth: 1,
                              ),
                              textStyle: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              animationDuration: Duration(milliseconds: 300),
                              enableActiveFill: true,
                              cursorColor: primaryColor,
                              enablePinAutofill: true,
                              keyboardType: TextInputType.number,
                              errorAnimationController: errorController,
                              controller: emailEditingController,

                              // 🔥 Fix: move cursor to end when box is tapped
                              onTap: () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  final text = emailEditingController.text;
                                  emailEditingController.selection =
                                      TextSelection.collapsed(
                                          offset: text.length);
                                });
                              },

                              // 🔥 Fix: update value correctly when typing or editing in middle
                              onChanged: (value) {
                                setState(() {
                                  currentText = value;
                                });
                                print(currentText);

                                // Force cursor to the end after any change
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  emailEditingController.selection =
                                      TextSelection.collapsed(
                                    offset: emailEditingController.text.length,
                                  );
                                });
                              },

                              onCompleted: (v) {
                                print("Completed: $v");
                              },

                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                return true;
                              },
                              appContext: context,
                            ),
                          ),
                        ],

                        // Terms Checkbox - Only show when OTP is sent
                        if (isOtpSent) ...[
                          Row(
                            children: [
                              Checkbox(
                                value: checkedValue,
                                activeColor: primaryColor,
                                side: BorderSide(color: Color(0xFFA66DFB)),
                                onChanged: (value) {
                                  setState(() {
                                    checkedValue = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  "I certify that I'm above 18, I agree to T&Cs.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        SizedBox(height: 10),

                        // Resend OTP - Only show when OTP is sent
                        if (isOtpSent) ...[
                          Center(
                            child: GestureDetector(
                              onTap: _secondsRemaining == 0 ? resendOTP : null,
                              child: Text(
                                _secondsRemaining > 0
                                    ? "${_formatTime(_secondsRemaining)} Resend OTP"
                                    : "Resend OTP",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _secondsRemaining > 0
                                      ? Colors.grey
                                      : redColor,
                                  fontWeight: FontWeight.w500,
                                  decoration: _secondsRemaining == 0
                                      ? TextDecoration.underline
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ],

                        // Sign In Button - Only show when OTP is sent
                        if (isOtpSent) ...[
                          SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(AppImages.Btngradient),
                                  fit: BoxFit.contain),
                              // gradient: LinearGradient(
                              //   transform: GradientRotation(52.61 *
                              //       3.14159 /
                              //       180), // Convert degrees to radians
                              //   begin: Alignment.topLeft,
                              //   end: Alignment.bottomRight,
                              //   stops: [
                              //     0.1502,
                              //     0.1706,
                              //     0.2410,
                              //     0.2781,
                              //     0.3280,
                              //     0.3681,
                              //     0.5620,
                              //     0.6553,
                              //     0.7411,
                              //     0.7849,
                              //     0.8103
                              //   ],
                              //   colors: [
                              //     Color(0xFFB2B2AF),
                              //     Color(0xFFBEBEBB),
                              //     Color(0xFFE1E1E1),
                              //     Color(0xFFEFEFEF),
                              //     Color(0xFFF2F2F2),
                              //     Color(0xFFFCFCFC),
                              //     Color(0xFFD1D1D1),
                              //     Color(0xFFDBDBDB),
                              //     Color(0xFFE8E8E8),
                              //     Color(0xFFF5F5F5),
                              //     Color(0xFFFFFFFF),
                              //   ],
                              // ),

                              border: Border.all(
                                color: Color(0xFF6A0BF8),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: verifyEmailOTP,
                                borderRadius: BorderRadius.circular(26),
                                child: Center(
                                  child: Text(
                                    'SIGN IN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],

                        SizedBox(height: 20),

                        // OR Divider
                        Center(
                          child: Container(
                            height: 45,
                            width: 45,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor.withAlpha(10),
                                border: Border.all(
                                    color: primaryColor.withAlpha(50),
                                    width: 1)),
                            child: Center(
                              child: Text(
                                "OR",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Google Sign In Button
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                signup(context);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppImages.gmail_image,
                                    width: 24,
                                    height: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
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
      ),
    );
  }

  Future<void> signup(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential? result;

      try {
        result = await auth.signInWithCredential(authCredential);

        // 🔥 Print entire Firebase response
        print("=========================================");
        print("🔥 Firebase Login Response");
        print("UserCredential: $result");
        print("AdditionalUserInfo: ${result.additionalUserInfo}");
        print("Provider ID: ${result.credential?.providerId}");
        print("=========================================");
      } catch (e) {
        print('❌ Firebase Auth error: $e');
        AppLoaderProgress.hideLoader(context);
        Fluttertoast.showToast(
          msg: 'Authentication failed. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
        );
        return;
      }

      if (result != null && result.user != null) {
        User user = result.user!;

        // 🔥 Print user details
        print("=========================================");
        print("🔥 Firebase User Details:");
        print("UID: ${user.uid}");
        print("Name: ${user.displayName}");
        print("Email: ${user.email}");
        print("PhotoURL: ${user.photoURL}");
        print("Phone: ${user.phoneNumber}");
        print("Is New User: ${result.additionalUserInfo?.isNewUser}");
        print("Last Sign-in: ${user.metadata.lastSignInTime}");
        print("Account Created: ${user.metadata.creationTime}");
        print("=========================================");

        // Device ID & Token
        String deviceId = '';
        String? idToken = '';

        try {
          HardWereInfo hardWereInfo = HardWereInfo();
          deviceId = await hardWereInfo.androidId();

          idToken = await user.getIdToken();

          // 🔥 Print tokens and device info
          print("🔥 Device / Token Info:");
          print("Device ID: $deviceId");
          print("Firebase ID Token: $idToken");
          print("=========================================");
        } catch (e) {
          print('Error getting device info: $e');
        }

        userLoginSocial(
          LoginRequest(
            name: user.displayName,
            email: user.email,
            image: user.photoURL ?? '',
            idToken: idToken,
            deviceId: deviceId,
            social_id: user.uid,
            socialLoginType: 'gmail',
            type: 'gmail',
            fcmToken: fcmToken,
          ),
        );

        googleSignIn.signOut();
      }
    }
  }

  void userLoginSocial(LoginRequest loginRequest) async {
    AppLoaderProgress.showLoader(context);
    try {
      print('🔍 Social Login Request Data:');
      print('Name: ${loginRequest.name}');
      print('Email: ${loginRequest.email}');
      print('Device ID: ${loginRequest.deviceId}');
      print('Social ID: ${loginRequest.social_id}');
      print('ID Token length: ${loginRequest.idToken?.length ?? 0}');
      print('Type: ${loginRequest.type}');

      final client = ApiClient(AppRepository.dio);
      LoginResponse loginResponse = await client.userLoginSocial(loginRequest);
      AppPrefrence.putString(AppConstants.LOGIN_REGISTER_TYPE, "social_login");
      AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_ID,
          loginResponse.result!.user_id.toString());
      AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_MOBILE,
          loginResponse.result!.mobile.toString());

      if ((loginResponse.isMobile == 1 || loginResponse.isMobile == null) &&
          loginResponse.result!.mobile_verify != 1 &&
          loginResponse.result!.mobile_verify != -1) {
        AppPrefrence.putString(AppConstants.FROM, "login");
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_ID,
            loginResponse.result!.user_id.toString());
        AppPrefrence.putString(
            AppConstants.AUTHTOKEN, loginResponse.result!.custom_user_token);
      } else if (loginResponse.result!.mobile_verify == 1) {
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_NAME,
            loginResponse.result!.username);
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_EMAIL,
            loginResponse.result!.email);
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_TOKEN,
            loginResponse.result!.custom_user_token);
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_REFER_CODE,
            loginResponse.result!.refercode);
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_TEAM_NAME,
            loginResponse.result!.team);
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_STATE_NAME,
            loginResponse.result!.state);
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_PIC,
            loginResponse.result!.user_profile_image);
        AppPrefrence.putInt(
            AppConstants.SHARED_PREFERENCE_USER_BANK_VERIFY_STATUS,
            loginResponse.result!.bank_verify);
        AppPrefrence.putInt(
            AppConstants.SHARED_PREFERENCE_USER_PAN_VERIFY_STATUS,
            loginResponse.result!.pan_verify);
        AppPrefrence.putInt(
            AppConstants.SHARED_PREFERENCE_USER_MOBILE_VERIFY_STATUS,
            loginResponse.result!.mobile_verify);
        AppPrefrence.putInt(
            AppConstants.SHARED_PREFERENCE_USER_EMAIL_VERIFY_STATUS,
            loginResponse.result!.email_verify);
        AppPrefrence.putString(
            AppConstants.AUTHTOKEN, loginResponse.result!.custom_user_token);
        AppConstants.token = loginResponse.result!.custom_user_token!;
        AppPrefrence.putString(AppConstants.FROM, "login");
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_ID,
            loginResponse.result!.user_id.toString());

        // Check if team name exists - new flow logic
        String? teamName = loginResponse.result!.team;
        if (teamName != null && teamName.isNotEmpty && teamName.trim() != '') {
          // User has team name - go to HomePage
          AppPrefrence.putBoolean(
              AppConstants.SHARED_PREFERENCES_IS_LOGGED_IN, true);
          navigateToHomePage(context);
        } else {
          // User doesn't have team name - go to SetTeamName
          navigateToSetTeamName(context);
        }
      } else {
        // Handle social login case where mobile_verify is -1
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_NAME,
            loginResponse.result!.username);
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_EMAIL,
            loginResponse.result!.email);
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_TOKEN,
            loginResponse.result!.custom_user_token);
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_REFER_CODE,
            loginResponse.result!.refercode);
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_TEAM_NAME,
            loginResponse.result!.team);
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_STATE_NAME,
            loginResponse.result!.state);
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_PIC,
            loginResponse.result!.user_profile_image);
        AppPrefrence.putInt(
            AppConstants.SHARED_PREFERENCE_USER_BANK_VERIFY_STATUS,
            loginResponse.result!.bank_verify);
        AppPrefrence.putInt(
            AppConstants.SHARED_PREFERENCE_USER_PAN_VERIFY_STATUS,
            loginResponse.result!.pan_verify);
        AppPrefrence.putInt(
            AppConstants.SHARED_PREFERENCE_USER_MOBILE_VERIFY_STATUS,
            loginResponse.result!.mobile_verify);
        AppPrefrence.putInt(
            AppConstants.SHARED_PREFERENCE_USER_EMAIL_VERIFY_STATUS,
            loginResponse.result!.email_verify);

        AppConstants.token = loginResponse.result!.custom_user_token!;
        AppPrefrence.putString(
            AppConstants.AUTHTOKEN, loginResponse.result!.custom_user_token);
        AppPrefrence.putString(AppConstants.FROM, "login");
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_ID,
            loginResponse.result!.user_id.toString());

        // Check if team name exists - new flow logic
        String? teamName = loginResponse.result!.team;
        if (teamName != null && teamName.isNotEmpty && teamName.trim() != '') {
          // User has team name - go to HomePage
          AppPrefrence.putBoolean(
              AppConstants.SHARED_PREFERENCES_IS_LOGGED_IN, true);
          navigateToHomePage(context);
        } else {
          // User doesn't have team name - go to SetTeamName
          navigateToSetTeamName(context);
        }
      }

      if (mounted) {
        AppLoaderProgress.hideLoader(context);
      }
    } catch (e) {
      if (mounted) {
        AppLoaderProgress.hideLoader(context);
      }
      print('❌ Social login API error: $e');

      // Check if it's a specific server error
      if (e.toString().contains('500')) {
        print('🚨 Server Error 500: Backend API is having issues');
        Fluttertoast.showToast(
            msg: 'Server temporarily unavailable. Please try again later.',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3);
      } else {
        // Show user-friendly error message for other errors
        Fluttertoast.showToast(
            msg: 'Login failed. Please try again or contact support.',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3);
      }
    }
  }

  void emailViewRefresh(String email, int type) {}

  // Country Picker Dialog
  void _showCountryPicker(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCountries =
                AppConstants.countryDialCodes.entries.where((entry) {
              final query = searchController.text.toLowerCase();
              return entry.key.toLowerCase().contains(query) ||
                  entry.value.contains(query);
            }).toList();

            return Container(
              height: 450,
              child: Column(
                children: [
                  /// Title
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Select Country',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  /// 🔍 Search Bar
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: TextField(
                      controller: searchController,
                      onChanged: (_) => setModalState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search country or code',
                        prefixIcon: Icon(
                          Icons.search,
                          color: primaryColor,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: borderColor, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: borderColor, width: 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        isDense: true,
                      ),
                    ),
                  ),

                  /// Country List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: filteredCountries.length,
                      itemBuilder: (context, index) {
                        final entry = filteredCountries[index];
                        final country = entry.key;
                        final code = entry.value;

                        return ListTile(
                          title: Text(
                            country,
                            style: TextStyle(
                              color: country == selectedCountry
                                  ? primaryColor
                                  : Colors.black,
                            ),
                          ),
                          trailing: Text(
                            code,
                            style: TextStyle(
                              color: code == selectedCountryCode
                                  ? primaryColor
                                  : Colors.black,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedCountry = country;
                              selectedCountryCode = code;

                              /// reset mobile field
                              mobileController.clear();

                              /// update max length
                              mobileMaxLength =
                                  AppConstants.countryMobileLength[code] ?? 10;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Timer Functions
  void _updateTimer(Timer timer) {
    setState(() {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
      } else {
        _timer?.cancel();
      }
    });
  }

  void _startTimer() {
    _secondsRemaining = 60; // 3 minutes
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
    setState(() {});
  }

  @override
  void dispose() {
    otpFocusNode.dispose();
    emailEditingController.dispose();
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Send OTP Function
  void sendEmailOTP() async {
    // Validate email
    if (emailController.text.isEmpty || !emailController.text.contains("@")) {
      Fluttertoast.showToast(
          msg: 'Please enter a valid email address',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
      return;
    }

    // Validate mobile number (exactly 10 digits)
    if (mobileController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please enter your mobile number',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
      return;
    }

    if (mobileController.text.length != mobileMaxLength ||
        !RegExp(r'^[0-9]+$').hasMatch(mobileController.text)) {
      Fluttertoast.showToast(
          msg: 'Please enter a valid ${mobileMaxLength}-digit mobile number',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
      return;
    }

    AppLoaderProgress.showLoader(context);
    try {
      Map<String, dynamic> request = {
        'email': emailController.text,
        'mobile': mobileController.text,
        'country': selectedCountry,
        'country_code': selectedCountryCode,
        'number_length': mobileMaxLength,
        'fcmToken': fcmToken,
      };

      final client = ApiClient(AppRepository.dio);
      LoginResponse response = await client.login_registerapi(request);

      AppLoaderProgress.hideLoader(context);

      if (response.status == 1) {
        setState(() {
          isOtpSent = true;
          userId = response.result!.user_id.toString();
          newUser = response.result!.new_user;
        });
        _startTimer();
        Fluttertoast.showToast(
            msg: response.message!,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1);
        otpFocusNode.requestFocus();
      } else {
        Fluttertoast.showToast(
            msg: response.message ?? 'Failed to send OTP',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1);
      }
    } catch (e) {
      AppLoaderProgress.hideLoader(context);
      print('Error sending OTP: $e');
      Fluttertoast.showToast(
          msg: 'Failed to send OTP. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
    }
  }

  // Verify OTP Function
  void verifyEmailOTP() async {
    String otp = otpControllers.map((controller) => controller.text).join();

    if (currentText.length != 6) {
      Fluttertoast.showToast(
          msg: 'Please enter the complete 6-digit OTP',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
      return;
    }

    if (mobileController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please enter your mobile number',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
      return;
    }

    if (!checkedValue) {
      Fluttertoast.showToast(
          msg: 'Please accept the terms and conditions',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
      return;
    }

    AppLoaderProgress.showLoader(context);
    try {
      NewLoginRequest request = NewLoginRequest(
        mobile: mobileController.text,
        country: selectedCountry,
        user_id: userId,
        email: emailController.text,
        new_user: newUser,
        otp: currentText,
        fcmToken: fcmToken,
      );

      final client = ApiClient(AppRepository.dio);
      LoginResponse response = await client.login_registerotp(request);

      AppLoaderProgress.hideLoader(context);

      if (response.status == 1) {
        // Save user data
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_ID,
            response.result!.user_id.toString());
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_NAME,
            response.result!.username ?? '');
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_EMAIL,
            response.result!.email ?? '');
        AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_TOKEN,
            response.result!.custom_user_token ?? '');
        AppPrefrence.putString(
            AppConstants.AUTHTOKEN, response.result!.custom_user_token ?? '');
        AppConstants.token = response.result!.custom_user_token ?? '';
        AppPrefrence.putBoolean(
            AppConstants.SHARED_PREFERENCES_IS_LOGGED_IN, true);

        // Navigate based on team name
        String? teamName = response.result!.team;
        if (teamName != null && teamName.isNotEmpty && teamName.trim() != '') {
          navigateToHomePage(context);
        } else {
          navigateToSetTeamName(context);
        }

        Fluttertoast.showToast(
            msg: response.message!,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1);
      } else {
        Fluttertoast.showToast(
            msg: response.message ?? 'Verification failed',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1);
      }
    } catch (e) {
      AppLoaderProgress.hideLoader(context);
      print('Error verifying OTP: $e');
      Fluttertoast.showToast(
          msg: 'Verification failed. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
    }
  }

  // Resend OTP Function
  void resendOTP() async {
    if (_secondsRemaining > 0) return;

    sendEmailOTP(); // Reuse the send OTP function
  }

  // Format timer display
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
