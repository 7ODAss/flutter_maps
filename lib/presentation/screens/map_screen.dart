import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/core/utils/app_strings.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhoneAuthCubit>(
      create: (context) => PhoneAuthCubit(),
      child: Scaffold(
        body: Column(
          children: [
             ElevatedButton(
                onPressed: () async {
                  await phoneAuthCubit.logOut();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, AppStrings.loginScreen);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(110, 50),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: Text(
                  'Verify',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

          ],
        ),
      ),
    );
  }
}
