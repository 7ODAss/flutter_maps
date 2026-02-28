import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  PhoneAuthCubit() : super(PhoneAuthInitial());

  late String verificationId;

  Future<void> submitPhoneNumber(String phoneNumber) async {
    emit(Loading());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      timeout: const Duration(seconds: 15),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    print('verification completed');
    await signIn(credential);
  }

  void verificationFailed(FirebaseAuthException e) {
    print('verification failed: ${e.toString()}');
    emit(ErrorOccurred(message: e.toString()));
  }

  void codeSent(String verificationId, int? resendToken) {
    print('code sent');
    this.verificationId = verificationId;
    emit(PhoneNumberSubmitted());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    print('codeAutoRetrievalTimeout');
  }

  Future<void> submitOtp(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpCode);

    await signIn(credential);
  }

  Future<void>signIn(PhoneAuthCredential credential)async{
    try{
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOtpVerified());
    }catch(error){
      emit(ErrorOccurred(message: error.toString()));
    }
  }

  Future<void>logOut()async{
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedInUser(){
    User fireBaseUser = FirebaseAuth.instance.currentUser!;
    return fireBaseUser;
  }
}
