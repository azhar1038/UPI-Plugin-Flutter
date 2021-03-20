// Class to process the response of upi request.
class UpiResponse {
  /// It is the Transaction ID from the response.
  String? transactionId;

  /// responseCode is the UPI Response code. You don't particularly need to use this.
  /// You may refer to https://ncpi.org.in for list of responseCode.
  String? responseCode;

  /// approvalRefNo is the UPI Approval reference number (beneficiary).
  /// It is optional. You may receive it as null.
  String? approvalRefNo;

  /// status gives the status of Transaction.
  /// There are three approved status: success, failure, submitted.
  /// DO NOT use the string directly. Instead use [UpiStatus]
  String? status;

  /// txnRef gives the Transaction Reference ID passed in input.
  String? transactionRefId;

  UpiResponse(String responseString) {
    List<String> _parts = responseString.split('&');
    for (int i = 0; i < _parts.length; ++i) {
      String key = _parts[i].split('=')[0];
      String value = _parts[i].split('=')[1];
      if (key.toLowerCase() == "txnid") {
        transactionId = _getValue(value);
      } else if (key.toLowerCase() == "responsecode") {
        responseCode = _getValue(value);
      } else if (key.toLowerCase() == "approvalrefno") {
        approvalRefNo = _getValue(value);
      } else if (key.toLowerCase() == "status") {
        if (value.toLowerCase().contains("success"))
          status = "success";
        else if (value.toLowerCase().contains("fail"))
          status = "failure";
        else if (value.toLowerCase().contains("submit"))
          status = "submitted";
        else
          status = "other";
      } else if (key.toLowerCase() == "txnref") {
        transactionRefId = _getValue(value);
      }
    }
  }

  String? _getValue(String? s) {
    if (s == null)
      return s;
    else if (s.isEmpty)
      return null;
    else if (s.toLowerCase() == 'null')
      return null;
    else if (s.toLowerCase() == 'undefined')
      return null;
    else
      return s;
  }
}

// This class is to match the status of transaction.
// It is advised to use this class to compare the status rather than doing string comparision.
class UpiPaymentStatus {
  /// SUCCESS occurs when transaction completes successfully.
  static const String SUCCESS = 'success';

  /// SUBMITTED occurs when transaction remains in pending state.
  static const String SUBMITTED = 'submitted';

  /// FAILURE occurs when transaction fails or user cancels it in the middle.
  static const String FAILURE = 'failure';

  /// In case status is not any of the three accepted value (by chance).
  static const String OTHER = 'other';
}
