import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

class Easypasa extends StatefulWidget{
  @override
  State<Easypasa> createState() => _EasypasaState();
}

class _EasypasaState extends State<Easypasa> {

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();


  // Future<void> initiateEasyPaisaPayment(String phoneNumber, double amount) async {
  //
  //   final url = Uri.parse('https://easypay.easypaisa.com.pk/easypay/Index.jsf');
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'x-auth-token': '564b1e8739bc690622de07c5a81fe6b'
  //   };
  //   final body = '''
  //   {
  //     "storeId": "23473",
  //     "amount": "1",
  //     "postBackURL": "http://www.my.online-store.com/transaction/MessageHandler",
  //     "orderRefNum": "11022131311",
  //     "expiryDate": "20250524 201521",
  //     "merchantHashedReq": "564b1e8739bc690622de07c5a81fe6b",
  //     "autoRedirect": "0",
  //     "paymentMethod": "MA_PAYMENT_METHOD",
  //     "emailAddr": "basitabbasi82@gmail.com",
  //     "mobileNum": "03355739701"
  //   }
  // ''';
  //
  //   final response = await http.post(url, headers: headers, body: body);
  //   if (response.statusCode == 200) {
  //     // Process the response
  //     print('Succefull: ${response.body}');
  //     print('Response: ${response.body}');
  //     final redirectionUrl = response.headers['location'];
  //   } else {
  //     // Handle error response
  //     print('API call failed with status code: ${response.headers['location']}');
  //   }
  // }
  String generateOrderId() {
    final uuid = Uuid();
    final timestamp = DateTime
        .now()
        .millisecondsSinceEpoch;
    final uniqueId = uuid.v4();
    return '$timestamp-$uniqueId';
  }

  void showPaymentSuccessDialog(BuildContext context,String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendEasyPaisaRequest(String phone, double amount) async {
    final url = Uri.parse(
        'https://easypaystg.easypaisa.com.pk/easypay-service/rest/v4/initiate-ma-transaction'); // Replace with the actual EasyPaisa API endpoint URL

    final headers = {
      'Content-Type': 'application/json',
      'Credentials': 'SHV6YWlmYUtoYW46NTY0YjFlODczOWJjNjkwNjIyZGUwN2M1YTgxZmU2Yg==',
    };


    String orderid = generateOrderId();
    final body = json.encode({
      'orderId': orderid,
      'storeId': '23473',
      'transactionAmount': amount,
      'transactionType': 'MA',
      'mobileAccountNo': phone,
      'emailAddress': 'basitabbasi82@gmail.com',
    });
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Sending Request....');
    final response = await http.post(url, headers: headers, body: body);
    pd.close();

    if (response.statusCode == 200) {
      // Request successful, process the response
      final responseData = json.decode(response.body);
      if(responseData['responseCode']=="0000")
      {
        showPaymentSuccessDialog(context,"Payment Successful","Thank you for your payment!");
      }else
        {
          showPaymentSuccessDialog(context,"OPS Payment Error","Some thing went wrong error code is "+responseData['responseCode']);
        }

      print('Success: ${response.body}');
      // Handle the response data
    } else {
      // Request failed, handle the error
      print('API call failed with status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset("assets/images/easypasa.png"),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: phoneNumberController,
                  style: TextStyle(
                    fontSize: 16.0, // Adjust the font size
                  ),
                  decoration: InputDecoration(
                    hintText: '03xxxxxxxxx',
                    hintStyle: TextStyle(
                      color: Colors.black38, // Set the hint text color
                    ),

                    labelText: 'Phone number',
                    labelStyle: TextStyle(
                      color: Colors.black, // Set the label color
                    ),

                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Adjust the padding
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: amountController,
                  style: TextStyle(
                    fontSize: 16.0, // Adjust the font size
                  ),
                  decoration: InputDecoration(
                    hintText: '10',
                    hintStyle: TextStyle(
                      color: Colors.black38, // Set the hint text color
                    ),

                    labelText: 'Amount',
                    labelStyle: TextStyle(
                      color: Colors.black, // Set the label color
                    ),

                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Adjust the padding
                  ),
                ),

                SizedBox(height: 32.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform EasyPaisa payment logic here
                      final phoneNumber = phoneNumberController.text;
                      final amount = amountController.text;
                      // Call the payment function with phoneNumber and amount
                      sendEasyPaisaRequest(phoneNumber, double.parse(amount));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Set the background color
                      onPrimary: Colors.white, // Set the text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Add rounded corners
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0), // Adjust the padding
                    ),
                    child: Text(
                      'Pay with EasyPaisa',
                      style: TextStyle(
                        fontSize: 16.0, // Adjust the font size
                        fontWeight: FontWeight.bold, // Apply bold font weight
                      ),
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}