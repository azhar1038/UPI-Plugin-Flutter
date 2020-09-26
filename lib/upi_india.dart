// This Plugin is only for use in India. It uses UPI- Unified Payment Interface.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upi_india/upi_app.dart';
import 'package:upi_india/upi_response.dart';

export 'package:upi_india/upi_app.dart';
export 'package:upi_india/upi_response.dart';

// This is the main class.
class UpiIndia {
  static MethodChannel _channel;

  UpiIndia() {
    _channel = const MethodChannel('upi_india');
  }

  /// This method will return the [List] of all apps in users device which can handle UPI Intents as [UpiIndiaApp]
  Future<List<UpiApp>> getAllUpiApps() async {
    final List<Map> apps = await _channel.invokeListMethod<Map>('getAllUpiApps');
    List<UpiApp> upiIndiaApps = [];
    apps.forEach((app) {
      upiIndiaApps.add(UpiApp.fromMap(Map<String, dynamic>.from(app)));
    });
    return upiIndiaApps;
  }

  /// This method is used to initiate a transaction with given parameters.
  Future<UpiResponse> startTransaction({
    /// app refers to app name provided using [UpiApp] class.
    @required String app,

    /// receiverUpiId is the UPI ID of the Payee (who will receive the money).
    /// Double check this value or you may end up paying the wrong person.
    @required String receiverUpiId,

    /// receiverName is the name of the Payee( who will receive the  money)
    @required String receiverName,

    /// transactionNote provides short description of transaction.
    @required String transactionNote,

    /// amount is the actual amount in decimal format (in INR by default) that should be paid.
    /// amount = 0 if you want user to enter the amount.
    @required double amount,

    // transactionRefId is a unique literal which you can use to find the transaction later easily.
    /// It is mandatory for Merchant transactions and dynamic URL generation.
    /// In response the "txnRef" that you will receive must match this value.
    String transactionRefId,

    /// currency refers to the currency code. Currently only "INR" is supported by UPI.
    String currency = "INR",

    /// url when used, MUST BE related to the particular transaction and
    /// MUST NOT be used to send unsolicited information that are not relevant to the transaction.
    String url,

    /// Payee merchant code. If present then needs to be passed as it is.
    String merchantId,
  }) {
    // Assertions start
    assert(receiverUpiId.contains(RegExp(r'\w+@\w+')));
    assert(amount >= 0 && amount.isFinite);
    assert(currency == "INR");
    assert(
        (merchantId != null && transactionRefId != null) || merchantId == null);
    // Assertions stop

    return _channel.invokeMethod('startTransaction', {
      "app": app,
      'receiverUpiId': receiverUpiId,
      'receiverName': receiverName,
      'transactionRefId': transactionRefId,
      'transactionNote': transactionNote,
      'amount': amount.toString(),
      'currency': currency,
      'merchantId': merchantId,
    }).then((response) {
      print("UPI_INDIA_FINAL_RESPONSE: $response");
      return UpiResponse(response);
    }).catchError((e) {
      print("UPI_INDIA_FINAL_RESPONSE: invalid_parameters");
      return UpiResponse('invalid_parameters');
    });
  }
}
