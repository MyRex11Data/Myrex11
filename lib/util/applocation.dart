import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import '../../localStoage/AppPrefrences.dart';
import '../appUtilities/app_constants.dart';

class LocationUtils {
  static void getCurrentLocation(String check,
      [void Function(VoidCallback fn)? setState]) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    var lat = position.latitude;
    var long = position.longitude;

    // passing this to latitude and longitude strings
    String latitude = "$lat";
    String longitude = "$long";

    await getAddressFromLatLong(position, setState);

    print("AASASASAS" + lat.toString() + '  ' + long.toString());

    AppConstants.SHARED_PREFERENCE_USER_LATITUDE = lat.toString();
    AppConstants.SHARED_PREFERENCE_USER_LONGITUDE = long.toString();
  }

  static Future<void> getAddressFromLatLong(Position position,
      [void Function(VoidCallback fn)? setState]) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];

    String state = place.administrativeArea!.toLowerCase();
    AppConstants.SHARED_PREFERENCE_USER_PLAYING_STATE_HEADER =
        place.administrativeArea!.toLowerCase();
    setState!(() {
      AppConstants.userstate = state;
      // AppPrefrence.putString(
      //   AppConstants.SHARED_PREFERENCE_USER_PLAYING_STATE,
      //   place.administrativeArea!.toLowerCase(),
      // );
    });

    print(
      "AASASASAS" +
          '${place.subLocality}, ${place.locality}, ${place.postalCode},${place.administrativeArea}, ${place.country}',
    );
  }

  static Future<Position> determinePosition(String check, BuildContext context,
      [void Function(VoidCallback fn)? setState]) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled) {
      // Location services are enabled, proceed to check permissions
      permission = await Geolocator.checkPermission();

      // If permission is denied or denied forever, request permission
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState?.call(() {
          AppConstants.serviceEnabled = false;
        });
        permission = await Geolocator.requestPermission();

        // Re-check the permission status after requesting
        permission = await Geolocator.checkPermission();

        // Only show settings dialog if permission is still denied forever
        if (permission == LocationPermission.deniedForever) {
          if (AppConstants.Is_PlayStoreBuild == 1) {
            setState?.call(() {
              AppConstants.serviceEnabled = false;
            });
            _showLocationServicesDialog(context);
          }

          return Future.error('Location permissions are permanently denied.');
        } else if (permission == LocationPermission.denied &&
            check != 'login') {
          if (AppConstants.Is_PlayStoreBuild == 1) {
            _showLocationServicesDialog(context);
          }

          // If permission is denied but not permanently, return an error
          return Future.error('Location permissions are denied.');
        }
      }
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        setState?.call(() async {
          AppConstants.serviceEnabled =
              await Geolocator.isLocationServiceEnabled();
        });
      } else {
        setState?.call(() {
          AppConstants.serviceEnabled = false;
        });
      }

      // If permissions are granted (while in use or always)
    } else {
      permission = await Geolocator.checkPermission();
      print(permission.name);

      if (permission == LocationPermission.always) {
        AppConstants.serviceEnabled =
            await Geolocator.isLocationServiceEnabled();
      } else if (permission == LocationPermission.whileInUse) {
        AppConstants.serviceEnabled =
            await Geolocator.isLocationServiceEnabled();
      } else if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();

        // Re-check the permission status after requesting
        permission = await Geolocator.checkPermission();

        // Only show settings dialog if permission is still denied forever
        if (permission == LocationPermission.deniedForever) {
          setState?.call(() {
            AppConstants.serviceEnabled = false;
          });
          _showLocationServicesDialog(context);
          return Future.error('Location permissions are permanently denied.');
        } else if (permission == LocationPermission.denied &&
            check != 'login') {
          _showLocationServicesDialog(context);
          // If permission is denied but not permanently, return an error
          return Future.error('Location permissions are denied.');
        }
      } else if (permission == LocationPermission.unableToDetermine) {
        _showLocationServicesDialog(context);
      } else {
        _showLocationServicesDialog(context);
        setState?.call(() {
          AppConstants.serviceEnabled = false;
        });
      }
      AppConstants.serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // Location services are disabled, show a dialog to prompt the user

      // Show dialog to prompt the user to enable location services

      return Future.error('Location services are disabled.');
    }

    // Get current position if services are enabled and permissions are granted
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

// Dialog to prompt enabling location services
  // static void _showLocationServicesDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text("Enable Location Services"),
  //       content: Text(
  //         "Location services are disabled. To use this feature, please enable location services in your device settings.",
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: Text("Cancel"),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             Navigator.of(context).pop();
  //             await openAppSettings();
  //           },
  //           child: Text("Open Settings"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

// Dialog for location permission settings
  static void _showLocationServicesDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Color(0xffd9d9d9)),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Enable Location Services",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 50,
                height: 50,
                child: Image.asset(AppImages.address),
              ),
              SizedBox(height: 16),
              Text(
                "Location services are disabled. To use this feature, please enable location services in your device settings.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await openAppSettings();
                    },
                    child: Text("Open Settings"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static void showMediaPermissionBottomSheet(
      BuildContext context, String imagepath) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color(0xffd9d9d9),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Media Access Needed',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 50,
                height: 50,
                child: Image.asset(imagepath),
              ),
              SizedBox(height: 8),
              // Text(
              //   'We Need Permission to Access Your Media',
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontFamily: "Roboto",
              //     fontWeight: FontWeight.w600,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              // SizedBox(height: 8),
              Text(
                'To upload media, please allow access to your photos, videos, and files.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Roboto",
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await openAppSettings();
                    },
                    child: Text("Open Settings"),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
