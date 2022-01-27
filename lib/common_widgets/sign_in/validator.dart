abstract class StringValidators {
  bool isValid(String value);

}
class NonEmptyStringValidor implements StringValidators{
  @override
  bool isValid(String value){
    return value.isNotEmpty;
  }

}
class EmailAndPassValidator {

  final  StringValidators emailValidator=NonEmptyStringValidor();
  final  StringValidators passValidator=NonEmptyStringValidor();
  final  String InValidEmailErrorText='Email can\'t be empty';
  final  String InValidPassErrorText='Password can\'t be empty';
}