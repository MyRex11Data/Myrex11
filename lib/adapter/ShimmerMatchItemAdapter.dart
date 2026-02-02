import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/customWidgets/CustomWidget.dart';

class ShimmerMatchItemAdapter extends StatefulWidget {
  @override
  _ShimmerMatchItemAdapterState createState() =>
      new _ShimmerMatchItemAdapterState();
}

class _ShimmerMatchItemAdapterState extends State<ShimmerMatchItemAdapter> {
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
    return new GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(0),
          child: new Container(
            child: new Column(
              children: [
                // new Container(
                //   height: 20,
                //   margin: EdgeInsets.only(top: 5),
                //   child: new Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       CustomWidget.rectangular(
                //         height: 15,
                //         width: 100,
                //       ),
                //       new Row(
                //         children: [
                //           CustomWidget.rectangular(
                //             height: 15,
                //             width: 50,
                //           ),
                //           new Container(
                //             margin: EdgeInsets.only(left: 10, right: 5),
                //             height: 18,
                //             width: 18,
                //             child: CustomWidget.circular(
                //               height: 18,
                //               width: 18,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // new Divider(),

                new Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Container(
                        width: 60,
                        child: CustomWidget.rectangular(
                          height: 15,
                        ),
                      ),
                      new Container(
                        width: 60,
                        alignment: Alignment.centerRight,
                        child: CustomWidget.rectangular(
                          height: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(top: 8, bottom: 13),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Flexible(
                        child: new Container(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  new Container(
                                    height: 15,
                                    width: 43,
                                    child: CustomWidget.rectangular(
                                      height: 15,
                                      width: 43,
                                    ),
                                  ),
                                  new Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: CustomWidget.circular(
                                        height: 30,
                                        width: 30,
                                      )),
                                ],
                              ),
                              new Container(
                                margin: EdgeInsets.only(left: 5),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Container(
                                      margin: EdgeInsets.only(top: 2),
                                      child: CustomWidget.rectangular(
                                        height: 15,
                                        width: 30,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        flex: 1,
                      ),
                      new Flexible(
                        child: new Container(
                          child: CustomWidget.rectangular(
                            height: 15,
                            width: 50,
                          ),
                        ),
                        flex: 1,
                      ),
                      new Flexible(
                        child: new Container(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              new Container(
                                margin: EdgeInsets.only(right: 5),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    new Container(
                                      margin: EdgeInsets.only(top: 2),
                                      child: CustomWidget.rectangular(
                                        height: 15,
                                        width: 30,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              new Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  new Container(
                                    height: 15,
                                    width: 43,
                                    child: CustomWidget.rectangular(
                                      height: 15,
                                      width: 43,
                                    ),
                                  ),
                                  new Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: CustomWidget.circular(
                                        height: 30,
                                        width: 30,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                new Container(
                  color: lightGrayColor,
                  height: 30,
                  child: new Container(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomWidget.rectangular(
                          height: 15,
                          width: 50,
                        ),
                        CustomWidget.rectangular(
                          height: 15,
                          width: 50,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () => {
        // navigateToUpcomingContests(context)
      },
    );
  }
}
