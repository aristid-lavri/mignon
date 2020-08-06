import '../mignon.core/Expression.dart';
import '../mignon.core/Statements.dart';
import '../mignon.core/Token.dart';
import '../mignon.core/Token_Kind.dart';

class Parser {
  final List<Token> _tokens;
  int _current = 0;

  Parser(this._tokens);

  LangExpression parse() {
    try {
      return Expression();
    } catch (e) {
      return null;
    }
  }

  List<Statement> parseStatements() {
    List<Statement> statements = [];

    while (!IsAtEnd()) {
      statements.add(declaration());
    }

    return statements;
  }

  Statement statement() {
    if (Match([Kind.PRINT])) return printStatement();
    if (Match([Kind.LEFT_BRACE])) return Block(block());
    return expressionStatement();
  }

  Statement printStatement() {
    var value = Expression();
    Consume(Kind.SEMICOLON, "Expect ';' after value.");
    return Print(value);
  }

  Statement expressionStatement() {
    var expr = Expression();
    Consume(Kind.SEMICOLON, "Expect ';' after expression.");
    return StatementExpression(expr);
  }

  List<Statement> block() {
    var statements = [];

    while (!Check(Kind.RIGHT_BRACE) && !IsAtEnd()) {
      statements.add(declaration());
    }

    Consume(Kind.RIGHT_BRACE, "Expect '}' after block.");
    return statements;
  }

  Statement declaration() {
    try {
      if (Match([Kind.VAR])) return VarDeclaration();

      return statement();
    } catch (e) {
      Synchronize();
      return null;
    }
  }

  Statement VarDeclaration() {
    var name = Consume(Kind.IDENTIFIER, 'Expect variable name.');

    var initializer;

    if (Match([Kind.EQUAL])) {
      initializer = Expression();
    }

    Consume(Kind.SEMICOLON, "Expect ';' after variable declaration.");
    return Var(name, initializer);
  }

  void Synchronize() {
    Advance();

    while (!IsAtEnd()) {
      if (Previous().kind == Kind.SEMICOLON) return;

      switch (Peek().kind) {
        case Kind.CLASS:
        case Kind.FUN:
        case Kind.VAR:
        case Kind.FOR:
        case Kind.IF:
        case Kind.WHILE:
        case Kind.PRINT:
        case Kind.RETURN:
          return;
      }

      Advance();
    }
  }

  LangExpression Expression() {
    return Assignment();
  }

  LangExpression Assignment() {
    var expression = Equality();

    if (Match([Kind.EQUAL])) {
      var value = Assignment();

      if (expression is Variable) {
        var name = expression.name;
        return Assign(name, value);
      }
    }

    return expression;
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

    if (Match([Kind.IDENTIFIER])) {
      return Variable(Previous());
    }

    if (Match([Kind.LEFT_PARENTH])) {
      var expr = Expression();

      Consume(Kind.RIGHT_PARENTH, 'Expect ")" after expression.');
      return Grouping(expr);
    }

    throw Error(Peek(), 'Expect Expression');
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

  Token Consume(Kind kind, String message) {
    if (Check(kind)) return Advance();

    throw Error(Peek(), message);
  }

  Exception Error(Token token, String message) {
    // Error.Emit(token, message);

    return Exception(message);
  }
}
