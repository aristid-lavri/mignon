import 'dart:io';

import 'mignon.scanner/Scanner.dart';

void main(List<String> arguments) {
  //read from file or from consome content

  var source = stdin.readLineSync();

  run(source);
}

void run(source) {
  Scanner scanner = Scanner(source);

  var tokens = scanner.ScanTokens();

  for (var item in tokens) {
    print(item.toString());
  }
}
