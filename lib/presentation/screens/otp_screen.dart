import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/core/utils/app_color.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../business_logic/phone_auth/phone_auth_cubit.dart';
import '../../core/utils/app_strings.dart';

class OtpScreen extends StatelessWidget {
  final phoneNumber;
  late String otpCode;
  OtpScreen({super.key,required this.phoneNumber});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 32, vertical: 88),
          child: Column(
            children: [
              _buildIntroTexts(),
              SizedBox(
                height: 88,
              ),
              _buildPinCodeFields(context),
              SizedBox(
                height: 60,
              ),
              _buildVerifyButton(context),
              _buildPhoneVerificationBloc(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildIntroTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify your phone number',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          child: RichText(
            text: TextSpan(
              text: 'Enter your 6 digit code numbers sent to ',
              style: TextStyle(color: Colors.black, fontSize: 18, height: 1.4),
              children: <TextSpan>[
                TextSpan(
                  text: '$phoneNumber',
                  style: TextStyle(color: AppColor.blue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
      ),
    );

    showDialog(barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context) => alertDialog,);
  }

  Widget _buildPinCodeFields(BuildContext context) {
    return PinInput(
      length: 6,
      autoFocus: true,
      builder: (context, cells) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cells.map((cell) {
            return Expanded(
              child: Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                  color: cell.isFocused ? AppColor.lightBlue : Colors.white,
                  border: Border.all(color: AppColor.blue),
                ),
                child: Center(
                  child: Text(
                    cell.character ?? '',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
      onCompleted: (pin) => otpCode=pin,
    );
  }

  Widget _buildVerifyButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          _showProgressIndicator(context);
          _login(context);
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
    );
  }

  Widget _buildPhoneVerificationBloc(){
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is Loading) {
          _showProgressIndicator(context);
        }
        if (state is PhoneOtpVerified) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(
            context,
            AppStrings.mapScreen,
          );
        }
        if (state is ErrorOccurred) {
          //Navigator.pop(context);
          String errorMsg = state.message.toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.black,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Container(),
    );
  }

  void _login(BuildContext context) {
    BlocProvider.of<PhoneAuthCubit>(context).submitOtp(otpCode);
  }

}