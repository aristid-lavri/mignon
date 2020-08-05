import '../mignon.core/KeyWords.dart';
import '../mignon.core/Token.dart';
import '../mignon.core/Token_Kind.dart';

class Scanner {
  final String _source;
  int _start = 0;
  int _current = 0;
  int _line = 1;

  final List<Token> _tokens = [];

  Scanner(this._source);

  // retourne la liste des tokens recupérés dans la source
  List<Token> ScanTokens() {
    while (!IsAtEnd()) {
      _start = _current;

      ScanToken();
    }

    _tokens.add(Token(Kind.EOF, '', null, _line));

    return _tokens;
  }

  // creé un token en fonction des caratères retournés
  void ScanToken() {
    var c = Advance();

    switch (c) {
      case '(':
        AddToken(Kind.LEFT_PARENTH);
        break;
      case ')':
        AddToken(Kind.RIGHT_PARENTH);
        break;
      case '{':
        AddToken(Kind.LEFT_BRACE);
        break;
      case '}':
        AddToken(Kind.RIGHT_BRACE);
        break;
      case ',':
        AddToken(Kind.COMMA);
        break;
      case '.':
        AddToken(Kind.DOT);
        break;
      case '-':
        AddToken(Kind.MINUS);
        break;
      case '+':
        AddToken(Kind.PLUS);
        break;
      case ';':
        AddToken(Kind.SEMICOLON);
        break;
      case '*':
        AddToken(Kind.STAR);
        break;
      case '!':
        AddToken(Match('=') ? Kind.BANG_EQUAL : Kind.BANG);
        break;
      case '=':
        AddToken(Match('=') ? Kind.EQUAL_EQUAL : Kind.EQUAL);
        break;
      case '<':
        AddToken(Match('=') ? Kind.LESS_EQUAL : Kind.LESS);
        break;
      case '>':
        AddToken(Match('=') ? Kind.GREATER_EQUAL : Kind.GREATER);
        break;
      case '/':
        if (Match('/')) {
          // A comment goes until the end of the _line.
          while (Peek() != '\n' && !IsAtEnd()) {
            Advance();
          }
        } else {
          AddToken(Kind.SLASH);
        }
        break;
      case ' ':
      case '\r':
      case '\t':
        // Ignore whitespace.
        break;
      case '\n':
        _line++;
        break;
      case '"':
        GetStringLiteral();
        break;
      case 'o':
        if (Peek() == 'r') {
          AddToken(Kind.OR);
        }
        break;

      default:
        if (IsDigit(c)) {
          GetNumberLiteral();
        } else if (IsAlpha(c)) {
          GetIdentifier();
        } else {
          throw Exception();
        }
        break;
    }
  }

  // verifier si le caratère courrant se trouve en fin de ligne
  bool IsAtEnd() {
    return _current >= _source.length;
  }

  // get next caractère without increment current index
  String Peek() {
    if (IsAtEnd()) return null;

    return _source[_current];
  }

  String PeekNext() {
    if (_current + 1 >= _source.length) return null;
    return _source[_current + 1];
  }

  // permet de passer au caractère suivant
  String Advance() {
    _current++;

    return _source[_current - 1];
  }

  // verify that next caractere is the expected one and go to next caracter if true
  bool Match(String expected) {
    if (IsAtEnd()) throw Exception();
    if (_source[_current] != expected) return false;

    _current++;
    return true;
  }

  void GetStringLiteral() {
    while (Peek() != '"' && !IsAtEnd()) {
      if (Peek() == '\n') _line++;
      Advance();
    }

    // Unterminated string.
    if (IsAtEnd()) {
      throw Exception();
    }

    // The closing ".
    Advance();

    // Trim the surrounding quotes.
    var value = _source.substring(_start + 1, _current - 1);
    AddToken(Kind.STRING, value);
  }

  // verify if caractere is digit (with ascii code)
  bool IsDigit(String char) {
    return char != null
        ? (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57)
        : false;
  }

  bool IsAlphaNumeric(String char) {
    return IsAlpha(char) || IsDigit(char);
  }

  // verify if caractere is alpha (with ascii code)
  bool IsAlpha(String char) {
    return char != null
        ? ((char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 122) ||
            (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90) ||
            (char.codeUnitAt(0) == 95))
        : false;
  }

  void GetNumberLiteral() {
    while (IsDigit(Peek())) {
      Advance();
    }

    // Look for a fractional part.
    if (Peek() == '.' && IsDigit(PeekNext())) {
      // Consume the "."
      Advance();

      while (IsDigit(Peek())) {
        Advance();
      }
    }

    AddToken(Kind.NUMBER, double.parse(_source.substring(_start, _current)));
  }

  void GetIdentifier() {
    while (IsAlphaNumeric(Peek())) {
      Advance();
    }
    // See if the identifier is a reserved word.
    var text = _source.substring(_start, _current);

    Reserved.keywords[text] == null
        ? AddToken(Kind.IDENTIFIER)
        : AddToken(Reserved.keywords[text]);
  }

  // add token when show one
  void AddToken(Kind kind, [Object literal]) {
    var text = _source.substring(_start, _current);
    _tokens.add(Token(kind, text, literal, _line));
  }
}
