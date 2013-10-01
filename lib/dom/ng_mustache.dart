library angular.directive.ng_mustache;

import 'dart:html' as dom;
import 'directive.dart';
import '../parser/parser_library.dart';
import '../interpolate.dart';
import '../scope.dart';

@NgDirective(selector: r':contains(/{{.*}}/)')
class NgTextMustacheDirective {
  dom.Node element;
  Expression interpolateFn;

  // This Directive is special and does not go through injection.
  NgTextMustacheDirective(dom.Node this.element, String markup, Interpolate interpolate, Scope scope) {
    interpolateFn = interpolate(markup);
    element.text = '';
    scope.$watch(interpolateFn.eval, (text) => element.text = text);
  }

}

@NgDirective(selector: r'[*=/{{.*}}/]')
class NgAttrMustacheDirective {
  static RegExp ATTR_NAME_VALUE_REGEXP = new RegExp(r'^([^=]+)=(.*)$');

// This Directive is special and does not go through injection.
  NgAttrMustacheDirective(NodeAttrs attrs, String markup, Interpolate interpolate, Scope scope) {
    var match = ATTR_NAME_VALUE_REGEXP.firstMatch(markup);
    var attrName = match[1];
    Expression interpolateFn = interpolate(match[2]);
    Function attrSetter = (text) => attrs[attrName] = text;
    attrSetter('');
    scope.$watch(interpolateFn.eval, attrSetter);
  }
}
