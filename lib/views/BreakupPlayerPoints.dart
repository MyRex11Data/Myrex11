import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/repository/model/player_points_response.dart';

class BreakupPlayerPoints extends StatefulWidget {
  MultiSportsPlayerPointItem breakupPoint;
  BreakupPlayerPoints(this.breakupPoint);
  @override
  _BreakupPlayerPointsState createState() => new _BreakupPlayerPointsState();
}

class _BreakupPlayerPointsState extends State<BreakupPlayerPoints> {
  TextEditingController codeController = TextEditingController();
  bool _enable = false;

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            /* set Status bar color in Android devices. */

            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/

            statusBarBrightness:
                Brightness.dark) /* set Status bar icon color in iOS. */
        );
    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(
        // image: AssetImage(AppImages.commanBackground), fit: BoxFit.cover),
        color: Colors.white,
      ),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60), // Set this height
          child: Container(
            padding: EdgeInsets.only(
              top: 50,
              bottom: 15,
              left: 15,
            ),
            decoration: BoxDecoration(color: primaryColor
                // image: DecorationImage(
                //     image:
                //         AssetImage("assets/images/Ic_creatTeamBackGround.png"),
                //     fit: BoxFit.cover)
                ),
            child: Row(
              children: [
                AppConstants.backButtonFunction(),
                Text(
                  "Points Breakup",
                  style: TextStyle(
                      // fontFamily: "Roboto",
                      fontFamily: "Roboto",
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        body: new Stack(
          alignment: Alignment.bottomCenter,
          children: [
            new Container(
              height: MediaQuery.of(context).size.height,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5)),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Container(
                          decoration: BoxDecoration(
                              //shape: BoxShape.circle,
                              // color: Colors.grey,
                              ),
                          alignment: Alignment.bottomCenter,
                          // width: 80,
                          height: 70,
                          // margin: EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: CachedNetworkImage(
                              imageUrl: widget.breakupPoint.image!,
                              placeholder: (context, url) =>
                                  new Image.asset(AppImages.userAvatarIcon2),
                              errorWidget: (context, url, error) =>
                                  new Image.asset(AppImages.userAvatarIcon2),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: new Column(
                            children: [
                              // new Container(
                              //   margin: EdgeInsets.only(bottom: 4),
                              //   child: new Text( widget.breakupPoint.short_name!=null&&widget.breakupPoint.role!=null?widget.breakupPoint.short_name!+'-'+widget.breakupPoint.role!:'',
                              //       style: TextStyle(
                              // fontFamily: "Roboto",
                              //           color: Colors.grey,
                              //           fontWeight: FontWeight.w400,
                              //           fontSize: 11)),
                              // ),
                              new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new Container(
                                    // margin: EdgeInsets.only(right: 40),
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        new Container(
                                          margin: EdgeInsets.only(bottom: 4),
                                          child: new Text('SELECTED BY',
                                              style: TextStyle(
                                                  // fontFamily: "Roboto",
                                                  //fontFamily: "Roboto",
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12)),
                                        ),
                                        new Container(
                                          child: new Text(
                                              widget.breakupPoint.selected_by! +
                                                  "%",
                                              style: TextStyle(
                                                  // fontFamily: "Roboto",
                                                  //fontFamily: "Roboto",
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 40,
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  new Container(
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        new Container(
                                          margin: EdgeInsets.only(bottom: 4),
                                          child: new Text('CREDITS',
                                              style: TextStyle(
                                                  // fontFamily: "Roboto",
                                                  //fontFamily: "Roboto",
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12)),
                                        ),
                                        new Container(
                                          child: new Text(
                                              widget.breakupPoint.credit
                                                  .toString(),
                                              style: TextStyle(
                                                  // fontFamily: "Roboto",
                                                  //fontFamily: "Roboto",
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 40,
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  new Container(
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        new Container(
                                          margin: EdgeInsets.only(bottom: 4),
                                          child: new Text('POINTS',
                                              style: TextStyle(
                                                  // fontFamily: "Roboto",
                                                  //fontFamily: "Roboto",
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12)),
                                        ),
                                        new Container(
                                          child: new Text(
                                              widget.breakupPoint.points
                                                  .toString(),
                                              style: TextStyle(
                                                  // fontFamily: "Roboto",
                                                  //fontFamily: "Roboto",
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17)),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              // new Container(
                              //   margin: EdgeInsets.only(top: 6,bottom: 5),
                              //   child: new Row(
                              //     children: [
                              //       new Container(
                              //         margin: EdgeInsets.only(right: 4),
                              //         child: new Text(widget.breakupPoint.isSelected==1?'In your team':'Not in your team',
                              //             style: TextStyle(
                              // fontFamily: "Roboto",
                              //                 color: Colors.grey,
                              //                 fontWeight: FontWeight.w400,
                              //                 fontSize: 12)),
                              //       ),
                              //       new Container(
                              //         width: 16,
                              //         height: 16,
                              //         child: Image(
                              //           image: AssetImage(widget.breakupPoint.isSelected==1?AppImages.greenCircleTickIcon:AppImages.greyCircleTickIcon),
                              //           fit: BoxFit.fill,),
                              //       ),
                              //
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new Container(
                    margin: EdgeInsets.only(bottom: 2, left: 11),
                    child: new Text(widget.breakupPoint.player_name ?? '',
                        style: TextStyle(
                            // fontFamily: "Roboto",
                            //fontFamily: "Roboto",
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  // new Divider(
                  //   height: 1,
                  //   thickness: 1,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: new Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: LightprimaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              'Event',
                              style: TextStyle(
                                  // fontFamily: "Roboto",
                                  color: Color(0xff717072),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13),
                            ),
                          ),
                          new Row(
                            children: [
                              new Container(
                                width: 100,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Actual',
                                  style: TextStyle(
                                      // fontFamily: "Roboto",
                                      color: Color(0xff717072),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                              ),
                              new Container(
                                margin: EdgeInsets.only(right: 10, left: 0),
                                width: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  'Points',
                                  style: TextStyle(
                                      // fontFamily: "Roboto",
                                      color: Color(0xff717072),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // new Divider(
                  //   height: 1,
                  //   thickness: 1,
                  // ),
                  new Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            // color: borderColor,

                            border: Border(
                                left: BorderSide(
                                  color: borderColor,
                                ),
                                right: BorderSide(
                                  color: borderColor,
                                ),
                                bottom: BorderSide(
                                  color: borderColor,
                                ))),
                        child: new ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount:
                                widget.breakupPoint.breakup_points!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new Column(
                                children: [
                                  new Container(
                                    padding: EdgeInsets.only(
                                        left: 10,
                                        right: 0,
                                        top: 10,
                                        bottom: 10),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        new Container(
                                          child: new Text(
                                            widget
                                                .breakupPoint
                                                .breakup_points![index]
                                                .event_name!,
                                            style: TextStyle(
                                                // fontFamily: "Roboto",
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: widget
                                                            .breakupPoint
                                                            .breakup_points![
                                                                index]
                                                            .event_name ==
                                                        'Total points'
                                                    ? FontWeight.bold
                                                    : FontWeight.w400),
                                          ),
                                        ),
                                        new Row(
                                          children: [
                                            new Container(
                                              width: 100,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                widget
                                                    .breakupPoint
                                                    .breakup_points![index]
                                                    .actual!
                                                    .toString(),
                                                style: TextStyle(
                                                    // fontFamily: "Roboto",
                                                    color: Colors.black,
                                                    fontWeight: widget
                                                                .breakupPoint
                                                                .breakup_points![
                                                                    index]
                                                                .event_name ==
                                                            'Total points'
                                                        ? FontWeight.bold
                                                        : FontWeight.w400,
                                                    fontSize: 13),
                                              ),
                                            ),
                                            new Container(
                                              margin: EdgeInsets.only(
                                                  right: 10, left: 0),
                                              width: 50,
                                              alignment: Alignment.center,
                                              child: Text(
                                                widget
                                                    .breakupPoint
                                                    .breakup_points![index]
                                                    .actual_points!
                                                    .toString(),
                                                style: TextStyle(
                                                    // fontFamily: "Roboto",
                                                    color: Colors.black,
                                                    fontWeight: widget
                                                                .breakupPoint
                                                                .breakup_points![
                                                                    index]
                                                                .event_name ==
                                                            'Total points'
                                                        ? FontWeight.bold
                                                        : FontWeight.w400,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if ((widget.breakupPoint.breakup_points!
                                          .indexOf(widget.breakupPoint
                                              .breakup_points![index]) !=
                                      widget.breakupPoint.breakup_points!
                                              .length -
                                          1))
                                    new Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: borderColor,
                                    ),
                                ],
                              );
                            }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            // new Container(
            //   height: 40,
            //   alignment: Alignment.center,
            //   color: primaryColor,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       new Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           new Container(
            //             width: 16,
            //             height: 16,
            //             child: Image(
            //               image: AssetImage(AppImages.greenCircleTickIcon),
            //               fit: BoxFit.fill,
            //             ),
            //           ),
            //           new Container(
            //             margin: EdgeInsets.only(left: 10),
            //             child: new Text('Your Players',
            //                 style: TextStyle(
            // fontFamily: "Roboto",
            //                     //fontFamily: "Roboto",
            //                     color: Colors.white,
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: 12)),
            //           ),
            //         ],
            //       ),
            //       new Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           new Container(
            //             width: 16,
            //             height: 16,
            //             // decoration: BoxDecoration(
            //             //   shape: BoxShape.circle,color: Colors.pink,
            //             // ),
            //             child: Image(
            //               image: AssetImage(AppImages.star),
            //               fit: BoxFit.contain,
            //             ),
            //           ),
            //           new Container(
            //             margin: EdgeInsets.only(left: 10),
            //             child: new Text('Top Players',
            //                 style: TextStyle(
            // fontFamily: "Roboto",
            //                     //fontFamily: "Roboto",
            //                     color: Colors.white,
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: 12)),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
