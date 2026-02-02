import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/customWidgets/CustomWidget.dart';

class ShimmerContestItemAdapter extends StatefulWidget {

  @override
  _ShimmerContestItemAdapterState createState() => new _ShimmerContestItemAdapterState();
}

class _ShimmerContestItemAdapterState extends State<ShimmerContestItemAdapter>{


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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2)),
        child: Container(
          padding: EdgeInsets.all(0),
          child: new Container(
            child: new Column(
              children: [
                new Container(
                  margin: EdgeInsets.only(top: 5),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Container(
                        margin: EdgeInsets.only(left: 10),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.rectangular(height: 15,width: 90,),
                            new Container(
                                margin: EdgeInsets.only(top: 5,bottom: 5),
                              child: CustomWidget.rectangular(height: 15,width: 120,),
                            )
                          ],
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.only(right: 10),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomWidget.rectangular(height: 10,width: 40,),
                            new Container(
                              margin: EdgeInsets.only(top: 5,bottom: 5),
                              alignment: Alignment.centerRight,
                              child: CustomWidget.rectangular(height: 30,width: 65,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: LinearProgressIndicator(value: .5,backgroundColor: mediumGrayColor,valueColor: AlwaysStoppedAnimation<Color>(mediumGrayColor,),),
                ),
                new Container(
                  height: 20,
                  margin: EdgeInsets.only(top: 5),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Container(
                        margin: EdgeInsets.only(left: 10),
                        child: CustomWidget.rectangular(height: 15,width: 100,),
                      ),
                      new Container(
                        margin: EdgeInsets.only(right: 10),
                        child: CustomWidget.rectangular(height: 15,width: 130,),
                      ),
                    ],
                  ),
                ),
                new Container(
                  color: lightGrayColor,
                  height: 35,
                  margin: EdgeInsets.only(top: 10),
                  child: new Container(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: ()=>{
      },
    );
  }
}