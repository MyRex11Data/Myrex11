import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:myrex11/util/customWidgets/customText.dart';

class PlayingHistory extends StatefulWidget {
  String? userId;
  PlayingHistory(this.userId, {Key? key}) : super(key: key);

  @override
  State<PlayingHistory> createState() => _PlayingHistoryState();
}

class _PlayingHistoryState extends State<PlayingHistory> {
  bool isLoading = false;
  String? contest = "";
  String? Matches = "";
  String? win = "";
  String? total_winning = "";
  String? league_close = "";
  String? series = "";

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55), // Set this height
        child: Container(
          padding: EdgeInsets.only(
            top: 50,
            bottom: 12,
            left: 16,
          ),
          decoration: BoxDecoration(color: primaryColor

              //  borderRadius: BorderRadius.circular(12), // Add border radius if needed
              // border: Border.all(color: Colors.grey, width: 2), // Optional border
              ),
          child: Row(
            children: [
              new GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => {Navigator.pop(context)},
                child: new Container(
                  padding: EdgeInsets.only(left: 0, right: 8),
                  alignment: Alignment.centerLeft,
                  child: new Container(
                    // width: 24,
                    height: 30,
                    child: Image(
                      image: AssetImage(AppImages.backImageURL),
                      fit: BoxFit.fill,
                      // color: headingColor,
                    ),
                  ),
                ),
              ),
              Text("Playing History",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16)),
            ],
          ),
        ),
      ),

      /* appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            new GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => {Navigator.pop(context)},
              child: new Container(
                padding: EdgeInsets.only(left: 0, right: 8),
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
            Text("Playing History",
                style: TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
          ],
        ),
        //CustomText(title: _controller.title, color: Colors.white),
        backgroundColor: primaryColor,
      ),*/
    );
  }

  Widget _body() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: primaryColor,
          ))
        : Container(
            decoration: BoxDecoration(
                //image: DecorationImage(image: AssetImage(AppImages.commanBackground),fit: BoxFit.cover),
                color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  // Row with horizontal scrolling
                  itemCard(
                      image: AppImages.contest_icon,
                      title: 'Contests',
                      point: '$contest'),
                  itemCard(
                      image: AppImages.matches_icon,
                      title: 'Matches',
                      point: '$Matches'),
                  itemCard(
                      image: AppImages.series_icon,
                      title: 'Series',
                      point: '$series'),
                  itemCard(
                      image: AppImages.win_icon, title: 'Win', point: '$win'),

                  // Last row for total winnings
                  itemCard(
                      image: AppImages.gstimage,
                      title: 'Total Winning',
                      point: '$total_winning',
                      color: Colors.white),
                ],
              ),
            ),
          );
  }

  Widget itemCard({String? image, String? title, String? point, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        // width: MediaQuery.of(context).size.width * 0.45, // Adjusted width
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
              side: BorderSide(color: borderColor, width: 0.7)),
          color: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(
                      image: AssetImage(
                        "$image",
                      ),
                      height: 60,
                      width: 60,
                      // color: color,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: CustomText(
                        title: "$title",
                        color: Color(0xff757575),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (color != null)
                      Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Container(
                          height: 18,
                          // width: 14,
                          child: Image.asset(AppImages.goldcoin),
                        ),
                      ),
                    CustomText(
                      title: "$point",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff565050),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getData() async {
    isLoading = true;
    setState(() {});
    GeneralRequest generalRequest = new GeneralRequest(
      user_id: widget.userId,
    );
    final client = ApiClient(AppRepository.dio);
    dynamic dataResponse = await client.playingHistoryResponse(generalRequest);

    if (dataResponse['status'] == 1) {
      setState(() {
        contest = dataResponse['result']['contest'].toString();
        Matches = dataResponse['result']['Matches'].toString();
        win = dataResponse['result']['win'].toString();
        total_winning = dataResponse['result']['total_winning'].toString();
        league_close = dataResponse['result']['league_close'].toString();
        series = dataResponse['result']['series'].toString();
      });
    }
    isLoading = false;
    setState(() {});
  }
}
