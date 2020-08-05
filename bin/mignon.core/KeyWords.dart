import 'Token_Kind.dart';

class Reserved {
  static const keywords = {
    'and': Kind.AND,
    'class': Kind.CLASS,
    'else': Kind.ELSE,
    'false': Kind.FALSE,
    'for': Kind.FOR,
    'fun': Kind.FUN,
    'if': Kind.IF,
    'nil': Kind.NIL,
    'or': Kind.OR,
    'print': Kind.PRINT,
    'return': Kind.RETURN,
    'super': Kind.SUPER,
    'this': Kind.THIS,
    'true': Kind.TRUE,
    'var': Kind.VAR,
    'while': Kind.WHILE
  };
}
