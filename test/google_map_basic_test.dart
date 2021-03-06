// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
@TestOn('browser')
library polymer_elements.test.google_map_basic_test;

import 'dart:async';
import 'dart:html';
import 'package:polymer_elements/google_map.dart';
import 'package:test/test.dart';
import 'package:web_components/web_components.dart';
import 'common.dart';

main() async {
  await initWebComponents();

  group('google-map', () {
    test('autoTilt', () {
      var done = new Completer();
      GoogleMap map = fixture('map');
      onReady(map, ([e]) {
        // When noAutoTilt is set, tilt is left at default (45).
        expect(map.map.callMethod('getTilt'), 45);
        done.complete();
      });
      return done.future;
    });

    test('noAutoTilt', () {
      var done = new Completer();
      GoogleMap map = fixture('map3');
      onReady(map, ([e]) {
        // When noAutoTilt is set, tilt is set to 0.
        expect(map.map.callMethod('getTilt'), 0);
        done.complete();
      });
      return done.future;
    });

    test('defaults', () {
      var done = new Completer();
      GoogleMap map = fixture('map');
      onReady(map, ([e]) {
        expect(map.markers.length, 0);
        expect(map.fitToMarkers, isFalse);
        expect(map.disableDefaultUi, isFalse);
        expect(map.zoom, 10);
        expect(map.noAutoTilt, false);
        expect(map.maxZoom, isNull);
        expect(map.minZoom, isNull);
        expect(map.disableZoom, isFalse);
        expect(map.latitude, 37.77493);
        expect(map.longitude, -122.41942);
        expect(map.mapType, 'roadmap');
        done.complete();
      });
      return done.future;
    });

    test('change properties', () {
      var done = new Completer();
      GoogleMap map = fixture('map3');
      onReady(map, ([_]) {
        expect(map.fitToMarkers, isTrue);
        expect(map.markers.length, 0);
        expect(map.zoom, map.map.callMethod('getZoom'));
        expect(map.maxZoom, map.map['maxZoom']);
        expect(map.minZoom, map.map['minZoom']);
        expect(map.disableZoom, isTrue);
        done.complete();
      });
      return done.future;
    });

    test('declarative map creation', () {
      GoogleMap map = new GoogleMap();
      document.querySelector('#newmap').append(map);
    });
  });
}

onReady(GoogleMap map, Function fn) {
  if (map.map != null) {
    fn();
  } else {
    map.on['google-map-ready'].take(1).listen(fn);
  }
}
