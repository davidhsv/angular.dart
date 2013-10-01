library angular.service.parser;

import 'dart:mirrors';
import 'package:perf_api/perf_api.dart';
import '../utils.dart';
import '../filter.dart';


part 'backend.dart';
part 'parser.dart';
part 'lexer.dart';
part 'static_parser.dart';

// Placeholder for DI.
// The parser you are looking for is DynamicParser
abstract class Parser {
  call(String text) {}
  primaryFromToken(Token token, parserError);
}
