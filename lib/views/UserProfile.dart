import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:myrex11/repository/retrofit/apis.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/base_response.dart';
import 'package:myrex11/repository/model/user_details_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:permission_handler/permission_handler.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserDetailValue userDetailValue = new UserDetailValue();
  TextEditingController nameController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController changeController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();

  String val = '';
  var groupValue;
  var _dropDownValue;
  late String userId = '0';
  String userPic = '';
  ImagePicker _imagePicker = new ImagePicker();

  String code = '+91';

  var mobileMaxLength;
  String selectedCountry = '';

  Future<void> showOptionsDialog(BuildContext context) async {
    showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext context, _, __) {
          return AlertDialog(
            title: Text(
              "Select Profile Picture",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text(
                      "Take Photo",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(context, ImageSource.camera);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text(
                      "Choose from Gallery",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(context, ImageSource.gallery);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  userPic.isNotEmpty
                      ? GestureDetector(
                          child: Text(
                            "Remove Photo",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            removeProfilePhoto();
                          },
                        )
                      : Container(),
                  userPic.isNotEmpty
                      ? Padding(padding: EdgeInsets.all(10))
                      : Container(),
                  GestureDetector(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _getImage(BuildContext context, ImageSource source) {
    _imagePicker
        .pickImage(source: source, imageQuality: 20)
        .then((value) => {sendFile(File(value!.path))});
  }

  void removeProfilePhoto() async {
    AppLoaderProgress.showLoader(context);
    GeneralRequest loginRequest = new GeneralRequest(user_id: userId);
    final client = ApiClient(AppRepository.dio);
    GeneralResponse response = await client.removeProfilePhoto(loginRequest);
    if (response.status == 1) {
      userPic = '';
      AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_PIC, '');
      setState(() {
        AppLoaderProgress.hideLoader(context);
      });
      MethodUtils.showSuccess(context, 'Profile Photo Removed Successfully.');
    }
  }

  void sendFile(File file) async {
    AppLoaderProgress.showLoader(context);
    FormData formData = new FormData.fromMap({
      "user_id": userId,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      )
    });
    Dio dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    dio.options.headers['Authorization'] = AppConstants.token;
    var response = await dio.post(
      AppRepository.dio.options.baseUrl + Apis.uploadProfileImage,
      data: formData,
    );
    AppLoaderProgress.hideLoader(context);
    var jsonObject = json.decode(response.toString());
    if (jsonObject['status'] == 1) {
      userPic = jsonObject['result'][0]['image'];
      print(userPic);
      AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_PIC, userPic);
      MethodUtils.showSuccess(context, 'Profile Photo Uploaded Successfully.');
    } else {
      MethodUtils.showError(context, 'Error in image uploading.');
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_PIC)
        .then((value) => {
              setState(() {
                userPic = value;
              })
            });
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                getFullUserDetails();
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            /* set Status bar color in Andrid devices. */
            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/
            statusBarBrightness:
                Brightness.light) /* set Status bar icon color in iOS. */
        );
    return SafeArea(
      top: false,
      child: new Scaffold(
        backgroundColor: Colors.white,
        /* appBar: PreferredSize(
          preferredSize: Size.fromHeight(50), // Set this height
          child: Container(
            padding: EdgeInsets.only(top: 28),
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => {Navigator.pop(context)},
                  child: new Container(
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: new Container(
                      width: 16,
                      height: 16,
                      child: Image(
                        image: AssetImage(AppImages.backImageURL),
                        fit: BoxFit.fill,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                new Container(
                  child: new Text('Update Profile',
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14)),
                ),
              ],
            ),
          ),
        ),*/

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60), // Set this height
          child: Container(
            padding: EdgeInsets.only(
              top: 45,
              bottom: 10,
              left: 16,
            ),
            decoration: BoxDecoration(color: primaryColor
                // image: DecorationImage(
                //     image: AssetImage("assets/images/Ic_creatTeamBackGround.png"),
                //     fit: BoxFit.cover)
                ),
            child: Row(
              children: [
                AppConstants.backButtonFunction(),
                Text("Edit Profile",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              // image: DecorationImage(
              //     image: AssetImage(AppImages.commanBackground),
              //     fit: BoxFit.cover),
              color: Colors.white),
          child: new SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (Platform.isAndroid) {
                      // Android-specific code
                      if (await Permission.camera.request().isGranted) {
                        if (await Permission.mediaLibrary.request().isGranted) {
                          showOptionsDialog(context);
                        }
                      }
                    } else if (Platform.isIOS) {
                      // iOS-specific code
                      if (await Permission.camera.request().isGranted) {
                        // if(await Permission.mediaLibrary.request().isGranted){
                        showOptionsDialog(context);
                        // }
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 22, top: 22),
                    color: Colors.white,
                    child: Center(
                      child: new GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            // decoration: BoxDecoration(
                            //     color: primaryColor, shape: BoxShape.circle),
                            child: Stack(
                              children: [
                                new Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(40)),
                                      border: Border.all(color: primaryColor)),
                                  height: 70,
                                  width: 70,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)),
                                    child: CachedNetworkImage(
                                        imageUrl: userPic,
                                        placeholder: (context, url) =>
                                            new Image.asset(
                                              AppImages.profileimgae,
                                            ),
                                        errorWidget: (context, url, error) =>
                                            new Image.asset(
                                              AppImages.profileimgae,
                                            ),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    bottom: 8,
                                    child: Image.asset(
                                      AppImages.EditProfile,
                                      scale: 3.7,
                                    )),
                              ],
                            ),
                          ),
                          onTap: () async {
                            if (Platform.isAndroid) {
                              // Android-specific code
                              if (await Permission.camera.request().isGranted) {
                                if (await Permission.mediaLibrary
                                    .request()
                                    .isGranted) {
                                  showOptionsDialog(context);
                                }
                              }
                            } else if (Platform.isIOS) {
                              // iOS-specific code
                              if (await Permission.camera.request().isGranted) {
                                // if(await Permission.mediaLibrary.request().isGranted){
                                showOptionsDialog(context);
                                // }
                              }
                            }
                          }),
                    ),
                  ),
                ),

                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(text: 'Name '),
                      TextSpan(
                        text: '(Same as National ID)',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),

                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    counterText: "",
                    // filled: true,
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Name',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    fillColor: Color(0Xff0af30000),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Color(0xFFEDE2FE), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Color(0xFFEDE2FE), width: 1),
                    ),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(top: 17),
                  child: Text(
                    'Team Name',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextField(
                    enabled: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                    ],
                    readOnly: userDetailValue.teamfreeze == 1,
                    controller: teamNameController,
                    decoration: InputDecoration(
                      counterText: "",
                      // filled: true,
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: 'Team Name',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      fillColor: Color(0Xff0af30000),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFEDE2FE), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(color: Color(0xFFEDE2FE), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(color: Color(0xFFEDE2FE), width: 1),
                      ),
                    ),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(top: 17),
                  child: Text(
                    'Country',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(0),
                  child: new DropdownButtonFormField(
                    isDense: true,
                    hint: _dropDownValue == null
                        ? Text('Select Country',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                            ))
                        : Text(
                            _dropDownValue,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                    isExpanded: true,
                    iconSize: 0.0,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    items: AppConstants.countryDialCodes.keys.map((country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: userDetailValue.statefreeze != 1
                        ? (val) {
                            setState(() {
                              selectedCountry = val as String; // cast to String

                              _dropDownValue = selectedCountry;

                              code = AppConstants
                                      .countryDialCodes[selectedCountry] ??
                                  "";

                              // 2. Set max length for mobile field
                              mobileMaxLength =
                                  AppConstants.countryMobileLength[code] ?? 10;
                              String trimmedText = userDetailValue.mobile ?? '';
                              if (trimmedText.length > mobileMaxLength) {
                                trimmedText =
                                    trimmedText.substring(0, mobileMaxLength);
                              }
                              mobileController.text = trimmedText;
                            });
                          }
                        : null,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: borderColor,
                        size: 30,
                      ),
                      counterText: "",
                      // filled: true,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      fillColor: const Color(0Xff0af30000),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFEDE2FE), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFEDE2FE), width: 1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1, color: Colors.orange),
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1, color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1, color: Colors.red)),
                    ),
                  ),
                ),

                new Container(
                  padding: EdgeInsets.only(top: 17),
                  child: Text(
                    'Mobile',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextField(
                    readOnly: userDetailValue.mobilefreeze == 1,
                    controller: mobileController,
                    maxLength: mobileMaxLength,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'Mobile',
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),

                      // ✅ FIXED PREFIX
                      prefixIcon: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            code,
                            style: const TextStyle(
                              fontSize: 15.2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFEDE2FE), width: 1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFEDE2FE), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFEDE2FE), width: 1),
                      ),
                    ),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(top: 17),
                  child: Text(
                    'Email',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 10),
                  // height: 50,
                  child: TextField(
                    enabled: false,
                    readOnly: userDetailValue.emailfreeze == 1,
                    controller: emailController,
                    decoration: InputDecoration(
                      counterText: "",
                      // filled: true,
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: 'Email',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      fillColor: Color(0Xff0af30000),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFEDE2FE), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(color: Color(0xFFEDE2FE), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(color: Color(0xFFEDE2FE), width: 1),
                      ),
                    ),
                  ),
                ),

                // new Container(
                //   padding: EdgeInsets.only(top: 17),
                //   child: Text(
                //     'Change Password',
                //     textAlign: TextAlign.start,
                //     style: TextStyle(
                //       fontSize: 13,
                //       color: Colors.black,
                //       fontStyle: FontStyle.normal,
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ),
                // ),
                // new Container(
                //   margin: EdgeInsets.only(top: 10),
                //   child: new Stack(
                //     alignment: Alignment.centerRight,
                //     children: [
                //       new Container(
                //         height: 50,
                //         child: TextField(
                //           readOnly: true,
                //           controller: changeController,
                //           decoration: InputDecoration(
                //             counterText: "",
                //             fillColor: Colors.white,
                //             filled: true,
                //             hintStyle: TextStyle(
                //               fontSize: 12,
                //               color: Colors.grey,
                //               fontStyle: FontStyle.normal,
                //               fontWeight: FontWeight.bold,
                //             ),
                //             hintText: 'Password',
                //             enabledBorder: const OutlineInputBorder(
                //               // width: 0.0 produces a thin "hairline" border
                //               borderSide: const BorderSide(
                //                   color: Colors.grey, width: 0.0),
                //             ),
                //             focusedBorder: OutlineInputBorder(
                //               borderSide: const BorderSide(
                //                   color: Colors.grey, width: 0.0),
                //             ),
                //           ),
                //         ),
                //       ),
                //       new GestureDetector(
                //         behavior: HitTestBehavior.translucent,
                //         child: new Container(
                //           padding: EdgeInsets.only(right: 10),
                //           child: Text(
                //             'Change Password',
                //             textAlign: TextAlign.start,
                //             style: TextStyle(
                //               fontSize: 12,
                //               color: Colors.grey,
                //               fontStyle: FontStyle.normal,
                //               fontWeight: FontWeight.w400,
                //               decoration: TextDecoration.underline,
                //             ),
                //           ),
                //         ),
                //         onTap: () {
                //           navigateToChangePassword(context, '');
                //         },
                //       ),
                //     ],
                //   ),
                // ),

                new Container(
                  padding: EdgeInsets.only(top: 17),
                  child: Text(
                    'Gender',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Radio(
                      visualDensity: const VisualDensity(horizontal: -4.0),
                      value: 'male',
                      groupValue: val,
                      activeColor: primaryColor,
                      onChanged: (value) {
                        setState(() {
                          val = 'male';
                        });
                      },
                    ),
                    Text(
                      'Male',
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    Radio(
                      value: 'female',
                      activeColor: primaryColor,
                      groupValue: val,
                      onChanged: (value) {
                        setState(() {
                          val = 'female';
                        });
                      },
                    ),
                    Text(
                      'Female',
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                new Container(
                  padding: EdgeInsets.only(top: 17),
                  child: Text(
                    'Date of Birth',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                new GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: new IgnorePointer(
                    child: new Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 50,
                      child: TextField(
                        readOnly: false,
                        controller: dobController,
                        decoration: InputDecoration(
                          counterText: "",
                          // filled: true,
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Date of Birth',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          fillColor: const Color(0Xff0af30000),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Color(0xFFEDE2FE), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Color(0xFFEDE2FE), width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    // Parse the date string into a DateTime object
                    // DateFormat format = DateFormat("MM/dd/yyyy");
                    // DateTime date = format.parse(dobController.text);
                    // Format the date as per your requirements (optional)

                    if (userDetailValue.dobfreeze != 1) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      await showDatePicker(
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: primaryColor,
                                      // <-- SEE HERE
                                      onPrimary: Colors.white,
                                      // <-- SEE HERE
                                      onSurface: primaryColor
                                          .withOpacity(0.5), // <-- SEE HERE
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            primaryColor, // button text color
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                              context: context,
                              initialDate: DateTime(DateTime.now().year - 18,
                                  DateTime.now().month, DateTime.now().day),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(DateTime.now().year - 18,
                                  DateTime.now().month, DateTime.now().day))
                          .then((value) => {
                                dobController.text =
                                    DateFormat("yyyy/MM/dd").format(value!)
                              });
                    }
                  },
                ),
                new Container(
                  padding: EdgeInsets.only(top: 17),
                  child: Text(
                    'City',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 50,
                  child: TextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[A-Z,a-z]")),
                    ],
                    // maxLength: 30,
                    controller: cityController,
                    decoration: InputDecoration(
                      counterText: "",
                      // filled: true,
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: 'City',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      fillColor: const Color(0Xff0af30000),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFEDE2FE), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFEDE2FE), width: 1),
                      ),
                    ),
                  ),
                ),

                new Container(
                  padding: EdgeInsets.only(top: 17),
                  child: Text(
                    'Pin Code',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 50,
                  child: TextField(
                    maxLength: 10,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    keyboardType: TextInputType.number,
                    controller: pincodeController,
                    decoration: InputDecoration(
                      counterText: "",
                      // filled: true,
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: 'Pin Code',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      fillColor: const Color(0Xff0af30000),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFEDE2FE), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFEDE2FE), width: 1),
                      ),
                    ),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(top: 17),
                  child: Text(
                    'PAN/National ID',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 50,
                  child: TextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[A-Z,a-z]")),
                    ],
                    //  maxLength: 30,
                    controller: nationalIdController,
                    decoration: InputDecoration(
                      counterText: "",
                      // filled: true,
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: 'Enter Your ID',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      fillColor: const Color(0Xff0af30000),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFEDE2FE), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFEDE2FE), width: 1),
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    updateUserProfile();
                  },
                  child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppImages.Btngradient),
                            fit: BoxFit.fill),
                        border: Border.all(
                          color: Color(0xFF6A0BF8),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: EdgeInsets.only(top: 18),
                      child: Center(
                          child: Text(
                        "Update".toUpperCase(),
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ))
                      // textcolor: Colors.white,
                      // color: primaryColor,
                      // borderRadius: 5,
                      // onpress: () {

                      // },
                      ),
                ),
                SizedBox(
                  height: 15,
                )
                // new Container(
                //     width: MediaQuery.of(context).size.width,
                //     height: 50,
                //     margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                //     child: RaisedButton(
                //       textColor: Colors.white,
                //       color: primaryColor,
                //       child: Text(
                //         '',
                //         style: TextStyle(fontSize: 14),
                //       ),
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(5)),
                //       onPressed: () {
                //         updateUserProfile();
                //       },
                //     )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getFullUserDetails() async {
    AppLoaderProgress.showLoader(context);
    GeneralRequest loginRequest = new GeneralRequest(user_id: userId);
    final client = ApiClient(AppRepository.dio);
    GetUserFullDetailsResponse userFullDetailsResponse =
        await client.getFullUserDetails(loginRequest);
    AppLoaderProgress.hideLoader(context);
    if (userFullDetailsResponse.status == 1) {
      userDetailValue = userFullDetailsResponse.result!.value!;
      nameController.text = userDetailValue.username ?? '';
      emailController.text = userDetailValue.email ?? '';
      mobileController.text = userDetailValue.mobile ?? '';
      teamNameController.text = userDetailValue.team ?? '';
      dobController.text = userDetailValue.dob ?? '';
      cityController.text = userDetailValue.city!;
      pincodeController.text = userDetailValue.pincode ?? '';
      nationalIdController.text = userDetailValue.nationalId ?? "";
      selectedCountry = userDetailValue.country ?? 'India';
      _dropDownValue = userDetailValue.country;
      val = userDetailValue.gender!;
      for (int i = 0; i < AppConstants.countryDialCodes.length; i++) {
        if (AppConstants.countryDialCodes.containsKey(selectedCountry)) {
          code = AppConstants.countryDialCodes[selectedCountry] ?? '';
          mobileMaxLength = AppConstants.countryMobileLength[code] ?? 11;
        }
      }
    }
    setState(() {});
  }

  void updateUserProfile() async {
    // if (val == '') {
    //   MethodUtils.showError(context, "Please select your gender.");
    //   return;
    // }
    // else
    //  if (nameController.text.isEmpty) {
    //   MethodUtils.showError(context, "Please enter your name.");
    //   return;
    // } else if (nameController.text.length < 3 ||
    //     nameController.text.length >= 30) {
    //   MethodUtils.showError(context, 'Name should be 3 characters.');
    //   return;
    // }
    // else if (dobController.text.isEmpty) {
    //   MethodUtils.showError(context, "Please select your date of birth.");
    //   return;
    // }
    /*else if (teamNameController.text.length < 3 ||
        teamNameController.text.length > 9) {
      MethodUtils.showError(context, "Team name should be 3 to 9 characters.");
      return;
    }*/
    // else if (pincodeController.text.length < 6) {
    //   MethodUtils.showError(context, "Pin code should be 6 digits long.");
    //   return;
    // }
    // else if (!emailController.text.contains("@") ||
    //     !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //         .hasMatch(emailController.text)) {
    //   MethodUtils.showError(context, "Please enter valid email address.");
    //   return;
    // } else
    //if (mobileController.text.length < 10) {
    //   MethodUtils.showError(context, "Please enter valid mobile number.");
    //   return;
    // }
    // else if (_dropDownValue == null || _dropDownValue == 'Select Country') {
    //   MethodUtils.showError(context, "Please select your Country.");
    //   return;
    // }
    //  else if (nationalIdController.text.isEmpty) {
    //   MethodUtils.showError(context, "Please enter your valid ID.");
    //   return;
    // }

    FocusScope.of(context).unfocus();
    AppLoaderProgress.showLoader(context);
    UserDetailValue loginRequest = new UserDetailValue(
        user_id: userId,
        username: nameController.text.toString(),
        dob: dobController.text.toString(),
        gender: val,
        city: cityController.text.toString(),
        country: _dropDownValue,
        pincode: pincodeController.text.toString(),
        team: teamNameController.text.toString(),
        email: emailController.text.toString(),
        mobile: mobileController.text,
        nationalId: nationalIdController.text);
    final client = ApiClient(AppRepository.dio);
    GeneralResponse userFullDetailsResponse =
        await client.updateUserProfile(loginRequest);
    AppLoaderProgress.hideLoader(context);
    if (userFullDetailsResponse.status == 1) {
      MethodUtils.showSuccess(context, "Profile Updated Successfully.");
      AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_NAME,
          nameController.text.toString());
      return;
    }
    MethodUtils.showError(context, userFullDetailsResponse.message);
  }
}
