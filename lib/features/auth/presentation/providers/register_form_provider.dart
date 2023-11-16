import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

//! 3.- StateNotifierProvider - consume outside
final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier,RegisterFormState>((ref) {
  
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(
    registerUserCallback: registerUserCallback,
  );
});

//! 2.- How to implentate a Notifier

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {

  final Function(String,String,String) registerUserCallback;

  RegisterFormNotifier({
    required this.registerUserCallback,
  }): super(RegisterFormState());

  onFullNameChanged(String value){
    final newFullName = FullName.dirty(value);

    state = state.copyWith(
      fullName: newFullName,
      isValid: Formz.validate([ 
        newFullName, 
        state.email, 
        state.password, 
        state.confirmPassword 
      ])
    );
  }

  onEmailChanged(String value){
    final newEmail = Email.dirty(value);

    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([ 
        newEmail, 
        state.fullName, 
        state.password, 
        state.confirmPassword 
      ])
    );
  }

  onPasswordChanged(String value){
    final newPassword = Password.dirty(value);

    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([ 
        newPassword, 
        state.fullName, 
        state.email, 
        state.confirmPassword 
      ])
    );
  }

  onConfirmPasswordChanged(String value){

    final newConfirmPassword = Password.dirty(value);

    state = state.copyWith(
      confirmPassword: newConfirmPassword,
      isValid: Formz.validate([
        newConfirmPassword,
        state.fullName, 
        state.email, 
        state.password 
      ])
    );
  }

  onFormSubmit() async {
    _touchedEveryField();
    
    // print(state);
    if(!state.isValid) return;
    //TODO: submit data

    registerUserCallback(
      state.fullName.value,
      state.email.value,
      state.password.value,
    );

  }

  _touchedEveryField(){

    final fullName = FullName.dirty(state.fullName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = Password.dirty(state.confirmPassword.value);

    if(password != confirmPassword){
      state = state.copyWith(
        passwordMatch: true
      );
      return;
    }

    state = state.copyWith(
      isFormPosted: true,
      fullName: fullName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      passwordMatch: false,
      isValid: Formz.validate([fullName, email, password, confirmPassword])
    );
  }
  
}

//! 1.- Create State of this Provider (StateNotifierProvider)

class RegisterFormState {

  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final FullName fullName;
  final Email email;
  final Password password;
  final Password confirmPassword;
  final bool passwordMatch;

  RegisterFormState({
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false, 
    this.fullName = const FullName.pure(), 
    this.email = const Email.pure(), 
    this.password = const Password.pure(),
    this.confirmPassword = const Password.pure(),
    this.passwordMatch = false
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    FullName? fullName,
    Email? email,
    Password? password,
    Password? confirmPassword,
    bool? passwordMatch,
  }) => RegisterFormState(
    isPosting : isPosting ?? this.isPosting,
    isFormPosted : isFormPosted ?? this.isFormPosted,
    isValid : isValid ?? this.isValid,
    fullName : fullName ?? this.fullName,
    email : email ?? this.email,
    password : password ?? this.password,
    confirmPassword: confirmPassword ?? this.confirmPassword,
    passwordMatch: passwordMatch ?? this.passwordMatch,
  );

  @override
  String toString(){
    return '''
      Login FormState:
      isPosting: $isPosting
      isFormPosted: $isFormPosted
      isValid: $isValid
      fullName: $fullName
      email: $email
      password: $password
      confirmPassword: $confirmPassword
      passwordMatch: $passwordMatch
    ''';
  }
}