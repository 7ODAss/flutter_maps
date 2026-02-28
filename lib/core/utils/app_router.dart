import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/presentation/screens/map_screen.dart';

import '../../business_logic/phone_auth/phone_auth_cubit.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/otp_screen.dart';
import 'app_strings.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;

  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppStrings.loginScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: LoginScreen(),
          ),
        );

      case AppStrings.otpScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: OtpScreen(phoneNumber: phoneNumber,),
          ),
        );

      case AppStrings.mapScreen:
        return MaterialPageRoute(
          builder: (context) => MapScreen(),
        );
    }
  }
}
