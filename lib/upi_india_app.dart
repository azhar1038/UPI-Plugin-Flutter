import 'dart:typed_data';

/// This is the model class of apps returned by [getAllUpiApps()].
/// This class contains some predefined package names of UPI apps.
class UpiIndiaApp {
  /// app is the package name of the app. Pass this in [app] argument of [startTransaction]
  String app;

  /// This is the app name for display purpose
  String name;

  /// This is the icon of the UPI app. Pass it in [Image.memory()] to display the icon.
  Uint8List icon;

  // Start of pre-defined package names

  /// PayTM : net.one97.paytm
  static const String PayTM = "net.one97.paytm";

  /// GooglePay : com.google.android.apps.nbu.paisa.user
  static const String GooglePay = "com.google.android.apps.nbu.paisa.user";

  /// BHIMUPI : in.org.npci.upiapp
  static const String BHIMUPI = "in.org.npci.upiapp";

  /// PhonePe : com.phonepe.app
  static const String PhonePe = "com.phonepe.app";

  /// MiPay : com.mipay.in.wallet (From Play Store)
  static const String MiPay = "com.mipay.in.wallet";

  /// AmazonPay : in.amazon.mShop.android.shopping
  static const String AmazonPay = "in.amazon.mShop.android.shopping";

  /// TrueCallerUPI : com.truecaller
  static const String TrueCallerUPI = "com.truecaller";

  /// MyAirtelUPI : com.myairtelapp
  static const String MyAirtelUPI = "com.myairtelapp";

  /// MobikwikUPI : com.mobikwik_new
  static const String MobikwikUPI = "com.mobikwik_new";

  /// FreeChargeUPI : com.freecharge.android
  static const String FreeChargeUPI = "com.freecharge.android";

  /// SBIPay : com.sbi.upi
  static const String SBIPay = "com.sbi.upi";

  /// IMobileICICI : com.csam.icici.bank.imobile
  static const String IMobileICICI = "com.csam.icici.bank.imobile";
  // End of pre-defined package names

  UpiIndiaApp.fromMap(Map<String, dynamic> m) {
    app = m['packageName'];
    name = m['name'];
    icon = m['icon'];
  }
}