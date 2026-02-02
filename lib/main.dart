import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/splashResponse.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myrex11/views/Home.dart';
import 'package:myrex11/views/newUI/registerNew.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appUtilities/app_colors.dart';
import 'appUtilities/app_constants.dart';
import 'appUtilities/app_images.dart';
import 'appUtilities/app_navigator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'customWidgets/AnimationDotsIndicator.dart';
import 'localStoage/AppPrefrences.dart';
import 'package:app_links/app_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ******** THE FIX: Register the background message handler right after Firebase init ********
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // WidgetsBinding.instance.renderView.automaticSystemUiAdjustment = false;
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    String AndroidVersion = androidInfo.version.release;
    print(AndroidVersion);
    if (AndroidVersion != '8') {
      await AndroidAlarmManager.initialize();
    }
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Enables edge-to-edge
    statusBarIconBrightness: Brightness.light, // Icons on dark background
    systemNavigationBarColor: Colors.black, // Optional
    systemNavigationBarIconBrightness: Brightness.light, // Optional
  ));

  registerNotification();

  _initPackageInfo();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedIn =
      (prefs.getBool(AppConstants.SHARED_PREFERENCES_IS_LOGGED_IN) == null)
          ? false
          : prefs.getBool(AppConstants.SHARED_PREFERENCES_IS_LOGGED_IN);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    color: Colors.black,
    navigatorKey: NavigationService.navigatorKey,
    highContrastDarkTheme: ThemeData(brightness: Brightness.light),
    highContrastTheme: ThemeData(brightness: Brightness.light),
    theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
        fontFamily: "roboto"),
    builder: (context, child) => ResponsiveWrapper.builder(
      child,
      maxWidth: 1200,
      minWidth: 480,
      defaultScale: true,
      defaultScaleFactor: 1.25,
      breakpoints: [
        ResponsiveBreakpoint.resize(480, name: MOBILE),
        ResponsiveBreakpoint.autoScale(800, name: TABLET),
        ResponsiveBreakpoint.resize(1000, name: DESKTOP),
      ],
    ),
    themeMode: ThemeMode.light,
    darkTheme: ThemeData.light(),
    home: SplashScreen(),
    //  !isLoggedIn! ? MyApp() : HomePage(),
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  // print("Handling a background message: ${message.messageId}");
  // //firebase push notification
  // showNotification(message);
}

Future<void> requestNotificationPermissions() async {
  print('🔔 Checking notification permissions...');

  // Check if already granted to avoid conflicts
  final PermissionStatus currentStatus = await Permission.notification.status;
  if (currentStatus.isGranted) {
    print('✅ Notification permission already granted');
    return;
  }

  print('📱 Requesting notification permission...');
  final PermissionStatus status = await Permission.notification.request();
  if (status.isGranted) {
    print('✅ Notification permission granted');
  } else if (status.isDenied) {
    print('❌ Notification permission denied');
  } else if (status.isPermanentlyDenied) {
    print('❌ Notification permission permanently denied');
    // Don't open app settings automatically, just log it
  }
}

Future<void> _initPackageInfo() async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  AppConstants.versionCode = info.buildNumber;
}

void registerNotification() async {
  await FirebaseMessaging.instance.subscribeToTopic("global");
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        enableVibration: true,
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        // defaultColor: Color(0xFF9D50DD),
        channelShowBadge: true,
        importance: NotificationImportance.High,
        playSound: true,
        ledColor: Colors.white)
  ]);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // 2. Instantiate Firebase Messaging
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  print(["fcm=>:", await _messaging.getToken()]);

  final prefs = await SharedPreferences.getInstance();
  // write
  prefs.setString('fcmToken', await _messaging.getToken() as String);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Don't request permission here as it will be handled in splash screen
  // Just check existing permission status
  NotificationSettings settings = await _messaging.getNotificationSettings();
  print('🔔 Firebase notification settings: ${settings.authorizationStatus}');

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('MyNotification');
      showNotification(message, AppConstants.notificationContext);
    });
  } else {
    print('Firebase notifications not authorized yet');
  }
}

void showNotification(RemoteMessage message, BuildContext context) {
  String titleTxt = '';
  String messageTxt = '';
  String image = '';

  if (message.notification != null) {
    titleTxt = message.notification!.title ?? '';
    messageTxt = message.notification!.body ?? '';
    image = message.notification!.android!.imageUrl ?? '';
    //print("sms_check ${jsonEncode(message.data)}");
  } else {
    if (message.data.isNotEmpty) {
      titleTxt = message.data['title'] ?? '';
      messageTxt = message.data['message'] ?? '';
      image = message.data['image'] ?? '';
    }
  }

  if (titleTxt.isNotEmpty && messageTxt.isNotEmpty) {
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      // 🔹 App in FOREGROUND → Show Flushbar instead of AwesomeNotification
      Flushbar(
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(12),
        backgroundColor: Colors.white,
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 4),

        // Leading app icon (like Awesome Notification)

        messageText: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Row(
                children: [
                  Container(
                    height: 18,
                    // width: 25,
                    child: Image.asset(
                      AppImages.appIcon,
                      // fills the box & respects radius
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'MyRex11',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Container(
                    child: Icon(
                      Icons.notifications_active,
                      color: Colors.black,
                      size: 16,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                titleTxt,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              messageTxt,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            if (image.isNotEmpty) ...[
              const SizedBox(height: 8),
              Image.network(
                image ?? "",
                // height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
          ],
        ),
      ).show(context);
    } else {
      // 🔹 App in BACKGROUND/TERMINATED → Show AwesomeNotification
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: new Random().nextInt(101), // unique ID
          channelKey: 'basic_channel',
          title: titleTxt,
          body: messageTxt.isNotEmpty ? messageTxt : "Hi there!",
          bigPicture: image,

          notificationLayout: image != null
              ? NotificationLayout.BigPicture
              : NotificationLayout.Default,
          fullScreenIntent: true,
        ),
      );
    }
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String splashUrl = '';
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  String userId = "";
  var isLoggedIn;
  // MyBalances? myBalances;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   AppConstants.loderContext = context;
    // });

    if (AppConstants.error400 == true) {
      print('AppConstants.error400${AppConstants.error400}');
      AppConstants.error400 = false;
      _ElseinitializeSplash();
    } else {
      splashUpdate();
      uiUpdate();
      _initializeSplash();
    }

    super.initState();
  }

  startTimeCount() async {
    // return time != null
    //     ? Timer(Duration(seconds: time!), getInside)
    //     : Timer(Duration(seconds: 4), getInside);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only precache if URL is not null and not empty
    if (splashUrl != null &&
        splashUrl!.isNotEmpty &&
        splashUrl!.startsWith('http')) {
      try {
        precacheImage(NetworkImage(splashUrl!), context);
      } catch (e) {
        print('Error precaching network image: $e');
        precacheImage(AssetImage(AppImages.splashImageURL), context);
      }
    } else {
      precacheImage(AssetImage(AppImages.splashImageURL), context);
    }
  }

  Future<File?> getSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final filePath = prefs.getString('splash_image_path');
    if (filePath != null) {
      return File(filePath);
    }
    return null;
  }

  uiUpdate() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            /* set Status bar color in Android devices. */
            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/
            statusBarBrightness:
                Brightness.light) /* set Status bar icon color in iOS. */
        );
  }

  void splashUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final client = ApiClient(AppRepository.dio);

    NormalRequest request = NormalRequest(
      build_type: Platform.isIOS
          ? 'IOS'
          : AppConstants.Is_PlayStoreBuild == 1
              ? 'PS'
              : 'WEB',
    );
    SplashResponse generalResponse = await client.splashUpdate(request);

    if (generalResponse.status == 1) {
      AppPrefrence.putString(
          AppConstants.SPLASH_UPDATE, generalResponse.result!.image ?? '');
      splashUrl = generalResponse.result!.image ?? '';

      // AppPrefrence.putString(
      //     AppConstants.SHARED_PREFERENCE_GET_REFERCODE_VIA_IP,
      //     generalResponse.result!.get_refer_code_via_ip ?? '');

      if (splashUrl.isNotEmpty) {
        downloadAndSaveImage(splashUrl);
        // Save the splash URL to SharedPreferences
        await prefs.setString(AppConstants.SPLASH_UPDATE, splashUrl);
      } else {
        print("Splash URL is empty or null");
      }

      // setState(() {
      // AppConstants.islocationFieldShow = generalResponse.playstore ?? 0;
      // AppConstants.customVersionCode =
      //     generalResponse.custom_build_version ?? 0;
      // });
      print('generalResponse.playstore');
    }
    print('generalResponse.fail');
  }

  Future<void> _initializeSplash() async {
    print('🚀 Starting splash initialization...');

    // Check login status first
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn =
        prefs.getBool(AppConstants.SHARED_PREFERENCES_IS_LOGGED_IN) ?? false;

    print('📱 Login status: $isLoggedIn');

    // Request permissions during splash with proper timing

    // Navigate to the appropriate screen after permissions are handled
    Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        print('🔄 Navigating...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => isLoggedIn ? HomePage() : RegisterNew(),
          ),
        );
        // if (isLoggedIn) {
        //   print('➡️ Going to HomePage');
        //   navigateToHomePage(context);
        // } else {
        //   print('➡️ Going to RegisterNew');
        //   navigateToRegisterNew(context);
        // }
      } else {
        print('❌ Widget not mounted, skipping navigation');
      }
    });
    await _requestPermissions();
    print('✅ Permissions handled');
  }

  Future<void> _requestPermissions() async {
    try {
      print('🔄 Starting permission requests...');

      // Request notification permission first using our manual method
      try {
        await requestNotificationPermissions();
        print('✅ Manual notification permission completed');

        // After manual permission, now request Firebase permission
        await Future.delayed(Duration(milliseconds: 1000));
        FirebaseMessaging _messaging = FirebaseMessaging.instance;
        NotificationSettings settings = await _messaging.requestPermission(
          alert: true,
          badge: true,
          provisional: false,
          sound: true,
        );
        print(
            '✅ Firebase notification permission completed: ${settings.authorizationStatus}');

        // If Firebase permission is granted, set up the message listener
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            print('MyNotification');
            showNotification(message, AppConstants.notificationContext);
          });
        }
      } catch (e) {
        print('❌ Notification permission error: $e');
      }

      // Longer delay to ensure notification permission dialogs are fully closed
      print('⏰ Waiting before location permission...');
      await Future.delayed(Duration(milliseconds: 3000));

      // Request location permission
      try {
        // await _requestLocationPermission();
        print('✅ Location permission completed');
      } catch (e) {
        print('❌ Location permission error: $e');
      }
    } catch (e) {
      print('❌ Error requesting permissions: $e');
    }
  }

  Future<void> _requestLocationPermission() async {
    try {
      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      // If permission is denied, request it
      if (permission == LocationPermission.denied) {
        print('Requesting location permission...');
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return;
        }

        if (permission == LocationPermission.deniedForever) {
          print('Location permissions are permanently denied');
          return;
        }
      }

      // Check if location services are enabled after permission is granted
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          print(
              'Location services are disabled. Please enable location services.');
          // Optionally, you can prompt user to enable location services
          return;
        }
        print('Location permission granted and services enabled');
      }
    } catch (e) {
      print('Error requesting location permission: $e');
    }
  }

  Future<void> _ElseinitializeSplash() async {
    print('🚀 Starting ELSE splash initialization...');

    // Check login status first
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoggedIn =
        prefs.getBool(AppConstants.SHARED_PREFERENCES_IS_LOGGED_IN) ?? false;

    print('📱 Login status: $isLoggedIn');

    // Request permissions during splash with proper timing

    // Navigate to the appropriate screen after permissions are handled
    if (mounted) {
      print('🔄 Navigating...');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? HomePage() : RegisterNew(),
        ),
      );
    } else {
      print('❌ Widget not mounted, skipping navigation');
    }
    await _requestPermissions();
    print('✅ Permissions handled');
  }

  Future<void> downloadAndSaveImage(String imageUrl) async {
    try {
      // Get application directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/splash_image.png';

      // Download image using dio
      final response = await Dio().download(imageUrl, filePath);

      if (response.statusCode == 200) {
        // Save file path to SharedPreferences for retrieval
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('splash_image_path', filePath);
        print("Image saved successfully at: $filePath");
      }
    } catch (e) {
      print("Error downloading and saving image: $e");
    }
  }

  // Future<void> _loadSplashImage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     splashUrl = prefs.getString(AppConstants.SPLASH_UPDATE) ??
  //         ''; // Fetch previously saved splash URL
  //   });
  // }

  Future<Widget> loadSplashImage() async {
    final imageFile = await getSavedImage();

    if (imageFile != null && await imageFile.exists()) {
      return SizedBox.expand(
        // Ensures the image fills its parent
        child: Image.file(
          imageFile,
          fit: BoxFit.fill, // Stretches the image to fill the parent
        ),
      );
    } else {
      return SizedBox.expand(
        child: Image.asset(
          AppImages.splashImageURL,
          fit: BoxFit.fill, // Add fit for the asset image too
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<Widget>(
          future: loadSplashImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return snapshot.data!;
            } else {
              return SizedBox.expand(
                  child: Image.asset(
                AppImages.splashImageURL,
                fit: BoxFit.fill,
              ));
            }
          },
        )
        // Center(
        //   child: Container(
        //     width: MediaQuery.of(context).size.width,
        //     height: MediaQuery.of(context).size.height,
        //     child: splashUrl.isNotEmpty
        //         ? Image.network(
        //             splashUrl,
        //             fit: BoxFit.fill,
        //           )
        //         : CircularProgressIndicator(),
        //   ),
        // ),
        );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MyApp> {
  bool isTimeOut = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    // Removed determinePosition() since permissions are now handled in splash screen
    //  startTimeCount();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
    super.initState();
  }

  startTimeCount() async {
    var _duration = const Duration(milliseconds: 1000);
    return Timer(_duration, navigateInside);
  }

  void navigateInside() => {
        AppPrefrence.getBoolean(AppConstants.SHARED_PREFERENCES_IS_LOGGED_IN)
            .then((value) => {
                  if (value)
                    {
                      navigateToHomePage(context),
                    }
                  else
                    {
                      setState(() {
                        isTimeOut = true;
                      })
                    }
                }),
      };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            /* set Status bar color in Android devices. */
            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/
            statusBarBrightness:
                Brightness.dark) /* set Status bar icon color in iOS. */
        );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFDF0E0E),
        body: new Stack(
          children: [
            new Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(AppImages.onBoardingImage,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill),
            ),
            new Align(
              alignment: Alignment.center,
              child: new Container(
                child: SingleChildScrollView(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height/3.7,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 35),
                        child: Image.asset(
                          AppImages.onBoardingLogo,
                          scale: 4,
                        ),
                      ),
                      Container(
                        height: 120,
                        child: PageView(
                          controller: _pageController,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      "Welcome to MyRex11",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Expanded(
                                      child: Center(
                                    child: Text(
                                      "Your one-stop destination for fantasy sports",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      "Welcome to MyRex11 Fantasy",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Expanded(
                                      child: Center(
                                    child: Text(
                                      "Your one-stop destination for fantasy sports",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      "Welcome to MyRex11 Fantasy",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Expanded(
                                      child: Center(
                                    child: Text(
                                      "Your one-stop destination for fantasy sports",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      DotsIndicator(
                        controller: _pageController,
                        itemCount: 3,
                        currentPage: _currentPage,
                      ),
                      new Container(
                        margin: EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 20),
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          // onPressed: () => navigateToRegister(context),
                          onPressed: () => navigateToRegisterNew(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(6), // Rounded corners
                            ),
                            padding: EdgeInsets.all(
                                8.0), // Padding inside the button
                          ),
                          child: Text(
                            'REGISTER',
                            style: TextStyle(
                              color: primaryColor, // Text color
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      new GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: new Container(
                          margin: EdgeInsets.only(top: 0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already a user?',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    //  fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal),
                              ),
                              GestureDetector(
                                onTap: () => {navigateToLogin(context)},
                                child: new Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Log In',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        // fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        onTap: () => {navigateToLogin(context)},
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

onTeamCreated() {}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();
}
