import '../mignon.core/Environment.dart';
import '../mignon.core/Expression.dart';
import '../mignon.core/Statements.dart';
import '../mignon.core/Token.dart';
import '../mignon.core/Token_Kind.dart';

class Interpreter implements Visitor<Object>, StatementVisitor<Object> {
  var environment = Environment();

  void interpret(LangExpression expression) {
    try {
      var value = evaluate(expression);
      print(stringify(value));
    } catch (e) {
      throw Exception(e);
    }
  }

  void StatementInterpret(List<Statement> statements) {
    try {
      for (var statement in statements) {
        Execute(statement);
      }
    } catch (e) {}
  }

  void Execute(Statement stmt) {
    stmt.Accept(this);
  }

  String stringify(Object object) {
    if (object == null) return 'nil';

    // Hack. Work around Java adding ".0" to integer-valued doubles.
    if (object is double) {
      var text = object.toString();
      if (text.endsWith('.0')) {
        text = text.substring(0, text.length - 2);
      }
      return text;
    }

    return object.toString();
  }

  @override
  Object visitAssignExpr(Assign expr) {
    var value = evaluate(expr.value);

    environment.Assign(expr.name, value);
    return value;
  }

  @override
  Object visitBinaryExpr(Binary expr) {
    var left = evaluate(expr.left);
    var right = evaluate(expr.right);

    switch (expr.langOperator.kind) {
      case Kind.MINUS:
        checkNumberOperands(expr.langOperator, left, right);
        return (left as double) - (right as double);
      case Kind.PLUS:
        {
          if (left is double && right is double) {
            return left * right;
          }

          if (left is String && right is String) {
            return left + right;
          }

          throw Exception('Operands must be two numbers or two strings.');
        }
        break;
      case Kind.SLASH:
        checkNumberOperands(expr.langOperator, left, right);
        return (left as double) / (right as double);
      case Kind.STAR:
        checkNumberOperands(expr.langOperator, left, right);
        return (left as double) * (right as double);
      case Kind.GREATER:
        checkNumberOperands(expr.langOperator, left, right);
        return (left as double) > (right as double);
      case Kind.GREATER_EQUAL:
        checkNumberOperands(expr.langOperator, left, right);
        return (left as double) >= (right as double);
      case Kind.LESS:
        checkNumberOperands(expr.langOperator, left, right);
        return (left as double) < (right as double);
      case Kind.LESS_EQUAL:
        checkNumberOperands(expr.langOperator, left, right);
        return (left as double) <= (right as double);
      case Kind.BANG_EQUAL:
        return !isEqual(left, right);
      case Kind.EQUAL_EQUAL:
        return isEqual(left, right);
    }

    // Unreachable.
    return null;
  }

  @override
  Object visitGroupingExpr(Grouping expr) {
    return evaluate(expr.expression);
  }

  @override
  Object visitLiteralExpr(Literal expr) {
    var lit = expr.value;
    return expr.value;
  }

  @override
  Object visitUnaryExpr(Unary expr) {
    var right = evaluate(expr.right);

    switch (expr.langOperator.kind) {
      case Kind.MINUS:
        checkNumberOperand(expr.langOperator, right);
        return -(right as double);
      case Kind.LEFT_PARENTH:
        // TODO: Handle this case.
        break;
      case Kind.RIGHT_PARENTH:
        // TODO: Handle this case.
        break;
      case Kind.LEFT_BRACE:
        // TODO: Handle this case.
        break;
      case Kind.RIGHT_BRACE:
        // TODO: Handle this case.
        break;
      case Kind.COMMA:
        // TODO: Handle this case.
        break;
      case Kind.DOT:
        // TODO: Handle this case.
        break;
      case Kind.PLUS:
        // TODO: Handle this case.
        break;
      case Kind.SEMICOLON:
        // TODO: Handle this case.
        break;
      case Kind.SLASH:
        // TODO: Handle this case.
        break;
      case Kind.STAR:
        // TODO: Handle this case.
        break;
      case Kind.BANG:
        return !isTruthy(right);
        break;
      case Kind.BANG_EQUAL:
        // TODO: Handle this case.
        break;
      case Kind.EQUAL:
        // TODO: Handle this case.
        break;
      case Kind.EQUAL_EQUAL:
        // TODO: Handle this case.
        break;
      case Kind.GREATER:
        // TODO: Handle this case.
        break;
      case Kind.GREATER_EQUAL:
        // TODO: Handle this case.
        break;
      case Kind.LESS:
        // TODO: Handle this case.
        break;
      case Kind.LESS_EQUAL:
        // TODO: Handle this case.
        break;
      case Kind.IDENTIFIER:
        // TODO: Handle this case.
        break;
      case Kind.STRING:
        // TODO: Handle this case.
        break;
      case Kind.NUMBER:
        // TODO: Handle this case.
        break;
      case Kind.AND:
        // TODO: Handle this case.
        break;
      case Kind.CLASS:
        // TODO: Handle this case.
        break;
      case Kind.ELSE:
        // TODO: Handle this case.
        break;
      case Kind.FALSE:
        // TODO: Handle this case.
        break;
      case Kind.FUN:
        // TODO: Handle this case.
        break;
      case Kind.FOR:
        // TODO: Handle this case.
        break;
      case Kind.IF:
        // TODO: Handle this case.
        break;
      case Kind.NIL:
        // TODO: Handle this case.
        break;
      case Kind.OR:
        // TODO: Handle this case.
        break;
      case Kind.PRINT:
        // TODO: Handle this case.
        break;
      case Kind.RETURN:
        // TODO: Handle this case.
        break;
      case Kind.SUPER:
        // TODO: Handle this case.
        break;
      case Kind.THIS:
        // TODO: Handle this case.
        break;
      case Kind.TRUE:
        // TODO: Handle this case.
        break;
      case Kind.VAR:
        // TODO: Handle this case.
        break;
      case Kind.WHILE:
        // TODO: Handle this case.
        break;
      case Kind.EOF:
        // TODO: Handle this case.
        break;
    }

    // Unreachable.
    return null;
  }

  @override
  Object visitVariableExpr(Variable expr) {
    return environment.Get(expr.name);
  }

  Object evaluate(LangExpression expression) {
    return expression.Accept(this);
  }

  bool isTruthy(Object right) {
    if (right == null) return false;
    if (right is bool) return right;

    return true;
  }

  bool isEqual(Object a, Object b) {
    if (a == null && b == null) return true;
    if (a == null) return false;

    return a == b;
  }

  void checkNumberOperand(Token langOperator, Object right) {
    if (langOperator is double) return;
    throw Exception('Operand must be a number.');
  }

  void checkNumberOperands(Token langOperator, Object left, Object right) {
    if (left is double && right is double) return;

    throw Exception('Operands must be numbers.');
  }

  @override
  Object VisitBlockStatement(Block statement) {
    executeBlock(statement.statements, Environment.unlaunched(environment));
    return null;
  }

  void executeBlock(List<Statement> statements, Environment environment) {
    var previous = this.environment;
    try {
      this.environment = environment;

      for (var statement in statements) {
        Execute(statement);
      }
    } finally {
      this.environment = previous;
    }
  }

  @override
  Object VisitExpressionStatement(StatementExpression statement) {
    evaluate(statement.expression);
    return null;
  }

  @override
  Object VisitPrintStatement(Print statement) {
    var value = evaluate(statement.expression);
    print(stringify(value));
    return null;
  }

  @override
  Object VisitVarStatement(Var statement) {
    var value;
    if (statement.initializer != null) {
      value = evaluate(statement.initializer);
    }

    environment.Define(statement.name.lexeme, value);
    return null;
  }
}
