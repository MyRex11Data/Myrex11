import 'package:myrex11/repository/model/cartDetailsResponse.dart';
import 'package:myrex11/repository/model/splashResponse.dart';
import 'package:dio/dio.dart';
import 'package:myrex11/repository/model/flexible_data_response.dart';
import 'package:myrex11/repository/model/invite_contest_response.dart';
import 'package:myrex11/repository/model/nttPayResponse.dart';
import 'package:myrex11/repository/model/refer_dynamic_link.dart';
import 'package:myrex11/repository/model/sonic_pay_model.dart';
import 'package:myrex11/repository/model/sonic_pay_process_model.dart';
import 'package:myrex11/repository/model/sonic_pay_response.dart';
import 'package:myrex11/repository/model/aadhar_details_response.dart';
import 'package:myrex11/repository/model/aadhar_verification_request.dart';
import 'package:myrex11/repository/model/sonicpay_transaction_status_model.dart';
import 'package:myrex11/repository/model/tds_data.dart';
import 'package:myrex11/repository/model/tds_list_data_model.dart';
import 'package:myrex11/repository/model/tds_model.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/repository/model/bank_details_response.dart';
import 'package:myrex11/repository/model/bank_verification_request.dart';
import 'package:myrex11/repository/model/bank_verify_response.dart';
import 'package:myrex11/repository/model/banner_response.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/base_response.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
import 'package:myrex11/repository/model/compare_team_response.dart';
import 'package:myrex11/repository/model/contest_details_response.dart';
import 'package:myrex11/repository/model/contest_request.dart';
import 'package:myrex11/repository/model/contest_response.dart';
import 'package:myrex11/repository/model/create_private_contest_request.dart';
import 'package:myrex11/repository/model/create_private_contest_response.dart';
import 'package:myrex11/repository/model/create_team_request.dart';
import 'package:myrex11/repository/model/create_team_response.dart';
import 'package:myrex11/repository/model/earn_contests_response.dart';
import 'package:myrex11/repository/model/finish_matchlist_response.dart';
import 'package:myrex11/repository/model/join_contest_by_code_request.dart';
import 'package:myrex11/repository/model/join_contest_by_code_response.dart';
import 'package:myrex11/repository/model/join_contest_request.dart';
import 'package:myrex11/repository/model/join_contest_response.dart';
import 'package:myrex11/repository/model/leaderboard_details_response.dart';
import 'package:myrex11/repository/model/leaderboard_series_response.dart';
import 'package:myrex11/repository/model/live_data_response.dart';
import 'package:myrex11/repository/model/login_request.dart';
import 'package:myrex11/repository/model/data.dart';
import 'package:myrex11/repository/model/matchlist_response.dart';
import 'package:myrex11/repository/model/my_balance_response.dart';
import 'package:myrex11/repository/model/notification_response.dart';
import 'package:myrex11/repository/model/offer_list_response.dart';
import 'package:myrex11/repository/model/otp_request.dart';
import 'package:myrex11/repository/model/pan_details_response.dart';
import 'package:myrex11/repository/model/pan_verification_request.dart';
import 'package:myrex11/repository/model/player_info_response.dart';
import 'package:myrex11/repository/model/player_list_response.dart';
import 'package:myrex11/repository/model/player_points_response.dart';
import 'package:myrex11/repository/model/promote_app_request.dart';
import 'package:myrex11/repository/model/promoter_teams_response.dart';
import 'package:myrex11/repository/model/promoter_total_response.dart';
import 'package:myrex11/repository/model/refer_list_response.dart';
import 'package:myrex11/repository/model/refresh_score_response.dart';
import 'package:myrex11/repository/model/register_request.dart';
import 'package:myrex11/repository/model/score_card_response.dart';
import 'package:myrex11/repository/model/series_leaderboard_response.dart';
import 'package:myrex11/repository/model/team_preview_point_request.dart';
import 'package:myrex11/repository/model/team_preview_point_response.dart';
import 'package:myrex11/repository/model/team_response.dart';
import 'package:myrex11/repository/model/teamname_update_request.dart';
import 'package:myrex11/repository/model/transactions_response.dart';
import 'package:myrex11/repository/model/transactions_request.dart';
import 'package:myrex11/repository/model/usable_balance_response.dart';
import 'package:myrex11/repository/model/user_details_response.dart';
import 'package:myrex11/repository/model/verify_response.dart';
import 'package:myrex11/repository/model/withdraw_amount_response.dart';
import 'package:myrex11/repository/retrofit/apis.dart';
import 'package:retrofit/http.dart';
import '../../dataModels/get_offer_response.dart';
import '../model/account_play_response.dart';
import '../model/cashfreeResponse.dart';
import '../model/gst_details_response.dart';
import '../model/refer_code_response.dart';
part 'api_client.g.dart';

@RestApi(baseUrl: AppConstants.base_api_url)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST(Apis.userLogin)
  Future<LoginResponse> userLogin(@Body() LoginRequest loginRequest);

  @POST(Apis.userLoginSocial)
  Future<LoginResponse> userLoginSocial(@Body() LoginRequest loginRequest);

  @POST(Apis.userLoginApple)
  Future<LoginResponse> userLoginWithApple(@Body() LoginRequest loginRequest);

  @POST(Apis.userRegisterNew)
  Future<LoginResponse> userRegisterNew(@Body() RegisterRequest loginRequest);

  @POST(Apis.validateMobileOtp)
  Future<LoginResponse> validateMobileOtp(@Body() OtpRequest otpRequest);

  @POST(Apis.otpRegisterVerifyNew)
  Future<LoginResponse> otpRegisterVerifyNew(@Body() OtpRequest otpRequest);

  @POST(Apis.verifyForgotMobileOtp)
  Future<LoginResponse> verifyForgotMobileOtp(@Body() OtpRequest otpRequest);

/*  @POST(Apis.sendOTPNew)
  Future<GeneralResponse> sendOTPNew(@Body() GeneralRequest GeneralRequest);*/

  @POST(Apis.sendOTPNew)
  Future<GeneralResponse> sendOTPNew(@Body() Map<String, dynamic> data);

  @POST(Apis.resendOTP)
  Future<LoginResponse> resendOTP(@Body() NewLoginRequest loginRequest);

  @POST(Apis.sendOTP)
  Future<GeneralResponse> sendOTP(@Body() GeneralRequest GeneralRequest);

  @POST(Apis.forgotPasswordNew)
  Future<LoginResponse> forgotPasswordNew(
      @Body() GeneralRequest GeneralRequest);

  @POST(Apis.sendForgotOTP)
  Future<GeneralResponse> sendForgotOTP(@Body() GeneralRequest GeneralRequest);

  @POST(Apis.changePassword)
  Future<GeneralResponse> changePassword(@Body() GeneralRequest GeneralRequest);

  @POST(Apis.changePasswordAfterForgot)
  Future<GeneralResponse> changePasswordAfterForgot(
      @Body() GeneralRequest GeneralRequest);

  @POST(Apis.getUserBalance)
  Future<MyBalanceResponse> getUserBalance(
      @Body() GeneralRequest GeneralRequest);

  @POST(Apis.getBannerList)
  Future<BannerListResponse> getBannerList(
      @Body() GeneralRequest GeneralRequest);

  @POST(Apis.getMatchList)
  Future<MatchListResponse> getMatchList(@Body() GeneralRequest GeneralRequest);

  @POST(Apis.remindMe)
  Future<GeneralResponse> remindMe(@Body() GeneralRequest GeneralRequest);

  @POST(Apis.updateTeamName)
  Future<GeneralResponse> updateTeamName(
      @Body() TeamNameUpdateRequest teamNameUpdateRequest);

  @POST(Apis.requestDeposite)
  Future<GeneralResponse> updateDepositAmount(
      @Body() GeneralRequest generalRequest);

  @POST(Apis.winningToCash)
  Future<WithdrawResponse> winningTransferAmount(
      @Body() GeneralRequest generalRequest);

  @POST(Apis.getMyMatchLiveList)
  Future<MatchListResponse> getMyMatchLiveList(
      @Body() GeneralRequest teamNameUpdateRequest);

  @POST(Apis.getMyMatchFinishList)
  Future<FinishMatchListResponse> getMyMatchFinishList(
      @Body() GeneralRequest teamNameUpdateRequest);

  @POST(Apis.getLevelData)
  Future<LevelDataResponse> getLevelData(
      @Body() GeneralRequest levelDataRequest);

  @POST(Apis.getPlayData)
  Future<PlayDataResponse> getPlayData(
      @Body() GeneralRequest teamNameUpdateRequest);

  @POST(Apis.getUserNotification)
  Future<GetNotificationResponse> getUserNotification(
      @Body() GeneralRequest teamNameUpdateRequest);

  @POST(Apis.getFullUserDetails)
  Future<GetUserFullDetailsResponse> getFullUserDetails(
      @Body() GeneralRequest teamNameUpdateRequest);

  @POST(Apis.updateUserProfile)
  Future<GeneralResponse> updateUserProfile(
      @Body() UserDetailValue userDetailValue);

  @POST(Apis.getReferBonusList)
  Future<ReferBonusListResponse> getReferBonusList(
      @Body() GeneralRequest generalRequest);

  @POST(Apis.allVerify)
  Future<AllVerifyResponse> allVerify(@Body() GeneralRequest generalRequest);

  @POST(Apis.getPainDetail)
  Future<PanDetailsResponse> getPainDetail(
      @Body() GeneralRequest generalRequest);

  @POST(Apis.verifyAadharDetail)
  Future<AadharDetailsResponse> verifyAadharDetail(
      @Body() AadharVerificationRequest generalRequest);

  @POST(Apis.verifyAddressDetail)
  Future<AadharDetailsResponse> verifyAddressDetail(
      @Body() AddressVerificationRequest generalRequest);

  @POST(Apis.getBankDetails)
  Future<BankDetailResponse> getBankDetails(
      @Body() GeneralRequest generalRequest);

  @POST(Apis.verifyPanDetail)
  Future<PanDetailsResponse> verifyPanDetail(
      @Body() PanVerificationRequest generalRequest);

  @POST(Apis.verifyBankDetail)
  Future<BankVerifyResponse> verifyBankDetail(
      @Body() BankVerifyRequest generalRequest);
  @POST(Apis.verifyUPIDetail)
  Future<UpiVerifyResponse> verifyUPIDetail(
      @Body() BankVerifyRequest generalRequest);
  @POST(Apis.verifyEmailStatus)
  Future<GeneralResponse> verifyEmailStatus(
      @Body() GeneralRequest generalRequest);

  @POST(Apis.sendNewEmail)
  Future<GeneralResponse> sendNewEmail(@Body() GeneralRequest generalRequest);

  @POST(Apis.verifyOtpNew)
  Future<LoginResponse> verifyOtpNew(@Body() GeneralRequest generalRequest);

  @POST(Apis.verifyOtp)
  Future<LoginResponse> verifyOtp(@Body() GeneralRequest generalRequest);

  @POST(Apis.verifyEmailOtp)
  Future<LoginResponse> verifyEmailOtp(@Body() GeneralRequest generalRequest);

  @POST(Apis.getAffiliationTotal)
  Future<PromoterTotalResponse> getAffiliationTotal(
      @Body() Map<String, dynamic> requestData);

  @POST(Apis.getAffiliateMatchData)
  Future<MatchListResponse> getAffiliateMatchData(
      @Body() GeneralRequest generalRequest);

  @POST(Apis.getAffiliateEarnData)
  Future<EarnContestResponse> getAffiliateEarnData(
      @Body() GeneralRequest generalRequest);

  @POST(Apis.promoterTeams)
  Future<PromoterTeamsResponse> promoterTeams(
      @Body() GeneralRequest generalRequest);

  @POST(Apis.updatePromoteAppDetails)
  Future<GeneralResponse> updatePromoteAppDetails(
      @Body() PromoteAppRequest generalRequest);

  @POST(Apis.getMyTransaction)
  Future<TransactionsResponse> getMyTransaction(
      @Body() TransactionRequest generalRequest);

  @POST(Apis.getWithdrawTransaction)
  Future<WithdrawTnxResponse> getWithdrawTransaction(
      @Body() TransactionRequest generalRequest);

  @POST(Apis.transactionDownload)
  Future<GeneralResponse> transactionDownload(
      @Body() TransactionRequest generalRequest);

  @POST(Apis.addCaseOfferList)
  Future<OfferListResponse> addCaseOfferList(
      @Body() GeneralRequest generalRequest);

  @POST(Apis.tdsData)
  Future<GetTDSData> getTDSCalculationData(
      @Body() GeneralRequest generalRequest);

  @POST(Apis.applyPromoCode)
  Future<GeneralResponse> applyPromoCode(@Body() GeneralRequest generalRequest);

  @POST(Apis.withdrawUserBalance)
  Future<WithdrawResponse> withdrawUserBalance(
      @Body() Map<String, dynamic> generalRequest);

  @POST(Apis.CheckWithdrawStatus)
  Future<CheckWithdrawResponse> CheckWithdrawStatus(
      @Body() BankInstantRequest loginRequest);

  @POST(Apis.getContestByCategory)
  Future<CategoryByContestResponse> getContestByCategory(
      @Body() ContestRequest generalRequest);

  @POST(Apis.getContestByCategoryId)
  Future<ContestResponse> getContestByCategoryId(
      @Body() ContestRequest generalRequest);

  @POST(Apis.getContests)
  Future<ContestResponse> getContests(@Body() ContestRequest generalRequest);

  @POST(Apis.getJoinedContests)
  Future<ContestResponse> getJoinedContests(
      @Body() ContestRequest generalRequest);

  @POST(Apis.getMyTeams)
  Future<MyTeamResponse> getMyTeams(@Body() ContestRequest generalRequest);

  @POST(Apis.getFavouriteContest)
  Future<GeneralResponse> getFavouriteContest(
      @Body() GeneralRequest generalRequest);

  @POST(Apis.addMatchPins)
  Future<GeneralResponse> addPinContest(@Body() GeneralRequest generalRequest);

  @POST(Apis.getWinnersPriceCard)
  Future<ScoreCardResponse> getWinnersPriceCard(
      @Body() ContestRequest generalRequest);

  @POST(Apis.getLeaderboardList)
  Future<ContestDetailResponse> getLeaderboardList(
      @Body() ContestRequest generalRequest);

  @POST(Apis.getPlayerList)
  Future<PlayerListResponse> getPlayerList(
      @Body() ContestRequest generalRequest);

  @POST(Apis.switchTeam)
  Future<GeneralResponse> switchTeam(@Body() ContestRequest generalRequest);

  @POST(Apis.getUsableBalance)
  Future<BalanceResponse> getUsableBalance(
      @Body() JoinContestRequest generalRequest);

  @POST(Apis.joinChallenge)
  Future<JoinContestResponse> joinChallenge(
      @Body() JoinContestRequest generalRequest);

  @POST(Apis.createTeam)
  Future<CreateTeamResponse> createTeam(
      @Body() CreateTeamRequest generalRequest);

  @POST(Apis.joinByContestCode)
  Future<JoinContestByCodeResponse> joinByContestCode(
      @Body() JoinContestByCodeRequest generalRequest);

  @POST(Apis.getMatchScores)
  Future<RefreshScoreResponse> getMatchScores(
      @Body() ContestRequest generalRequest);

  @POST(Apis.getPlayerPoints)
  Future<PlayerPointsResponse> getPlayerPoints(
      @Body() ContestRequest generalRequest);

  @POST(Apis.getPreviewPlayers)
  Future<TeamPointPreviewResponse> getPreviewPlayers(
      @Body() TeamPreviewPointRequest generalRequest);

  @POST(Apis.createContest)
  Future<CreatePrivateContestResponse> createContest(
      @Body() CreatePrivateContestRequest request);

  @POST(Apis.getSeries)
  Future<SeriesResponse> getSeries(@Body() GeneralRequest request);

  @POST(Apis.getInvestments)
  Future<SeriesResponse> getInvestments(@Body() GeneralRequest request);

  @POST(Apis.gethomepromoter)
  Future<SeriesResponse> gethomepromoterSeries(@Body() GeneralRequest request);

  @POST(Apis.getDeposit)
  Future<SeriesResponse> getDeposit(@Body() GeneralRequest request);

  @POST(Apis.getPromoterSeries)
  Future<SeriesResponse> getPromoterSeries(@Body() GeneralRequest request);

  @POST(Apis.getSeriesLeaderboard)
  Future<SeriesLeaderboardResponse> getSeriesLeaderboard(
      @Body() GeneralRequest request);

  @POST(Apis.getInvestmentsLeaderboard)
  Future<SeriesLeaderboardResponse> getInvestmentsLeaderboard(
      @Body() GeneralRequest request);

  @POST(Apis.gethomepromoterLeaderboard)
  Future<SeriesLeaderboardResponse> gethomepromoterLeaderboard(
      @Body() GeneralRequest request);

  @POST(Apis.getDepositLeaderboard)
  Future<SeriesLeaderboardResponse> getDepositLeaderboard(
      @Body() GeneralRequest request);

  @POST(Apis.getInvestmentsMatchLeaderboard)
  Future<LeaderboardDetailsResponse> getInvestmentsMatchLeaderboard(
      @Body() GeneralRequest request);

  @POST(Apis.getDepositMatchLeaderboard)
  Future<LeaderboardDetailsResponse> getDepositMatchLeaderboard(
      @Body() GeneralRequest request);

  @POST(Apis.getLeaderboardDetails)
  Future<LeaderboardDetailsResponse> getLeaderboardDetails(
      @Body() GeneralRequest request);

  @POST(Apis.getPromoterLeaderboardDetails)
  Future<LeaderboardDetailsResponse> getPromoterLeaderboardDetails(
      @Body() GeneralRequest request);

  @POST(Apis.getPromoterLeaderboard)
  Future<SeriesLeaderboardResponse> getPromoterLeaderboard(
      @Body() GeneralRequest request);

  @POST(Apis.getPromoterMatchLeaderboard)
  Future<LeaderboardDetailsResponse> getPromoterMatchLeaderboard(
      @Body() GeneralRequest request);

  @POST(Apis.getCompareTeamData)
  Future<CompareTeamResponse> getCompareTeamData(
      @Body() GeneralRequest request);

  @POST(Apis.removeProfilePhoto)
  Future<GeneralResponse> removeProfilePhoto(@Body() GeneralRequest request);

  @POST(Apis.getPlayerInfo)
  Future<PLayerInfoResponse> getPlayerInfo(@Body() GeneralRequest request);

  @POST(Apis.getReferCode)
  Future<ReferCodeResponse> getRefercode(@Body() GeneralRequest request);

  @POST(Apis.getOffer)
  Future<GetOfferResponse> getOffer(@Body() GeneralRequest request);

  @POST(Apis.getLevelData)
  Future<LevelDataResponse> userLevel(@Body() GeneralRequest request);

  @FormUrlEncoded()
  @POST(Apis.getCfToken)
  Future<GeneralResponse> getCfToken(data);

  @POST(Apis.getTds)
  Future<GetTdsData> getTds(@Body() GeneralRequest request);

  @POST(Apis.getTdsList)
  Future<TdsListData> getTdsList(@Body() GeneralRequest request);

  @POST(Apis.createOrderSonicPay)
  Future<SonicPayCreate> createOrderSonicPay(@Body() GeneralRequest request);

  @POST(Apis.sonicpeOrderProcess)
  Future<SonicPayProcessResponse> sonicpeOrderProcess(
      @Body() SonicPayRequest request);

  @POST(Apis.sonicpeTransactionStatus)
  Future<SonicPayTransactionResponse> sonicpeTransactionStatus(
      @Body() SonicPayRequest request);

  @POST(Apis.getscore_flaxible)
  Future<FlexibleDataResponse> flexibleDataResponse(
      @Body() GeneralRequest request);

  @POST(Apis.getmatchdetailsbylink)
  Future<InviteContestData> inviteContestResponse(
      @Body() GeneralRequest request);

  @POST(Apis.createDynamicDeepLinkForReferral)
  Future<ReferDynamicLink> getDynamicLintRefer(@Body() GeneralRequest request);

  @POST(Apis.emailorphonelogin)
  Future<LoginResponse> emailorphonelogin(@Body() LoginRequest request);

  @POST(Apis.otpverifylogin)
  Future<LoginResponse> otpverifylogin(@Body() LoginRequest request);

  @POST(Apis.deleteAccountPermanently)
  Future<JoinContestByCodeResponse> deleteUserAccount(
      @Body() JoinContestByCodeRequest generalRequest);

  @POST(Apis.user_playing_history)
  Future<dynamic> playingHistoryResponse(@Body() GeneralRequest request);

  @POST(Apis.login_registerapi)
  Future<LoginResponse> login_registerapi(@Body() Map<String, dynamic> request);

  @POST(Apis.login_registerotp)
  Future<LoginResponse> login_registerotp(@Body() NewLoginRequest request);

  @POST(Apis.getGstDetails)
  Future<GstResponse> getGstDetails(@Body() GeneralRequest generalRequest);

  @POST(Apis.getTdsDetails)
  Future<WithdrawalConfirmation> getTdsDetails(
      @Body() NormalRequest generalRequest);

  @POST(Apis.NttPayRequest)
  Future<NttPayResponse> nttPayRequest(@Body() NormalRequest request);

  @POST(Apis.cashFreeCheckSum)
  Future<cashfreeResponse> cashFreeCheckSum(@Body() NormalRequest request);

  @POST(Apis.splashUpdate)
  Future<SplashResponse> splashUpdate(@Body() NormalRequest request);

  @POST(Apis.submitUpiTnx)
  Future<UpiDetailsResponse> submitUpiTnx(@Body() Map<String, dynamic> request);

  @POST(Apis.updateTeamNameNew)
  Future<GeneralResponse> updateTeamNameNew(@Body() NewLoginRequest request);

  @POST(Apis.getCartContests)
  Future<ContestResponse> getCartContests(
      @Body() ContestRequest generalRequest);

  @POST(Apis.getCartDetails)
  Future<ContestCartResponse> getCartDetails(
      @Body() ContestRequest generalRequest);

  @POST(Apis.getTeamDetailsByLink)
  Future<TeamPointPreviewResponse> getTeamDetailsByLink(
      @Body() GeneralRequest generalRequest);

  @POST(Apis.getTempContests)
  Future<ContestResponse> getTempContests(
      @Body() Map<String, dynamic> generalRequest);
}
