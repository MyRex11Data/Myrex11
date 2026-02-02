import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:myrex11/adapter/TeamItemAdapter.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/repository/model/team_response.dart';

class PickTeamBottomSheet extends StatefulWidget {
  GeneralModel model;
  List<Team> teamList;
  Function? createTeam;
  String userTeamName;
  PickTeamBottomSheet(
      this.model, this.teamList, this.createTeam, this.userTeamName);

  // const PickTeamBottomSheet({super.key});

  @override
  State<PickTeamBottomSheet> createState() => _PickTeamBottomSheetState();
}

class _PickTeamBottomSheetState extends State<PickTeamBottomSheet> {
  double maxsizeSheet = 0.92;
  int radioClick = 0;
  double _sheetHeight = 285;
  double scrollPosition = 0.0;
  late DraggableScrollableController _draggableController;
  ScrollController _innerScroller = ScrollController();
  bool isFirst = true;

  void teamClickListener(int position) {
    radioClick = 1;
    widget.teamList.forEach((element) {
      element.isSelected = false;
    });
    if (widget.teamList[position].is_joined != 1) {
      if (widget.teamList[position].isSelected ?? false) {
        widget.teamList[position].isSelected = false;
      } else {
        widget.teamList[position].isSelected = true;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _draggableController = DraggableScrollableController();

    radioClick = widget.teamList.length >= 30 ? 1 : 0;
    _sheetHeight = widget.teamList.length >= 30 ? 770 : 285;
    widget.teamList[0].isSelected = widget.teamList.length >= 30 ? true : false;
    widget.model.teamClickListener = teamClickListener;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.direction < 0) {
          _draggableController.animateTo(0.92,
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        } else {
          if (_draggableController.size <= 0.314) {
            Navigator.pop(context);
          } else {
            _draggableController.animateTo(0.313,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          }
        }
      },
      child: DraggableScrollableSheet(
        controller: _draggableController,
        expand: true,
        initialChildSize: 0.313, // Starting height as a fraction of the screen
        minChildSize: 0.312, // Minimum height
        maxChildSize: 0.92, // Maximum height
        snap: true,
        snapSizes: [
          0.313,
          0.92,
        ],
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              // controller: scrollController,
              // padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // GestureDetector(
                      //   child: SvgPicture.asset(AppImages.),
                      //   onTap: () async {
                      //     Navigator.pop(context);
                      //   },
                      // ),
                      Text(
                        'Save as',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Divider(
                  thickness: 1,
                  height: 0,
                ),
                widget.teamList.length >= 30
                    ? SizedBox.shrink()
                    : InkWell(
                        onTap: () {
                          radioClick = 0;

                          _draggableController.animateTo(0.313,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                          widget.teamList
                              .forEach((element) => element.isSelected = false);
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: radioClick == 0
                                  ? [Color(0xFFE6F2EB), Color(0xFFFAFCFB)]
                                  : [Colors.transparent, Colors.transparent],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          height: 60,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              // SvgPicture.asset(
                              //   AppImages.createTeamIconBottomSheetIcon,
                              //   color: radioClick == 0
                              //       ? greenButtonColor
                              //       : Colors.black,
                              // ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'New team',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: radioClick == 0
                                      ? buttonGreenColor
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                InkWell(
                  onTap: () {
                    maxsizeSheet = 0.92;
                    _draggableController.animateTo(0.92,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                    if (radioClick != 1) {
                      radioClick = 1;
                      widget.teamList[0].isSelected = true;
                      widget.model.teamId = widget.teamList[0].teamid ?? 0;
                      setState(() {});
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: radioClick == 1
                            ? [Color(0xFFE6F2EB), Color(0xFFFAFCFB)]
                            : [Colors.transparent, Colors.transparent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    height: 80.9,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        // SvgPicture.asset(
                        //   AppImages.replaceIconBottomSheetIcon,
                        //   color:
                        //       radioClick == 1 ? greenButtonColor : Colors.black,
                        // ),
                        SizedBox(
                          width: 22,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Replace an existing team',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                color: radioClick == 1
                                    ? buttonGreenColor
                                    : Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'This team will replace the chosen team in all joined \ncontest ',
                              style: TextStyle(
                                color: textFieldBgColor,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: ListView.builder(
                      itemCount: widget.teamList.length,
                      controller: scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        _innerScroller.addListener(() {
                          // Check if the user pulls the ListView above the top
                          if (_innerScroller.position.pixels.isZero) {
                            _draggableController.animateTo(0.31,
                                duration: Duration(milliseconds: 300),
                                curve: Curves
                                    .easeInOut); // Call custom action here

                            // Execute something when the hard pull occurs
                            if (_innerScroller.position.pixels < -100) {
                              _draggableController.animateTo(0.31,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves
                                      .easeInOut); // Call custom action here
                            }
                          }
                        });
                        return TeamItemAdapter(
                          widget.model,
                          widget.teamList[index],
                          widget.teamList.length > 1,
                          index,
                          // () {},
                          // () {},
                          // widget.userTeamName,
                          // myteamLength: widget.teamList.length,
                        );
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (radioClick == 0) {
                      widget.createTeam!(
                          isFromTeamSharing: true, radioclick: 0);
                    } else {
                      widget.teamList.forEach((element) {
                        if (element.isSelected == true) {
                          widget.model.teamId = element.teamid;
                        }
                      });
                      widget.createTeam!(isFromTeamSharing: true);
                    }
                  },
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                              color: Colors.grey.withOpacity(0.4), width: 1),
                        )),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: buttonGreenColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'CONFIRM',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  getSheetHeight() {
    int nonPlaying = 0;

    if (widget.teamList.length == 1) {
      _sheetHeight = 470;

      widget.teamList.forEach((ele) {
        ele.players!.forEach((action) {
          if (action.is_substitute == 1 || action.is_playing == 0) {
            nonPlaying = 1;
          }
        });
      });
      if (nonPlaying == 1) {
        _sheetHeight += 50;
      }
    } else if (widget.teamList.length == 2) {
      _sheetHeight = 670;
    } else {
      _sheetHeight = 770;
    }
    if (radioClick == 0) {
      _sheetHeight = 285;
    }

    setState(() {});
  }
}
