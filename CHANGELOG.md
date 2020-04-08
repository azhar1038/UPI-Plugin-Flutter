## 1.1.2
* Removed **UpiIndiaResponseStatus.FAILED**.
* Removed **MI Pay** because of conflicting package name in  Play Store and GetApps(MI Apps).
* Added **Mobikwik** and **FreeCharge**
* Now look for **UPI_INDIA_FINAL_RESPONSE** in your terminal window to see the actual response string from your requested app.

## 1.1.1
* Changed **UpiIndiaResponseStatus.FAILED** to **UpiIndiaResponseStatus.FAILURE**.
* **UpiIndiaResponseStatus.FAILED** has been deprecated.

## 1.1.0

* Prevented app to crash in case requested app wasn't ready to proceed payment
* Did some changes in response status because PhonePe was returning **FAILED** instead of **FAILURE** as specified.

## 1.0.0

* Plugin to implement UPI in Android
