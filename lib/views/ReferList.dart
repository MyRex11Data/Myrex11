import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/refer_list_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';

class ReferList extends StatefulWidget {
  @override
  _ReferListState createState() => _ReferListState();
}

class _ReferListState extends State<ReferList> {
  TextEditingController searchController = TextEditingController();
  late String userId = '0';
  late String totalUser = '0';
  List<ReferLIstItem> referList = [];
  var val;
  var groupValue;
  bool searchVisible = false;
  String? totalEarn = '0';

  @override
  void initState() {
    super.initState();
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                getReferBonusList();
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            /* set Status bar color in Android devices. */

            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/

            statusBarBrightness:
                Brightness.light) /* set Status bar icon color in iOS. */
        );
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          padding: EdgeInsets.only(top: 45, bottom: 12, left: 16, right: 16),
          decoration: BoxDecoration(color: primaryColor
              // image: DecorationImage(
              //   image: AssetImage("assets/images/Ic_creatTeamBackGround.png"),
              //   fit: BoxFit.cover,
              // ),
              ),
          child: Stack(
            children: [
              /// Normal AppBar Row
              if (!searchVisible)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            // width: 24,
                            height: 30,
                            child: Image.asset(
                              AppImages.backImageURL,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Refer List',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    // GestureDetector(
                    //   behavior: HitTestBehavior.translucent,
                    //   onTap: () {
                    //     setState(() {
                    //       searchVisible = true;
                    //     });
                    //   },
                    //   child: Icon(Icons.search, color: Colors.white, size: 20),
                    // ),
                  ],
                ),

              /// Search Bar Overlay
              if (searchVisible)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background
                    borderRadius: BorderRadius.circular(25), // Rounded edges
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center vertically
                    children: [
                      Icon(Icons.search, color: Colors.grey, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) => getReferBonusList(),
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle:
                                TextStyle(fontSize: 12, color: Colors.grey),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (searchController.text.isEmpty) {
                              FocusScope.of(context).unfocus();
                              searchVisible = false;
                            } else {
                              searchController.clear();
                              getReferBonusList();
                            }
                          });
                        },
                        child: Icon(Icons.clear, size: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Circular radius
              side: BorderSide(
                  color: borderColor, width: 0.7), // Border color and width
            ),
            child: new Column(
              children: [
                // new Divider(height: 2,thickness: 1,),
                new Container(
                  color: borderColor1,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  // margin: EdgeInsets.all(15),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Container(
                        child: new Text('Total Refer',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                      new Container(
                        child: new Text(totalUser,
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16)),
                      ),
                    ],
                  ),
                ),
                new Divider(
                  color: borderColor,
                  height: 0,
                  thickness: 1,
                ),
                ListView.builder(
                    itemCount: referList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          new Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                left: 15, right: 10, top: 10, bottom: 10),
                            child: new Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 13),
                                  height: 40,
                                  width: 40,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    child: CachedNetworkImage(
                                      imageUrl: referList[index].image ?? '',
                                      placeholder: (context, url) =>
                                          Image.asset(
                                              AppImages.defaultAvatarIconColor),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              AppImages.defaultAvatarIconColor),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                // new Container(
                                //   margin: EdgeInsets.only(right: 13),
                                //   height: 40,
                                //   width: 40,
                                //   child: new Image.asset(
                                //       AppImages.defaultAvatarIcon,
                                //       fit: BoxFit.fill),
                                // ),
                                new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Text(
                                      referList[index].name ?? '',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          if ((referList.indexOf(referList[index]) !=
                              referList.length - 1))
                            new Divider(
                              height: 2,
                              thickness: 1,
                            ),
                        ],
                      );
                    }),
                /* Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 16),
                    child: new Column(
                    children: List.generate(

                      referList.length,
                          (index) => new Column(
                        children: [
                          new Container(
                             color: Colors.white,
                            padding: EdgeInsets.only(left: 20,right: 10,top: 10,bottom: 10),
                            child: new Row(
                              children: [
                                new Container(
                                  margin: EdgeInsets.only(right: 13),
                                  height: 40,
                                  width: 40,
                                  child: new Image.asset(AppImages.defaultAvatarIcon,
                                      fit: BoxFit.fill),
                                ),
                                new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Text(
                                       referList[index].name==''?referList[index].email!:referList[index].name!,

                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          new Divider(height: 2,thickness: 1,),
                        ],
                      ),
                    ),
                ),
                  )*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getReferBonusList() async {
    AppLoaderProgress.showLoader(context);
    GeneralRequest loginRequest = new GeneralRequest(
        user_id: userId, search: searchController.text.toString(), page: '0');
    final client = ApiClient(AppRepository.dio);
    ReferBonusListResponse referBonusListResponse =
        await client.getReferBonusList(loginRequest);
    AppLoaderProgress.hideLoader(context);
    if (referBonusListResponse.status == 1) {
      totalEarn = referBonusListResponse.total_amount.toString();
      referList = referBonusListResponse.result!;
      totalUser = referBonusListResponse.total_user!.toString();
      setState(() {});
    }
  }
}
