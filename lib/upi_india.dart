// This Plugin is only for use in India. It uses UPI- Unified Payment Interface.
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:upi_india/upi_app.dart';
import 'package:upi_india/upi_exception.dart';
import 'package:upi_india/upi_response.dart';

export 'package:upi_india/upi_app.dart';
export 'package:upi_india/upi_exception.dart';
export 'package:upi_india/upi_response.dart';

List<String> _verifiedApps = [
  UpiApp.allBank.packageName,
  UpiApp.amazonPay.packageName,
  UpiApp.axisPay.packageName,
  UpiApp.barodaPay.packageName,
  UpiApp.bhim.packageName,
  UpiApp.centUpi.packageName,
  UpiApp.cointab.packageName,
  UpiApp.corpUpi.packageName,
  UpiApp.dcbUpi.packageName,
  UpiApp.finoBPay.packageName,
  UpiApp.freecharge.packageName,
  UpiApp.googlePay.packageName,
  UpiApp.iMobileICICI.packageName,
  UpiApp.indusPay.packageName,
  UpiApp.khaaliJeb.packageName,
  UpiApp.mahaUpi.packageName,
  UpiApp.mobikwik.packageName,
  UpiApp.orientalPay.packageName,
  UpiApp.paytm.packageName,
  UpiApp.paywiz.packageName,
  UpiApp.phonePe.packageName,
  UpiApp.psb.packageName,
  UpiApp.sbiPay.packageName,
  UpiApp.yesPay.packageName,
];

List<String> _appsReturningNoTxnId = [
  UpiApp.miPayGlobal.packageName,
  UpiApp.miPayXiaomi.packageName,
  UpiApp.hsbcSimplyPay.packageName,
];

List<String> _nonVerifiedApps = [
  UpiApp.trueCallerUPI.packageName, // Reetesh: Repetitive mobile verification SMS failures
  UpiApp.boiUpi.packageName, // Reetesh: Mobile number verification failed
  UpiApp.csbUpi.packageName, // Reetesh: Hangs on opening screen
  UpiApp.cubUpi.packageName,
  UpiApp.digibank.packageName,
  UpiApp.equitasUpi.packageName, // Reetesh: Mobile number verification failed
  UpiApp.kotak.packageName,
  UpiApp.payZapp.packageName, // Reetesh: Mobile number verification failed
  UpiApp.pnb.packageName,
  UpiApp.rblPay.packageName, // Reetesh: Keeps looping in login screen
  UpiApp.realmePaySa.packageName, // Reetesh: Mobile number verification failed
  UpiApp.unitedUpiPay.packageName,
  UpiApp.vijayaUpi.packageName, // Reetesh: Could never complete SMS Verification
];

//List<String> _invalidApps = [
//  UpiApp.airtelThanksUpi.packageName, // Azhar, Reetesh: Never returns back after payment
//  UpiApp.auPay.packageName, // Reetesh: Returns null parameters in response after payment
//  UpiApp.bandhanUpi.packageName, // Reetesh: Something went wrong
//  UpiApp.candi.packageName, // Reetesh: Keeps saying transaction failed
//  UpiApp.indianBankUpi.packageName, // Reetesh: Unstable behaviour
//  UpiApp.jetPay.packageName,
// Reetesh: Intent invocation gets a java.lang.SecurityException: Permission Denial
//  UpiApp.kblUpi.packageName, // Reetesh: Mandatory values are missing
//  UpiApp.kvbUpay.packageName, // Reetesh: Does not auto fill input data
//  UpiApp.lvbUpaay.packageName, // Reetesh: Does not return back after payment with response
//  UpiApp.syndUpi.packageName, // Reetesh: Functional errors while trying to complete payment
//  UpiApp.ucoUpi.packageName, // Reetesh: Mandatory values are missing
//  UpiApp.ultraCash.packageName, // Reetesh: Transaction cancelled always
//];

// This is the main class.
class UpiIndia {
  static late MethodChannel _channel;

  UpiIndia() {
    _channel = const MethodChannel('com.az.upi_india');
  }

  /// This method will return the [List] of all apps in users device which can handle UPI Intents as [UpiApp]
  Future<List<UpiApp>> getAllUpiApps({
    /// Is it necessary for the requested app to return Transaction ID on completion of transaction.
    /// Defaults to true
    ///
    /// Some UPI apps like MiPay does not return Transaction ID on completion
    /// If you set this to false, those app will be shown in the list otherwise not.
    bool mandatoryTransactionId = true,

    /// Set this to true if you want to include the non-verified apps in the list too.
    /// It is recommended to set this to false for production.
    bool allowNonVerifiedApps = false,

    /// Pass the [UpiApp]s that you want to support.
    /// Only these apps will be returned if they are installed on user device while others will be dropped.
    List<UpiApp>? includeOnly,
  }) async {
    List<Map>? apps;
    try {
      apps = await _channel.invokeListMethod<Map>('getAllUpiApps');
    } on PlatformException catch (e) {
      switch (e.code) {
        case "activity_missing":
          return Future.error(UpiIndiaActivityMissingException());
        case "package_get_failed":
          return Future.error(UpiIndiaAppsGetException());
      }
    }
    List<UpiApp> upiIndiaApps = [];
    List<String> _validApps;
    if (includeOnly != null && includeOnly.length > 0) {
      _validApps = [];
      includeOnly.forEach((app) => _validApps.add(app.packageName));
    } else {
      _validApps = _verifiedApps;
      if (allowNonVerifiedApps) {
        _validApps.addAll(_nonVerifiedApps);
      }
      if (!mandatoryTransactionId) {
        _validApps.addAll(_appsReturningNoTxnId);
      }
    }
    apps!.forEach((app) {
      if (_validApps.contains(app['packageName'])) {
        upiIndiaApps.add(UpiApp.fromMap(Map<String, dynamic>.from(app)));
      }
    });
    return upiIndiaApps;
  }

  /// This method is used to initiate a transaction with given parameters.
  Future<UpiResponse> startTransaction({
    /// app refers to app name provided using [UpiApp] class.
    required UpiApp app,

    /// receiverUpiId is the UPI ID of the Payee (who will receive the money).
    /// Double check this value or you may end up paying the wrong person.
    required String receiverUpiId,

    /// receiverName is the name of the Payee( who will receive the  money)
    required String receiverName,

    /// transactionRefId is a unique literal which you can use to find the transaction later easily.
    /// It is mandatory for Merchant transactions and dynamic URL generation.
    /// In response the "txnRef" that you will receive must match this value.
    required String transactionRefId,

    /// transactionNote provides short description of transaction.
    String? transactionNote,

    /// amount is the actual amount in decimal format (in INR by default) that should be paid.
    /// amount = 0 if you want user to enter the amount.
    double amount = 1,

    /// If true allows user to enter the amount
    bool flexibleAmount = false,

    /// currency refers to the currency code. Currently only "INR" is supported by UPI.
    String currency = "INR",

    /// url when used, MUST BE related to the particular transaction and
    /// MUST NOT be used to send unsolicited information that are not relevant to the transaction.
    String? url,

    /// Payee merchant code. If present then needs to be passed as it is.
    String? merchantId,
  }) {
    if (receiverUpiId.split("@").length != 2) {
      return Future.error(UpiIndiaInvalidParametersException("Incorrect UPI ID provided"));
    }

//    if (receiverAccountNumber != null && !RegExp(r'^\d{9,18}$').hasMatch(receiverAccountNumber)) {
//      return Future.error(UpiIndiaInvalidParametersException(
//        "Invalid Account number provided! Indian Account number length varies between 9 to 18 only",
//      ));
//    }
//
//    if(receiverIfscCode != null && !RegExp(r'^[A-Za-z]{4}[a-zA-Z0-9]{7}$').hasMatch(receiverIfscCode)){
//      return Future.error(UpiIndiaInvalidParametersException(
//        "Invalid IFSC code provided!",
//      ));
//    }

    if (amount < 1 || amount > 100000) {
      return Future.error(
        UpiIndiaInvalidParametersException(
          "Incorrect amount provided. Range is between 1 to 1,00,000",
        ),
      );
    }

    if (!RegExp(r'^\d{1,}(\.\d{0,2})?$').hasMatch(amount.toString())) {
      return Future.error(UpiIndiaInvalidParametersException(
        "Incorrect amount format. Make sure to use only two digits after decimal",
      ));
    }

    if (currency != "INR") {
      return Future.error(UpiIndiaInvalidParametersException("Only INR is currently supported"));
    }

    return _channel.invokeMethod('startTransaction', {
      "app": app.packageName,
      'receiverUpiId': receiverUpiId,
      'receiverName': receiverName,
      'transactionRefId': transactionRefId,
      'transactionNote': transactionNote,
      'amount': flexibleAmount ? '' : amount.toString(),
      'currency': currency,
      'merchantId': merchantId,
    }).then((response) {
      print("UPI_INDIA_FINAL_RESPONSE: $response");
      return UpiResponse(response);
    }).catchError((e) {
      print("UPI_INDIA_FINAL_RESPONSE: ${e.message}");
      switch (e.code) {
        case "app_not_installed":
          throw UpiIndiaAppNotInstalledException();

        case "null_response":
          throw UpiIndiaNullResponseException();

        case "user_canceled":
          throw UpiIndiaUserCancelledException();

        case "invalid_parameters":
          throw UpiIndiaInvalidParametersException();

        default:
          throw e;
      }
    }, test: (e) => e is PlatformException);
  }

  // /// To generate normalized and fully qualified payment address using Account number and IFSC code.
  // /// IMPORTANT: This is not supported by all apps.
  // String getIdFromAccount(String accountNumber, String ifscCode) {
  //   return "$accountNumber@$ifscCode.ifsc.npci";
  // }

// Do not know if these still work.
//  /// To generate normalized and fully qualified payment address using Aadhaar number.
//  /// Aadhar number should be linked to account otherwise transaction will fail.
//  String getIdFromAadhaar(String aadhaarNumber){
//    return "$aadhaarNumber@aadhar.npci";
//  }
//
//  /// To generate normalized and fully qualified payment address using Mobile number.
//  /// Mobile number should be registered otherwise transaction will fail
//  String getIdFromMobile(String mobileNumber){
//    return "$mobileNumber@mobile.npci";
//  }
//
//  /// To generate normalized and fully qualified payment address using RuPay card number.
//  String getIdFromRuPay(String ruPayNumber){
//    return "$ruPayNumber@rupay.npci";
//  }
}
