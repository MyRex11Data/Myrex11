import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:http/http.dart' as http;
import 'package:myrex11/appUtilities/buildType.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
import 'package:myrex11/repository/model/contest_request.dart';
import 'package:myrex11/repository/model/contest_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:myrex11/views/cart/cartDetailScreen.dart';

class SelectionOfCartScreen extends StatefulWidget {
  GeneralModel model;
  Map<String, String> teamsListArray;
  String userId;
  String matchKey;
  String? teamid;
  int? isEdit;
  SelectionOfCartScreen(
      this.model, this.teamsListArray, this.userId, this.matchKey,
      {this.teamid, this.isEdit});

  @override
  State<SelectionOfCartScreen> createState() => _SelectionOfCartScreenState();
}

class _SelectionOfCartScreenState extends State<SelectionOfCartScreen> {
  Map<String, String> sportsListArra = {};
  Map<String, String> tempListArray = {};
  String? selectedTeam;
  String? selectedSpot;
  String? selectedTemplate;
  String? selectedTeamId;
  List<Contest> contestList = [];
  Map<int, int> selectedChallenges = {};
  bool isSelected = false;

  String? expandedFilter; // 'TEAM', 'SPOTS', 'TEMPLATE'
  final ExpansionTileController teamController = ExpansionTileController();
  final ExpansionTileController spotsController = ExpansionTileController();
  final ExpansionTileController templateController = ExpansionTileController();
  final tooltipController = JustTheController();
  Map<String, TextEditingController> quantityControllers =
      {}; // Individual controllers
  final ScrollController _scrollController = ScrollController();
  Map<int, FocusNode> quantityFocusNodes = {};

  String balance = '0';

  final Map<int, int> _cachedEntryFee = {}; // contestId → entryFee
  final Map<int, int> _cachedquantity = {};

  bool isloading = false; // contestId → quantity

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppPrefrence.getString(AppConstants.KEY_USER_TOTAL_BALANCE)
        .then((value) => {
              setState(() {
                balance = value;
              })
            });
    if (widget.isEdit == 1) {
      setState(() {
        selectedTeam = widget.teamid;
      });
    }
    getCartSports();
    getCarttemp();
  }

  @override
  void dispose() {
    for (final c in quantityControllers.values) {
      c.dispose();
    }
    for (final f in quantityFocusNodes.values) {
      f.dispose();
    }
    super.dispose();
  }

  Future<Map<String, String>> getCartSports() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppRepository.dio.options.baseUrl}api/auth/get-cart-spots',
        ),
      );

      request.headers['Authorization'] = AppConstants.token;
      request.headers['Devicetype'] = Platform.isIOS
          ? 'IOS'
          : Platform.isAndroid
              ? 'ANDROID'
              : 'WEB';
      request.headers['Versioncode'] = AppConstants.versionCode;
      request.headers['Accept'] = 'application/json';

      // 🔹 Request fields
      request.fields['user_id'] = widget.userId;
      request.fields['matchkey'] = widget.matchKey ?? '';

      print('=== REQUEST DETAILS ===');
      print('URL: ${request.url}');
      print('Method: ${request.method}');
      print('Headers: ${request.headers}');
      print('Fields: ${request.fields}');
      print('=======================');

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      print('=== RESPONSE DETAILS ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: $jsonResponse');
      print('========================');

      if (jsonResponse['status'] == 1) {
        Map<String, dynamic> result =
            Map<String, dynamic>.from(jsonResponse['result']);

        // Convert dynamic map → String map
        setState(() {
          result.forEach((key, value) {
            sportsListArra[key] = value.toString();
          });
        });
      } else {
        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? 'Failed to fetch data',
        );
      }
    } catch (e) {
      print('Error fetching cart teams: $e');
      Fluttertoast.showToast(msg: 'Oops something went wrong...');
    }

    return sportsListArra;
  }

  Future<Map<String, String>> getCarttemp() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppRepository.dio.options.baseUrl}api/auth/get-cart-templates',
        ),
      );

      request.headers['Authorization'] = AppConstants.token;
      request.headers['Devicetype'] = Platform.isIOS
          ? 'IOS'
          : Platform.isAndroid
              ? 'ANDROID'
              : 'WEB';
      request.headers['Versioncode'] = AppConstants.versionCode;
      request.headers['Accept'] = 'application/json';

      // 🔹 Request fields
      request.fields['user_id'] = widget.userId;
      request.fields['matchkey'] = widget.matchKey ?? '';

      print('=== REQUEST DETAILS ===');
      print('URL: ${request.url}');
      print('Method: ${request.method}');
      print('Headers: ${request.headers}');
      print('Fields: ${request.fields}');
      print('=======================');

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      print('=== RESPONSE DETAILS ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: $jsonResponse');
      print('========================');

      if (jsonResponse['status'] == 1) {
        Map<String, dynamic> result =
            Map<String, dynamic>.from(jsonResponse['result']);

        setState(() {
          result.forEach((key, value) {
            tempListArray[key] = value.toString();
          });
        });
      } else {
        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? 'Failed to fetch data',
        );
      }
    } catch (e) {
      print('Error fetching cart teams: $e');
      Fluttertoast.showToast(msg: 'Oops something went wrong...');
    }

    return tempListArray;
  }

  Future<Map<String, String>> AddTocart() async {
    try {
      setState(() {
        isloading = true;
      });
      final List<Map<String, String>> cart = selectedChallenges.entries
          .map((e) => {
                "challenge_id": e.key.toString(),
                "quantity": e.value.toString(),
              })
          .toList();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppRepository.dio.options.baseUrl}api/auth/add-cart-items',
        ),
      );

      request.headers['Authorization'] = AppConstants.token;
      request.headers['Devicetype'] = Platform.isIOS
          ? 'IOS'
          : Platform.isAndroid
              ? 'ANDROID'
              : 'WEB';
      request.headers['Versioncode'] = AppConstants.versionCode;
      request.headers['Accept'] = 'application/json';

      // 🔹 Request fields
      request.fields['user_id'] = widget.userId;
      request.fields['matchkey'] = widget.matchKey ?? '';
      request.fields['team_id'] = selectedTeam ?? '';
      request.fields['sport_key'] = widget.model.sportKey ?? '';
      request.fields['isEdit'] = widget.isEdit.toString() ?? '0';
      request.fields['template_id'] = selectedTemplate ?? '';
      request.fields['cart'] = jsonEncode(cart);

      print('=== REQUEST DETAILS ===');
      print('URL: ${request.url}');
      print('Method: ${request.method}');
      print('Headers: ${request.headers}');
      print('Fields: ${request.fields}');
      print('=======================');

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      print('=== RESPONSE DETAILS ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: $jsonResponse');
      print('========================');

      if (jsonResponse['status'] == 1) {
        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? 'Failed to fetch teams',
        );
        // Map<String, dynamic> result =
        //     Map<String, dynamic>.from(jsonResponse['result']);

        // setState(() {
        //   result.forEach((key, value) {
        //     tempListArray[key] = value.toString();
        //   });
        // });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CartDetailScreen(
                    widget.model,
                    widget.userId,
                    widget.matchKey,
                    widget.teamsListArray))).then((value) {
          // selectedChallenges.clear();
        });
      } else {
        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? 'Failed to fetch ',
        );
      }
    } catch (e) {
      print('Error fetching cart teams: $e');
      Fluttertoast.showToast(msg: 'Oops something went wrong...');
    } finally {
      setState(() {
        isloading = false;
      });
    }

    return tempListArray;
  }

  void getCartContests() async {
    setState(() {
      isloading = true;
    });
    ContestRequest contestRequest = new ContestRequest(
        user_id: widget.userId,
        matchkey: widget.model.matchKey,
        sport_key: widget.model.sportKey,
        fantasy_type: widget.model.fantasyType.toString(),
        slotes_id: widget.model.slotId.toString(),
        category_id: widget.model.categoryId.toString(),
        // entryfee: entryFee.join(","),
        // page: pageNumber.toString(),
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            widget.model.fantasyType.toString(),
            sportsKey: widget.model
                .sportKey) /*widget.model.fantasyType==1?"7":widget.model.fantasyType==2?"6":"0"*/,
        // winning: winning.join(","),
        // contest_type: contest_type.join(","),
        // contest_size: contest_size.join(",")
        spots: selectedSpot,
        teamid: selectedTeam,
        isEdit: widget.isEdit ?? 0);
    final client = ApiClient(AppRepository.dio);
    ContestResponse response = await client.getCartContests(contestRequest);
    if (response.status == 1) {
      //isPagination = false;

      //pageNumber++;
      // contestList = response.result!.contest!;
      widget.model.allContest = 'viewall';
      contestList = response.result!.contest ?? [];
      if (widget.isEdit == 1) {
        buildSelectedChallenges();
      }
      //widget.model.teamCount = response.result!.user_teams;
    }

    // Fluttertoast.showToast(msg: myBalanceResponse.message!, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
    setState(() {
      // scrollValue = true;

      isloading = false;
    });
  }

  void getTempContests() async {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> contestRequest = {
      "user_id": widget.userId,
      "matchkey": widget.model.matchKey,
      "sport_key": widget.model.sportKey,
      "fantasy_type": widget.model.fantasyType.toString(),
      "slotes_id": widget.model.slotId.toString(),
      "category_id": widget.model.categoryId.toString(),
      "fantasy_type_id": CricketTypeFantasy.getCricketType(
        widget.model.fantasyType.toString(),
        sportsKey: widget.model.sportKey,
      ),
      "spots": selectedSpot,
      "teamid": selectedTeam,
      "isEdit": widget.isEdit ?? 0,
      "template_id": selectedTemplate,
    };

    final client = ApiClient(AppRepository.dio);
    ContestResponse response = await client.getTempContests(contestRequest);
    if (response.status == 1) {
      //isPagination = false;

      //pageNumber++;
      // contestList = response.result!.contest!;
      widget.model.allContest = 'viewall';
      contestList = response.result!.contest ?? [];

      buildSelectedChallenges();

      //widget.model.teamCount = response.result!.user_teams;
    }

    // Fluttertoast.showToast(msg: myBalanceResponse.message!, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
    setState(() {
      isloading = false;
    });
  }

  void buildSelectedChallenges() {
    for (final contest in contestList) {
      if (contest.is_selected == 1 && contest.id != null) {
        selectedChallenges[contest.id!] = contest.quantity ?? 1;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(65), // Set this height
              child: Container(
                padding: EdgeInsets.only(
                  top: 40,
                  bottom: 12,
                  left: 16,
                ),
                decoration: BoxDecoration(color: primaryColor
                    // image: DecorationImage(
                    //     image: AssetImage(
                    //         "assets/images/Ic_creatTeamBackGround.png"),
                    //     fit: BoxFit.cover)

                    ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => {Navigator.pop(context)},
                      child: new Container(
                        padding: EdgeInsets.only(left: 0, right: 8),
                        alignment: Alignment.centerLeft,
                        child: new Container(
                          height: 30,
                          child: Image(
                            image: AssetImage(AppImages.backImageURL),
                            fit: BoxFit.fill,
                            // color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Text("Selection of Cart",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartDetailScreen(
                                      widget.model,
                                      widget.userId,
                                      widget.matchKey,
                                      widget.teamsListArray))).then((value) {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image.asset(
                                    AppImages.cartIcon,
                                    height: 30,
                                    // width: 70,
                                  ),
                                ),
                                Image.asset(AppImages.goldcoin, height: 18),
                                SizedBox(width: 6),
                                Text(
                                  balance,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 60,
                    ),
                    // spotsList: ['10 Spots', '20 Spots', '50 Spots'],
                    // templateList: ['Classic', 'Mega', 'H2H'],

                    contestList.length > 0
                        ? Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: contestList.length,
                              itemBuilder: (_, i) =>
                                  _prizePoolCard(contestList[i]),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 100,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 200,
                                  child: Image.asset(
                                      'assets/images/empty_contest.webp'),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  'No item found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    if (selectedChallenges.isNotEmpty) _bottomBar(),
                  ],
                ),
                _filters(
                  teamList: widget.teamsListArray,
                  spotsList: sportsListArra,
                  templateList: tempListArray,
                  selectedTeam: selectedTeam,
                  selectedSpot: selectedSpot,
                  selectedTemplate: selectedTemplate,
                  onTeamChanged: (val) {
                    setState(() => selectedTeam = val);
                  },
                  onSpotChanged: (val) {
                    if (selectedTeam == null) {
                      Fluttertoast.showToast(msg: 'Please select your team');
                    } else {
                      setState(() => selectedSpot = val);
                      // selectedChallenges.clear();
                      getCartContests();
                    }
                  },
                  onTemplateChanged: (val) {
                    if (selectedTeam == null) {
                      Fluttertoast.showToast(msg: 'Please select your team');
                    } else {
                      setState(
                        () => selectedTemplate = val,
                      );
                      getTempContests();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        if (isloading == true)
          Center(
              child: CircularProgressIndicator(
            color: primaryColor,
          ))
      ],
    );
  }

  Widget _filters({
    required Map<String, String> teamList,
    required Map<String, String> spotsList,
    required Map<String, String> templateList,
    required String? selectedTeam,
    required String? selectedSpot,
    required String? selectedTemplate,
    required Function(String?) onTeamChanged,
    required Function(String?) onSpotChanged,
    required Function(String?) onTemplateChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _filterExpansion(
                title: 'TEAM',
                controller: teamController,
                items: teamList,
                selectedValue: selectedTeam,
                onChanged: (value) {
                  if (widget.isEdit == 1) {
                    Fluttertoast.showToast(
                      timeInSecForIosWeb: 2,
                      msg:
                          "You can’t update this team. Select the spots to proceed.",
                    );

                    teamController.collapse();
                  } else {
                    onTeamChanged(value);
                    teamController.collapse(); // ✅ CLOSES
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _filterExpansion(
                title: 'SPOTS',
                controller: spotsController,
                items: spotsList,
                selectedValue: selectedSpot,
                onChanged: (value) {
                  onSpotChanged(value);
                  spotsController.collapse();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _filterExpansion(
                title: 'TEMPLATE',
                controller: templateController,
                items: templateList,
                selectedValue: selectedTemplate,
                onChanged: (value) {
                  onTemplateChanged(value);
                  templateController.collapse();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterExpansion({
    required String title,
    required Map<String, String> items,
    required String? selectedValue,
    required Function(String?) onChanged,
    required ExpansionTileController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isEdit == 1 && title == 'TEAM'
            ? Colors.grey
            : LightprimaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ExpansionTile(
        minTileHeight: 40,
        controller: controller, // ✅ KEY FIX
        tilePadding: const EdgeInsets.only(
          left: 8,
          right: 2,
        ),
        childrenPadding: const EdgeInsets.only(bottom: 6),
        title: Text(
          selectedValue != null
              ? title == 'SPOTS'
                  ? 'Spots ${items[selectedValue]!}'
                  : items[selectedValue]!
              : title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: selectedValue != null ? 12 : 11,
              fontWeight: FontWeight.w500),
        ),
        children: items.entries.map((entry) {
          return InkWell(
            onTap: () => onChanged(entry.key),
            child: Column(
              children: [
                Divider(
                  height: 1,
                  color: Colors.white,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      color: items[selectedValue] == entry.value
                          ? primaryColor
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void toggleChallenge(int challengeId, int quantity) {
    setState(() {
      if (selectedChallenges.containsKey(challengeId)) {
        selectedChallenges.remove(challengeId); // unselect
      } else {
        selectedChallenges[challengeId] = quantity; // select with quantity
      }
    });

    print(selectedChallenges);
  }

  void updatequantity(int challengeId, int quantity) {
    if (selectedChallenges.containsKey(challengeId)) {
      setState(() {
        selectedChallenges[challengeId] = quantity;
      });
    }
    print(selectedChallenges);
  }

  Widget _prizePoolCard(Contest data) {
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
                              GestureDetector(
                                onTap: () {
                                  toggleChallenge(data.id!, data.quantity ?? 1);
                                },
                                child: Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  size: 25,
                                  color: isSelected
                                      ? const Color(0xff7B3FE4)
                                      : Colors.grey,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Current Prize Pool',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              if (data.is_offer_team == 1) ...[
                                SizedBox(width: 6),
                                Image.asset(AppImages.offer, scale: 3),
                              ]
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

                        /// quantity SELECTOR
                        /// quantity SELECTOR
                        Row(
                          children: [
                            const Text(
                              'Qty:',
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 6),

                            /// MINUS
                            GestureDetector(
                              onTap: () {
                                if ((data.quantity ?? 1) > 1) {
                                  setState(() {
                                    data.quantity = data.quantity! - 1;

                                    // Update TextField if you want a controller
                                    if (!quantityControllers
                                        .containsKey(data.id!)) {
                                      quantityControllers[data.id.toString()] =
                                          TextEditingController(
                                              text: data.quantity.toString());
                                    } else {
                                      quantityControllers[data.id!]!.text =
                                          data.quantity.toString();
                                    }
                                  });
                                  updatequantity(data.id!,
                                      data.quantity!); // pass String id
                                }
                              },
                              child: _quantityButton(
                                Icons.remove,
                              ),
                            ),

                            /// TEXT FIELD
                            SizedBox(
                              width: 40,
                              height: 24,
                              child: TextFormField(
                                maxLines: 1,
                                scrollPhysics: BouncingScrollPhysics(),
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(fontSize: 14),
                                controller: quantityControllers.putIfAbsent(
                                  data.id.toString(),
                                  () => TextEditingController(
                                    text: (data.quantity ?? 1).toString(),
                                  ),
                                ),
                                focusNode: quantityFocusNodes.putIfAbsent(
                                  data.id!,
                                  () => FocusNode(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  // LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: const InputDecoration(
                                  isDense: true,
                                  counterText: '',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 2),
                                ),
                                onChanged: (value) {
                                  final quantity = int.tryParse(value);
                                  if (quantity != null && quantity > 0) {
                                    data.quantity = quantity;
                                    updatequantity(data.id!, quantity);
                                  }
                                },
                              ),
                            ),

                            /// PLUS
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  data.quantity = (data.quantity ?? 1) + 1;

                                  if (!quantityControllers
                                      .containsKey(data.id!)) {
                                    quantityControllers[data.id.toString()] =
                                        TextEditingController(
                                            text: data.quantity.toString());
                                  } else {
                                    quantityControllers[data.id!]!.text =
                                        data.quantity.toString();
                                  }
                                });
                                updatequantity(data.id!, data.quantity!);
                              },
                              child: _quantityButton(Icons.add),
                            ),
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

  Widget _quantityButton(IconData icon) {
    return Container(
      height: 22,
      width: 22,
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

  // ---------------- BOTTOM ----------------
  Widget _bottomBar() {
    final contestMap = {for (var c in contestList) c.id: c};

    // 🔥 Step 0: REMOVE unselected items
    _cachedEntryFee.removeWhere(
      (id, _) => !selectedChallenges.containsKey(id),
    );
    _cachedquantity.removeWhere(
      (id, _) => !selectedChallenges.containsKey(id),
    );

    // 🔥 Step 1: ADD / UPDATE selected items
    selectedChallenges.forEach((id, quantity) {
      if (_cachedEntryFee.containsKey(id)) {
        _cachedquantity[id] = quantity;
        return;
      }

      final challenge = contestMap[id];
      if (challenge != null) {
        _cachedEntryFee[id] = int.tryParse(challenge.entryfee) ?? 0;
        _cachedquantity[id] = quantity;
      }
    });

    // 🔥 Step 2: Build UI from cache
    int totalSum = 0;
    List<Widget> rows = [];

    _cachedEntryFee.forEach((id, entryFee) {
      final quantity = _cachedquantity[id] ?? 0;
      totalSum += entryFee * quantity;

      rows.add(
        Text(
          '$entryFee x $quantity = ${entryFee * quantity}',
          style:
              TextStyle(fontSize: 13, color: textcolor, fontFamily: 'Roboto'),
        ),
      );
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 12, top: 12, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: MaterialStateProperty.all(
                  primaryColor, // 🎨 YOUR COLOR
                ),
                thickness: MaterialStateProperty.all(4),
                radius: const Radius.circular(10),
              ),
              child: SizedBox(
                height: 70,
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.left,
                  interactive: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: rows.isNotEmpty
                          ? rows
                          : [
                              Text(
                                'No selections',
                                style:
                                    TextStyle(fontSize: 13, color: textcolor),
                              ),
                            ],
                    ),
                  ),
                ),
              ),
            ),
            Container(height: 50, width: 1.5, color: borderColor),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(text: 'Sum of Selections: '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Image.asset(
                          AppImages.goldcoin,
                          height: 18,
                        ),
                      ),
                      TextSpan(text: ' $totalSum'),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: AddTocart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.Btngradient),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFF6A0BF8),
                        width: 1.5,
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBtn extends StatelessWidget {
  final String title;
  const _FilterBtn(this.title);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.keyboard_arrow_down, size: 18),
      label: Text(title),
    );
  }
}

class StaticContest {
  static const int isOfferTeam = 0;
  static const int isGadget = 0;
  static const int isBonus = 1;
  static const int bonusPercent = 10;
  static const int joinedUsers = 45;
  static const int maximumUsers = 100;
  static const int entryFee = 50;
  static const int winAmount = 10000;
  static const int firstRankPrize = 5000;
  static const int totalWinners = 10;
  static const int confirmedChallenge = 1;
  static const int multiEntry = 1;
}
