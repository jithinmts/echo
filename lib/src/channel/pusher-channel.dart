import 'dart:async';

import 'package:laravel_echo/src/channel/channel.dart';
import 'package:laravel_echo/src/util/event-formatter.dart';

///
/// This class represents a pusher channel.
///
class PusherChannel extends Channel {
  /// The Pusher client instance.
  late dynamic pusher;

  /// The name of the channel.
  late dynamic name;

  /// Channel options.
  late dynamic options;

  /// The event formatter.
  late EventFormatter eventFormatter;

  /// The subcription of the channel.
  dynamic subcription;

  /// Create a new class instance.
  PusherChannel(dynamic pusher, String name, dynamic options) {
    this.name = name;
    this.pusher = pusher;
    this.options = options;
    this.eventFormatter = new EventFormatter(this.options['namespace']);

    this.subscribe();
  }

  /// Subscribe to a Pusher channel.
  void subscribe() {
    this.subcription = this.pusher.subscribe(this.name);
  }

  /// Unsubscribe from a channel.
  void unsubscribe() {
    this.pusher.unsubscribe(this.name);
  }

  /// Listen for an event on the channel instance.
  PusherChannel listen(String event, Function callback) {
    this.on(this.eventFormatter.format(event), callback);
    return this;
  }

  /// Stop listening for an event on the channel instance.
  PusherChannel stopListening(String event) {
    this.subcription.unbind(this.eventFormatter.format(event));
    return this;
  }

  /// Register a callback to be called anytime a subscription succeeds.
  PusherChannel subscribed(Function callback) {
    this.on('pusher:subscription_succeeded', () => callback());

    return this;
  }

  ///  Register a callback to be called anytime a subscription error occurs.
  PusherChannel error(Function callback) {
    this.on('pusher:subscription_error', (status) => callback(status));

    return this;
  }

  /// Bind a channel to an event.
  PusherChannel on(String event, Function callback) {
    if (this.subcription is Future) {
      this.subcription.then((channel) => channel.bind(event, callback));
    } else {
      this.subcription.bind(event, callback);
    }

    return this;
  }
}
