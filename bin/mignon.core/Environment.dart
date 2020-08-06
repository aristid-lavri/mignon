import 'Token.dart';

class Environment {
  Environment _enclosing;
  var values = <String, Object>{};

  Environment() {
    _enclosing = null;
  }

  Environment.unlaunched(Environment enclosing) {
    _enclosing = enclosing;
  }

  Object Get(Token token) {
    if (values.containsKey(token.lexeme)) {
      var keyValue = values[token.lexeme];
      return keyValue;
    }

    if (_enclosing != null) return _enclosing.Get(token);

    throw Exception("Undefined variable '" + token.lexeme + "'.");
  }

  void Assign(Token token, Object value) {
    if (values.containsKey(token.lexeme)) {
      values[token.lexeme] = value;
      return;
    }

    if (_enclosing != null) {
      _enclosing.Assign(token, value);
      return;
    }

    throw Exception("Undefined variable '" + token.lexeme + "'.");
  }

  void Define(String token, Object value) {
    values[token] = value;
  }
}
