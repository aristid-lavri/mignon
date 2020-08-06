import 'Expression.dart';

class Printer extends Visitor<String> {
  String printer(LangExpression expression) {
    return expression.Accept(this);
  }

  @override
  String visitBinaryExpr(Binary expression) {
    return Parenthesize(
        expression.langOperator.lexeme, [expression.left, expression.right]);
  }

  @override
  String visitGroupingExpr(Grouping expression) {
    return Parenthesize('group', [expression.expression]);
  }

  @override
  String visitLiteralExpr(Literal expression) {
    if (expression.value == null) return 'nil';
    return expression.value.toString();
  }

  @override
  String visitUnaryExpr(Unary expression) {
    return Parenthesize(expression.langOperator.lexeme, [expression.right]);
  }

  @override
  String visitAssignExpr(Assign expr) {
    // TODO: implement visitAssignExpr
    throw UnimplementedError();
  }

  @override
  String visitVariableExpr(Variable expr) {
    // TODO: implement visitVariableExpr
    throw UnimplementedError();
  }

  String Parenthesize(String name, List<LangExpression> exprs) {
    var builder = '';
    builder += '($name';

    for (var expr in exprs) {
      builder += ' ';
      var value = expr.Accept(this);
      builder += '$value';
    }
    builder += ')';

    return builder;
  }
}
