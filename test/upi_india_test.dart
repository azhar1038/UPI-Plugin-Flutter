import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upi_india/upi_india.dart';

void main() {
  const MethodChannel channel = MethodChannel('upi_india');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    UpiIndia upi = UpiIndia();
    expect(
        await upi.startTransaction(
          app: UpiApp.PhonePe,
          receiverUpiId: "9078600498@ybl",
          receiverName: "Md Azharuddin",
          transactionRefId: "AzTest123",
          transactionNote: "Test Transfer",
          amount: 1.00,
        ),
        '42');
  });
}
