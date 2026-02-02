import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/appUtilities/pickTeamBottomSheet.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/repository/model/team_response.dart';

import 'app_images.dart';

class SharebottomsheetUi extends StatefulWidget {
  String? teamSharingLink;
  GeneralModel? model;
  SharebottomsheetUi(this.teamSharingLink, this.model);
  // const Sharebottomsheet({super.key});

  @override
  State<SharebottomsheetUi> createState() => _SharebottomsheetState();
}

class _SharebottomsheetState extends State<SharebottomsheetUi> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 260,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 16,
          ),
          Text(
            'Share Team',
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 12,
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    launchTelegram(widget.teamSharingLink ?? "");
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 35,
                        child: Image.asset(AppImages.telegramIcon),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Telegram',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    openWhatsAppApp(widget.teamSharingLink ?? "");
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 35,
                        child: Image.asset(AppImages.whatsappIcon),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Whatsapp',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    onShare(context, widget.teamSharingLink.toString(),
                        widget.model!);
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 35,
                        child: Icon(Icons.share),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Share',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 26,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            width: MediaQuery.of(context).size.width,
            color: LightprimaryColor,
            child: Text(
              'Once the team is shared, other connot view changes\nmade to the team',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  color: Color(0xff1D3877)),
            ),
          )
        ],
      ),
    );
  }

  void launchTelegram(String message) async {
    final telegramAppUrl = "tg://msg?text=${Uri.encodeComponent(message)}";
    final telegramWebUrl =
        "https://t.me/share/url?url=${Uri.encodeComponent(message)}";

    if (await canLaunch(telegramAppUrl)) {
      await launch(telegramAppUrl);
    } else if (await canLaunch(telegramWebUrl)) {
      await launch(telegramWebUrl);
    } else {
      throw "Could not launch Telegram to share the message.";
    }
  }

  void openWhatsAppApp(String message) async {
    final whatsappAppUrl =
        "whatsapp://send?text=${Uri.encodeComponent(message)}";
    final whatsappWebUrl =
        "https://wa.me/?text=${Uri.encodeComponent(message)}";

    if (await canLaunch(whatsappAppUrl)) {
      await launch(whatsappAppUrl);
    } else if (await canLaunch(whatsappWebUrl)) {
      await launch(whatsappWebUrl); // Opens the WhatsApp web version
    } else {
      throw "Could not launch WhatsApp to share the message.";
    }
  }

  onShare(
      BuildContext context, String teamSharingLink, GeneralModel model) async {
    String shareBody = teamSharingLink;
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.share(shareBody,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}

class ShareBottomSheet {
  static openBottomSheet(
      BuildContext context, String teamSharingLink, GeneralModel model) {
    showModalBottomSheet(
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SharebottomsheetUi(teamSharingLink, model),
        );
      },
    );
  }

  static openBottomSheetPickTeam(BuildContext context, GeneralModel model,
      List<Team> teamList, Function createTeam, String userTeamName) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: PickTeamBottomSheet(model, teamList, createTeam, userTeamName),
        );
      },
    );
  }
}
