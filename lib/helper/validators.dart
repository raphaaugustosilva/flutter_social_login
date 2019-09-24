import 'package:flutter/services.dart';

abstract class StringValidator {
  bool estaValido(String value);
}

class RegexValidator implements StringValidator {
  RegexValidator({this.regexSource});
  final String regexSource;

  @override
  bool estaValido(String value) {
    try {
      // https://regex101.com/
      final RegExp regex = RegExp(regexSource);
      final Iterable<Match> matches = regex.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class ValidatorInputFormatter implements TextInputFormatter {
  ValidatorInputFormatter({this.editingValidator});
  final StringValidator editingValidator;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final bool oldValueValid = editingValidator.estaValido(oldValue.text);
    final bool newValueValid = editingValidator.estaValido(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}

class EmailEditingRegexValidator extends RegexValidator {
  EmailEditingRegexValidator() : super(regexSource: '^(|\\S)+\$');
}

class EmailSubmitRegexValidator extends RegexValidator {
  EmailSubmitRegexValidator() : super(regexSource: '^\\S+@\\S+\\.\\S+\$');
}

class NonEmptyStringValidator extends StringValidator {
  @override
  bool estaValido(String value) {
    return value.isNotEmpty;
  }
}

class MinLengthStringValidator extends StringValidator {
  MinLengthStringValidator(this.minLength);
  final int minLength;

  @override
  bool estaValido(String value) {
    return value.length >= minLength;
  }
}

class EmailESenhaValidadores {
  final TextInputFormatter emailEntradaFormatter = ValidatorInputFormatter(editingValidator: EmailEditingRegexValidator());
  final StringValidator emailValidoValidador = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator = MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator = NonEmptyStringValidator();
}
