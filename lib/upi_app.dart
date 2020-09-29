import 'dart:typed_data';

enum _ValidUpiApps{
  airtelThanksUpi,
  allBank,
  amazonPay,
  auPay,
  axisPay,
  bandhanUpi,
  barodaPay,
  bhim,
  boiUpi,
  candi,
  centUpi,
  cointab,
  corpUpi,
  csbUpi,
  dcbUpi,
  finoBPay,
  freecharge,
  googlePay,
  hsbcSimplyPay,
  iMobileICICI,
  indianBankUpi,
  indusPay,
  jetPay,
  kblUpi,
  khaaliJeb,
  kvbUpay,
  lvbUpaay,
  mahaUpi,
  miPayGlobal,
  miPayXiaomi,
  mobikwik,
  orientalPay,
  paytm,
  paywiz,
  phonePe,
  psb,
  rblPay,
  sbiPay,
  syndUpi,
  trueCallerUpi,
  ucoUpi,
  ultraCash,
  vijayaUpi,
  yesPay,
}

/// This is the model class of apps returned by [getAllUpiApps()].
/// This class contains some predefined package names of UPI apps.
class UpiApp {
  // Start of pre-defined Apps supported by this plugin
  /// Paytm(Paytm-One97 Communications Ltd.): net.one97.paytm
  static UpiApp paytm = UpiApp._fromEnum(_ValidUpiApps.paytm);

  /// Google Pay(GoogleLLC): com.google.android.apps.nbu.paisa.user
  static UpiApp googlePay = UpiApp._fromEnum(_ValidUpiApps.googlePay);

  /// BHIM(National Payments Corporation of India): in.org.npci.upiapp
  static UpiApp bhim = UpiApp._fromEnum(_ValidUpiApps.bhim);

  /// PhonePe: com.phonepe.app
  static UpiApp phonePe = UpiApp._fromEnum(_ValidUpiApps.phonePe);

  /// Mi Pay(Non Xiaomi devices): com.mipay.in.wallet (From Play Store)
  static UpiApp miPayGlobal = UpiApp._fromEnum(_ValidUpiApps.miPayGlobal);

  /// Mi Pay(Only Xiaomi devices): com.mipay.wallet.in (From Get Apps)
  static UpiApp miPayXiaomi = UpiApp._fromEnum(_ValidUpiApps.miPayXiaomi);

  /// Amazon(Amazon Mobile LLC): in.amazon.mShop.android.shopping
  static UpiApp amazonPay = UpiApp._fromEnum(_ValidUpiApps.amazonPay);

  /// Truecaller(True Software Scandinavia AB): com.truecaller
  static UpiApp trueCallerUPI = UpiApp._fromEnum(_ValidUpiApps.trueCallerUpi);

  /// Airtel Thanks(Airtel): com.myairtelapp
  static UpiApp airtelThanksUpi = UpiApp._fromEnum(_ValidUpiApps.airtelThanksUpi);

  /// Mobikwik: com.mobikwik_new
  static UpiApp mobikwik = UpiApp._fromEnum(_ValidUpiApps.mobikwik);

  /// Freecharge: com.freecharge.android
  static UpiApp freecharge = UpiApp._fromEnum(_ValidUpiApps.freecharge);

  /// BHIM SBI Pay(State Bank of India): com.sbi.upi
  static UpiApp sbiPay = UpiApp._fromEnum(_ValidUpiApps.sbiPay);

  /// iMobile(ICICI Bank Ltd.): com.csam.icici.bank.imobile
  static UpiApp iMobileICICI = UpiApp._fromEnum(_ValidUpiApps.iMobileICICI);

  /// BHIM Axis Pay(Axis Bank Ltd.): com.upi.axispay
  static UpiApp axisPay = UpiApp._fromEnum(_ValidUpiApps.axisPay);

  /// BHIM ALLBANK UPI(Allahabad Bank): com.lcode.allahabadupi
  static UpiApp allBank = UpiApp._fromEnum(_ValidUpiApps.allBank);

  /// BHIM AUPay(AU Small Finance Bank Limited): com.aubank.aupay.bhimupi
  static UpiApp auPay = UpiApp._fromEnum(_ValidUpiApps.auPay);

  /// BHIM Bandhan UPI(Bandhan Bank Limited): com.fisglobal.bandhanupi.app
  static UpiApp bandhanUpi = UpiApp._fromEnum(_ValidUpiApps.bandhanUpi);

  /// BHIM Baroda Pay(Bank of Baroda): com.bankofbaroda.upi
  static UpiApp barodaPay = UpiApp._fromEnum(_ValidUpiApps.barodaPay);

  /// BHIM BOI UPI(Bank of India Official): com.infra.boiupi
  static UpiApp boiUpi= UpiApp._fromEnum(_ValidUpiApps.boiUpi);

  /// BHIM Cent UPI(CENTRAL BANK OF INDIA): com.infrasofttech.centralbankupi
  static UpiApp centUpi = UpiApp._fromEnum(_ValidUpiApps.centUpi);

  /// BHIM CORP UPI(Corporation Bank): com.lcode.corpupi
  static UpiApp corpUpi = UpiApp._fromEnum(_ValidUpiApps.corpUpi);

  /// BHIM CSB-UPI(CSB Bank Ltd): com.lcode.csbupi
  static UpiApp csbUpi = UpiApp._fromEnum(_ValidUpiApps.csbUpi);

  /// BHIM DCB Bank UPI(DCB Bank): com.olive.dcb.upi
  static UpiApp dcbUpi = UpiApp._fromEnum(_ValidUpiApps.dcbUpi);

  /// BHIM IndianBank UPI(Indian Bank): com.infrasofttech.indianbankupi
  static UpiApp indianBankUpi = UpiApp._fromEnum(_ValidUpiApps.indianBankUpi);

  /// BHIM IndusPay(IndusInd Bank Ltd.): com.mgs.induspsp
  static UpiApp indusPay = UpiApp._fromEnum(_ValidUpiApps.indusPay);

  /// BHIM JetPay(JSBL, PUNE): com.finacus.jetpay
  static UpiApp jetPay = UpiApp._fromEnum(_ValidUpiApps.jetPay);

  /// BHIM KBL UPI(KARNATAKA BANK): com.lcode.smartz
  static UpiApp kblUpi = UpiApp._fromEnum(_ValidUpiApps.kblUpi);

  /// BHIM KVB Upay(The Karur Vysya Bank Ltd.): com.mycompany.kvb
  static UpiApp kvbUpay = UpiApp._fromEnum(_ValidUpiApps.kvbUpay);

  /// BHIM LVB UPAAY(LAKSHMI VILAS BANK): com.lvbank.upaay
  static UpiApp lvbUpaay = UpiApp._fromEnum(_ValidUpiApps.lvbUpaay);

  /// BHIM Oriental Pay(Oriental Bank of Commerce): com.mgs.obcbank
  static UpiApp orientalPay = UpiApp._fromEnum(_ValidUpiApps.orientalPay);

  ///BHIM PayWiz(IDBI BANK): com.idbibank.paywiz
  static UpiApp paywiz = UpiApp._fromEnum(_ValidUpiApps.paywiz);

  /// BHIM PSB(PUNJAB & SIND BANK): com.mobileware.upipsb
  static UpiApp psb = UpiApp._fromEnum(_ValidUpiApps.psb);

  /// BHIM RBL Pay(RBL Bank Ltd.): com.rblbank.upi
  static UpiApp rblPay = UpiApp._fromEnum(_ValidUpiApps.rblPay);

  /// BHIM SyndUPI(Syndicate Bank): com.fisglobal.syndicateupi.app
  static UpiApp syndUpi = UpiApp._fromEnum(_ValidUpiApps.syndUpi);

  /// BHIM UCO UPI(UCO BANK): com.lcode.ucoupi
  static UpiApp ucoUpi = UpiApp._fromEnum(_ValidUpiApps.ucoUpi);

  /// BHIM VIJAYA UPI App(Vijaya Bank): com.fss.vijayapsp
  static UpiApp vijayaUpi = UpiApp._fromEnum(_ValidUpiApps.vijayaUpi);

  /// BHIM YES PAY(Yes Bank Limited): com.YesBank
  static UpiApp yesPay = UpiApp._fromEnum(_ValidUpiApps.yesPay);

  /// Fino BPay(Fino Payments Bank): com.finopaytech.bpayfino
  static UpiApp finoBPay = UpiApp._fromEnum(_ValidUpiApps.finoBPay);

  /// CANDI-Mobile Banking App!(CANARA BANK): com.canarabank.mobility
  static UpiApp candi = UpiApp._fromEnum(_ValidUpiApps.candi);

  /// Cointab: in.cointab.app
  static UpiApp cointab = UpiApp._fromEnum(_ValidUpiApps.cointab);

  /// HSBC Simply Pay(HSBC India): com.mgs.hsbcupi
  static UpiApp hsbcSimplyPay = UpiApp._fromEnum(_ValidUpiApps.hsbcSimplyPay);

  /// KhaaliJeb: com.khaalijeb.inkdrops
  static UpiApp khaaliJeb = UpiApp._fromEnum(_ValidUpiApps.khaaliJeb);

  /// BHIM Maha UPI(Bank of Maharashtra): com.infrasofttech.mahaupi
  static UpiApp mahaUpi = UpiApp._fromEnum(_ValidUpiApps.mahaUpi);

  /// UltraCash: com.ultracash.payment.customer
  static UpiApp ultraCash = UpiApp._fromEnum(_ValidUpiApps.ultraCash);

  // End of pre-defined Apps

  /// app is the package name of the app. Pass this in [app] argument of [startTransaction]
  String packageName;

  /// This is the app name for display purpose
  String name;

  /// This is the icon of the UPI app. Pass it in [Image.memory()] to display the icon.
  Uint8List icon;

  // Default constructor
  UpiApp(appName, package){
    packageName = package;
    name=appName;
  }
  
  // Constructor for enum
  UpiApp._fromEnum(_ValidUpiApps app){
    this.packageName = _getPackageName(app);
    this.name = _getName(app);
  }

  // Constructor for apps returned by PackageManager containing App Icon
  UpiApp.fromMap(Map<String, dynamic> m) {
    packageName = m['packageName'];
    name = m['name'];
    icon = m['icon'];
  }
  
  String _getName(_ValidUpiApps app){
    switch(app){
      case _ValidUpiApps.googlePay:
        return "Google Pay";
      case _ValidUpiApps.phonePe:
        return 'PhonePe';
      case _ValidUpiApps.paytm:
        return 'Paytm';
      case _ValidUpiApps.sbiPay:
        return 'SBI Pay';
      case _ValidUpiApps.iMobileICICI:
        return 'iMobile by ICICI';
      case _ValidUpiApps.bhim:
        return 'BHIM';
      case _ValidUpiApps.miPayGlobal:
      case _ValidUpiApps.miPayXiaomi:
        return 'MiPay';
      case _ValidUpiApps.amazonPay:
        return 'Amazon Pay';
      case _ValidUpiApps.trueCallerUpi:
        return 'Truecaller';
      case _ValidUpiApps.airtelThanksUpi:
        return 'Airtel Thanks';
      case _ValidUpiApps.axisPay:
        return 'Axis Pay';
      case _ValidUpiApps.allBank:
        return 'ALLBANK';
      case _ValidUpiApps.auPay:
        return 'AUPay';
      case _ValidUpiApps.bandhanUpi:
        return 'Bandhan UPI';
      case _ValidUpiApps.barodaPay:
        return 'Baroda Pay';
      case _ValidUpiApps.boiUpi:
        return 'BOI UPI';
      case _ValidUpiApps.centUpi:
        return 'Cent UPI';
      case _ValidUpiApps.corpUpi:
        return 'CORP UPI';
      case _ValidUpiApps.csbUpi:
        return 'CSB UPI';
      case _ValidUpiApps.dcbUpi:
        return 'DCB UPI';
      case _ValidUpiApps.indianBankUpi:
        return 'IndianBank UPI';
      case _ValidUpiApps.indusPay:
        return 'IndusPay';
      case _ValidUpiApps.jetPay:
        return 'JetPay';
      case _ValidUpiApps.kblUpi:
        return 'KBL UPI';
      case _ValidUpiApps.kvbUpay:
        return 'KVB Upay';
      case _ValidUpiApps.lvbUpaay:
        return 'LVB Upaay';
      case _ValidUpiApps.orientalPay:
        return 'Oriental Pay';
      case _ValidUpiApps.paywiz:
        return 'Paywiz';
      case _ValidUpiApps.psb:
        return 'PSB';
      case _ValidUpiApps.rblPay:
        return 'RBL Pay';
      case _ValidUpiApps.syndUpi:
        return 'SyndUPI';
      case _ValidUpiApps.ucoUpi:
        return 'UCO UPI';
      case _ValidUpiApps.vijayaUpi:
        return 'Vijaya UPI';
      case _ValidUpiApps.yesPay:
        return 'Yes Pay';
      case _ValidUpiApps.finoBPay:
        return 'Fino BPay';
      case _ValidUpiApps.candi:
        return 'CANDI';
      case _ValidUpiApps.cointab:
        return 'Cointab';
      case _ValidUpiApps.freecharge:
        return 'Freecharge';
      case _ValidUpiApps.hsbcSimplyPay:
        return 'HSBC Simply Pay';
      case _ValidUpiApps.khaaliJeb:
        return 'KhaaliJeb';
      case _ValidUpiApps.mahaUpi:
        return 'MahaUPI';
      case _ValidUpiApps.mobikwik:
        return 'Mobikwik';
      case _ValidUpiApps.ultraCash:
        return 'UltraCash';
      default:
        return "Unknown";
    }
  }

  String _getPackageName(_ValidUpiApps app) {
    switch (app) {
      case _ValidUpiApps.googlePay:
        return "com.google.android.apps.nbu.paisa.user";
      case _ValidUpiApps.phonePe:
        return 'com.phonepe.app';
      case _ValidUpiApps.paytm:
        return 'net.one97.paytm';
      case _ValidUpiApps.sbiPay:
        return 'com.sbi.upi';
      case _ValidUpiApps.iMobileICICI:
        return 'com.csam.icici.bank.imobile';
      case _ValidUpiApps.bhim:
        return 'in.org.npci.upiapp';
      case _ValidUpiApps.miPayGlobal:
        return 'com.mipay.in.wallet';
      case _ValidUpiApps.miPayXiaomi:
        return 'com.mipay.wallet.in';
      case _ValidUpiApps.amazonPay:
        return 'in.amazon.mShop.android.shopping';
      case _ValidUpiApps.trueCallerUpi:
        return 'com.truecaller';
      case _ValidUpiApps.airtelThanksUpi:
        return 'com.myairtelapp';
      case _ValidUpiApps.axisPay:
        return 'com.upi.axispay';
      case _ValidUpiApps.allBank:
        return 'com.lcode.allahabadupi';
      case _ValidUpiApps.auPay:
        return 'com.aubank.aupay.bhimupi';
      case _ValidUpiApps.bandhanUpi:
        return 'com.fisglobal.bandhanupi.app';
      case _ValidUpiApps.barodaPay:
        return 'com.bankofbaroda.upi';
      case _ValidUpiApps.boiUpi:
        return 'com.infra.boiupi';
      case _ValidUpiApps.centUpi:
        return 'com.infrasofttech.centralbankupi';
      case _ValidUpiApps.corpUpi:
        return 'com.lcode.corpupi';
      case _ValidUpiApps.csbUpi:
        return 'com.lcode.csbupi';
      case _ValidUpiApps.dcbUpi:
        return 'com.olive.dcb.upi';
      case _ValidUpiApps.indianBankUpi:
        return 'com.infrasofttech.indianbankupi';
      case _ValidUpiApps.indusPay:
        return 'com.mgs.induspsp';
      case _ValidUpiApps.jetPay:
        return 'com.finacus.jetpay';
      case _ValidUpiApps.kblUpi:
        return 'com.lcode.smartz';
      case _ValidUpiApps.kvbUpay:
        return 'com.mycompany.kvb';
      case _ValidUpiApps.lvbUpaay:
        return 'com.lvbank.upaay';
      case _ValidUpiApps.orientalPay:
        return 'com.mgs.obcbank';
      case _ValidUpiApps.paywiz:
        return 'com.idbibank.paywiz';
      case _ValidUpiApps.psb:
        return 'com.mobileware.upipsb';
      case _ValidUpiApps.rblPay:
        return 'com.rblbank.upi';
      case _ValidUpiApps.syndUpi:
        return 'com.fisglobal.syndicateupi.app';
      case _ValidUpiApps.ucoUpi:
        return 'com.lcode.ucoupi';
      case _ValidUpiApps.vijayaUpi:
        return 'com.fss.vijayapsp';
      case _ValidUpiApps.yesPay:
        return 'com.YesBank';
      case _ValidUpiApps.finoBPay:
        return 'com.finopaytech.bpayfino';
      case _ValidUpiApps.candi:
        return 'com.canarabank.mobility';
      case _ValidUpiApps.cointab:
        return 'in.cointab.app';
      case _ValidUpiApps.freecharge:
        return 'com.freecharge.android';
      case _ValidUpiApps.hsbcSimplyPay:
        return 'com.mgs.hsbcupi';
      case _ValidUpiApps.khaaliJeb:
        return 'com.khaalijeb.inkdrops';
      case _ValidUpiApps.mahaUpi:
        return 'com.infrasofttech.mahaupi';
      case _ValidUpiApps.mobikwik:
        return 'com.mobikwik_new';
      case _ValidUpiApps.ultraCash:
        return 'com.ultracash.payment.customer';
      default:
        return 'unknown';
    }
  }
}