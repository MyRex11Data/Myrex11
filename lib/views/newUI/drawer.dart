import 'dart:io';
import 'package:myrex11/views/newUI/registerNew.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import '../../appUtilities/app_navigator.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:myrex11/repository/retrofit/apis.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/base_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String userName = 'John Doe';
  String userTeamName = 'John5842';
  String userProfileImage = '';

  String val = '';
  var groupValue;
  String show_refer_earn = '';
  String show_refer_list = '';
  int isVisibleAffiliate = 0;

  var _dropDownValue;
  late String userId = '0';
  String userPic = '';
  ImagePicker _imagePicker = new ImagePicker();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    userName =
        await AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_NAME);
    userTeamName = await AppPrefrence.getString(
        AppConstants.SHARED_PREFERENCE_USER_TEAM_NAME);
    userPic =
        await AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_PIC);

    AppPrefrence.getString(AppConstants.SHOW_REFER_EARN).then((value) => {
          setState(() {
            show_refer_earn = value;
          })
        });

    AppPrefrence.getString(AppConstants.SHOW_REFER_LIST).then((value) => {
          setState(() {
            show_refer_list = value;
          })
        });

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
              })
            });

    AppPrefrence.getInt(AppConstants.IS_VISIBLE_AFFILIATE, 0).then((value) => {
          setState(() {
            isVisibleAffiliate = value;
          })
        });

    if (userName.isEmpty) userName = 'User';
    if (userTeamName.isEmpty) userTeamName = 'Team';

    if (mounted) {
      setState(() {});
    }
  }

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
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          return Text(
                            DateFormat('hh:mm a').format(DateTime.now()),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          );
                        },
                      )
                    ],
                  ),
                  // SizedBox(height: 20),
                  // Profile Image with Edit Icon
                  Row(
                    children: [
                      GestureDetector(
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(40)),
                                            border: Border.all(
                                                color: primaryColor)),
                                        height: 70,
                                        width: 70,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40)),
                                          child: CachedNetworkImage(
                                              imageUrl: userPic,
                                              placeholder: (context, url) =>
                                                  new Image.asset(
                                                    AppImages.profileimgae,
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
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
                                    if (await Permission.camera
                                        .request()
                                        .isGranted) {
                                      if (await Permission.mediaLibrary
                                          .request()
                                          .isGranted) {
                                        showOptionsDialog(context);
                                      }
                                    }
                                  } else if (Platform.isIOS) {
                                    // iOS-specific code
                                    if (await Permission.camera
                                        .request()
                                        .isGranted) {
                                      // if(await Permission.mediaLibrary.request().isGranted){
                                      showOptionsDialog(context);
                                      // }
                                    }
                                  }
                                }),
                          ),
                        ),
                      ),
                      SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              userName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          SizedBox(height: 4),
                          // Team Name
                          Text(
                            userTeamName,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // SizedBox(height: 10),

                  // Divider(
                  //   height: 1,
                  //   color: borderColor,
                  // ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Menu Items
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDrawerItem(
                      icon: AppImages.profile,
                      title: 'Profile',
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to Profile
                        navigateToUserProfile(context);
                      },
                    ),

                    if (show_refer_earn == '1')
                      _buildDrawerItem(
                        icon: AppImages.invite_friends,
                        title: 'Invite Friends',
                        onTap: () {
                          navigateToReferAndEarn(context);

                          ///Navigator.pop(context);
                          // Navigate to Invite Friends
                        },
                      ),

                    if (show_refer_list == '1')
                      _buildDrawerItem(
                        icon: AppImages.refer_list,
                        title: 'Refer List',
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to Refer List
                          navigateToReferList(context);
                        },
                      ),

                    if (isVisibleAffiliate == 1)
                      _buildDrawerItem(
                        icon: AppImages.affiliate_dashboard,
                        title: 'Affiliate dashboard',
                        onTap: () {
                          Navigator.pop(context);
                          navigateToAffiliateProgram(context);
                        },
                      ),

                    Spacer(),

                    // Logout Button
                    Container(
                      width: 180,
                      height: 52,
                      margin: EdgeInsets.only(bottom: 30),
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Navigator.pop(context);
                            _showLogoutDialog(context);
                          },
                          borderRadius: BorderRadius.circular(26),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.logout_icon,
                                  width: 20,
                                  height: 20,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'LOG OUT',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ],
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
    );
  }

  Widget _buildDrawerItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        // color: Color(0xFFF8F5FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFEDE2FE),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Container(
                  // width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    // color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Image.asset(
                    icon,
                    width: 40,
                    height: 40,
                    // color: primaryColor,
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFEDE2FE),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _performLogout();
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() async {
    // Clear all shared preferences
    AppPrefrence.clearPrefrence();
    // Navigate to Login screen
    // if (!mounted) return;
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => RegisterNew()),
    //   (route) => false,
    // );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => RegisterNew()),
      ModalRoute.withName("/main"),
    );
  }
}
