import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/core/utils/app_strings.dart';
import 'core/utils/app_router.dart';

//late String initialRoute;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseAuth.instance.authStateChanges().listen((user){
  //   if(user == null) {
  //     initialRoute = AppStrings.loginScreen;
  //   }else{
  //     initialRoute = AppStrings.mapScreen;
  //   }
  // });
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      //initialRoute: initialRoute,
    );
  }
}
