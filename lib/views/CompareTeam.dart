import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/buildType/buildType.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/compare_team_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';

class CompareTeam extends StatefulWidget {
  String matchKey, sportKey, team1Id, team2Id, fantasyType, slotId, challengeId;
  GeneralModel model;
  CompareTeam(this.matchKey, this.sportKey, this.team1Id, this.team2Id,
      this.fantasyType, this.slotId, this.challengeId, this.model);
  @override
  _CompareTeamState createState() => new _CompareTeamState();
}

class _CompareTeamState extends State<CompareTeam> {
  TextEditingController codeController = TextEditingController();
  bool loading = false;
  String userId = '0';
  late CompareData compareData;

  @override
  void initState() {
    super.initState();
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                compareTeamData();
              })
            });
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
      child: new Scaffold(
        backgroundColor: Colors.white,
        /*appBar: PreferredSize(
          preferredSize: Size.fromHeight(55), // Set this height
          child: Container(
            color: primaryColor,
            padding: EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => {Navigator.pop(context)},
                  child: new Container(
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: new Container(
                      width: 16,
                      height: 16,
                      child: Image(
                        image: AssetImage(AppImages.backImageURL),
                        fit: BoxFit.fill,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                new Container(
                  child: new Text('Compare Team',
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18)),
                ),
              ],
            ),
          ),
        ),*/

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65), // Set this height
          child: Container(
            padding: EdgeInsets.only(
              top: 50,
              bottom: 12,
              left: 16,
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
                Text("Compare Team",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        body: !loading
            ? new Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0, right: 0, bottom: 4),
                    child: new Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height,
                      child: new Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                            ),
                            child: new Container(
                              decoration: BoxDecoration(
                                color: LightprimaryColor,
                                // border: Border.all(
                                //   color: borderColor,
                                //   width: 1,
                                // ),
                                borderRadius: BorderRadius.circular(10.0),

                                // 🔥 Bottom shadow
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor, // soft shadow
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                    offset: const Offset(
                                        0, 2), // shadow only at bottom
                                  ),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        new Expanded(
                                          child: new Container(
                                            padding: EdgeInsets.only(
                                                left: 4, bottom: 0),
                                            child: new Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                new Container(
                                                  child: new ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                    child: new Container(
                                                      height: 40,
                                                      width: 40,
                                                      child: CachedNetworkImage(
                                                          imageUrl: compareData
                                                              .team1_image!,
                                                          placeholder: (context,
                                                                  url) =>
                                                              new Image.asset(
                                                                AppImages
                                                                    .CompareAvatarIcon,
                                                              ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Image.asset(
                                                                AppImages
                                                                    .CompareAvatarIcon,
                                                              ),
                                                          fit: BoxFit.fill),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0, left: 4),
                                                  child: new Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      new Text(
                                                        compareData
                                                                .team1_name ??
                                                            "",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                AppConstants
                                                                    .textRegular,
                                                            color: Color(
                                                                0xff464646),
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      new Container(
                                                        margin: EdgeInsets.only(
                                                            top: 0),
                                                        child: new Text(
                                                          compareData
                                                                  .team1_rank ??
                                                              '',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  AppConstants
                                                                      .textRegular,
                                                              color: Color(
                                                                  0xff464646),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          flex: 4,
                                        ),
                                        new Expanded(
                                          child: new Container(
                                            padding: EdgeInsets.only(
                                                right: 8, bottom: 0),
                                            child: new Row(
                                              // crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                new Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    new Text(
                                                      compareData.team2_name!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              AppConstants
                                                                  .textRegular,
                                                          color:
                                                              Color(0xff464646),
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    new Container(
                                                      margin: EdgeInsets.only(
                                                          top: 0),
                                                      child: new Text(
                                                        compareData.team2_rank!,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                AppConstants
                                                                    .textRegular,
                                                            color: Color(
                                                                0xff464646),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6),
                                                  child: new Container(
                                                    child: new ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30)),
                                                      child: new Container(
                                                        height: 41,
                                                        width: 41,
                                                        child:
                                                            CachedNetworkImage(
                                                                imageUrl:
                                                                    compareData
                                                                        .team2_image!,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    new Image
                                                                        .asset(
                                                                      AppImages
                                                                          .CompareAvatarIcon,
                                                                    ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    new Image
                                                                        .asset(
                                                                      AppImages
                                                                          .CompareAvatarIcon,
                                                                    ),
                                                                fit: BoxFit
                                                                    .fill),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          flex: 4,
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 40,
                                      child: Image.asset(
                                        AppImages.electricIcon,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          compareData.team1_points.toString().isNotEmpty ||
                                  compareData.team2_points.toString().isNotEmpty
                              ? Container()
                              : Container(
                                  child: Text(
                                    'Both Teams points are not available.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            child: Column(
                              children: [
                                new Container(
                                  decoration: BoxDecoration(
                                    color: LightprimaryColor,
                                    // border: Border.all(
                                    //   color: Color(0xFFe8adad), // Border color
                                    //   width: 0.4, // Optional: Border width
                                    // ),
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Add rounded corners
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: new Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: Text(
                                          'Total Points',
                                          style: TextStyle(
                                              fontFamily: 'roboto',
                                              color: textCol,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      compareData.team1_points
                                                  .toString()
                                                  .isNotEmpty ||
                                              compareData.team2_points
                                                  .toString()
                                                  .isNotEmpty
                                          ? Container(
                                              height: 40,
                                              width: 155,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(AppImages
                                                          .comparePointsBgIcon),
                                                      fit: BoxFit.fill)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    //width: 50,
                                                    // decoration:
                                                    //     BoxDecoration(
                                                    //         gradient: double.parse(compareData
                                                    //                     .team1_points
                                                    //                     .toString()) >=
                                                    //                 double.parse(compareData
                                                    //                     .team2_points
                                                    //                     .toString())
                                                    //             ? LinearGradient(
                                                    //                 colors: [
                                                    //                     Colors.white,
                                                    //                     const Color.fromARGB(255, 202, 241, 203)
                                                    //                   ])
                                                    //             : LinearGradient(
                                                    //                 colors: [
                                                    //                     Colors.white,
                                                    //                     Color.fromARGB(255, 242, 200, 202),
                                                    //                   ])),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 16,
                                                              left: 2),
                                                      child: new Text(
                                                        (MethodUtils().prettify(
                                                            double.parse(compareData
                                                                .team1_points
                                                                .toString()))),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                AppConstants
                                                                    .textRegular,
                                                            color: double.parse(compareData
                                                                        .team1_points
                                                                        .toString()) >=
                                                                    double.parse(compareData
                                                                        .team2_points
                                                                        .toString())
                                                                ? Color(
                                                                    0xff076E39)
                                                                : primaryColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    // decoration:
                                                    //     BoxDecoration(
                                                    //         gradient: double.parse(compareData
                                                    //                     .team2_points
                                                    //                     .toString()) >=
                                                    //                 double.parse(compareData
                                                    //                     .team1_points
                                                    //                     .toString())
                                                    //             ? LinearGradient(
                                                    //                 colors: [
                                                    //                     const Color.fromARGB(255, 202, 241, 203),
                                                    //                     Colors.white,
                                                    //                   ])
                                                    //             : LinearGradient(
                                                    //                 colors: [
                                                    //                     Color.fromARGB(255, 242, 200, 202),
                                                    //                     Colors.white,
                                                    //                   ])),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 2,
                                                              left: 16),
                                                      child: new Text(
                                                        (MethodUtils()
                                                            .prettify(double
                                                                .parse(compareData
                                                                    .team2_points
                                                                    .toString()))
                                                            .toString()),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                AppConstants
                                                                    .textRegular,
                                                            color: double.parse(compareData
                                                                        .team2_points
                                                                        .toString()) >=
                                                                    double.parse(compareData
                                                                        .team1_points
                                                                        .toString())
                                                                ? Color(
                                                                    0xff076E39)
                                                                : primaryColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              height: 30,
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: new Container(
                                          // height: 30,
                                          color: Colors.transparent,
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              new Container(
                                                alignment: Alignment.center,
                                                child: new Text(
                                                  compareData.diff_text!,
                                                  style: TextStyle(
                                                    fontFamily: AppConstants
                                                        .textSemiBold,
                                                    color: Color(0xff464646),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              new Container(
                                                alignment: Alignment.center,
                                                // margin: EdgeInsets.only(left: 5),
                                                child: new Text(
                                                  compareData.diff_points
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily: AppConstants
                                                        .textSemiBold,
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              new Container(
                                                alignment: Alignment.center,
                                                child: new Text(
                                                  "pts",
                                                  style: TextStyle(
                                                    fontFamily: AppConstants
                                                        .textSemiBold,
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(height: 10),
                          // new Divider(
                          //   color: Color(0xfff5f5f5),
                          //   height: 1,
                          //   thickness: 10,
                          // ),
                          Expanded(
                              child: new SingleChildScrollView(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                    ),
                                    child: new Column(
                                      children: List.generate(
                                        compareData.player_list!.length,
                                        (index) => new Column(
                                          children: [
                                            new Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 10, top: 10),
                                              child: new Column(
                                                children: [
                                                  new Container(
                                                    alignment: Alignment.center,
                                                    child: new Text(
                                                      index == 0
                                                          ? 'Captain and Vice Captain'
                                                          : index == 1
                                                              ? 'Different Players'
                                                              : 'Common Players',
                                                      style: TextStyle(
                                                        fontFamily: AppConstants
                                                            .textSemiBold,
                                                        color:
                                                            Color(0xff464646),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  new Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      new Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: new Text(
                                                          compareData
                                                                  .player_list![
                                                                      index]
                                                                  .diff_text ??
                                                              '',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                AppConstants
                                                                    .textSemiBold,
                                                            color: Color(
                                                                0xff464646),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      new Container(
                                                        alignment:
                                                            Alignment.center,
                                                        // margin:
                                                        //     EdgeInsets.only(
                                                        //         left: 5),
                                                        child: new Text(
                                                          compareData
                                                              .player_list![
                                                                  index]
                                                              .diff_points
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  AppConstants
                                                                      .textSemiBold,
                                                              color:
                                                                  primaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 11,
                                                              height: 1.5),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: new Text(
                                                          "points",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  AppConstants
                                                                      .textSemiBold,
                                                              color: Color(
                                                                  0xff464646),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 12,
                                                              height: 1.5),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            compareData.player_list![index]
                                                        .data!.length >
                                                    0
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            LightprimaryColor,
                                                        // border: Border.all(
                                                        //   color:
                                                        //       Color(0xffF4D2D2),
                                                        // ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4,
                                                          vertical: 6),
                                                      child: new Column(
                                                        children: List.generate(
                                                            compareData
                                                                .player_list![
                                                                    index]
                                                                .data!
                                                                .length,
                                                            (position) =>
                                                                new Column(
                                                                  children: [
                                                                    Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      children: [
                                                                        new Container(
                                                                          height:
                                                                              50,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              new Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              new Expanded(
                                                                                child: new Container(
                                                                                  child: new Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Stack(
                                                                                        alignment: Alignment.bottomLeft,
                                                                                        children: [
                                                                                          new Container(
                                                                                            child: new Stack(
                                                                                              alignment: Alignment.topLeft,
                                                                                              children: [
                                                                                                new Container(
                                                                                                  margin: EdgeInsets.only(top: 5, left: 12),
                                                                                                  child: CachedNetworkImage(
                                                                                                      height: 45,
                                                                                                      width: 45,
                                                                                                      imageUrl: compareData.player_list![index].data![position].player_data == null ? '' : compareData.player_list![index].data![position].player_data![0].image ?? '',
                                                                                                      placeholder: (context, url) => new Image.asset(
                                                                                                            AppImages.CompareAvatarIcon,
                                                                                                          ),
                                                                                                      errorWidget: (context, url, error) => new Image.asset(
                                                                                                            AppImages.CompareAvatarIcon,
                                                                                                          ),
                                                                                                      fit: BoxFit.fill),
                                                                                                ),
                                                                                                index == 0
                                                                                                    ? new Container(
                                                                                                        height: 20,
                                                                                                        width: 20,
                                                                                                        margin: EdgeInsets.only(bottom: 2),
                                                                                                        alignment: Alignment.center,
                                                                                                        decoration: BoxDecoration(border: Border.all(color: position == 0 ? Colors.black : Colors.black), borderRadius: BorderRadius.circular(14), color: position == 0 ? Colors.black : Colors.white),
                                                                                                        child: new Text(
                                                                                                          position == 0 ? 'C' : 'VC',
                                                                                                          style: TextStyle(color: position == 0 ? Colors.white : Colors.black, fontWeight: FontWeight.w500, fontSize: 10),
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                      )
                                                                                                    : new Container(),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(bottom: 2),
                                                                                            child: Container(
                                                                                              // height: 20,
                                                                                              decoration: BoxDecoration(color: compareData.player_list![index].data![position].player_data![0].team == "team1" ? Colors.white : Colors.black, borderRadius: BorderRadius.circular(2), border: Border.all(color: compareData.player_list![index].data![position].player_data![0].team == "team1" ? Color(0xffdedede) : Colors.black)),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(2),
                                                                                                child: Text(
                                                                                                  compareData.player_list![index].data![position].player_data![0].teamcode ?? "",
                                                                                                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: compareData.player_list![index].data![position].player_data![0].team == "team1" ? Colors.black : Colors.white),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                      new Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          new Text(
                                                                                            compareData.player_list![index].data![position].player_data == null ? '' : compareData.player_list![index].data![position].player_data![0].getShortName(),
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            maxLines: 1,
                                                                                            style: TextStyle(fontFamily: AppConstants.textRegular, color: Colors.black, fontSize: 11, fontWeight: FontWeight.w500),
                                                                                          ),
                                                                                          new Container(
                                                                                            margin: EdgeInsets.only(top: 5),
                                                                                            child: new Text(
                                                                                              compareData.player_list![index].data![position].player_data == null ? '' : compareData.player_list![index].data![position].player_data![0].role ?? '',
                                                                                              style: TextStyle(fontFamily: AppConstants.textRegular, color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w400),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                flex: 2,
                                                                              ),
                                                                              new Expanded(
                                                                                child: new Container(
                                                                                  child: new Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      new Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          new Text(
                                                                                            compareData.player_list![index].data![position].player_data == null ? '' : compareData.player_list![index].data![position].player_data![1].getShortName(),
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            maxLines: 1,
                                                                                            style: TextStyle(fontFamily: AppConstants.textRegular, color: Colors.black, fontSize: 11, fontWeight: FontWeight.w500),
                                                                                          ),
                                                                                          new Container(
                                                                                            margin: EdgeInsets.only(top: 5),
                                                                                            child: new Text(
                                                                                              compareData.player_list![index].data![position].player_data == null ? '' : compareData.player_list![index].data![position].player_data![1].role ?? '',
                                                                                              style: TextStyle(fontFamily: AppConstants.textRegular, color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w400),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Stack(
                                                                                        alignment: Alignment.bottomRight,
                                                                                        children: [
                                                                                          new Container(
                                                                                            child: new Stack(
                                                                                              alignment: Alignment.topRight,
                                                                                              children: [
                                                                                                new Container(
                                                                                                  height: 45,
                                                                                                  width: 45,
                                                                                                  margin: EdgeInsets.only(top: 5, right: 12),
                                                                                                  child: CachedNetworkImage(
                                                                                                      imageUrl: compareData.player_list![index].data![position].player_data == null ? '' : compareData.player_list![index].data![position].player_data![1].image ?? '',
                                                                                                      placeholder: (context, url) => new Image.asset(
                                                                                                            AppImages.CompareAvatarIcon,
                                                                                                          ),
                                                                                                      errorWidget: (context, url, error) => new Image.asset(
                                                                                                            AppImages.CompareAvatarIcon,
                                                                                                          ),
                                                                                                      fit: BoxFit.fill),
                                                                                                ),
                                                                                                index == 0
                                                                                                    ? new Container(
                                                                                                        height: 20,
                                                                                                        width: 20,
                                                                                                        margin: EdgeInsets.only(bottom: 2),
                                                                                                        alignment: Alignment.center,
                                                                                                        decoration: BoxDecoration(border: Border.all(color: position == 0 ? Colors.black : Colors.black), borderRadius: BorderRadius.circular(14), color: position == 0 ? Colors.black : Colors.white),
                                                                                                        child: new Text(
                                                                                                          position == 0 ? 'C' : 'VC',
                                                                                                          style: TextStyle(color: position == 0 ? Colors.white : Colors.black, fontWeight: FontWeight.w500, fontSize: 10),
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                      )
                                                                                                    : new Container(),
                                                                                                // Positioned(
                                                                                                //   bottom: 2,
                                                                                                //   left: 20,
                                                                                                //   child:
                                                                                                // )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(bottom: 2),
                                                                                            child: Container(
                                                                                              // height: 20,
                                                                                              // padding: EdgeInsets.only(left: 0, right: 0, top: 2, bottom: 2),
                                                                                              decoration: BoxDecoration(color: compareData.player_list![index].data![position].player_data![1].team == "team1" ? Colors.white : Colors.black, borderRadius: BorderRadius.circular(2), border: Border.all(color: compareData.player_list![index].data![position].player_data![1].team == "team1" ? Color(0xffdedede) : Colors.black)),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(2),
                                                                                                child: Text(
                                                                                                  compareData.player_list![index].data![position].player_data![1].teamcode ?? "",
                                                                                                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: compareData.player_list![index].data![position].player_data![1].team == "team1" ? Colors.black : Colors.white),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                flex: 2,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          // height:
                                                                          //     30,
                                                                          // width: position ==
                                                                          //         0
                                                                          //     ? 104
                                                                          //     : position ==
                                                                          //             1
                                                                          //         ? 104
                                                                          //         : 80,
                                                                          padding:
                                                                              EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                5,
                                                                          ),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            color:
                                                                                Colors.transparent,
                                                                            // border:
                                                                            //     Border.all(
                                                                            //   color: Color(0xffF4D2D2), //                   <--- border color
                                                                            //   width: 1.0,
                                                                            // ),
                                                                          ),
                                                                          child:
                                                                              IntrinsicWidth(
                                                                            child:
                                                                                new Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Container(
                                                                                  padding: EdgeInsets.only(left: 0, right: 5, top: 3, bottom: 3),
                                                                                  decoration: BoxDecoration(
                                                                                      border: Border(
                                                                                          right: BorderSide(
                                                                                    color: Colors.white,
                                                                                  ))),
                                                                                  child: index == 0
                                                                                      ? Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            new Text(
                                                                                              compareData.player_list![index].data![position].player_data == null ? '' : (MethodUtils().prettify(double.parse((compareData.player_list![index].data![position].player_data![0].playerpoints ?? '0').toString()))),
                                                                                              // textAlign: TextAlign.center,
                                                                                              style: TextStyle(fontFamily: AppConstants.textRegular, color: index == 1 ? primaryColor : Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                                                                                            ),
                                                                                            new Text(
                                                                                              compareData.player_list![index].data![position].player_data == null ? '' : ('${(double.parse(compareData.player_list![index].data![position].player_data![0].playerpoints) / (position == 0 ? 2 : 1.5)).toStringAsFixed(1)}' + "x${position == 0 ? 2.0 : 1.5}"),
                                                                                              // textAlign: TextAlign.center,
                                                                                              style: TextStyle(fontFamily: AppConstants.textRegular, color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      : Padding(
                                                                                          padding: const EdgeInsets.only(left: 0),
                                                                                          child: new Text(
                                                                                            compareData.player_list![index].data![position].player_data == null ? '' : (MethodUtils().prettify(double.parse((compareData.player_list![index].data![position].player_data![0].playerpoints ?? "0").toString()))),
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(fontFamily: AppConstants.textRegular, color: index == 1 ? /* primaryColor*/ Colors.black : Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                                                                                          ),
                                                                                        ),
                                                                                ),

                                                                                // Container(
                                                                                //   height: 20,
                                                                                //   width: 1,
                                                                                //   color: Color(0xffdedede),
                                                                                // ),
                                                                                VerticalDivider(
                                                                                  color: Colors.white,
                                                                                  width: 5,
                                                                                ),
                                                                                index == 0
                                                                                    ? Container(
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            new Text(
                                                                                              compareData.player_list![index].data![position].player_data == null ? '' : (MethodUtils().prettify(double.parse((compareData.player_list![index].data![position].player_data![1].playerpoints ?? '0').toString()))),
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(fontFamily: AppConstants.textRegular, color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                                                                                            ),
                                                                                            new Text(
                                                                                              compareData.player_list![index].data![position].player_data == null ? '' : ('${(double.parse(compareData.player_list![index].data![position].player_data![1].playerpoints) / (position == 0 ? 2 : 1.5)).toStringAsFixed(1)}' + "x${position == 0 ? 2.0 : 1.5}"),
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(fontFamily: AppConstants.textRegular, color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    : new Text(
                                                                                        compareData.player_list![index].data![position].player_data == null ? '' : (MethodUtils().prettify(double.parse((compareData.player_list![index].data![position].player_data![1].playerpoints ?? '0').toString()))),
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontFamily: AppConstants.textRegular, color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                                                                                      ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    if ((compareData
                                                                            .player_list![
                                                                                index]
                                                                            .data!
                                                                            .indexOf(compareData.player_list![index].data![
                                                                                position]) !=
                                                                        compareData.player_list![index].data!.length -
                                                                            1))
                                                                      new Divider(
                                                                        height:
                                                                            1,
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                  ],
                                                                )),
                                                      ),
                                                    ),
                                                  )
                                                : new Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : new Container(),
      ),
    );
  }

  void compareTeamData() async {
    setState(() {
      loading = true;
    });
    AppLoaderProgress.showLoader(context);
    GeneralRequest contestRequest = new GeneralRequest(
        user_id: userId,
        matchkey: widget.matchKey,
        sport_key: widget.sportKey,
        fantasy_type: widget.fantasyType,
        slotes_id: widget.slotId,
        team1_id: widget.team1Id,
        team2_id: widget.team2Id,
        challenge_id: widget.challengeId,
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            widget.model.fantasyType.toString(),
            sportsKey: widget.model
                .sportKey) /*widget.model.fantasyType==1?"7":widget.model.fantasyType==2?"6":"0")*/);
    final client = ApiClient(AppRepository.dio);
    CompareTeamResponse response =
        await client.getCompareTeamData(contestRequest);
    if (response.status == 1) {
      compareData = response.result!;
    } else {
      MethodUtils.showError(
          context, response.message ?? 'Something went wrong!');
    }
    setState(() {
      loading = false;
      AppLoaderProgress.hideLoader(context);
    });
  }
}
