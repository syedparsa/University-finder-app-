
import 'package:dream_university_finder_app/common_widgets/sign_in/validator.dart';

enum EmailSigninformType { signIn, register }

class EmailSignInModel with EmailAndPassValidator {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSigninformType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  final String email;
  final String password;
  EmailSigninformType formType;
  final bool isLoading;
  final bool submitted;

  String get primarytButtonText {
    return formType == EmailSigninformType.signIn
        ? 'Sign in '
        : 'Creat an account';
  }

  String get secondaryButtonText {
    return formType == EmailSigninformType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        emailValidator.isValid(password) &&
        !isLoading;
  }

  String? get passwordErrorText {
    bool ShowError = submitted && !passValidator.isValid(password);
    return ShowError ? InValidPassErrorText : null;
  }

  String? get EmailErrorText {
    bool ShowError = submitted && !emailValidator.isValid(email);
    return ShowError ? InValidEmailErrorText : null;
  }




  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSigninformType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
