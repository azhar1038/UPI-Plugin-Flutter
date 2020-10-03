# UPI India (for Android only)

This plugin is used to integrate **UPI** Options in your **Android** app. You can use this plugin to initiate transaction to any UPI ID or to any Account number.  
[Check the Supported apps here.](#supported-apps)

For a complete example of how to use this plugin, look at the **Example** tab or in the [Github repository](https://github.com/mdazharuddin1011999/UPI-Plugin-Flutter/blob/master/example/lib/main.dart).

## Help required
If you can help to extend this for iOS, feel free to check [this issue](https://github.com/mdazharuddin1011999/UPI-Plugin-Flutter/issues/20).  
If you can help to verify the compatibility of different UPI apps, feel free to check [this issue](https://github.com/mdazharuddin1011999/UPI-Plugin-Flutter/issues/23).

Thanks in advance :)

***
<img src="https://user-images.githubusercontent.com/42082172/82893565-d3643480-9f6e-11ea-96a7-493181df6214.gif" alt="How example looks" width="300" height="540">

<img src="https://user-images.githubusercontent.com/42082172/94981672-b4dffc80-0551-11eb-821b-a3adb7f7a62f.jpg" alt="Success Status" width="300" height="540">

## Classes to know
1. **UpiIndia** - It is the main class containing two methods:
  - getAllUpiApps() - It takes: 
    * `bool allowNonVerifiedApps`: Should include apps whose working has not been verified yet or not  
    * `List[UpiApp] includeOnly`: List of UpiApps which should be shown and hide the others.
    * `bool mandatoryTransactionId`: Should include those apps which doesn't return Transaction ID or not  

  - startTransaction() - It takes:
    * `double amount`: Amount to transfer (in ₹)
    * `UpiApp app`: Which app to use to do the transaction
    * `String currency`: Currently only supports INR
    * `bool flexibleAmount`: Set `true` to allow user to fill the amount
    * `String merchantId`: Merchant code if present
    * `String receiverId`: ID of the receiver
    * `String receiverName`: Name of receiver
    * `String transactionNote`: A note about the transaction
    * `String transactionRefId`: Reference Id of transaction
    * `String url`: For some extra information

2. **UpiApp** - It contains supported apps. It is also the model class for the apps returned by getAllUpiApps().

3. **UpiResponse** - You will use this to get response from the requested app.

4. **UpiPaymentStatus** - Use this to see if transaction was a success or not.
***

## Custom Exception thrown by this Plugin (with self explanatory names)
1. **UpiIndiaAppNotInstalledException**

2. **UpiIndiaUserCancelledException**

3. **UpiIndiaNullResponseException**

4. **UpiIndiaInvalidParametersException**

5. **UpiIndiaActivityMissingException**

6. **UpiIndiaAppsGetException**

## How to start transaction?

### Step 1:
Import the Package:

```dart
import 'package:upi_india/upi_india.dart';
```

### Step 2:
Create **UpiIndia** object.

```dart
UpiIndia _upiIndia = UpiIndia();
```

### Step 3:
Get list of all apps in the device which can handle UPI Intent, as shown.

```dart
List<UpiIndiaApp> apps;

@override
void initState() {
  _upiIndia.getAllUpiApps().then((value) {
    setState(() {
      apps = value;
    });
  });
  super.initState();
}
```

**OR**

You can directly use the predefined apps, like:

```dart
UpiApp app = UpiApp.googlePay;
```

and assign it to the app parameter in **Step 4**

### Step 4:
Create a method which will start the transaction on being called, as shown.  
To initiate transaction to any UPI ID, directly pass the ID to `receiverId`  
To initiate transaction to any Bank Account use `_upiIndia.getIdFromAccount()` method and pass the Account number and IFSC code

```dart
Future<UpiResponse> initiateTransaction(String app) async {
  return _upiIndia.startTransaction(
    app: apps[0], //  I took only the first app from List<UpiIndiaApp> app.
    receiverId: 'tester@test', // Make Sure to change this UPI Id
    receiverName: 'Tester',
    transactionRefId: 'TestingId',
    transactionNote: 'Not actual. Just an example.',
    amount: 1.00,
  );
}
```

### Step 5:
Call this method on any button click or through FutureBuilder and then you will get the Response!
***

## How to handle Response?

### Step 1:
After getting the snapshot from the Future, check if there is any error or not:

```dart
if (snapshot.hasError) {
  print(snapshot.error.toString());
  switch (snapshot.error.runtimeType) {
    case UpiIndiaAppNotInstalledException:
      print("Requested app not installed on device");
      break;
    case UpiIndiaUserCancelledException:
      print("You cancelled the transaction");
      break;
    case UpiIndiaNullResponseException:
      print("Requested app didn't return any response");
      break;
    case UpiIndiaInvalidParametersException:
      print("Requested app cannot handle the transaction");
      break;
    default:
      print("An Unknown error has occurred");
      break;
  }
}
```

### Step 2:
If **snapshot.hasError** is false, you can then get the response **UpiResponse** from **snapshot.data** and extract these parameters:
* Transaction ID
* Response Code
* Approval Reference Number
* Transaction Reference ID
* Status

### Step 3:
Check the Status property. It has following values:
* UpiPaymentStatus.SUCCESS
* UpiPaymentStatus.SUBMITTED
* UpiPaymentStatus.FAILURE

If Status is SUCCESS, Congratulations! You have successfully used this plugin.
***
For a complete example of how to use this plugin, look at the **Example** tab or in the [Github repository](https://github.com/mdazharuddin1011999/UPI-Plugin-Flutter/blob/master/example/lib/main.dart).

## Supported Apps
#### Verified Apps - These Apps have been tested to work fine with this plugin (included by default):
* All Bank 
* **Amazon Pay** 
* Axis Pay 
* Baroda Pay 
* **BHIM** 
* Cent UPI 
* Cointab 
* Corp UPI 
* DCB UPI 
* Fino BPay 
* Freecharge 
* **Google Pay** 
* iMobile ICICI 
* Indus Pay 
* Khaali Jeb 
* Maha UPI 
* Mobikwik 
* Oriental Pay 
* **Paytm** 
* Paywiz 
* **PhonePe** 
* PSB 
* SBI Pay 
* Yes Pay 

#### Apps that don't return Transaction ID in response (pass `mandatoryTransactionId: false` to `getAllUpiApps` to use them):
* MiPay (Both Play Store and GetApps version)
* HSBC Simply Pay

#### Non-Verified Apps - These apps haven't been tested yet (pass `allowNonVerifiedApps: true` to `getAllUpiApps` to use them):
* True Caller
* BOI UPI
* CSB UPI
* CUB UPI
* digibank
* Equitas UPI
* Kotak
* PayZapp
* PNB
* RBL Pay
* realme PaySa
* United UPI Pay
* Vijaya UPI

## Unsupported Apps
#### (These apps are not working as expected currently)
* Airtel Thanks
* AUPay
* Bandhan Bank UPI
* CANDI
* Indian Bank UPI
* Jet Pay
* KBL UPI
* KVB UPI
* LVB UPAAY
* Synd UPI
* UCO UPI
* Ultra Cash

Don't forget to give Like and Stars!
