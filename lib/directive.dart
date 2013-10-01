library angular.service.directive;

import 'package:di/di.dart';
import 'registry.dart';

class NgAnnotationBase {
  /**
   * CSS selector which will trigger this component/directive.
   * CSS Selectors are limited to a single element and can contain:
   *
   * * `element-name` limit to a given element name.
   * * `.class` limit to an element with a given class.
   * * `[attribute]` limit to an element with a given attribute name.
   * * `[attribute=value]` limit to an element with a given attribute and value.
   *
   *
   * Example: `input[type=checkbox][ng-model]`
   */
  final String selector;

  /**
   * A directive/component controller class can be injected into other
   * directives/components. This attribute controls whether the
   * controller is available to others.
   *
   * * `local` [NgDirective.LOCAL_VISIBILITY] - the controller can be injected
   *   into other directives / components on the same DOM element.
   * * `children` [NgDirective.CHILDREN_VISIBILITY] - the controller can be
   *   injected into other directives / components on the same or child DOM
   *   elements.
   * * `direct_children` [NgDirective.DIRECT_CHILDREN_VISIBILITY] - the
   *   controller can be injected into other directives / components on the
   *   direct children of the current DOM element.
   */
  final String visibility;
  final List<Type> publishTypes;

  /**
   * Use map to define the mapping of component's DOM attributes into
   * the component instance or scope. The map's key is the DOM attribute name
   * to map in camelCase (DOM attribute is in dash-case). The Map's value
   * consists of a mode character, and an expression. If expression is not
   * specified, it maps to the same scope parameter as is the DOM attribute.
   *
   * * `@` - Map the DOM attribute string. The attribute string will be taken
   *   literally or interpolated if it contains binding {{}} systax.
   *
   * * `=` - Treat the DOM attribute value as an expression. Set up a watch
   *   on both outside as well as component scope to keep the src and
   *   destination in sync.
   *
   * * `!` - Treat the DOM attribute value as an expression. Set up a one time
   *   watch on expression. Once the expression turns truthy it will no longer
   *   update.
   *
   * * `&` - Treat the DOM attribute value as an expression. Assign a closure
   *   function into the component. This allows the component to control
   *   the invocation of the closure. This is useful for passing
   *   expressions into controllers which act like callbacks.
   *
   * NOTE: an expression may start with `.` which evaluates the expression
   * against the current controller rather then current scope.
   *
   * Example:
   *
   *     <my-component title="Hello {{username}}"
   *                   selection="selectedItem"
   *                   on-selection-change="doSomething()">
   *
   *     @NgComponent(
   *       selector: 'my-component'
   *       map: const {
   *         'title': '@.title',
   *         'selection': '=.currentItem',
   *         'onSelectionChange': '&.onChange'
   *       }
   *     )
   *     class MyComponent {
   *       String title;
   *       var currentItem;
   *       ParsedFn onChange;
   *     }
   *
   *  The above example shows how all three mapping modes are used.
   *
   *  * `@.title` maps the title DOM attribute to the controller `title`
   *    field. Notice that this maps the content of the attribute, which
   *    means that it can be used with `{{}}` interpolation.
   *
   *  * `=.currentItem` maps the expression (in this case the `selectedItem`
   *    in the current scope into the `currentItem` in the controller. Notice
   *    that mapping is bi-directional. A change either in controller or on
   *    parent scope will result in change of the other.
   *
   *  * `&.onChange` maps the expression into tho controllers `onChange`
   *    field. The result of mapping is a callable function which can be
   *    invoked at any time by the controller. The invocation of the
   *    callable function will result in the expression `doSomething()` to
   *    be executed in the parent context.
   */
  final Map<String, String> map;

  /**
   * Use the list to specify expression containing attributes which are not
   * included under [map] with '=' or '@' specification.
   */
  final List<String> exportExpressionAttrs;

  /**
   * Use the list to specify a expressions which are evaluated dynamically
   * (ex. via [Scope.$eval]) and are otherwise not statically discoverable.
   */
  final List<String> exportExpressions;

  /**
   * An expression under which the controller instance will be published into.
   * This allows the expressions in the template to be referring to controller
   * instance and its properties.
   */
  final String publishAs;

  const NgAnnotationBase({
    this.selector,
    this.visibility: NgDirective.LOCAL_VISIBILITY,
    this.publishAs,
    this.publishTypes: const [],
    this.map: const {},
    this.exportExpressions: const [],
    this.exportExpressionAttrs: const []
  });

  toString() => selector;
  get hashCode => selector.hashCode;
  operator==(other) =>
      other is NgAnnotationBase && this.selector == other.selector;

}


// Explicitly pass all the named parameters to work around dartbug.com/13556
/**
 * Meta-data marker placed on a class to make the compiler skip processing
 * Angular constructs on the element matched by the specified selector and all
 * of its descendants.  This allows one to have DOM nodes that contains Angular
 * markup but should not be processed as a template.
 */
class NgNonBindable extends NgAnnotationBase {
  const NgNonBindable({ selector }) : super(
      selector: selector, visibility: null,
      publishTypes: null, map: null,
      exportExpressions: null,
      exportExpressionAttrs: null);
}


/**
 * Meta-data marker placed on a class which should act as a controller for the
 * component. Angular components are a light-weight version of web-components.
 * Angular components use shadow-DOM for rendering their templates.
 *
 * Angular components are instantiated using dependency injection, and can
 * ask for any injectable object in their constructor. Components
 * can also ask for other components or directives declared on the DOM element.
 *
 * Components can declared these optional methods:
 *
 * * `attach()` - Called on first [Scope.$digest()].
 *
 * * `detach()` - Called on when owning scope is destroyed.
 *
 */
class NgComponent extends NgAnnotationBase {
  /**
   * Inlined HTML template for the component.
   */
  final String template;

  /**
   * A URL to HTML template. This will be loaded asynchronously and
   * cached for future component instances.
   */
  final String templateUrl;

  /**
   * A CSS URL to load into the shadow DOM.
   */
  final String cssUrl;

  /**
   * Set the shadow root applyAuthorStyles property. See shadow-DOM
   * documentation for further details.
   */
  final bool applyAuthorStyles;

  /**
   * Set the shadow root resetStyleInheritance property. See shadow-DOM
   * documentation for further details.
   */
  final bool resetStyleInheritance;

  const NgComponent({
    this.template,
    this.templateUrl,
    this.cssUrl,
    this.applyAuthorStyles,
    this.resetStyleInheritance,
    publishAs,
    map,
    selector,
    visibility,
    publishTypes : const <Type>[],
    exportExpressions,
    exportExpressionAttrs
  }) : super(selector: selector, visibility: visibility,
      publishTypes: publishTypes, publishAs: publishAs, map: map,
      exportExpressions: exportExpressions,
      exportExpressionAttrs: exportExpressionAttrs);
}

RegExp _ATTR_NAME = new RegExp(r'\[([^\]]+)\]$');

class NgDirective extends NgAnnotationBase {
  static const String LOCAL_VISIBILITY = 'local';
  static const String CHILDREN_VISIBILITY = 'children';
  static const String DIRECT_CHILDREN_VISIBILITY = 'direct_children';

  final bool transclude;
  final String attrName;

  const NgDirective({
    this.transclude: false,
    this.attrName: null,
    publishAs,
    map,
    selector,
    visibility,
    publishTypes : const <Type>[],
    exportExpressions,
    exportExpressionAttrs
  }) : super(selector: selector, visibility: visibility,
      publishTypes: publishTypes, publishAs: publishAs, map: map,
      exportExpressions: exportExpressions,
      exportExpressionAttrs: exportExpressionAttrs);

  get defaultAttributeName {
    if (attrName == null && selector != null) {
      var match = _ATTR_NAME.firstMatch(selector);
      return match != null ? match[1] : null;
    }
    return attrName;
  }
}

/**
 * Implementing directives or components [attach] method will be called when
 * the next scope digest occurs after component instantiation. It is guaranteed
 * that when [attach] is invoked, that all attribute mappings have already
 * been processed.
 */
abstract class NgAttachAware {
  void attach();
}

/**
 * Implementing directives or components [detach] method will be called when
 * the associated scope is destroyed.
 */
abstract class NgDetachAware {
  void detach();
}

class DirectiveMap extends AnnotationMap<NgAnnotationBase> {
  DirectiveMap(Injector injector, MetadataExtractor metadataExtractor)
      : super(injector, metadataExtractor);
}
