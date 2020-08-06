import 'Token.dart';

abstract class LangExpression {
  T Accept<T>(Visitor<T> visitor);
}

abstract class Visitor<T> {
  T visitAssignExpr(Assign expr);
  T visitVariableExpr(Variable expr);
  T visitBinaryExpr(Binary expr);
  T visitGroupingExpr(Grouping expr);
  T visitLiteralExpr(Literal expr);
  T visitUnaryExpr(Unary expr);
}

class Assign extends LangExpression {
  Assign(Token name, LangExpression value) {
    this.name = name;
    this.value = value;
  }
  @override
  T Accept<T>(Visitor<T> visitor) {
    return visitor.visitAssignExpr(this);
  }

  Token name;
  LangExpression value;
}

class Variable extends LangExpression {
  Variable(Token name) {
    this.name = name;
  }
  @override
  T Accept<T>(Visitor<T> visitor) {
    return visitor.visitVariableExpr(this);
  }

  Token name;
}

class Grouping extends LangExpression {
  LangExpression expression;
  Grouping(this.expression);

  @override
  T Accept<T>(Visitor<T> visitor) {
    return visitor.visitGroupingExpr(this);
  }
}

class Binary extends LangExpression {
  LangExpression left;
  LangExpression right;
  Token langOperator;

  Binary(this.left, this.langOperator, this.right);

  @override
  T Accept<T>(Visitor<T> visitor) {
    return visitor.visitBinaryExpr(this);
  }
}

class Literal extends LangExpression {
  Object value;
  Literal(this.value);

  @override
  T Accept<T>(Visitor<T> visitor) {
    return visitor.visitLiteralExpr(this);
  }
}

class Unary extends LangExpression {
  Token langOperator;
  LangExpression right;
  Unary(this.langOperator, this.right);

  @override
  T Accept<T>(Visitor<T> visitor) {
    return visitor.visitUnaryExpr(this);
  }
}
