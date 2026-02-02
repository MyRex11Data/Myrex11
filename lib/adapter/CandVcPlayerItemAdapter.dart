import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/repository/model/team_response.dart';

class CandVcPlayerItemAdapter extends StatefulWidget {
  Player player;
  Function captainViceCaptainListener;
  int index;
  bool displayRole;
  String role;
  String? matchKey;
  String? sportKey;
  int? fantasyType;
  int? slotId;
  List<Player>? selectedList;
  bool? isSorting;

  CandVcPlayerItemAdapter(
      this.player,
      this.captainViceCaptainListener,
      this.index,
      this.displayRole,
      this.role,
      this.matchKey,
      this.sportKey,
      this.fantasyType,
      this.slotId,
      this.selectedList,
      {this.isSorting});

  @override
  _CandVcPlayerItemAdapterState createState() =>
      _CandVcPlayerItemAdapterState();
}

class _CandVcPlayerItemAdapterState extends State<CandVcPlayerItemAdapter> {
  bool isAnnounced = true;
  bool isLastPlayed = false;

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
    return Container(
      color: Colors.white,
      child: Column(
        children: [
         widget.isSorting == true ? Container() :  Container(),
         // widget.isSorting == true ? Container() : createHeader1(),
          Container(
            padding: EdgeInsets.only(left: 8, right: 8, top: 14, bottom: 0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Row(
                  children: [
                    new GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: new Container(
                        width: 80,
                        margin: EdgeInsets.only(right: 5),
                        child: new Stack(
                          alignment: Alignment.bottomLeft,
                          //// overflow: Overflow.visible,
                          children: [
                            new Container(
                              alignment: Alignment.bottomRight,
                              // width: 70,
                              child: new Container(
                                child: new Container(
                                  alignment: Alignment.bottomRight,
                                  height: 55,
                                  width: 55,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.player.image!,
                                    placeholder: (context, url) =>
                                        new Image.asset(
                                            AppImages.player_avatar),
                                    errorWidget: (context, url, error) =>
                                        new Image.asset(
                                            AppImages.player_avatar),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Container(
                                  margin: EdgeInsets.only(bottom: 40),
                                  child: Image.asset(
                                    AppImages.profile_info,
                                    height: 17,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Card(
                                elevation: 2,
                                margin: EdgeInsets.only(left: 4, bottom: 0),
                                color: widget.player.team != 'team1'
                                    ? Colors.black
                                    : Colors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                        width: .5,
                                          color: widget.player.team == 'team1'
                                              ? Colors.white
                                              : Colors.black),

                                  ),
                                  // height: 17,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 2),
                                  child: new Text(
                                    widget.player.teamcode!,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: widget.player.team == 'team1'
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 1),
                            //   child: Card(
                            //     child: new Container(
                            //       //margin: EdgeInsets.only(left: 0, top: 0),
                            //       // height: 16,
                            //       // width: 40,
                            //       decoration: BoxDecoration(
                            //         color: widget.player.team != 'team1'
                            //             ? Colors.black
                            //             : Colors.white,
                            //         borderRadius: BorderRadius.circular(3),
                            //         // border: widget.player.team != 'team1'
                            //         //     ? Border.all(color: Colors.black)
                            //         //     : Border.all(color: Colors.black)
                            //       ),
                            //       alignment: Alignment.center,
                            //       child: Padding(
                            //         padding: const EdgeInsets.symmetric(
                            //             horizontal: 3, vertical: 2),
                            //         child: new Text(
                            //           widget.player.teamcode!,
                            //           overflow: TextOverflow.clip,
                            //           style: TextStyle(
                            //             fontSize: 10,
                            //             fontWeight: FontWeight.normal,
                            //             color: widget.player.team != 'team1'
                            //                 ? Colors.white
                            //                 : Colors.black,
                            //           ),
                            //           textAlign: TextAlign.center,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      onTap: () {
                        navigateToPlayerInfo(
                            context,
                            widget.matchKey,
                            widget.player.id,
                            widget.player.name,
                            widget.player.team,
                            widget.player.image,
                            widget.player.isSelected,
                            widget.index,
                            0,
                            widget.sportKey,
                            widget.fantasyType,
                            // widget.slotId,
                            '1',
                            null,
                            widget.role,
                            widget.player.selected_by,
                            widget.player.points ?? '0',
                            widget.player.count ?? 0,
                            widget.player.teamcode);
                      },
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(
                          widget.player.getShortName(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 5),
                        /*Text(
                          "Sel by " +
                              widget.player.selected_by.toString() +
                              "%",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),*/
                        new Container(
                          width: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.player.series_points,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                new Row(
                  children: [
                  /*  new Container(
                      width: 50,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.player.series_points,
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ),*/
                    new Column(
                      children: [
                        new GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            height: 32,
                            width: 32,
                            margin: EdgeInsets.only(bottom: 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: widget.player.isCaptain ?? false
                                        ? Colors.black
                                        : mediumGrayColor),
                                borderRadius: BorderRadius.circular(18),
                                color: widget.player.isCaptain ?? false
                                    ? Colors.black
                                    : Colors.white),
                            child: new Text(
                              widget.player.isCaptain ?? false ? '2x' : 'C',
                              style: TextStyle(
                                  color: widget.player.isCaptain ?? false
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            build(context);
                            widget.captainViceCaptainListener(
                                true, widget.index, widget.selectedList);
                          },
                        ),
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.player.captain_selected_by!}%',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 15,),
                    Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            height: 32,
                            width: 32,
                            margin: EdgeInsets.only(bottom: 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: widget.player.isVcCaptain ?? false
                                        ? Colors.black
                                        : mediumGrayColor),
                                borderRadius: BorderRadius.circular(20),
                                color: widget.player.isVcCaptain ?? false
                                    ? Colors.black
                                    : Colors.white),
                            child: new Text(
                              widget.player.isVcCaptain ?? false
                                  ? '1.5x'
                                  : 'VC',
                              style: TextStyle(
                                  color: widget.player.isVcCaptain ?? false
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            widget.captainViceCaptainListener(
                                false, widget.index, widget.selectedList);
                          },
                        ),
                        new Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.player.vice_captain_selected_by!}%',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12,),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
        //  widget.isSorting == true ? Container() : createHeader(),
          widget.isSorting == true ? Container() : Container(),
        ],
      ),
    );
  }

  Widget createHeader1() {
    if (widget.index == 0) {
      return new Container(
        height: 35,
        decoration: BoxDecoration(
            // gradient: new LinearGradient(
            //   colors: [
            //     const Color(0xff787878),
            //     const Color(0xffc9c8c6),
            //   ],
            //   begin: const FractionalOffset(0.0, 0.0),
            //   end: const FractionalOffset(1.0, 0.0),
            // ),
            color: Color(0xFFf8f9fb)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                widget.player.display_role!,
                style: TextStyle(
                    color: Color(0xFF747272),
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }
    return new Container();
  }

  Widget createHeader() {
    if (widget.displayRole) {
      return new Container(
        height: 35,
        decoration: new BoxDecoration(
            //color: Colors.grey.shade300
            color: Color(0xFFf8f9fb)),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            new Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                widget.role,
                style: TextStyle(
                    color: Color(0xFF747272),
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }
    return new Container();
  }
}
