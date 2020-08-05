import 'Token_Kind.dart';

class Token {
  Kind kind;
  String lexeme;
  Object literal;
  int line;

  Token(this.kind, this.lexeme, this.literal, this.line) {}

  @override
  String toString() {
    return 'type: $kind. Lexeme: $lexeme. Value: $literal';
  }
}
