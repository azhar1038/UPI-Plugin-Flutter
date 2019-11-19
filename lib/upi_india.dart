// This Plugin is only for use in India. It uses UPI- Unified Payment Interface.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// This is the main class.
class UpiIndia {
  static const MethodChannel _channel = const MethodChannel('upi_india');

  /// app refers to app name provided using [UpiIndiaApps] class.
  final String app;

  /// receiverUpiId is the UPI ID of the Payee (who will receive the money).
  /// Double check this value or you may end up paying the wrong person.
  final String receiverUpiId;

  /// receiverName is the name of the Payee( who will receive the  money)
  final String receiverName;

  /// transactionNote provides short description of transaction.
  final String transactionNote;

  /// amount is the actual amount in decimal format (in INR by default) that should be paid.
  /// amount = 0 if you want user to enter the amount.
  final double amount;

  /// transactionRefId is a unique literal which you can use to find the transaction later easily.
  /// It is mandatory for Merchant transactions and dynamic URL generation.
  /// In response the "txnRef" that you will receive must match this value.
  final String transactionRefId;

  /// currency refers to the currency code. Currently only "INR" is supported by UPI.
  final String currency;

  /// url when used, MUST BE related to the particular transaction and
  /// MUST NOT be used to send unsolicited information that are not relevant to the transaction.
  final String url;

  /// Payee merchant code. If present then needs to be passed as it is.
  final String merchantId;

  UpiIndia({
    @required this.app,
    @required this.receiverUpiId,
    @required this.receiverName,
    @required this.transactionNote,
    @required this.amount,
    this.transactionRefId,
    this.currency = "INR",
    this.url,
    this.merchantId,
  })  : assert(receiverUpiId.contains(RegExp(r'\w+@\w+'))),
        assert(amount >= 0 && amount.isFinite),
        assert(currency == "INR"),// For now
        assert((merchantId != null && transactionRefId != null) ||
            merchantId == null);

  Future<String> startTransaction() async {
    final String response = await _channel.invokeMethod('startTransaction', {
      "app": app,
      'receiverUpiId': receiverUpiId,
      'receiverName': receiverName,
      'transactionRefId': transactionRefId,
      'transactionNote': transactionNote,
      'amount': amount.toString(),
      'currency': currency,
      'merchantId': merchantId,
    }).catchError((error){
      print(error);
      return 'invalid_parameters';
    });
    return response;
  }
}

// List of UPI apps supported by this plugin
// It is advised to use this class to pass the 'app' value of [UpiIndia].
class UpiIndiaApps {
  static const String PayTM = "net.one97.paytm";
  static const String GooglePay = "com.google.android.apps.nbu.paisa.user";
  static const String BHIMUPI = "in.org.npci.upiapp";
  static const String PhonePe = "com.phonepe.app";
  static const String MiPay = "com.mipay.wallet.in";
  static const String AmazonPay = "in.amazon.mShop.android.shopping";
  static const String TrueCallerUPI = "com.truecaller";
  static const String MyAirtelUPI = "com.myairtelapp";
}

// Class to process the response of upi request.
class UpiIndiaResponse {
  /// It is the Transaction ID from the response.
  String transactionId;

  /// responseCode is the UPI Response code. You don't particularly need to use this.
  /// You may refer to https://ncpi.org.in for list of responseCode.
  String responseCode;

  /// approvalRefNo is the UPI Approval reference number (beneficiary).
  /// It is optional. You may receive it as null.
  String approvalRefNo;

  /// status gives the status of Transaction.
  /// There are three approved status: success, failure, submitted.
  /// DO NOT use the string directly. Instead use [UpiIndiaResponseStatus]
  String status;

  /// txnRef gives the Transaction Reference ID passed in input.
  String transactionRefId;

  UpiIndiaResponse(String responseString) {
    List<String> _parts = responseString.split('&');

    for (int i = 0; i < _parts.length; ++i) {
      String key = _parts[i].split('=')[0];
      String value = _parts[i].split('=')[1];
      if (key.toLowerCase() == "txnid") {
        transactionId = value;
      } else if (key.toLowerCase() == "responsecode") {
        responseCode = value;
      } else if (key.toLowerCase() == "approvalrefno") {
        approvalRefNo = value;
      } else if (key.toLowerCase() == "status") {
        if(value.toLowerCase() == "success") status = "success";
        else if(value.toLowerCase().contains("fail")) status = "failure";
        else if(value.toLowerCase().contains("submit")) status = "submitted";
        else status = "other";
      } else if (key.toLowerCase() == "txnref") {
        transactionRefId = value;
      }
    }
  }
}

// This class is to match the status of transaction.
// It is advised to use this class to compare the status rather than doing string comparision.
class UpiIndiaResponseStatus {
  /// SUCCESS occurs when transaction completes successfully.
  static const String SUCCESS = 'success';

  /// SUBMITTED occurs when transaction remains in pending state.
  static const String SUBMITTED = 'submitted';

  /// Deprecated! Don't use it. Use FAILURE instead.
  static const String FAILED = 'failure';

  /// FAILURE occurs when transaction fails or user cancels it in the middle.
  static const String FAILURE = 'failure';

  /// In case status is not any of the three accepted value (by chance).
  static const String OTHER = 'other';
}

// Class that contains error responses that must be used to check for errors.
class UpiIndiaResponseError{
  /// When user selects app to make transaction but the app is not installed.
  static const String APP_NOT_INSTALLED = 'app_not_installed';

  /// When the parameters of UPI request is/are invalid or app cannot proceed with the payment.
  static const String INVALID_PARAMETERS = 'invalid_parameters';

  /// Failed to receive any response from the invoked activity.
  static const String NULL_RESPONSE = 'null_response';

  /// User cancelled the transaction.
  static const String USER_CANCELLED = 'user_canceled';
}

