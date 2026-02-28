part of 'phone_auth_cubit.dart';

@immutable
sealed class PhoneAuthState {}

final class PhoneAuthInitial extends PhoneAuthState {}

class Loading extends PhoneAuthState{}
class PhoneNumberSubmitted extends PhoneAuthState{}
class PhoneOtpVerified extends PhoneAuthState{}
class ErrorOccurred extends PhoneAuthState{
  final String message;
  ErrorOccurred({required this.message});
}
