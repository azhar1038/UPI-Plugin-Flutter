class _UpiIndiaException implements Exception {
  final message;
  final prefix;

  _UpiIndiaException([this.message, this.prefix]);

  String toString() {
    return "$prefix: $message";
  }
}

class UpiIndiaAppNotInstalledException extends _UpiIndiaException {
  UpiIndiaAppNotInstalledException() : super("App not installed in user device.", "APP_NOT_INSTALLED");
}

class UpiIndiaInvalidParametersException extends _UpiIndiaException {
  UpiIndiaInvalidParametersException([String message = "Incorrect parameters provided for transaction"])
      : super(message, "INVALID_PARAMETERS");
}

class UpiIndiaNullResponseException extends _UpiIndiaException {
  UpiIndiaNullResponseException()
      : super("No response was received from the requested UPI app", "NULL_RESPONSE");
}

class UpiIndiaUserCancelledException extends _UpiIndiaException {
  UpiIndiaUserCancelledException()
      : super("User cancelled the transaction by pressing back button", "USER_CANCELLED");
}

class UpiIndiaActivityMissingException extends _UpiIndiaException {
  UpiIndiaActivityMissingException() : super("Activity was destroyed for some unknown reason", "ACTIVITY_MISSING");
}

class UpiIndiaAppsGetException extends _UpiIndiaException{
  UpiIndiaAppsGetException():super("Failed to get UPI Apps", "APP_GET_FAILED");
}
