// Class to process the response of upi request.
class UpiResponse {
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
  /// DO NOT use the string directly. Instead use [UpiStatus]
  String status;

  /// txnRef gives the Transaction Reference ID passed in input.
  String transactionRefId;

  /// If any error occurs it is stored in error.
  /// IMPORTANT: Always check this before further checking others.
  /// Use [UpiError] to check different type of errors.
  String error;

  UpiResponse(String responseString) {
    List<String> _parts = responseString.split('&');
    if (_parts.length == 1) {
      error = _parts[0];
    } else {
      error = null;
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
          if (value.toLowerCase() == "success")
            status = "success";
          else if (value.toLowerCase().contains("fail"))
            status = "failure";
          else if (value.toLowerCase().contains("submit"))
            status = "submitted";
          else
            status = "other";
        } else if (key.toLowerCase() == "txnref") {
          transactionRefId = value;
        }
      }
    }
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

// Class that contains error responses that must be used to check for errors.
class UpiError{
  /// When user selects app to make transaction but the app is not installed.
  static const String APP_NOT_INSTALLED = 'app_not_installed';

  /// When the parameters of UPI request is/are invalid or app cannot proceed with the payment.
  static const String INVALID_PARAMETERS = 'invalid_parameters';

  /// Failed to receive any response from the invoked activity.
  static const String NULL_RESPONSE = 'null_response';

  /// User cancelled the transaction.
  static const String USER_CANCELLED = 'user_canceled';
}
