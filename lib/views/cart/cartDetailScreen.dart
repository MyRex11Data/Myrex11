import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/buildType.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/cartDetailsResponse.dart';
import 'package:myrex11/repository/model/contest_request.dart';
import 'package:myrex11/repository/model/contest_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:myrex11/views/AddBalance.dart';
import 'package:myrex11/views/cart/contestcart.dart';
import 'package:http/http.dart' as http;

class CartDetailScreen extends StatefulWidget {
  GeneralModel model;

  String userId;
  String matchKey;
  Map<String, String> teamsListArray;

  CartDetailScreen(this.model, this.userId, this.matchKey, this.teamsListArray);
  @override
  State<CartDetailScreen> createState() => _CartDetailScreenState();
}

class _CartDetailScreenState extends State<CartDetailScreen> {
  String balance = '0';
  List<ContestCart> contestList = [];
  List<ContestCartTeam> cartresult = [];
  Map<int, int> selectedChallenges = {};
  String userId = '';
  final TextEditingController templateNameController = TextEditingController();

  bool isExpand = false;
  FocusNode focusNode = FocusNode();

  bool isloading = false;
  int total_cart_amount = 0;
  int? low_balance = 0;
  String? required_balance = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppPrefrence.getString(AppConstants.KEY_USER_BALANCE).then((value) => {
          setState(() {
            balance = value;
          })
        });

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                getCartContests();
              })
            });
  }

  //  CartDetailScreen();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            focusNode.unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                _header(),
                Expanded(
                    child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: cartresult.length > 0
                      ? Column(
                          children: [
                            _templateName(),
                            const SizedBox(height: 12),
                            ListView.builder(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cartresult.length, // contest count
                              itemBuilder: (context, index) {
                                return teamExpansionTile(cartresult[index]);
                              },
                            ),
                            // const SizedBox(height: 80),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 150,
                            ),
                            Container(
                              height: 200,
                              child:
                                  Image.asset('assets/images/emptyCart.webp'),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'No items added to the cart',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                )),
                _bottomButton(),
              ],
            ),
          ),
        ),
        if (isloading == true)
          Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
      ],
    );
  }

  void deleteCartItems({
    required String matchKey,
    required String userId,
    required String teamId,
  }) async {
    try {
      setState(() {
        isloading = true;
      });
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppRepository.dio.options.baseUrl}api/auth/delete-cart-items',
        ),
      );

      /// HEADERS
      request.headers['Authorization'] = AppConstants.token;
      request.headers['Devicetype'] = Platform.isIOS
          ? 'IOS'
          : Platform.isAndroid
              ? 'ANDROID'
              : 'WEB';
      request.headers['Versioncode'] = AppConstants.versionCode;
      request.headers['Accept'] = 'application/json';

      /// REQUEST FIELDS
      request.fields['matchkey'] = matchKey;
      request.fields['user_id'] = userId;
      request.fields['team_id'] = teamId;

      /// DEBUG LOGS
      print('=== DELETE CART ITEMS REQUEST ===');
      print('URL: ${request.url}');
      print('Headers: ${request.headers}');
      print('Fields: ${request.fields}');
      print('================================');

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      print('=== DELETE CART ITEMS RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: $jsonResponse');
      print('=================================');

      if (jsonResponse['status'] == 1) {
        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? 'Challenges deleted successfully!',
        );
        getCartContests();
        // return true;
      } else {
        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? 'Something went wrong!',
        );
        // return false;
      }
    } catch (e) {
      print('Error deleting cart items: $e');
      Fluttertoast.showToast(msg: 'Oops! Something went wrong.');
      // return false;
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  void cartProceed({
    required String matchKey,
    required String userId,
    required String sportKey,
    required String templateName,
  }) async {
    try {
      setState(() {
        isloading = true;
      });
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppRepository.dio.options.baseUrl}api/auth/cart-proceed',
        ),
      );

      /// HEADERS
      request.headers['Authorization'] = AppConstants.token;
      request.headers['Devicetype'] = Platform.isIOS
          ? 'IOS'
          : Platform.isAndroid
              ? 'ANDROID'
              : 'WEB';
      request.headers['Versioncode'] = AppConstants.versionCode;
      request.headers['Accept'] = 'application/json';

      /// REQUEST FIELDS
      request.fields['matchkey'] = matchKey;
      request.fields['user_id'] = userId;
      request.fields['sport_key'] = sportKey;
      request.fields['template'] = templateName;

      /// DEBUG LOGS
      print('=== CART PROCEED REQUEST ===');
      print('URL: ${request.url}');
      print('Headers: ${request.headers}');
      print('Fields: ${request.fields}');
      print('===========================');

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      print('=== CART PROCEED RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: $jsonResponse');
      print('============================');

      if (jsonResponse['status'] == 1) {
        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? 'Cart Items Purchased Successfully!',
        );

        // Refresh cart / navigate if needed
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? 'Cart Items Purchase Failed!',
        );
      }
    } catch (e) {
      print('Error in cart proceed: $e');
      Fluttertoast.showToast(msg: 'Oops! Something went wrong.');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  // 🔹 HEADER
  Widget _header() {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 45, bottom: 15, right: 16),
      decoration: BoxDecoration(
        color: primaryColor,
        // borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        children: [
          AppConstants.backButtonFunction(),
          // const SizedBox(width: 10),
          const Text(
            'Cart',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          // const Spacer(),
          // Padding(
          //   padding: const EdgeInsets.only(right: 0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //         border: Border.all(color: Colors.white),
          //         borderRadius: BorderRadius.all(Radius.circular(8))),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.only(right: 10),
          //             child: Image.asset(
          //               AppImages.cartIcon,
          //               height: 30,
          //               // width: 70,
          //             ),
          //           ),
          //           Image.asset(AppImages.goldcoin, height: 18),
          //           SizedBox(width: 6),
          //           Text(
          //             balance,
          //             style: TextStyle(
          //                 fontSize: 14,
          //                 fontWeight: FontWeight.w600,
          //                 color: Colors.white),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  void getCartContests() async {
    setState(() {
      isloading = true;
    });
    ContestRequest contestRequest = ContestRequest(
      user_id: userId,
      matchkey: widget.model.matchKey,
      sport_key: widget.model.sportKey,
      fantasy_type: widget.model.fantasyType.toString(),
      slotes_id: widget.model.slotId.toString(),
      category_id: widget.model.categoryId.toString(),
      fantasy_type_id: CricketTypeFantasy.getCricketType(
        widget.model.fantasyType.toString(),
        sportsKey: widget.model.sportKey,
      ),
    );

    final client = ApiClient(AppRepository.dio);
    ContestCartResponse response = await client.getCartDetails(contestRequest);

    if (response.status == 1 && response.result != null) {
      /// ✅ FLATTEN contests from all teams
      cartresult = response.result ?? [];
      total_cart_amount = response.total_cart_amount ?? 0;

      low_balance = response.low_balance ?? 0;
      required_balance = response.required_balance ?? '0';
      templateNameController.text = response.template ?? '';
    } else {
      Fluttertoast.showToast(msg: response.message ?? '');
    }

    setState(() {
      isloading = false;
    });
  }

  // 🔹 TEMPLATE NAME
  Widget _templateName() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: _cardDecoration(),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: templateNameController, // define this controller
                  decoration: const InputDecoration(
                    hintText: 'Template Name',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  focusNode.requestFocus();
                },
                child: const Icon(
                  Icons.edit,
                  color: Color(0xFF9B6BFF),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 TEAM CARD
  Widget teamExpansionTile(ContestCartTeam cartresult) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _cardDecoration(),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpand,
          onExpansionChanged: (value) {
            setState(() {
              isExpand = value;
            });
          },
          showTrailingIcon: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          childrenPadding: const EdgeInsets.only(bottom: 12),
          title: Row(
            children: [
              Text(cartresult.team_text ?? '',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              Spacer(),
              Image.asset(AppImages.goldcoin, height: 18),
              SizedBox(width: 6),
              Text(cartresult.total_amount.toString()),
              SizedBox(width: 12),
              _icon(AppImages.cartpreview),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectionOfCartScreen(
                          widget.model,
                          widget.teamsListArray,
                          userId,
                          widget.model.matchKey ?? '',
                          teamid: cartresult.team_id,
                          isEdit: 1,
                        ),
                      ),
                    );
                  },
                  child: _icon(AppImages.cartedit)),
              GestureDetector(
                  onTap: () {
                    showDeleteTeamPopup(
                        context: context,
                        matchKey: cartresult.matchkey ?? '',
                        userId: userId,
                        teamId: cartresult.team_id ?? '');
                  },
                  child: _icon(AppImages.cartempty)),
            ],
          ),
          children: [
            ListView.builder(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartresult.contest!.length, // contest count
              itemBuilder: (context, indexdf) {
                return _prizePoolCard(cartresult.contest![indexdf]);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteTeamPopup({
    required BuildContext context,
    required String matchKey,
    required String userId,
    required String teamId,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Delete",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to delete the cart items?",
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: LightprimaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: primaryColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
                deleteCartItems(
                    matchKey: matchKey ?? '',
                    userId: userId,
                    teamId: teamId ?? '');
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Widget _prizePoolCard(ContestCart data) {
    bool isSelected = selectedChallenges.containsKey(data.id);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Color(0xffE1E1E1), width: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP SECTION
          Padding(
            padding: const EdgeInsets.all(12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// LEFT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // GestureDetector(
                              //   onTap: () {
                              //     //toggleChallenge(data.id!, data.qty ?? 1);
                              //   },
                              //   child: Icon(
                              //     isSelected
                              //         ? Icons.radio_button_checked
                              //         : Icons.radio_button_unchecked,
                              //     size: 25,
                              //     color: isSelected
                              //         ? const Color(0xff7B3FE4)
                              //         : Colors.grey,
                              //   ),
                              // ),
                              // SizedBox(width: 6),
                              Text(
                                'Current Prize Pool',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              // if (data.is_offer_team == 1) ...[
                              //   SizedBox(width: 6),
                              //   Image.asset(AppImages.offer, scale: 3),
                              // ]
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Image.asset(AppImages.goldcoin, height: 18),
                              SizedBox(width: 6),
                              Text(
                                '${data.win_amount}',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),

                    /// RIGHT
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Entry Fee',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 6),

                        /// ENTRY FEE
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xff076e39),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Image.asset(AppImages.goldcoin, height: 14),
                              SizedBox(width: 4),
                              Text(
                                '${data.entryfee}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),

                        /// QTY SELECTOR
                        Row(
                          children: [
                            const Text(
                              'Qty:',
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 6),

                            /// MINUS
                            // GestureDetector(
                            //   onTap: () {
                            //     if ((data.quantity ?? 1) > 1) {
                            //       setState(() {
                            //         data.quantity = data.quantity! - 1;
                            //       });
                            //       updateQty(data.id!, data.quantity!);
                            //     }
                            //   },
                            //   child: _qtyButton(Icons.remove),
                            // ),

                            Container(
                              // width: 36,
                              alignment: Alignment.center,
                              child: Text(
                                (data.quantity ?? 1).toString().padLeft(2, '0'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            /// PLUS
                            // GestureDetector(
                            //   onTap: () {
                            //     setState(() {
                            //       data.quantity = (data.quantity ?? 1) + 1;
                            //     });
                            //     updateQty(data.id!, data.quantity!);
                            //   },
                            //   child: _qtyButton(Icons.add),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 105),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${data.maximum_user!} Spots',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0XFF666666),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      LinearProgressIndicator(
                        value: data.joinedusers! / data.maximum_user!,
                        minHeight: 6,
                        backgroundColor: Color(0xffEDEDED),
                        color: Color(0xffA66DFB),
                      ),
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${data.maximum_user! - data.joinedusers!} Spots Left',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff2E7D32),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          /// BONUS CHIP

          /// FOOTER
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF1E7FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (data.is_bonus == 1)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppImages.bonus_icon,
                          height: 14,
                          color: Color(0XFF666666),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${data.bonus_percent}% Bonus',
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                Spacer(),
                _footerItem(
                    AppImages.winnerMedalIcon, '${data.first_rank_prize}'),
                if (data.multi_entry == 1)
                  _footerItem(AppImages.multiEntry, ''),
                if (data.confirmed_challenge == 1)
                  _footerItem(AppImages.confirmIcon, 'Guaranteed'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon) {
    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        color: LightprimaryColor,
        border: Border.all(color: LightprimaryColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16),
    );
  }

  Widget _footerItem(String icon, String text) {
    return Row(
      children: [
        SizedBox(width: 6),
        Image.asset(
          icon,
          height: 14,
          color: Color(0XFF666666),
        ),
        SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  void updateQty(int challengeId, int qty) {
    if (selectedChallenges.containsKey(challengeId)) {
      setState(() {
        selectedChallenges[challengeId] = qty;
      });
    }
    print(selectedChallenges);
  }

  // 🔹 BOTTOM BUTTON
  Widget _bottomButton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius: 10,
        //     color: Colors.black12,
        //   )
        // ],
      ),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonGreenColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(
                color: Color(0xFF6A0BF8),
                width: 2,
              ),
            ),
          ),
          onPressed: () {
            if (cartresult.length == 0) {
              Navigator.pop(context);
              Fluttertoast.showToast(msg: 'No items added to the cart');
            } else if (templateNameController.text.isEmpty) {
              Fluttertoast.showToast(msg: 'Please enter template name');
            } else {
              if (low_balance == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddBalance(
                              '',
                              entryFee: required_balance,
                              isFromCheck: 'joinpopup',
                            ))).then((value) {
                  getCartContests();
                });
              } else {
                cartProceed(
                    matchKey: widget.model.matchKey ?? '',
                    userId: userId,
                    sportKey: widget.model.sportKey ?? '',
                    templateName: templateNameController.text);
              }
            }
          },
          child: const Text(
            'PROCESS WITH CART',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // 🔹 HELPERS
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    );
  }

  Widget _icon(String icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
          height: 30,
          child: Image.asset(
            icon,
          )),
    );
  }
}

class _qtyButton extends StatelessWidget {
  final IconData icon;
  const _qtyButton(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16),
    );
  }
}

class _chip extends StatelessWidget {
  final String text;
  const _chip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1ECFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    );
  }
}
