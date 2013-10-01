library angular.registry;

import 'dart:mirrors';
import 'package:di/di.dart';

abstract class AnnotationMap<K> {
  final Map<K, Type> _map = {};

  AnnotationMap(Injector injector, MetadataExtractor extractMetadata) {
    injector.types.forEach((type) {
      var meta = extractMetadata(type)
        .where((annotation) => annotation is K)
        .forEach((annotation) {
          if (_map.containsKey(annotation)) {
            var annotationType = K;
            throw "Duplicate annotation found: $annotationType: $annotation. " +
                  "Exisitng: ${_map[annotation]}; New: $type.";
          }
          _map[annotation] = type;
        });
    });
  }

  Type operator[](K annotation) {
    var value = _map[annotation];
    if (value == null) {
      throw 'No $annotation found!';
    }
    return value;
  }

  forEach(fn(K, Type)) => _map.forEach(fn);
}

class MetadataExtractor {

  Iterable call(Type type) {
    var metadata = reflectClass(type).metadata;
    if (metadata == null) return [];
    return metadata.map((InstanceMirror im) => im.reflectee);
  }
}
