import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FocusWebView extends StatefulWidget {
  var title, url;
  var isSocket;
  UniqueKey? key;

  FocusWebView(this.title, this.url, {this.key, this.isSocket});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<FocusWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  var _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return /*IndexedStack(
      index: _stackToView,
      children: [
        WebView(
          backgroundColor: Colors.white,
          initialUrl: widget.url,
          javascriptMode: widget.title=='Telegram'?JavascriptMode.disabled:JavascriptMode.unrestricted,
          onPageFinished: _handleLoad,
          onWebViewCreated: (WebViewController webViewController){
            _controller.complete(webViewController);
          },
        ),
        widget.isSocket != null ? SizedBox.shrink():
        Container(child: Center(child: CircularProgressIndicator(),))
      ],
    )*/
        Scaffold(
            // key: widget.key,
            appBar: widget.title == "LiveFinish"
                ? null
                : PreferredSize(
                    preferredSize: Size.fromHeight(55), // Set this height
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 50,
                        bottom: 12,
                        left: 16,
                      ),
                      decoration: BoxDecoration(
                          // image: DecorationImage(
                          //     image: AssetImage(
                          //         "assets/images/Ic_creatTeamBackGround.png"),
                          //     fit: BoxFit.cover)),
                          color: primaryColor),
                      child: Row(
                        children: [
                          AppConstants.backButtonFunction(),
                          Text(widget.title,
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16)),
                        ],
                      ),
                    ),
                  ),

            // PreferredSize(
            //         preferredSize: Size.fromHeight(55), // Set this height
            //         child: Container(
            //           padding: EdgeInsets.only(top: 28),
            //           color: primaryColor,
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               GestureDetector(
            //                 behavior: HitTestBehavior.translucent,
            //                 onTap: () => {Navigator.pop(context)},
            //                 child: Container(
            //                   padding: EdgeInsets.only(
            //                       left: 15, right: 8, top: 15, bottom: 15),
            //                   alignment: Alignment.centerLeft,
            //                   child: Container(
            //                     width: 16,
            //                     height: 16,
            //                     child: Image(
            //                       image: AssetImage(AppImages.backImageURL),
            //                       fit: BoxFit.fill,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               Container(
            //                 child: Text(widget.title,
            //                     style: TextStyle(
            //                         fontFamily: "Roboto",
            //                         color: Colors.white,
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 16)),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            body: IndexedStack(
              index: _stackToView,
              children: [
                Container(
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage(AppImages.),
                  //         fit: BoxFit.cover),
                  //     color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WebView(
                      backgroundColor: Colors.transparent,
                      initialUrl: widget.url,
                      javascriptMode: widget.title == 'Telegram'
                          ? JavascriptMode.disabled
                          : JavascriptMode.unrestricted,
                      onPageFinished: _handleLoad,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.complete(webViewController);
                      },
                    ),
                  ),
                ),
                widget.isSocket != null
                    ? SizedBox.shrink()
                    : Container(
                        child: Center(
                        child: CircularProgressIndicator(),
                      )),
              ],
            ));
  }
}
