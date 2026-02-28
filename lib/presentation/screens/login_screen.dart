import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/core/utils/app_color.dart';
import 'package:flutter_maps/core/utils/app_router.dart';
import 'package:flutter_maps/core/utils/app_strings.dart';
import 'package:flutter_maps/presentation/screens/otp_screen.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String phoneNumber;

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 32, vertical: 88),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIntroText(),
                const SizedBox(height: 110),
                _buildPhoneNumberField(),
                const SizedBox(height: 50),
                _buildNextButton(context),
                _buildPhoneNumberSubmittedBloc(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is your phone number?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            'Please enter your phone number to verify your account.',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 60,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.lightGrey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${generateCountryFlag()} +20',
              style: TextStyle(fontSize: 18, letterSpacing: 2.0),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.blue),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              autofocus: true,
              style: TextStyle(fontSize: 18, letterSpacing: 2.0),
              decoration: InputDecoration(border: InputBorder.none),
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                } else if (value.length < 11) {
                  return 'Too short for a phone number';
                }
                return null;
              },
              onSaved: (value) {
                phoneNumber = value!;
              },
            ),
          ),
        ),
      ],
    );
  }

  String generateCountryFlag() {
    String countryCode = 'eg';
    String flag = countryCode.toUpperCase().replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
    );
    return flag;
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          _showProgressIndicator(context);
          _register(context);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(110, 50),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          'Next',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberSubmittedBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is Loading) {
          _showProgressIndicator(context);
        }
        if (state is PhoneNumberSubmitted) {
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            AppStrings.otpScreen,
            arguments: phoneNumber,
          );
        }
        if (state is ErrorOccurred) {
          Navigator.pop(context);
          String errorMsg = state.message.toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg,style: TextStyle(fontSize: 26),),
              backgroundColor: Colors.black,
              duration: Duration(seconds: 10),
            ),
          );
        }
      },
      child: Container(),
    );
  }

  void _showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );

    showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context) => alertDialog,
    );
  }

  Future<void> _register(BuildContext context) async{
    if(!formKey.currentState!.validate()){
      Navigator.pop(context);
      return;
    }
    else{
      Navigator.pop(context);
      formKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNumber(phoneNumber);
    }
  }
}
