// Copyright (c) 2013, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library spark.event_bus;

import 'dart:async';

import 'enum.dart';

class BusEventType extends Enum<String> {
  const BusEventType._(String value) : super(value);

  String get enumName => 'BusEventType';

  static const FILE_MODIFIED = const BusEventType._('FILE_MODIFIED');
  static const FILES_SAVED = const BusEventType._('FILES_SAVED');
}

/**
 * An event type for use with [EventBus].
 */
abstract class BusEvent {
  BusEventType get type;
}

class SimpleBusEvent extends BusEvent {
  BusEventType _type;

  SimpleBusEvent(this._type);
  BusEventType get type => _type;
}

/**
 * An event bus class. Clients can listen for classes of events, optionally
 * filtered by a string type. This can be used to decouple events sources and
 * event listeners.
 */
class EventBus {
  StreamController<BusEvent> _controller;

  EventBus() {
    _controller = new StreamController.broadcast();
  }

  /**
   * Listen for events on the event bus. Clients can pass in an optional [type],
   * which filters the events to only those specific ones.
   */
  Stream<BusEvent> onEvent([BusEventType type]) {
    return _controller.stream.where((e) => type == null || e.type == type);
  }

  /**
   * Add an event to the event bus.
   */
  void addEvent(BusEvent event) {
    _controller.add(event);
  }

  /**
   * Close (destroy) this [EventBus]. This is generally not used outside of a
   * testing context. All Stream listeners will be closed and the bus will not
   * fire any more events.
   */
  void close() {
    _controller.close();
  }
}
