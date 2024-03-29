import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adrenod_driver/functions/functions.dart';
import 'package:adrenod_driver/functions/notifications.dart';
import 'pages/loadingPage/loadingpage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  checkInternetConnection();
  initMessaging();
  currentPositionUpdate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    platform = Theme.of(context).platform;
    return GestureDetector(
        onTap: () {
          //remove keyboard on touching anywhere on the screen.
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Adrenod Driver',
            theme: ThemeData(
                inputDecorationTheme: const InputDecorationTheme(
                 enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black26),
                 ),
           focusedBorder: OutlineInputBorder(
           borderSide: BorderSide(width: 1, color: Colors.black),
             ))
            ),

            home:  const LoadingPage()));

  }



}



class removeall extends StatefulWidget {
  @override
  State<removeall> createState() => _removeallState();
}


class _removeallState extends State<removeall> {
  Future<void> deleteAllRequests() async {
    try {
      await FirebaseDatabase.instance
          .ref().child('requests').set(null);
      print('All requests deleted successfully.');
    } catch (error) {
      print('Failed to delete requests: $error');
      rethrow;
    }
  }
    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Scaffold(
        body: SafeArea(
          child: ElevatedButton(
            onPressed: (){
              deleteAllRequests();
            },
            child: Text('Delete All Requests'),
          ),
        ),
      );
    }
  }
