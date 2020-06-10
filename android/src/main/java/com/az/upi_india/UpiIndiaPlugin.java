package com.az.upi_india;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class UpiIndiaPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {

    private int uniqueRequestCode = 5120;
    private Activity activity;
    private MethodChannel.Result finalResult;
    private boolean exception = false;

    private UpiIndiaPlugin(Registrar registrar) {
        activity = registrar.activity();
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.az.upi_india");
        UpiIndiaPlugin _plugin = new UpiIndiaPlugin(registrar);

        registrar.addActivityResultListener(_plugin);
        channel.setMethodCallHandler(_plugin);
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        finalResult = result;

        if (call.method.equals("startTransaction")) {
            startTransaction(call, result);
        } else if(call.method.equals("getAllUpiApps")){
            List<Map<String, Object>> packages = getAllUpiApps();
            result.success(packages);
        }else {
            result.notImplemented();
        }
    }

    private void startTransaction(MethodCall call, Result result){
        String app;

        // Extract the arguments.
        if (call.argument("app") == null) {
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
            exception = false;
            Uri.Builder uriBuilder = new Uri.Builder();
            uriBuilder.scheme("upi").authority("pay");
            uriBuilder.appendQueryParameter("pa", receiverUpiId);
            uriBuilder.appendQueryParameter("pn", receiverName);
            uriBuilder.appendQueryParameter("tn", transactionNote);
            uriBuilder.appendQueryParameter("am", amount);
            if (transactionRefId != null) {
                uriBuilder.appendQueryParameter("tr", transactionRefId);
            }
            if (currency == null) {
                uriBuilder.appendQueryParameter("cr", "INR");
            } else
                uriBuilder.appendQueryParameter("cu", currency);
            if (url != null) {
                uriBuilder.appendQueryParameter("url", url);
            }
            if (merchantId != null) {
                uriBuilder.appendQueryParameter("mc", merchantId);
            }

            Uri uri = uriBuilder.build();

            // Built Query. Ready to call intent.
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setData(uri);
            intent.setPackage(app);

            if (isAppInstalled(app)) {
                activity.startActivityForResult(intent, uniqueRequestCode);
                finalResult = result;
            } else {
                Log.d("UpiIndia NOTE: ", app + " not installed on the device.");
                result.success("app_not_installed");
            }
        } catch (Exception ex) {
            exception = true;
            Log.d("UpiIndia NOTE: ", "" + ex);
            result.error("FAILED", "invalid_parameters", null);
        }
    }

    // On receiving the response.
    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (uniqueRequestCode == requestCode && finalResult != null) {
            if (data != null) {
                try {
                    String response = data.getStringExtra("response");
                    if (!exception) finalResult.success(response);
                } catch (Exception ex) {
                    if (!exception) finalResult.success("null_response");
                }
            } else {
                Log.d("UpiIndia NOTE: ", "Received NULL, User cancelled the transaction.");
                if (!exception) finalResult.success("user_canceled");
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
            Log.e("UpiIndia ERROR: ", "" + pme);
        }
        return false;
    }

    // Method to get all Apps on device who can handle UPI Intent.
    private List<Map<String, Object>> getAllUpiApps(){
        List<Map<String, Object>> packages = new ArrayList<>();
        Intent intent = new Intent(Intent.ACTION_VIEW);
        Uri.Builder uriBuilder = new Uri.Builder();
        uriBuilder.scheme("upi").authority("pay");
        uriBuilder.appendQueryParameter("pa", "test@ybl");
        uriBuilder.appendQueryParameter("pn", "Test");
        uriBuilder.appendQueryParameter("tn", "Get All Apps");
        uriBuilder.appendQueryParameter("am", "1.0");
        uriBuilder.appendQueryParameter("cr", "INR");
        Uri uri = uriBuilder.build();
        intent.setData(uri);
        PackageManager pm = activity.getPackageManager();
        List<ResolveInfo> resolveInfoList = pm
                .queryIntentActivities(intent, 0);
        for (ResolveInfo resolveInfo : resolveInfoList) {
            try {
                // Get Package name of the app.
                String packageName = resolveInfo.activityInfo.packageName;

                // Get Actual name of the app to display.
                String name = (String) pm.getApplicationLabel(pm.getApplicationInfo(packageName, PackageManager.GET_META_DATA));

                // Get app icon as Drawable
                Drawable dIcon = pm.getApplicationIcon(packageName);

                // Convert the Drawable Icon as Bitmap.
                Bitmap bIcon = getBitmapFromDrawable(dIcon);

                // Convert the Bitmap icon to byte[] received as Uint8List by dart.
                ByteArrayOutputStream stream = new ByteArrayOutputStream();
                bIcon.compress(Bitmap.CompressFormat.PNG, 100, stream);
                byte[] icon = stream.toByteArray();

                // Put everything in a map
                Map<String, Object> m = new HashMap<>();
                m.put("packageName", packageName);
                m.put("name", name);
                m.put("icon", icon);

                // Add this app info to the list.
                packages.add(m);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return packages;
    }

    // It converts the Drawable to Bitmap. There are other inbuilt methods too.
    private Bitmap getBitmapFromDrawable(Drawable drawable){
        Bitmap bmp = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bmp);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);
        return bmp;
    }
}
