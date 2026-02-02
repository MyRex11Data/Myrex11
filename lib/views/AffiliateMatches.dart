// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myrex11/adapter/ShimmerMatchItemAdapter.dart';
import 'package:myrex11/views/AffiliateMatches/bloc/affiliate_matches_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/views/NoMatchesListFound.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AffiliateMatches extends StatelessWidget {
  String start_date;
  String end_date;
  String userid;
  AffiliateMatches(this.start_date, this.end_date, this.userid, {key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            /* set Status bar color in Android devices. */

            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/

            statusBarBrightness: Brightness.dark)
        /* set Status bar icon color in iOS. */
        );
    return BlocProvider(
      create: (context) => AffiliateMatchesBloc()
        ..add(FetchAffileateMatches(
            startDate: start_date, endDate: end_date, userId: userid)),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,

              // image: DecorationImage(
              //   image: AssetImage("assets/images/Ic_creatTeamBackGround.png"),
              //   fit: BoxFit.fill,
              // ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 45,
                bottom: 15,
                left: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => {Navigator.pop(context)},
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        height: 30,
                        child: Image(
                          image: AssetImage(AppImages.backImageURL),
                          // fit: BoxFit.fill,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text('Affiliate',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: BlocBuilder<AffiliateMatchesBloc, AffiliateMatchesState>(
            builder: (context, state) {
          if (state is AffiliateMatchesLoading) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: 7,
                  itemBuilder: (BuildContext context, int index) {
                    return ShimmerMatchItemAdapter();
                  }),
            );
          } else if (state is AffiliateMatchesLoaded) {
            return Stack(
              children: [
                state.matchList.length > 0
                    ? Container(
                        margin: EdgeInsets.all(8),
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: state.matchList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    padding: EdgeInsets.all(0),
                                    child: new Container(
                                      child: new Column(
                                        children: [
                                          new Container(
                                            height: 20,
                                            margin: EdgeInsets.only(top: 5),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                new Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10, top: 5),
                                                  child: Text(
                                                    state.matchList[index]
                                                            .name ??
                                                        '',
                                                    style: TextStyle(
                                                        fontFamily: "Roboto",
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          new Divider(),
                                          new Container(
                                            padding: EdgeInsets.all(0),
                                            margin: EdgeInsets.only(
                                                top: 8, bottom: 13),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                new Container(
                                                  child: new Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      new Container(
                                                        child: new Stack(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          children: [
                                                            new Container(
                                                              height: 16,
                                                              width: 43,
                                                              child: Image(
                                                                image: AssetImage(
                                                                    AppImages
                                                                        .leftTeamIcon),
                                                                fit:
                                                                    BoxFit.fill,
                                                                color: MethodUtils
                                                                    .hexToColor(state
                                                                        .matchList[
                                                                            index]
                                                                        .team1_color!),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            16)),
                                                                child:
                                                                    new Container(
                                                                  height: 33,
                                                                  width: 33,
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: state
                                                                        .matchList[
                                                                            index]
                                                                        .team1logo!,
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        new Image
                                                                            .asset(
                                                                            AppImages.logoPlaceholderURL),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        new Image
                                                                            .asset(
                                                                            AppImages.logoPlaceholderURL),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      new Container(
                                                        margin: EdgeInsets.only(
                                                            left: 5),
                                                        child: new Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            new Container(
                                                              margin: EdgeInsets
                                                                  .only(top: 2),
                                                              child: new Text(
                                                                state
                                                                    .matchList[
                                                                        index]
                                                                    .team1display!,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                new Container(
                                                  margin:
                                                      EdgeInsets.only(top: 2),
                                                  child: new Text(
                                                    'Winner Declare',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      color: Color(0xff076e39),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                                new Container(
                                                  child: new Row(
                                                    children: [
                                                      new Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        child: new Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            new Container(
                                                              margin: EdgeInsets
                                                                  .only(top: 2),
                                                              child: new Text(
                                                                state
                                                                    .matchList[
                                                                        index]
                                                                    .team2display!,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      new Stack(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        children: [
                                                          new Container(
                                                            height: 16,
                                                            width: 43,
                                                            child: Image(
                                                              image: AssetImage(
                                                                  AppImages
                                                                      .rightTeamIcon),
                                                              fit: BoxFit.fill,
                                                              color: MethodUtils
                                                                  .hexToColor(state
                                                                      .matchList[
                                                                          index]
                                                                      .team2_color!),
                                                            ),
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            16)),
                                                            child:
                                                                new Container(
                                                              height: 33,
                                                              width: 33,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: state
                                                                    .matchList[
                                                                        index]
                                                                    .team2logo!,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    new Image
                                                                        .asset(
                                                                        AppImages
                                                                            .logoPlaceholderURL),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    new Image
                                                                        .asset(
                                                                        AppImages
                                                                            .logoPlaceholderURL),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          new Divider(
                                            height: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              new Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(AppImages
                                                        .MyMatchesWonBg),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                height: 30,
                                                child: new Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10, left: 12),
                                                  child: Center(
                                                    child: new Text(
                                                      'Total Affiliation: ' +
                                                          "${state.matchList[index].total_earned ?? "0.0"}",
                                                      style: TextStyle(
                                                        fontFamily: "Roboto",
                                                        color:
                                                            Color(0xff076e39),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {},
                              );
                            }),
                      )
                    : NoMatchesListFound()
              ],
            );
          } else {
            return SizedBox();
          }
        }),
      ),
    );
  }
}

//class _AffiliateMatchesState extends State<AffiliateMatches> {
  // late List<MatchDetails> state.matchList = [];
  // TextEditingController codeController = TextEditingController();
  // bool _enable = false;
  // late String userId = '0';

  // @override
  // void initState() {
  //   super.initState();
  //   AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
  //       .then((value) => {
  //             setState(() {
  //               userId = value;
  //               getAffiliateMatchData();
  //             })
  //           });
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }


  // void getAffiliateMatchData() async {
  //   AppLoaderProgress.showLoader(context);
  //   GeneralRequest loginRequest = new GeneralRequest(
  //       user_id: userId,
  //       start_date: widget.start_date,
  //       end_date: widget.end_date,
  //       page: '0');
  //   final client = ApiClient(AppRepository.dio);
  //   state.MatchListResponse state.matchListResponse =
  //       await client.getAffiliateMatchData(loginRequest);
  //   AppLoaderProgress.hideLoader(context);
  //   if (state.matchListResponse.status == 1) {
  //     state.matchList = state.matchListResponse.result!;
  //     setState(() {});
  //   }
  // }
// }
