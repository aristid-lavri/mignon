import 'Expression.dart';
import 'Token.dart';

abstract class Statement {
  T Accept<T>(StatementVisitor<T> visitor);
}

abstract class StatementVisitor<T> {
  T VisitBlockStatement(Block Statement);
  T VisitExpressionStatement(StatementExpression Statement);
  // T VisitIfStatement(If Statement);
  T VisitPrintStatement(Print Statement);
  T VisitVarStatement(Var Statement);
}

class Block extends Statement {
  Block(List<Statement> statements) {
    this.statements = statements;
  }

  @override
  T Accept<T>(StatementVisitor<T> visitor) {
    return visitor.VisitBlockStatement(this);
  }

  List<Statement> statements;
}

class StatementExpression extends Statement {
  StatementExpression(LangExpression expression) {
    this.expression = expression;
  }

  @override
  T Accept<T>(StatementVisitor<T> visitor) {
    return visitor.VisitExpressionStatement(this);
  }

  LangExpression expression;
}

// class If extends Statement {
//   If(LangExpression condition, Statement thenBranch, Statement elseBranch) {
//     this.condition = condition;
//     this.thenBranch = thenBranch;
//     this.elseBranch = elseBranch;
//   }

//   @override
//   T Accept<T>(Visitor<T> visitor) {
//     return visitor.VisitIfStatement(this);
//   }

//   LangExpression condition;
//   Statement thenBranch;
//   Statement elseBranch;
// }

class Print extends Statement {
  Print(LangExpression expression) {
    this.expression = expression;
  }

  @override
  T Accept<T>(StatementVisitor<T> visitor) {
    return visitor.VisitPrintStatement(this);
  }

  LangExpression expression;
}

class Var extends Statement {
  Var(Token name, LangExpression initializer) {
    this.name = name;
    this.initializer = initializer;
  }

  @override
  T Accept<T>(StatementVisitor<T> visitor) {
    return visitor.VisitVarStatement(this);
  }

  Token name;
  LangExpression initializer;
}
