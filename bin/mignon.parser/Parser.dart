import '../mignon.core/Expression.dart';
import '../mignon.core/Token.dart';
import '../mignon.core/Token_Kind.dart';

class Parser {
  final List<Token> _tokens;
  int _current = 0;

  Parser(this._tokens);

  LangExpression Expression() {
    return Equality();
  }

  LangExpression Equality() {
    var left = Comparison();

    while (Match([Kind.BANG_EQUAL, Kind.EQUAL_EQUAL])) {
      var langOperator = Previous();

      var right = Comparison();
      left = Binary(left, langOperator, right);
    }

    return left;
  }

  LangExpression Comparison() {
    var left = Addition();

    while (
        Match([Kind.GREATER, Kind.GREATER_EQUAL, Kind.LESS, Kind.LESS_EQUAL])) {
      var langOperator = Previous();

      var right = Addition();
      left = Binary(left, langOperator, right);
    }

    return left;
  }

  LangExpression Addition() {
    var left = Multiplication();
    while (Match([Kind.MINUS, Kind.PLUS])) {
      var langOperator = Previous();
      var right = Addition();
      left = Binary(left, langOperator, right);
    }

    return left;
  }

  LangExpression Multiplication() {
    var left = FuncUnary();
    while (Match([Kind.SLASH, Kind.STAR])) {
      var langOperator = Previous();
      var right = FuncUnary();
      left = Binary(left, langOperator, right);
    }

    return left;
  }

  LangExpression FuncUnary() {
    if (Match([Kind.MINUS, Kind.PLUS])) {
      var langOperator = Previous();
      var right = FuncUnary();
      return Unary(langOperator, right);
    }

    return FuncPrimary();
  }

  LangExpression FuncPrimary() {
    if (Match([Kind.FALSE])) return Literal(false);
    if (Match([Kind.TRUE])) return Literal(true);
    if (Match([Kind.NIL])) return Literal(null);

    if (Match([Kind.NUMBER, Kind.STRING])) {
      return Literal(Previous().literal);
    }

    if (Match([Kind.LEFT_PARENTH])) {
      var expr = Expression();
      print('$Kind.RIGHT_PARENTH, Expect ")" after expression.');
      return Grouping(expr);
    }

    var err = Peek().toString();
    throw Exception('$err Expect Expression');
  }

  bool Match(List<Kind> kinds) {
    for (var kind in kinds) {
      if (Check(kind)) {
        Advance();
        return true;
      }
    }

    return false;
  }

  Token Advance() {
    if (!IsAtEnd()) _current++;

    return Previous();
  }

  bool IsAtEnd() {
    return Peek().kind == Kind.EOF;
  }

  Token Peek() {
    return _tokens.elementAt(_current);
  }

  Token Previous() {
    return _tokens.elementAt(_current - 1);
  }

  bool Check(Kind kind) {
    if (IsAtEnd()) return false;
    return Peek().kind == kind;
  }
}
