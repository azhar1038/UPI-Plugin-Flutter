import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test UPI',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<UpiResponse> _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp> apps;

  TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e){
      apps = [];
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverId: '9078600498@ybl',
      receiverName: 'Md Azharuddin',
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Not actual. Just an example.',
      amount: 1.00,
    );
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps.length == 0)
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    else
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
            body,
            style: value,
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: displayUpiApps(),
          ),
          Expanded(
            child: FutureBuilder(
              future: _transaction,
              builder: (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    String errorText = "";
                    switch (snapshot.error.runtimeType) {
                      case UpiIndiaAppNotInstalledException:
                        errorText = "Requested app not installed on device";
                        break;
                      case UpiIndiaUserCancelledException:
                        errorText = "You cancelled the transaction";
                        break;
                      case UpiIndiaNullResponseException:
                        errorText = "Requested app didn't return any response";
                        break;
                      case UpiIndiaInvalidParametersException:
                        errorText = "Requested app cannot handle the transaction";
                        break;
                      default:
                        errorText = "An Unknown error has occurred";
                        break;
                    }
                    return Center(
                      child: Text(
                        errorText,
                        style: header,
                      ),
                    );
                  }
                  UpiResponse _upiResponse;
                  _upiResponse = snapshot.data;
                  String txnId = _upiResponse.transactionId ?? "N/A";
                  if (txnId.isEmpty) txnId = "N/A";
                  String resCode = _upiResponse.responseCode ?? "N/A";
                  String txnRef = _upiResponse.transactionRefId ?? "N/A";
                  String status = _upiResponse.status ?? "N/A";
                  String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
                  switch (status) {
                    case UpiPaymentStatus.SUCCESS:
                      print('Transaction Successful');
                      break;
                    case UpiPaymentStatus.SUBMITTED:
                      print('Transaction Submitted');
                      break;
                    case UpiPaymentStatus.FAILURE:
                      print('Transaction Failed');
                      break;
                    default:
                      print('Unknown Error occurred');
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        displayTransactionData('Transaction Id', txnId),
                        displayTransactionData('Response Code', resCode),
                        displayTransactionData('Reference Id', txnRef),
                        displayTransactionData('Status', status.toUpperCase()),
                        displayTransactionData('Approval No', approvalRef),
                      ],
                    ),
                  );
                } else
                  return Center(
                    child: Text(''),
                  );
              },
            ),
          )
        ],
      ),
    );
  }
}
