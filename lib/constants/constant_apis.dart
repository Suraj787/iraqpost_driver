// ignore_for_file: constant_identifier_names

class AppConstants {
  // static const String BASE_URL = 'http://192.168.29.32:4000';
  // static const String DOMAIN = 'https://app.namasteremittance.com.au/';
  static const String DOMAIN = 'https://admin.superfastremit.com/';
  static const String BASE_URL = '${DOMAIN}ws/web/';
  static const String REGISTER_URI = 'register';
  static const String LOGIN_URI = 'signin';
  static const String COUNTRY = 'getCounteries';
  static const String SharePrefeCOUNTRY = 'Countrylist';
  static const String LANGUAGELIST = 'getLanguages?app_id=';
  static const String GETAPPS = 'getApps';
  static const String USERSBYID = 'users';
  static const String CATEGORIESLIST = 'getCategories?app_id=';

  static const String ANDROID_APP_LINK =
      "https://play.google.com/store/apps/details?id=com.magic.magic_remit";
  static const String IOS_APP_LINK =
      "https://apps.apple.com/us/app/everest-express-remit/id6452677306";
  static const String TERMS_CON_LINK =
      "https://everestexpress.com.au/termAndCondition.php";
  static const String PRIVACY_LINK =
      "https://everestexpress.com.au/privacypolicy.php";
  static const String WEBSITE = "https://everestexpress.com.au";

  static const String POST_ADMIN_Rate = 'getrate';
  static const String POST_ADMIN_SETTING = 'getadminsettings';
  static const String POST_LOGIN = 'wsauth';
  static const String FORGET_PASSWORD = 'forgetpassword';
  static const String SIGNUP_ONE = 'otpsignupv2';
  static const String POST_SENDER = 'getsender';
  static const String POST_RECEIVER_LIST = 'getreceiverlist';
  static const String POST_ORDER_LIST = 'getorderlist';
  static const String ADD_RECEIVER = 'addreceiver';
  static const String UPDATED_RECEIVER = 'editreceiver';
  static const String UPLOAD_FILE_2 = 'uploadfilev2';
  static const String CRETED_ORDER = 'createorder';
  static const String UPDATED_PROFILE = 'editsender';
  static const String DETELE_PROFILE = 'inactivatelogin';

  // Share Prefernce
  static const String IntroScreen = 'introscreenshow';
  static const String SaveExchanegRate = 'saveexchanegrate_rate';
  static const String SaveAccessKey = 'saveaccesskey_email';
  static const String SaveAccessSecret = 'saveaccesssecret_pass';
  static const String SaveUserCode = 'saveusercode_usedid';
  static const String userData = 'userdatas';
  static const String saveNowTime = 'save_now_time';
  static const String RememberMe = 'remember_me_check';

//   text
  static const String APP_NAME = 'Remit Hubs';
  static const double APP_VERSION = 1.0;
  static const String THEME = 'theme';
  static const String INTRO = 'intro';
  static const String TOKEN = 'token';
  static const String LANGUAGE_CODE = 'language_code';
  static const String ANDROID_VERSION = "android45";
  static const String IOS_VERSION = "ios45";
  static const String VERSION = "ANDROID45";
}

const routeJsonData = '''{
      "route_info": [
        {
          "provider": "Google Maps",
          "destination": {"latitude": 33.24456, "longitude": 44.133345},
          "estimated_travel_time": 7564.0,
          "formatted_travel_time": "2 hours 6 minutes",
          "distance": "196.84 km",
          "geometry": {
            "type": "LineString",
            "coordinates": "gjhbEqkdqGlAiEoHnRkPhEgt@vBe\\\\r@sb@hAy]Baq@|Fsx@zGi^hC{FFc]uFos@gQk`Bu_@ob@oG}_@wDemAwMy}@_JaZ{DweAwU{^kJ_OiAcIXyUzAgNdIqR~I{KPiUXeBWWE]d@wb@~Pyk@lSmqA|g@q_CpbAsi@rTkg@bRaRlD}UvAqIDcYw@wR_C_mDag@_cBcVobAsQeFcAxEiLtA{B`HgAzCbBu@`HqTtg@moA~uCaz@zmBuVrf@qUp^g@ne@ka@v^wYpS}_@zSsi@dTaj@dNi[xG_NjDsW|K{Y~Puc@z`@_\\\\bc@ud@}@ib@hx@mKbPoOlR}TxUel@ne@w_Ant@}UrQub@b_@kLpMuPpVgL~Rw]h~@aXvw@sNf^qLhVgc@br@km@xq@efAliAwQlT}RtYac@r{@_Mn]mMhk@qN|w@wOj|@kLhc@_Qlc@qHnNiSbYy\\\\b^g_@dYkmApn@a@|SyVpRmVvViKzMofAlyAqi@nv@cV~Xu[jZgd@j[sj@fXgi@pPmb@|H_g@zE_i@rGsb@hKwZfLcf@bX}\\\\dXmg@nh@iShRiTzOoUdNye@dSkc@bL_f@lGkl@A{e@}Aqj@oAig@|@}i@~Ecl@vK_j@xP_g@dUy{B`tAmkCv~Aqk@pWkr@jSc]pGeU|Caa@Dma@|@a\\\\Soe@aCqY}Cka@gGwe@eHmnAwP{b@wB_c@NoZzAk[jD_n@vMijAj^ul@xQe\\\\fHm_@dFs_@zB_e@Ncg@eCq`AqO}uAkWofAcQoc@eDil@_Ai\\\\n@yu@tFq@pGk`Br`@y_AvU{j@vKc}@xHe|AvFm`DrLsm@bEai@fIch@rM{j@fTo_@zRac@vY_[lW{Zp[w\\\\~b@q_@do@{w@ddBaVzp@wJr_@oI~d@oGhm@{EvvAyBfv@yDbp@mHpp@cPr|@wNfj@wJzY{a@naAo^t{@gTjr@sJda@gK`j@aShaAyNff@mMd]yR`b@e[rh@s^~d@mWvWsi@|b@gr@i@qRlSwN~Rqp@rjAkd@ho@im@vn@s@~g@aJhOa^vs@oPvd@cLta@ia@|cBsUzo@mTvb@eYnc@eYz\\\\s|@b@kTfWqNnT_Pr[eBrBuFpCiE{@aU{e@aUu_@yLeOgWoWaCi@mMaNY[kNePUkD[wFgC}@_AFk@jEaAxFoDyAKkAfAeBnBf@fX`Ytg@g@\\\\c@xI~N`Od]tL~XbCnKi@rImCxEyCCoAsAIuEvPeh@tJgT|[og@zmA_qAdYe]lXsb@pIuO|BaFdDrCpL}WbG}P"
          }
        },
        {
          "provider": "Google Maps",
          "destination": {"latitude": 33.23456, "longitude": 44.123345},
          "estimated_travel_time": 528.0,
          "formatted_travel_time": "0 hours 8 minutes",
          "distance": "4.31 km",
          "geometry": {
            "type": "LineString",
            "coordinates": "_c|iEkyjlGoChIk@pAgA`DcDxHuC|GwBdEs@]qBuBd@aAbBkDlAuCzEkLbE}K`FaOzBuHHHVFHL~BhAA^{@bD_A|Cw@pBEl@d@vAPNBh@nBrJl@`EAjB@h@xAtJd@bCX`Af@x@fAdAlDrEdArAB^P\\\\jAJPMr@JpSeDtKcBh@bFt@vH"
          }
        }
      ],
      "total_time": "2 hours 14 minutes",
      "total_distance": "201.14 km",
      "provider": "Google Maps",
      "status": "success"
    }''';
