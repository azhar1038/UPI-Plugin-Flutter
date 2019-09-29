package com.az.upi_india;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** UpiIndiaPlugin */
public class UpiIndiaPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {

  int uniqueRequestCode = 5120;
  Activity activity;
  Context context;
  MethodChannel.Result finalResult;

  UpiIndiaPlugin(Registrar registrar, MethodChannel channel) {
    activity = registrar.activity();
    context = registrar.activeContext();
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "upi_india");
    UpiIndiaPlugin _plugin = new UpiIndiaPlugin(registrar, channel);

    registrar.addActivityResultListener(_plugin);
    channel.setMethodCallHandler(_plugin);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    finalResult = result;

    if (call.method.equals("startTransaction")) {

      String app;

      // Extract the arguments.
      if(call.argument("app") == null){
        app = "in.org.npci.upiapp";
      } else {
        app = call.argument("app");
      }
      String receiverUpiId = call.argument("receiverUpiId");
      String receiverName = call.argument("receiverName");
      String transactionRefId = call.argument("transactionRefId");
      String transactionNote = call.argument("transactionNote");
      String amount = call.argument("amount");
      String currency = call.argument("currency");
      String url = call.argument("url");
      String merchantId = call.argument("merchantId");

      // Build the query and initiate the transaction.
      try {
        Uri.Builder uriBuilder = new Uri.Builder();
        uriBuilder.scheme("upi").authority("pay");
        uriBuilder.appendQueryParameter("pa", receiverUpiId);
        uriBuilder.appendQueryParameter("pn", receiverName);
        uriBuilder.appendQueryParameter("tn", transactionNote);
        uriBuilder.appendQueryParameter("am", amount);
        if(transactionRefId != null){
          uriBuilder.appendQueryParameter("tr", transactionRefId);
        }
        if(currency == null){
          uriBuilder.appendQueryParameter("cr", "INR");
        }else
          uriBuilder.appendQueryParameter("cu", currency);
        if(url != null){
          uriBuilder.appendQueryParameter("url", url);
        }
        if(merchantId != null){
          uriBuilder.appendQueryParameter("mc", merchantId);
        }

        Uri uri = uriBuilder.build();

        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(uri);
        intent.setPackage(app);

        if(isAppInstalled(app)) {
          activity.startActivityForResult(intent, uniqueRequestCode);
          finalResult = result;
        } else {
          Log.d("UpiIndia NOTE: ", app + " not installed on the device.");
          result.success("app_not_installed");
        }
      } catch(Exception ex) {
        result.success("invalid_parameters") ;
      }
    } else {
      result.notImplemented();
    }
  }

  // On receiving the response.
  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    if (uniqueRequestCode == requestCode && finalResult != null) {
      if(data != null) {
        try {
          String response = data.getStringExtra("response");
          finalResult.success(response);
        } catch(Exception ex) {
          finalResult.success("null_response");
        }
      } else {
        Log.d("UpiIndia NOTE: ","Received NULL, User cancelled the transaction.");
        finalResult.success("user_canceled");
      }
    }

    return true;
  }

  // Method to check if app is already installed or not.
  private boolean isAppInstalled(String uri) {
    PackageManager pm = activity.getPackageManager();
    try {
      pm.getPackageInfo(uri, PackageManager.GET_ACTIVITIES);
      return true;
    } catch (PackageManager.NameNotFoundException pme) {
      pme.printStackTrace();
      Log.e("UpiIndia ERROR: ",""+pme);
    }
    return false;
  }
}
