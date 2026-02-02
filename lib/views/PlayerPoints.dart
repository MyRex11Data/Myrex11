import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/repository/model/player_points_response.dart';
import '../appUtilities/method_utils.dart';

class PlayerPoints extends StatefulWidget {
  List<MultiSportsPlayerPointItem> list;
  GeneralModel model;
  PlayerPoints(this.list, this.model);

  @override
  _PlayerPointsState createState() => new _PlayerPointsState();
}

class _PlayerPointsState extends State<PlayerPoints> {
  bool ascending = true;
  bool ascendingPoint = true;
  bool isFirstPoint = true;
  bool isFirstSel = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getShortName(dynamic name) {
    if (name!.isNotEmpty) {
      name = name!.trim();
      if (name!.length > 0) {
        var names = name!.split(" ");
        names.remove("");
        if (names.length > 2)
          return names[0].substring(0, 1) +
              " " +
              names[1].substring(0, 1) +
              " " +
              names[names.length - 1];
        else if (names.length > 1)
          return names[0].substring(0, 1) + " " + names[names.length - 1];
        else
          return names[0];
      } else
        return name ?? '';
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    if (!isFirstSel) {
      widget.list.sort((a, b) => (double.tryParse(a.selected_by ?? '0') ?? 0)
          .compareTo(double.tryParse(b.selected_by ?? '0') ?? 0));

      if (!ascending) {
        widget.list = widget.list.reversed.toList();
      }
    }

    if (!isFirstPoint) {
      widget.list.sort((a, b) => (double.tryParse(a.points ?? '0') ?? 0)
          .compareTo(double.tryParse(b.points ?? '0') ?? 0));

      if (!ascendingPoint) {
        widget.list = widget.list.reversed.toList();
      }
    }

    setState(() {});
    return Column(
      children: [
        new Container(
          height: 30,
          padding: EdgeInsets.only(left: 10, right: 10),
          alignment: Alignment.center,
          child: new Text('Showing Player Stats by Match',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: 12)),
        ),
        SizedBox(
          height: 5,
        ),
        new Divider(
          height: 1,
          thickness: 1,
          color: borderColor,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: LightprimaryColor,
              border: Border.all(
                color: borderColor, // Border color
                width: 0.4, // Optional: Border width
              ),
              borderRadius: BorderRadius.circular(10.0), // Add rounded corners
            ),
            child: Column(
              children: [
                new Container(
                  height: 40,
                  //color: Color(0xFFf8f9fb),

                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          'Players',
                          style: TextStyle(
                              color: textCol,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // new Container(
                          //   width: 1,
                          //   height: 40,
                          //   margin: EdgeInsets.only(right: 20),
                          //   alignment: Alignment.center,
                          //   color: lightGrayColor3,
                          // ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                ascendingPoint = !ascendingPoint;
                                isFirstPoint = false; // allow points sort
                                isFirstSel = true; // disable sel sort
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Points ',
                                  style: TextStyle(
                                    color: textCol,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                  ),
                                ),
                                Image(
                                  image: AssetImage(
                                    ascendingPoint
                                        ? AppImages.downSort
                                        : AppImages.upSort,
                                  ),
                                  color: Colors.black,
                                  height: 13,
                                  width: 5,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            width: 20,
                          ),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                ascending = !ascending;
                                isFirstSel = false; // allow sel sort
                                isFirstPoint = true; // disable point sort
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  '% Sel By ',
                                  style: TextStyle(
                                    color: textCol,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                  ),
                                ),
                                Image(
                                  image: AssetImage(
                                    ascending
                                        ? AppImages.downSort
                                        : AppImages.upSort,
                                  ),
                                  color: Colors.black,
                                  height: 13,
                                  width: 5,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                new Divider(
                  height: 0.5,
                  thickness: 0.5,
                ),
                new ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      // print([widget.list[index].player_name, index]);
                      return new GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: new Column(
                          children: [
                            new Container(
                              decoration: BoxDecoration(
                                  gradient: widget.list[index].isSelected == 1
                                      ? LinearGradient(
                                          colors: [
                                            const Color(0xffE6AD00).withOpacity(
                                                0.25), // left yellow
                                            Colors.white, // right white
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        )
                                      : const LinearGradient(
                                          colors: [Colors.white, Colors.white],
                                        ),

                                  // color: widget.list[index].isSelected == 1
                                  //     ? Color(0xfff8ebeb)
                                  //     : Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: (widget.list.indexOf(
                                                  widget.list[index]) ==
                                              widget.list.length - 1)
                                          ? Radius.circular(10)
                                          : Radius.circular(0),
                                      bottomLeft: (widget.list.indexOf(
                                                  widget.list[index]) ==
                                              widget.list.length - 1)
                                          ? Radius.circular(10)
                                          : Radius.circular(0))),

                              //margin: EdgeInsets.only(bottom: 10),

                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new Row(
                                    children: [
                                      new Container(
                                        margin: EdgeInsets.only(
                                            right: 10,
                                            top: 10,
                                            bottom: 0,
                                            left: 10),
                                        height: 53,
                                        width: 53,
                                        child: CachedNetworkImage(
                                          imageUrl: widget.list[index].image!,
                                          placeholder: (context, url) =>
                                              new Image.asset(
                                                  AppImages.defaultAvatarIcon),
                                          errorWidget: (context, url, error) =>
                                              new Image.asset(
                                                  AppImages.defaultAvatarIcon),
                                        ),
                                      ),
                                      new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          new Text(
                                            getShortName(
                                                widget.list[index].player_name),
                                            // widget.list[index].player_name!.length > 20
                                            //     ? widget.list[index].player_name!
                                            //             .substring(0, 20) +
                                            //         "..."
                                            //     : widget.list[index].player_name!,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          new Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 4, right: 0),
                                                child: new Container(
                                                  // margin:
                                                  //     EdgeInsets.only(top: 4, right: 5),
                                                  child: (widget
                                                                  .list[index]
                                                                  .short_name
                                                                  ?.isNotEmpty ??
                                                              false) &&
                                                          (widget
                                                                  .list[index]
                                                                  .role
                                                                  ?.isNotEmpty ??
                                                              false)
                                                      ? RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: widget
                                                                    .list[index]
                                                                    .short_name,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          109,
                                                                          108,
                                                                          108),
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600, // bold
                                                                ),
                                                              ),
                                                              const TextSpan(
                                                                text: ' - ',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: widget
                                                                    .list[index]
                                                                    .role,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400, // normal
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                ),
                                              ),
                                              widget.list[index].isSelected == 1
                                                  ? new Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5, top: 2),
                                                      height: 14,
                                                      width: 14,
                                                      child: Image(
                                                        image: AssetImage(
                                                          AppImages
                                                              .circleTickIcon,
                                                        ),
                                                      ),
                                                    )
                                                  : new Container(),
                                            ],
                                          ),
                                          // Row(
                                          //   children: [

                                          //     // widget.list[index].isSelected == 1
                                          //     //     ? new Container(
                                          //     //         margin: EdgeInsets.only(right: 5),
                                          //     //         height: 16,
                                          //     //         width: 16,
                                          //     //         child: Image(
                                          //     //           image: AssetImage(
                                          //     //             AppImages.starTickIcon,
                                          //     //           ),
                                          //     //         ),
                                          //     //       )
                                          //     //     : new Container(),
                                          //   ],
                                          // )
                                        ],
                                      )
                                    ],
                                  ),
                                  new Row(
                                    children: [
                                      /*  new Container(
                                  width: 1,
                                  height: 60,
                                  margin: EdgeInsets.only(right: 20),
                                  alignment: Alignment.center,
                                  color: lightGrayColor3,
                                ),*/

                                      new Container(
                                        margin:
                                            EdgeInsets.only(right: 10, left: 0),
                                        width: 55,
                                        alignment: Alignment.center,
                                        child: Text(
                                          widget.list[index].points ?? '',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                      ),
                                      new Container(
                                        margin:
                                            EdgeInsets.only(right: 10, left: 0),
                                        width: 50,
                                        alignment: Alignment.center,
                                        child: Text(
                                          widget.list[index].selected_by ?? '',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            new Divider(
                              height: 0.5,
                              thickness: 0.5,
                              color: borderColor,
                            ),
                          ],
                        ),
                        onTap: () {
                          navigateToBreakupPlayerPoints(
                              context, widget.list[index]);
                        },
                      );
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
