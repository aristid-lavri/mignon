import 'dart:io';

import 'mignon.core/ATSPrinter.dart';
import 'mignon.interpreter/Interpreter.dart';
import 'mignon.parser/Parser.dart';
import 'mignon.scanner/Scanner.dart';

final interpreter = Interpreter();

void main(List<String> arguments) async {
  //read from file or from consome content
  // var source = stdin.readLineSync();

  // run(source);
  await runFile(
      'E:/Personal/Projects/Learning/Dart/test_2/bin/mignon.language/main.mig');
}

Future runFile(String path) async {
  var file = File(path);

  var sourceCode = await file.readAsString();

  // print(sourceCode);
  run(sourceCode);
}

void run(source) {
  var scanner = Scanner(source);

  var tokens = scanner.ScanTokens();

  // // scanner
  // for (var item in tokens) {
  //   print(item.toString());
  // }

  // parsercls
  var parser = Parser(tokens);
  var statements = parser.parseStatements();
  //var expression = parser.parse();

  // Stop if there was a syntax error.
  //if (expression == null) print('error');

  //print(Printer().printer(expression));

  // interpreter.interpret(expression);
  interpreter.StatementInterpret(statements);
}
