import 'Token.dart';

abstract class LangExpression {}

class Grouping extends LangExpression {
  LangExpression expression;
  Grouping(this.expression);
}

class Binary extends LangExpression {
  LangExpression left;
  LangExpression right;
  Token langOperator;

  Binary(this.left, this.langOperator, this.right);
}

class Literal extends LangExpression {
  Object value;
  Literal(this.value);
}

class Unary extends LangExpression {
  Token langOperator;
  LangExpression right;
  Unary(this.langOperator, this.right);
}
