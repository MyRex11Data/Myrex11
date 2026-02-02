// Class for api tags
class Apis {
  static const String getOffer = 'api/auth/get-free-teams-by-Challenge';
  static const String userLogin = 'api/auth/login-new';
  static const String userLoginSocial = 'api/auth/social-login';
  static const String userLoginApple = 'api/auth/apple-login';
  static const String userRegisterNew = 'api/auth/register_new';
  static const String validateMobileOtp = 'api/auth/verify-otp-login';
  static const String otpRegisterVerifyNew = 'api/auth/verify-otp-register_new';
  static const String verifyForgotMobileOtp = 'api/auth/validate-otp-new';
  static const String sendOTPNew = 'api/auth/send_new_otp_new';
  static const String resendOTP = 'api/auth/app_resend_otp';
  static const String sendOTP = 'api/auth/send_new_otp';
  static const String forgotPasswordNew = 'api/auth/forget-password-new';
  static const String sendForgotOTP = 'api/auth/resend-password-new';
  static const String changePassword = 'api/auth/change-password';
  static const String changePasswordAfterForgot =
      'api/auth/change-password-new';
  static const String getUserBalance = 'api/auth/mybalance';
  static const String getBannerList = 'api/auth/get-banners';
  static const String getMatchList = 'api/auth/getmatchlist';
  static const String remindMe = 'api/auth/add-match-alerts';
  static const String updateTeamName = 'api/auth/updateteamname_new';
  // static const String updateTeamName = 'api/auth/app_update_team_name';
  static const String updateTeamNameNew = 'api/auth/app_update_team_name';
  static const String requestDeposite = 'api/auth/request-deposite';
  static const String winningToCash = 'api/auth/winningToCash';
  static const String getMyMatchLiveList = 'api/auth/myjoinedmatches_live';
  static const String getMyMatchFinishList =
      'api/auth/myjoinedmatches_finished';
  static const String getLevelData = 'api/auth/userlevel';
  static const String getPlayData = 'api/auth/my-play-history';
  static const String getUserNotification = 'api/auth/usernotifications';
  static const String getFullUserDetails = 'api/auth/user-full-details';
  static const String updateUserProfile = 'api/auth/edit-profile';
  static const String getReferBonusList = 'api/auth/refer-bonus-list-new';
  static const String allVerify = 'api/auth/all-verify';
  static const String getPainDetail = 'api/auth/see-pan-details';
  static const String getBankDetails = 'api/auth/seebankdetails';
  static const String uploadPanImage = 'api/auth/upload-pan-image-android';
  static const String uploadFrontImage =
      'api/auth/upload-adhar-front-image-android';
  static const String uploadbackImage =
      'api/auth/upload-adhar-back-image-android';
  static const String verifyAadharDetail = 'api/auth/verify-adhar-request';
  static const String verifyAddressDetail = 'api/auth/verify-address';
  static const String uploadProfileImage = 'api/auth/update-profile-image';
  static const String uploadBankImage = 'api/auth/upload-bank-image-android';
  static const String verifyPanDetail = 'api/auth/verify-pan-request';
  static const String verifyBankDetail = 'api/auth/bank-verify';

  static const String verifyUPIDetail = 'api/auth/verify-upi-id';
  static const String verifyEmailStatus = 'api/auth/edit-email';
  static const String sendNewEmail = 'api/auth/send-new-mail';
  static const String verifyOtpNew = 'api/auth/verify_otp_new';
  static const String verifyOtp = 'api/auth/verify_otp';
  static const String verifyEmailOtp = 'api/auth/verify_email_otp';
  static const String getAffiliationTotal = 'api/auth/promoterTotal';
  static const String getAffiliateMatchData = 'api/auth/promoterMatches';
  static const String getAffiliateEarnData = 'api/auth/promoterContests';
  static const String promoterTeams = 'api/auth/promoterTeams';
  static const String updatePromoteAppDetails =
      'api/auth/addPromoteBasicDetails';
  static const String getMyTransaction = 'api/auth/mytransaction';

  static const String getWithdrawTransaction = 'api/auth/withdraw-list';

  static const String transactionDownload = 'api/auth/transaction-download';
  static const String addCaseOfferList = 'api/auth/getpromocode';
  static const String tdsData = 'api/auth/tds-amount';
  static const String applyPromoCode = 'api/auth/verify-promo-code';
  static const String withdrawUserBalance = 'api/auth/request-withdraw';
  static const String CheckWithdrawStatus = 'api/auth/check-withdrawl-status';
  static const String getContestByCategory =
      'api/auth/get-challenges-by-category';
  static const String getContestByCategoryId = 'api/auth/category-leagues';
  static const String getContests = 'api/auth/get-challenges-new';
  static const String addMatchPins = 'api/auth/addMatchPins';
  static const String getJoinedContests = 'api/auth/myjoinedleauges';
  static const String getMyTeams = 'api/auth/myjointeam';
  static const String getFavouriteContest = 'api/auth/fav-contest';
  static const String getWinnersPriceCard = 'api/auth/getscorecards';
  static const String getLeaderboardList = 'api/auth/leaderboard';
  static const String getPlayerList = 'api/auth/getplayerlist';
  static const String switchTeam = 'api/auth/updateteamleauge';
  static const String getUsableBalance = 'api/auth/myusablebalance';
  static const String joinChallenge = 'api/auth/joinleague-v2';
  static const String createTeam = 'api/auth/create-team';
  static const String joinByContestCode = 'api/auth/join-by-code';
  static const String getMatchScores = 'api/auth/refresh-scores-new';
  static const String getPlayerPoints = 'api/auth/matchplayerspoints';
  static const String getPreviewPlayers = 'api/auth/getteamtoshow';
  static const String createContest = 'api/auth/create-challenge';
  static const String getSeries = 'api/auth/get-series';
  static const String getInvestments = 'api/auth/get-investments';

  static const String gethomepromoter = 'api/auth/get-promoter-user-series';

  static const String getDeposit = 'api/auth/get-deposit-list';
  static const String getPromoterSeries = 'api/auth/get-promoter-series';
  static const String getSeriesLeaderboard =
      'api/auth/get-series-leaderboard-new';
  static const String getInvestmentsLeaderboard =
      'api/auth/get-investments-leaderboard';

  static const String gethomepromoterLeaderboard =
      'api/auth/get-promoter-user-series-leaderboard';
  static const String getDepositLeaderboard =
      'api/auth/get-investments-deposit';
  static const String getInvestmentsMatchLeaderboard =
      'api/auth/get-investments-match-leaderboard';
  static const String getDepositMatchLeaderboard =
      'api/auth/get-investments-deposit-leaderboard';
  static const String getLeaderboardDetails = 'api/auth/get-match-leaderboard';

  static const String getPromoterLeaderboardDetails =
      'api/auth/get-promoter-user-match-leaderboard';
  static const String getPromoterLeaderboard =
      'api/auth/get-promoter-series-leaderboard-new';
  static const String getPromoterMatchLeaderboard =
      'api/auth/get-promoter-match-leaderboard';
  static const String getCompareTeamData = 'api/auth/compare_new';
  static const String removeProfilePhoto = 'api/auth/remove-profile-image';
  static const String getPlayerInfo = 'api/auth/playerfullinfo';
  static const String getCfToken = 'api/auth/get_cashfree_token';
  static const String getPaytmChecksum = 'api/auth/get_paytm_checksum';
  static const String getReferCode = 'api/auth/get-refer-code';
  static const String getTds = 'api/auth/tds-new-api';
  static const String getTdsList = 'api/auth/all-tds-list';
  static const String createOrderSonicPay = 'api/auth/sonicpe_create_order';
  static const String sonicpeOrderProcess = 'api/auth/sonicpe_order_process';
  static const String sonicpeTransactionStatus =
      'api/auth/sonicpe_transaction_status';
  static const String emailorphonelogin = 'api/auth/emailorphonelogin';
  static const String otpverifylogin = 'api/auth/otpverifylogin';

  static const String deleteAccountPermanently = 'api/auth/deleteAccount';
  static const String getscore_flaxible = 'api/auth/flaxible-getscore-cards';
  static const String user_playing_history = 'api/auth/user-playing-history';
  static const String getmatchdetailsbylink = 'api/auth/getmatchdetailsbylink';
  static const String createDynamicDeepLinkForReferral =
      'api/auth/createDynamicDeepLinkForReferral';

  static const String login_registerapi = 'api/auth/app_register_login_new';
  static const String login_registerotp =
      'api/auth/app_verify_otp_register_login';
  static const String getGstDetails = 'api/auth/addcashgstcalculation';
  static const String getTdsDetails = 'api/auth/withdrwal-tds-popup';
  static const String NttPayRequest = 'api/auth/ndpsRequest';
  static const String cashFreeCheckSum = 'api/auth/cashfreeRequest';
  static const String splashUpdate = 'api/auth/get-splash-banners';
  static const String uploadUpiImage = 'api/auth/upload-upi-image';

  static const String submitUpiTnx = 'api/auth/add-fund-request';

  static const String getCartContests = 'api/auth/get-cart-challenges';

  static const String getCartDetails = 'api/auth/show-cart-items';

  static const String getTeamDetailsByLink = 'api/auth/team-details';

  static const String getTempContests = 'api/auth/get-template-contests';
}
