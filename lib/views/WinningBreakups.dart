import 'package:cached_network_image/cached_network_image.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/repository/model/score_card_response.dart';

class WinningBreakups extends StatefulWidget {
  List<WinnerScoreCardItem> breakupList;

  WinningBreakups(this.breakupList);

  @override
  _WinningBreakupsState createState() => new _WinningBreakupsState();
}

class _WinningBreakupsState extends State<WinningBreakups> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
      child: new Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(color: borderColor, width: 0.7),
              // image: DecorationImage(
              //     image: AssetImage(AppImages.commanBackground),
              //     fit: BoxFit.cover),
              color: Colors.transparent),
          child: new Column(
            children: [
              // new Divider(
              //   height: 1,
              //   thickness: 1,
              // ),
              new Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: LightprimaryColor,
                ),
                height: 40,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        'RANK',
                        style: TextStyle(
                            //fontFamily: "Roboto",
                            color: Color(0xff717072),
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        'PRIZE',
                        style: TextStyle(
                            //fontFamily: "Roboto",
                            color: Color(0xff717072),
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              new Divider(
                height: 1,
                thickness: 1,
              ),
              new Expanded(
                child: new ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.breakupList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Column(
                        children: [
                          new Container(
                            height: 40,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    widget.breakupList[index].start_position!,
                                    style: TextStyle(
                                        //   fontFamily: "Roboto",
                                        color: textCol,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ),
                                Row(
                                  children: [
                                    new Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Row(
                                        children: [
                                          widget.breakupList[index].is_gadget ==
                                                  1
                                              ? Container()
                                              : Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6),
                                                  child: Container(
                                                    height: 14,
                                                    width: 14,
                                                    child: Image.asset(
                                                        AppImages.goldcoin),
                                                  ),
                                                ),
                                          Text(
                                            widget.breakupList[index]
                                                        .is_gadget ==
                                                    1
                                                ? widget.breakupList[index]
                                                        .gadget_name ??
                                                    ''
                                                :
                                                // '₹' +
                                                double.tryParse(widget
                                                        .breakupList[index]
                                                        .price!
                                                        .toString())!
                                                    .toStringAsFixed(0),
                                            style: TextStyle(
                                                //fontFamily: "Roboto",
                                                color: textCol,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    widget.breakupList[index].is_gadget == 1
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3, vertical: 2),
                                            child: new Container(
                                              height: 35,
                                              width: 35,
                                              child:
                                                  // widget.matchDetails.logo1bytes!=null&&widget.matchDetails.logo1bytes!.length>0?Image.memory(widget.matchDetails.logo1bytes!):Image.asset(AppImages.logoPlaceholderURL)
                                                  CachedNetworkImage(
                                                memCacheWidth: 270,
                                                memCacheHeight: 270,
                                                filterQuality:
                                                    FilterQuality.low,
                                                imageUrl: widget
                                                    .breakupList[index]
                                                    .gadget_image!,
                                                // errorWidget: (context,
                                                //         url,
                                                //         error) =>
                                                //     new Image
                                                //             .asset(
                                                //         AppImages
                                                //             .logoPlaceholderURL),
                                              ),
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              ],
                            ),
                          ),
                          new Divider(
                            height: 1,
                            thickness: 1,
                            color: borderColor,
                          ),
                        ],
                      );
                    }),
              ),
              // new Container(
              //   padding: EdgeInsets.all(5),
              //   child: Text(
              //     "Note : The actual prize money may be different then the prize money mentioned above if there is a tie for any of the winning positions. Check FAQ\'s for further details. As per government regulations, a tax of 30% will be deducted if an individual wins more than Rs. 10,000.",
              //     style: TextStyle(fontFamily: "Roboto",
              //         color: Colors.grey,
              //         fontWeight: FontWeight.w400,
              //         fontSize: 12),
              //   ),
              // ),
            ],
          )),
    );
  }
}
