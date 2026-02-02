import 'dart:io';



import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_ip_address/get_ip_address.dart';

class HardWereInfo{

  var myIP;



  ipAddress() async {
    if(Platform.isAndroid){
      try {
        /// Initialize Ip Address
        var ipAddress = IpAddress(type: RequestType.json);
        /// Get the IpAddress based on requestType.
        myIP = await ipAddress.getIpAddress();
      } on IpAddressException catch (exception) {
        /// Handle the exception.
        print("=======================1111111"+exception.message);
      }
      return myIP['ip'].toString();
    }
    return "";
  }

  androidId() async {

   if(Platform.isAndroid){
     DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
     AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
     return androidInfo.id;
   }
   return "";
  }




}