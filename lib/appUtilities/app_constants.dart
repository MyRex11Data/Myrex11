import 'package:myrex11/appUtilities/app_images.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/repository/model/banner_response.dart';

class AppConstants {
  // TODO : Dev base url

  // static const String base_api_url =
  //     'https://hireitguy.com/myrex11/myrex11-api/public/';

  // TODO : Live base url

  static const String base_api_url = 'https://api.myrex11.com/';

  static String web_pages_url = base_api_url + "app/";
  static String terms_url = web_pages_url +
      "terms-and-conditions"; //"https://66f6acf6c572d2537b7cec0e--admirable-queijadas-84ef1c.netlify.app/";
  static String fantasy_point_url = web_pages_url +
      "fantasy-point-system"; //"https://points-system-myrex11.netlify.app/";
  static String privacy_url =
      web_pages_url + "privacy-policy"; //"https://myrex11.in/privacy.html";
  static String addcash_url = web_pages_url + "add-cash-term-condition";
  static String withdrawcash_url = web_pages_url + "withdraw-term-condition";
  static String about_us_url =
      web_pages_url + "about-us"; //"https://myrex11.in/about_us.html";
  static String how_to_play_url = web_pages_url +
      "how-to-play"; //"https://how-to-play-myrex11.netlify.app/";
  static String fair_play =
      web_pages_url + "fair-play"; //"https://how-to-play-myrex11.netlify.app/";
  static String refund_policy = web_pages_url +
      "cancellation-refund-policy"; //"https://how-to-play-myrex11.netlify.app/";
  static String legality_url = web_pages_url + "legalities-app";
  static String account_suspended = 'https://www.myrex11.com/account_suspended';
  static String respnsible_play = web_pages_url + "responsible-play";
  static String apk_url = "https://myrex11.in/APK/myrex11.apk";
  static String apk_refer_url = "https://myrex11.in/APK/myrex11.apk";
  static String app_store_url =
      "https://apps.apple.com/in/app/myrex11-fantasy-cricket/id6479639836";
  static String fb_url = "https://www.facebook.com/myrex11.fantasy";
  static String twitter_url = "https://twitter.com/myrex11_official";
  static String instagram_url = "https://www.instagram.com/";
  static String telegram_url = "https://t.me/myrex11_official";
  static String youtube_url = "https://www.youtube.com/@myrex11_fantasy ";
  static String whatsapp_url = "";
  static String telegram_urlhome = "";
  static String show_whatsapp_support = "";
  static String show_telegram_support = "";
  static String rupee = "";
  static String invite_bonus = "500";
  static String signup_bonus = "25";
  static String token = "";
  static int is_skiped_update = 0;
  static int is_skiped_popup = 0;

  static String cashfree_notify_url =
      "https://admin.myrex11.in/admin/cashfree-notify";

  //static String cashfree_notify_url = "https://fantasy.rgisports.com/repos/focus11/focus11_admin/admin/cashfree-notify";
  //PlayStoreWork===============================PlayStoreWork
  static int Is_PlayStoreBuild = 0;
  static Map<String, String> addressDocType = {};
  static String MAX_TEAM_LIMIT = 'MAX_TEAM_LIMIT';
  static String SHARED_PREFERENCE_USER_LATITUDE = "";
  static String SHARED_PREFERENCE_USER_LONGITUDE = "";

  // static final String SHARED_PREFERENCE_USER_PLAYING_STATE =
  //     "user_PLAYING_STATE";
  static String SHARED_PREFERENCE_USER_PLAYING_STATE_HEADER = "";
  static bool serviceEnabled = false;

  //PlayStoreWork===============================PlayStoreWork
  static String SHOW_REFER_EARN = "show_refer_earn";
  static String SHOW_REFER_LIST = "show_refer_list";
  static String cash_free_app_id = "1916626555d506aa26c5cb4aba266191";
  static String paytm_mid = "VISION15147168410696";
  static final String TOTAL_REFERAL_COUNT = "is_referal_count";
  static bool? isFilter;
  static String versionCode = '0';
  static late BuildContext context;

  static late BuildContext loderContext;

  static late BuildContext notificationContext;
  static bool error400 = false;
  static String screenCheck = '';
  static bool createTimeUp = false;
  static bool candvcTimeUp = false;
  static bool movetowallet = false;
  static bool matchHeaderTimeUp = false;
  static int homecount = 0;
  // static late AppsflyerSdk appsflyerSdk;
  static late Function callTimer;

  static final String SHARED_PREFERENCE_DOB = "date_of_birth";

//  =================== MESSAGES ============================

  static String get getNoInternetMsg => "Internet not available.";

  static String get getTechnicalErrorMsg => "Technical Error";

  static String get notPermittedMsg =>
      "You can't login using these credentials";

  static String get successMsg => "Success";

  static String get somethingWentWrongMsg => "Something Went Wrong";

  static String get invalidCredentialsMsg => "Invalid Credentials";

  static String get technicalErrorMsg => "TECHNICAL ERROR";

//  ==================================== URLS AND OTHER =====================

  static String get textRegular => 'Roboto';

  static String get textBold => "Roboto";

  static String get textSemiBold => 'Roboto';

  static String get localNotifStorage => '_localNotifStorage';

  static String get localCouriorStorage => '_localCouriorStorageJSON_ARY';

//  ======================== REPLACEMENTS =======================

  static String get replaceString4 => 'amp;';

  static String sonicPayURLLL = '';
  static List<String> banned_states = [];
  static List<String> contestJoinCountList = [];
  static List<LeaderBoardSport> sport_leaderboard = [];
  static bool showLeaderboardSpots = false;

  static late Function hidebuttons;
  static String userstate = '';
  static var channelTypes = [
    'Select Chanel Type',
    'Facebook',
    'YouTube',
    'Twitter',
    'Instagram',
    'Telegram',
    'Other'
  ];

  static List<String> stateList = [
    "assam",
    "odisha",
    "andhra pradesh",
    "sikkim",
    "telangana",
    "nagaland",
  ];

  static Map<String, String> countryDialCodes = {
    "Afghanistan": "+93",
    "Albania": "+355",
    "Algeria": "+213",
    "American Samoa": "+1-684",
    "Andorra": "+376",
    "Angola": "+244",
    "Anguilla": "+1-264",
    "Antarctica": "+672",
    "Antigua and Barbuda": "+1-268",
    "Argentina": "+54",
    "Armenia": "+374",
    "Aruba": "+297",
    "Australia": "+61",
    "Austria": "+43",
    "Azerbaijan": "+994",
    "Bahamas": "+1-242",
    "Bahrain": "+973",
    "Bangladesh": "+880",
    "Barbados": "+1-246",
    "Belarus": "+375",
    "Belgium": "+32",
    "Belize": "+501",
    "Benin": "+229",
    "Bermuda": "+1-441",
    "Bhutan": "+975",
    "Bolivia": "+591",
    "Bosnia and Herzegowina": "+387",
    "Botswana": "+267",
    "Brazil": "+55",
    "Brunei Darussalam": "+673",
    "Bulgaria": "+359",
    "Burkina Faso": "+226",
    "Burundi": "+257",
    "Cambodia": "+855",
    "Cameroon": "+237",
    "Canada": "+1",
    "Cape Verde": "+238",
    "Cayman Islands": "+1-345",
    "Central African Republic": "+236",
    "Chad": "+235",
    "Chile": "+56",
    "China": "+86",
    "Colombia": "+57",
    "Comoros": "+269",
    "Congo": "+242",
    "Congo, the Democratic Republic of the": "+243",
    "Costa Rica": "+506",
    "Cote d'Ivoire": "+225",
    "Croatia": "+385",
    "Cuba": "+53",
    "Cyprus": "+357",
    "Czech Republic": "+420",
    "Denmark": "+45",
    "Djibouti": "+253",
    "Dominica": "+1-767",
    "Dominican Republic": "+1-809",
    "Ecuador": "+593",
    "Egypt": "+20",
    "El Salvador": "+503",
    "Equatorial Guinea": "+240",
    "Eritrea": "+291",
    "Estonia": "+372",
    "Ethiopia": "+251",
    "Fiji": "+679",
    "Finland": "+358",
    "France": "+33",
    "Gabon": "+241",
    "Gambia": "+220",
    "Georgia": "+995",
    "Germany": "+49",
    "Ghana": "+233",
    "Greece": "+30",
    "Greenland": "+299",
    "Grenada": "+1-473",
    "Guadeloupe": "+590",
    "Guam": "+1-671",
    "Guatemala": "+502",
    "Guinea": "+224",
    "Guinea-Bissau": "+245",
    "Guyana": "+592",
    "Haiti": "+509",
    "Honduras": "+504",
    "Hong Kong": "+852",
    "Hungary": "+36",
    "Iceland": "+354",
    "India": "+91",
    "Indonesia": "+62",
    "Iran (Islamic Republic of)": "+98",
    "Iraq": "+964",
    "Ireland": "+353",
    "Israel": "+972",
    "Italy": "+39",
    "Jamaica": "+1-876",
    "Japan": "+81",
    "Jordan": "+962",
    "Kazakhstan": "+7",
    "Kenya": "+254",
    "Kiribati": "+686",
    "Korea, Republic of": "+82",
    "Kuwait": "+965",
    "Kyrgyzstan": "+996",
    "Lao, People's Democratic Republic": "+856",
    "Latvia": "+371",
    "Lebanon": "+961",
    "Lesotho": "+266",
    "Liberia": "+231",
    "Libya": "+218",
    "Liechtenstein": "+423",
    "Lithuania": "+370",
    "Luxembourg": "+352",
    "Macau": "+853",
    "Madagascar": "+261",
    "Malawi": "+265",
    "Malaysia": "+60",
    "Maldives": "+960",
    "Mali": "+223",
    "Malta": "+356",
    "Marshall Islands": "+692",
    "Martinique": "+596",
    "Mauritania": "+222",
    "Mauritius": "+230",
    "Mayotte": "+262",
    "Mexico": "+52",
    "Micronesia, Federated States of": "+691",
    "Moldova, Republic of": "+373",
    "Monaco": "+377",
    "Mongolia": "+976",
    "Montserrat": "+1-664",
    "Morocco": "+212",
    "Mozambique": "+258",
    "Myanmar": "+95",
    "Namibia": "+264",
    "Nauru": "+674",
    "Nepal": "+977",
    "Netherlands": "+31",
    "New Caledonia": "+687",
    "New Zealand": "+64",
    "Nicaragua": "+505",
    "Niger": "+227",
    "Nigeria": "+234",
    "Niue": "+683",
    "Norfolk Island": "+672",
    "Northern Mariana Islands": "+1-670",
    "Norway": "+47",
    "Oman": "+968",
    "Pakistan": "+92",
    "Palau": "+680",
    "Panama": "+507",
    "Papua New Guinea": "+675",
    "Paraguay": "+595",
    "Peru": "+51",
    "Philippines": "+63",
    "Poland": "+48",
    "Portugal": "+351",
    "Puerto Rico": "+1-787",
    "Qatar": "+974",
    "Romania": "+40",
    "Russia": "+7",
    "Rwanda": "+250",
    "Saint Kitts and Nevis": "+1-869",
    "Saint Lucia": "+1-758",
    "Saint Vincent and the Grenadines": "+1-784",
    "Samoa": "+685",
    "San Marino": "+378",
    "Sao Tome and Principe": "+239",
    "Saudi Arabia": "+966",
    "Senegal": "+221",
    "Seychelles": "+248",
    "Sierra Leone": "+232",
    "Singapore": "+65",
    "Slovakia": "+421",
    "Slovenia": "+386",
    "Solomon Islands": "+677",
    "Somalia": "+252",
    "South Africa": "+27",
    "Spain": "+34",
    "Sri Lanka": "+94",
    "Sudan": "+249",
    "Suriname": "+597",
    "Swaziland": "+268",
    "Sweden": "+46",
    "Switzerland": "+41",
    "Syrian Arab Republic": "+963",
    "Taiwan": "+886",
    "Tajikistan": "+992",
    "Tanzania": "+255",
    "Thailand": "+66",
    "Togo": "+228",
    "Tonga": "+676",
    "Trinidad and Tobago": "+1-868",
    "Tunisia": "+216",
    "Turkey": "+90",
    "Turkmenistan": "+993",
    "Uganda": "+256",
    "Ukraine": "+380",
    "United Arab Emirates": "+971",
    "United Kingdom": "+44",
    "United States": "+1",
    "Uruguay": "+598",
    "Uzbekistan": "+998",
    "Vanuatu": "+678",
    "Venezuela": "+58",
    "Vietnam": "+84",
    "Yemen": "+967",
    "Zambia": "+260",
    "Zimbabwe": "+263",
    "Palestine": "+970",
  };

  static Map<String, int> countryMobileLength = {
    "+93": 9, // Afghanistan
    "+355": 9,
    "+213": 9,
    "+1": 10, // USA/Canada
    "+376": 6,
    "+244": 9,
    "+54": 10,
    "+374": 8,
    "+61": 9,
    "+43": 10,
    "+994": 9,
    "+973": 8,
    "+880": 11,
    "+375": 9,
    "+32": 9,
    "+501": 7,
    "+229": 8,
    "+975": 8,
    "+591": 8,
    "+387": 8,
    "+267": 7,
    "+55": 11,
    "+673": 7,
    "+359": 9,
    "+226": 8,
    "+257": 8,
    "+855": 9,
    "+237": 9,
    "+238": 7,
    "+236": 8,
    "+235": 8,
    "+56": 9,
    "+86": 11,
    "+57": 10,
    "+269": 7,
    "+242": 9,
    "+682": 5,
    "+506": 8,
    "+385": 9,
    "+53": 8,
    "+357": 8,
    "+420": 9,
    "+45": 8,
    "+253": 8,
    "+1-767": 7,
    "+1-809": 10,
    "+593": 9,
    "+20": 10,
    "+503": 8,
    "+240": 9,
    "+291": 7,
    "+372": 7,
    "+251": 9,
    "+679": 7,
    "+358": 9,
    "+33": 9,
    "+241": 7,
    "+220": 7,
    "+995": 9,
    "+49": 11,
    "+233": 9,
    "+350": 8,
    "+30": 10,
    "+299": 6,
    "+502": 8,
    "+224": 9,
    "+245": 7,
    "+592": 7,
    "+509": 8,
    "+504": 8,
    "+36": 9,
    "+354": 7,
    "+91": 10,
    "+62": 11,
    "+98": 10,
    "+964": 10,
    "+353": 9,
    "+972": 9,
    "+39": 10,
    "+225": 8,
    "+81": 10,
    "+962": 9,
    "+254": 9,
    "+686": 8,
    "+383": 8,
    "+965": 8,
    "+996": 9,
    "+856": 8,
    "+371": 8,
    "+961": 8,
    "+266": 8,
    "+231": 7,
    "+218": 9,
    "+423": 7,
    "+370": 8,
    "+352": 9,
    "+853": 8,
    "+389": 8,
    "+261": 9,
    "+265": 9,
    "+60": 9,
    "+960": 7,
    "+223": 8,
    "+356": 8,
    "+692": 7,
    "+596": 9,
    "+222": 8,
    "+230": 8,
    "+262": 10,
    "+52": 10,
    "+691": 7,
    "+373": 8,
    "+377": 8,
    "+976": 8,
    "+382": 8,
    "+212": 9,
    "+258": 9,
    "+95": 9,
    "+264": 9,
    "+674": 7,
    "+977": 10,
    "+31": 9,
    "+687": 6,
    "+64": 9,
    "+505": 8,
    "+227": 8,
    "+234": 10,
    "+683": 4,
    "+47": 8,
    "+968": 8,
    "+92": 10,
    "+680": 7,
    "+970": 9,
    "+507": 8,
    "+675": 8,
    "+595": 9,
    "+51": 9,
    "+63": 10,
    "+48": 9,
    "+351": 9,
    "+974": 8,
    "+242": 9,
    "+40": 10,
    "+7": 10, // Russia
    "+250": 9,
    "+590": 9,
    "+290": 4,
    "+508": 6,
    "+685": 7,
    "+378": 8,
    "+239": 7,
    "+966": 9,
    "+221": 9,
    "+381": 9,
    "+248": 7,
    "+232": 8,
    "+65": 8,
    "+421": 9,
    "+386": 9,
    "+677": 8,
    "+252": 9,
    "+27": 9,
    "+82": 11,
    "+211": 9,
    "+34": 9,
    "+94": 9,
    "+249": 9,
    "+597": 7,
    "+268": 8,
    "+46": 9,
    "+41": 9,
    "+963": 9,
    "+886": 10,
    "+992": 9,
    "+255": 9,
    "+66": 9,
    "+670": 7,
    "+228": 8,
    "+690": 4,
    "+676": 5,
    "+216": 8,
    "+90": 10,
    "+993": 8,
    "+688": 5,
    "+256": 9,
    "+380": 9,
    "+971": 9,
    "+44": 10,
    "+598": 9,
    "+998": 9,
    "+678": 7,
    "+58": 10,
    "+84": 10,
    "+681": 6,
    "+967": 9,
    "+260": 9,
    "+263": 9,
  };

  static var items = [
    'Select State',
    'Andaman & Nicobar Islands',
    'Arunachal Pradesh',
    'Bihar',
    'Chandigarh',
    'Chhattisgarh',
    'Dadra & Nagar Haveli',
    'Daman & Diu',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu & Kashmir',
    'Jharkhand',
    'Karnataka'
        'Kerala'
        'Lakshadweep',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Pondicherry',
    'Punjab',
    'Rajasthan',
    'Tamil Nadu',
    'Tripura',
    'Uttarakhand',
    'Uttar Pradesh',
    'West Bengal'
  ];
  static final String SPLASH_UPDATE = "splash_update";

  static final String PREVIOUS_SPOTS_DATA = "previous_spots_data";

  static final String SHARED_PREFERENCES_IS_LOGGED_IN = "is_logged_in";
  static final String SHARED_PREFERENCE_USER_ID = "user_id";
  static final String SHARED_PREFERENCE_USER_TOKEN = "user_token";
  static final String SHARED_PREFERENCE_USER_NAME = "user_name";
  static final String SHARED_PREFERENCE_USER_EMAIL = "user_email";
  static final String SHARED_PREFERENCE_USER_MOBILE = "user_mobile";
  static final String SHARED_PREFERENCE_NEW_USER = "new_user";
  static final String SHARED_PREFERENCE_USER_DYNAMIC_LINK = "USER_DYNAMIC_LINK";

  static final String SHARED_PREFERENCE_USER_MOBILE_VERIFY_STATUS =
      "user_mobile_verify_status";
  static final String SHARED_PREFERENCE_USER_EMAIL_VERIFY_STATUS =
      "user_email_verify_status";
  static final String SHARED_PREFERENCE_USER_PAN_VERIFY_STATUS =
      "user_pan_verify_status";
  static final String SHARED_PREFERENCE_USER_BANK_VERIFY_STATUS =
      "user_bank_verify_status";
  static final String SHARED_PREFERENCE_USER_AADHAR_VERIFY_STATUS =
      "user_aadhaar_verify_status";
  static final String SHARED_PREFERENCE_USER_UPI_VERIFY_STATUS =
      "user_upi_verify_status";
  static final String LOGIN_REGISTER_TYPE = "login_register_type";
  static final String FROM = "from";

  static final String SHARED_PREFERENCE_USER_FCM_TOKEN = "user_fcm_token";
  static final String SHARED_PREFERENCE_USER_REFER_CODE = "user_refer_code";
  static final String SPORT_KEY = "sport_key";
  static final String MATCH_STATUS = "match_status";
  static final String KEY_BANNER_IMAGE = "banner_image";
  static final String IS_VISIBLE_AFFILIATE = "is_visible_affiliate";

  static final String IS_VISIBLE_RAZORPAY = "is_visible_razorpay";
  static final String IS_VISIBLE_ADDRESS = "is_visible_address";
  static final String IS_ADDRESS_VERIFIED = "is_address_verified";
  static final String CASHFREE_MODE = "cashfree_mode";

  static final String IS_VISIBLE_UPI = "is_visible_upi";

  static final String IS_VISIBLE_PRIVATE_CONTEST = "is_visible_private_contest";

  static final String IS_VISIBLE_PHONEPE = "is_visible_phonepe";
  static final String IS_VISIBLE_NTTPAY = "is_visible_nttpay";
  static final String IS_VISIBLE_CASHFREE = "is_visible_cashfree";
  static final String PHONE_PAY_TEXT = "phone_pay_text";
  static final String NTT_PAY_TEXT = "ntt_pay_text";
  static final String CASH_FREE_TEXT = "cash_free_text";
  static final String MIN_DEPOSITE = "min_deposite";
  static final String MAX_DEPOSITE = "max_deposite";
  static final String MIN_INST_WITHDRAW = "min_inst_withdraw";
  static final String MAX_INST_WITHDRAW = "max_inst_withdraw";
  static final String MIN_BANK_WITHDRAW = "min_bank_withdraw";
  static final String MAX_BANK_WITHDRAW = "max_bank_withdraw";

  static final String MIN_WINNING_TRANSFER = "min_winning_transfer";
  static final String MAX_WINNING_TRANSFER = "max_winning_transfer";

  static final String IS_WITHDRAW = "is_withdraw";
  static final String IS_INST_WITHDRAW = "is_inst_withdraw";
  static final String IS_PROMOTER_WITHDRAW = "is_promotor_withdraw";
  static final String IS_PROMOTER_INST_WITHDRAW = "is_promotor_inst_withdraw";

  static final String KYC_DEPOSIT_CHECK = "kyc_deposit_check";
  static final String KYC_DEPOSIT_LIMIT = "kyc_deposit_limit";
  static final String TOTAL_CASHFREE_DEPOSIT = "total_cashfree_deposit";
  static final String CASHFREE_MESSAGE = "cashfree_message";

  static final String IS_VISIBLE_PROMOTE = "is_visible_promote";
  static final String GST_PERCENT = "GST_PERCENT";
  static final String WINNING_PERCENT = "WINNING_PERCENT";
  static final String REBATE_PERCENT = "REBATE_PERCENT";
  static final String IS_ACCOUNT_WALLET_DISABLE = "is_visible_wallet_account";
  static final String IS_VISIBLE_PROMOTER_LEADERBOARD =
      "is_visible_promoter_leaderboard";
  static final String IS_VISIBLE_PROMOTER_REQUEST =
      "is_visible_promoter_requested";
  static final String SportTabSlected = "SportTabSlected";

  static final String SHOW_AFF_WALLET = "show_aff_wallet";
  static final String SHOW_AFF_WALLET_WITHDRAW = "show_aff_wallet_withdraw";

  static final String SHARED_PREFERENCE_USER_TEAM_NAME = "user_team_name";
  static final String SHARED_PREFERENCE_USER_STATE_NAME = "user_state_name";
  static final String SHARED_PREFERENCE_USER_PIC = "user_pic_url";
  static final String SHARED_PREFERENCES_ACCESS_TOKEN = "access_token";
  static final String SHARED_PREFERENCES_CLIENT_ACCESS_TOKEN =
      "client_access_token";
  static final String SHARED_SPORTS_LIST = "SHARED_SPORTS_LIST";
  static final String SERVER_DATE_TIME = "SERVER_DATE_TIME";
  static final String USER_VERIFIED = "USER_VERIFIED";
  static final String Max_Team_Add_Limit = "max_team_add_limit";

  static final String FILTER_CONDITION = "filter_condition";

  static final String IS_MULTI_SPORTS_ENABLE = "IS_MULTI_SPORTS_ENABLE";
  static final String MULTI_SPORTS = "MULTI_SPORTS";
  static final String AUTHTOKEN = "AUTHTOKEN";
  static final String VERIFIED = "Verified";
  static final String UNVERIFIED = "Unverified";
  static final String PAYTM = "paytm";
  static final String NO_TEAM_CREATED = "You have not created any team yet !!";
  static final String SOMETHING_WENT_WRONG = "Oops! Something went Wrong";
  static final int OTP_SEND_TIME = 60 * 1000;
  static final int SPLASH_TIMEOUT = 1500;
  static final String APP_NAME = "myrex11";
  static final String RAZORPAY = "razorPay";
  static final int MIN_BANK_WITHDRAW_AMOUNT = 200;
  static final int MIN_PAYTM_WITHDRAW_AMOUNT = 100;
  static final int MIN_BANK_INSTANT_WITHDRAW_AMOUNT = 200;

  static final int MAX_PAYTM_WITHDRAW_AMOUNT = 10000;
  static final int MAX_BANK_WITHDRAW_AMOUNT = 200000;
  static final int MAX_BANK_INSTANT_WITHDRAW_AMOUNT = 50000;
  static final double DEFAULT_PERCENT = 1.15;

  static final String API_VERSION = "1.1";
  static final String ACCEPT_HEADER =
      "application/vnd.md.api.v" + API_VERSION + "+json";
  static final String KEY_WINING_PERCENT = "key_winning_percent";

  static final int KEY_LIVE_MATCH = 1;
  static final int KEY_UPCOMING_MATCH = 2;
  static final int KEY_FINISHED_MATCH = 3;

  //PAN STATUS
  static final int KEY_PAN_VERIFIED = 1;
  static final int KEY_PAN_UNVERIFIED = 0;
  static final int KEY_PAN_NOT_REQUESTED = -1;
  static final int KEY_PAN_REJECTED = 2;

  //BANK STATUS
  static final int KEY_BANK_VERIFIED = 1;
  static final int KEY_BANK_UNVERIFIED = 0;
  static final int KEY_BANK_NOT_REQUESTED = -1;
  static final int KEY_BANK_REJECTED = 2;

  //EMAIL STATUS
  static final int KEY_EMAIL_VERIFIED = 1;
  static final int KEY_EMAIL_UNVERIFIED = 0;

  //MOBILE_STATUS
  static final int KEY_MOBILE_VERIFIED = 1;
  static final int KEY_MOBILE_UNVERIFIED = 0;

  //Player Role
  static final String KEY_PLAYER_ROLE_BAT = "batsman";
  static final String KEY_PLAYER_ROLE_ALL_R = "allrounder";
  static final String KEY_PLAYER_ROLE_BOL = "bowler";
  static final String KEY_PLAYER_ROLE_KEEP = "keeper";

  //That use for ic_switch_team data
  static final String KEY_MATCH_KEY = "key_match_key";
  static final String KEY_WINING_AMOUNT = "key_wining_amount";
  static final String KEY_TEAM_VS = "key_team_vs";
  static final String KEY_TEAM_FIRST_URL = "key_team_first_url";
  static final String KEY_TEAM_SECOND_URL = "key_team_second_url";
  static final String KEY_TEAM_ID = "key_team_id";
  static final String KEY_TEAM_ID2 = "key_team_id2";
  static final String KEY_CONTEST_KEY = "key_contest_key";
  static final String KEY_IS_FOR_JOIN_CONTEST = "key_is_for_join_contest";
  static final String KEY_CONTEST_DATA = "key_contest_data";
  static final String KEY_USER_BALANCE = "key_user_balance";
  static final String KYC_VERIFIED = "KYC_VERIFIED";
  static final String KEY_USER_BONUS_BALANCE = "key_user_bonus_balance";
  static final String KEY_USER_WINING_AMOUNT = "key_user_wining_amount";
  static final String KEY_USER_TOTAL_BALANCE = "key_user_total_balance";
  static final String KEY_USER_GST_BALANCE = "key_user_gst_balance";
  static final String KEY_USER_AFFILIATE_BALANCE = "key_user_affiliate_balance";
  static final String CONTEST_ID = "CONTEST_ID";
  static final String signup_refer_statement = "signup_refer_statement";
  static final String refer_statement = "refer_statement";
  static late String Refer_code = "Refer_code";
  static String Deep_Link_Refer_code = "";
  static final String Both_earn = "Both_earn";
  static final String lifetime_commission = "lifetime_commission";
  static final String Both_earn_stmt = "Both_earn_stmt";
  static final String lifetime_commission_stmt = "lifetime_commission_stmt";
  static final String is_lifetime_commission = "is_lifetime_commission";
  static final String withdraw_limit_string = "withdraw_limit_string";
  static final String withdraw_min_limit = "withdraw_min_limit";
  static final String withdraw_max_limit = "withdraw_max_limit";
  static final String score_focus = "score_focus";
  static final String commentry_focus = "commentry_focus";
  static final String score_card_focus = "score_card_focus";
  static TextEditingController codeController = TextEditingController();

  //key for fantsy type
  static final String KEY_IS_BATTING_FANTASY = "KEY_IS_BATTING_FANTASY";
  static final String KEY_IS_BOWLING_FANTASY = "KEY_IS_BOWLING_FANTASY";
  static final String KEY_IS_LIVE_FANTASY = "KEY_IS_LIVE_FANTASY";
  static final String KEY_IS_SECOND_INNING_FANTASY =
      "KEY_IS_SECOND_INNING_FANTASY";
  static final String KEY_IS_REVERSE_FANTASY = "KEY_IS_REVERSE_FANTASY";

  static final int FULL_MATCH_FANTASY_TYPE = 0;
  static final int LIVE_FANTASY_TYPE = 1;
  static final int BATTING_FANTASY_TYPE = 2;
  static final int BOWLING_FANTASY_TYPE = 3;
  static final int SECOND_INNINGS_FANTASY_TYPE = 4;
  static final int REVERSE_FANTASY = 5;
  static final int FIVE_PLUS_ONE = 6;

  static final String KEY_FANTASY_TYPE = "KEY_FANTASY_TYPE";
  static final String KEY_FANTASY_SLOT_ID = "KEY_FANTASY_SLOT_ID";

  static final String KEY_FANTASY_SLOTS = "KEY_FANTASY_SLOTS";
  static final String KEY_PROMTER_LEADERBOARD_ID =
      "key_promoter_leaderboard_id";

  static final String KEY_STATUS_HEADER_TEXT = "key_status_header_text";
  static final String KEY_STATUS_IS_TIMER_HEADER = "key_status_is_timer_text";
  static final String KEY_IS_FOR_SWITCH_TEAM = "key_is_for_switch_team";

  static final String KEY_TEAM_COUNT = "key_team_count";

  static final String KEY_STATUS_IS_FOR_CONTEST_DETAILS =
      "key_is_for_contest_details";
  static String SKIP_CREATETEAM_INSTRUCTION = "SKIP_CREATETEAM_INSTRUCTION";
  static String SKIP_CREATECVC_INSTRUCTION = "SKIP_CREATECVC_INSTRUCTION";

  static final String KEY_TEAM_LIST_WK = "key_team_list_wk";
  static final String KEY_TEAM_LIST_BAT = "key_team_list_bat";
  static final String KEY_TEAM_LIST_AR = "key_team_list_ar";
  static final String KEY_TEAM_LIST_BOWL = "key_team_list_bowl";
  static final String KEY_TEAM_LIST_C = "KEY_TEAM_LIST_C";
  static final String KEY_TEAM_NAME = "key_team_name";
  static final String KEY_TEAM1_FULL_NAME = "key_team1_full_name";
  static final String KEY_TEAM2_FULL_NAME = "key_team2_full_name";
  static final String KEY_TEAM1_SCORE = "key_team1_score";
  static final String KEY_TEAM2_SCORE = "key_team2_score";
  static final String KEY_TEXT = "key_text";

  static final String KEY_ALL_CONTEST = "key_all_contest";
  static final String ERROR_MSG =
      "We are facing problem...We will be right back!";

  //TAGS
  static final String TAG_CRICKET = "CRICKET";
  static final String TAG_LIVE = "LIVE";
  static final String TAG_FOOTBALL = "FOOTBALL";
  static final String TAG_BASKETBALL = "BASKETBALL";
  static final String TAG_BASEBALL = "BASEBALL";
  static final String TAG_HANDBALL = "HANDBALL";
  static final String TAG_HOCKEY = "HOCKEY";
  static final String TAG_KABADDI = "KABADDI";

  //CRICKET TAG
  static final String WK = "WK";
  static final String BAT = "BAT";
  static final String AR = "AR";
  static final String BOWL = "BOWL";

  //Player Role for Football
  static final String KEY_PLAYER_ROLE_DEF = "Defender";
  static final String KEY_PLAYER_ROLE_ST = "Forward";
  static final String KEY_PLAYER_ROLE_GK = "Goalkeeper";
  static final String KEY_PLAYER_ROLE_MID = "Midfielder";
  static final String KEY_PLAYER_ROLE_STR = "Striker";
  static final String KEY_PLAYER_ROLE_RD = "raider";

  //FOOTBALL TAG
  static final String GK = "GK";
  static final String DEF = "DEF";
  static final String MID = "MID";
  static final String ST = "ST";
  static final String ALL = "ALL";
  static final String RAIDER = "RAIDER";

  //Player Role for BasketBall(NBA)
  static final String KEY_PLAYER_ROLE_PG = "Point guard"; //1-4
  static final String KEY_PLAYER_ROLE_SG = "Shooting guard"; //1-4
  static final String KEY_PLAYER_ROLE_SF = "Small forward"; //1-4
  static final String KEY_PLAYER_ROLE_PF = "Power forward"; //1-4
  static final String KEY_PLAYER_ROLE_C = "Center"; //1-4

  static final String PG = "PG";
  static final String SG = "SG";
  static final String SF = "SF";
  static final String PF = "PF";
  static final String C = "C";

  //Player Role for BaseBall
  static final String KEY_PLAYER_ROLE_OF = "Outfielder";
  static final String KEY_PLAYER_ROLE_IF = "Infielder";
  static final String KEY_PLAYER_ROLE_PITCHER = "Pitcher";
  static final String KEY_PLAYER_ROLE_CATCHER = "Catcher";

  //BASEBALL TAG
  static final String OF = "OF";
  static final String IF = "IF";
  static final String PIT = "P";
  static final String CAT = "C";

  // Playing Status
  static final String PLAYING = "playing";
  static final String NOT_PLAYING = "not_playing";
  static final String BOTH = "both";

  //Home Pop Up Banner
  static final String PREVIOUS_DATE = "previous_date";
  static final String IS_NIGHT_BANNER_SHOWN = "is_night_banner_shown";
  static final String IS_MORNING_BANNER_SHOWN = "is_morning_banner_shown";
  static final String IS_AFTERNOON_BANNER_SHOWN = "is_afternoon_banner_shown";
  static final String IS_EVENING_BANNER_SHOWN = "is_evening_banner_shown";
  static final String NIGHT_START_TIME = "00:00:00";
  static final String NIGHT_END_TIME = "05:59:59";
  static final String MORNING_START_TIME = "06:00:00";
  static final String MORNING_END_TIME = "11:59:59";
  static final String AFTERNOON_START_TIME = "12:00:00";
  static final String AFTERNOON_END_TIME = "17:59:59";
  static final String EVENING_START_TIME = "18:00:00";
  static final String EVENING_END_TIME = "23:59:59";

  static bool onApiError = false;
  static bool fromHomeScreen = false;
  static bool showLoader = false;
  static final String KEY_SHOW_ADMIN_UPI = "key_show_admin_upi";
  static final String KEY_ADMIN_UPI_LIST = "key_admin_upi_list";

  static final String KEY_SHOW_ADMIN_BANK = "key_show_admin_bank";
  static final String KEY_ADMIN_BANK_NAME = "key_admin_bank_name";
  static final String KEY_ADMIN_BANK_IFSC = "key_admin_bank_ifsc";
  static final String KEY_ADMIN_BANK_CUSTOMER_NAME =
      "key_admin_bank_customer_name";
  static final String KEY_ADMIN_BANK_ACCOUNT = "key_admin_bank_account";

  static final String SHARED_PREFERENCES_SHOW_WEB_PAYEMNT = "show_web_payment";

  static String cart_feature_enable = '0';

  static backButtonFunction() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {
        Navigator.pop(context),
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: new Container(
          height: 30,
          child: Image(
            image: AssetImage(AppImages.backImageURL),
          ),
        ),
      ),
    );
  }

  static late Function onteamUpdate;
  static late Function updateMysport;

  static bool onContestScreen = false;
  static bool isTeamShare = false;
  static String sportKey = '';
}
