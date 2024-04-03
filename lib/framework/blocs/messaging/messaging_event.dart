// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';


const INTERNET_STATUS_EVENTS_KEY = "last_internet_connection_status";
const LAST_MESSAGE_EVENTS_KEY = "last_message_event";

abstract class MessagingEvent extends Equatable {
  const MessagingEvent();

  @override
  List<Object> get props => [];
}

class MessagingStarted extends MessagingEvent {}

class MessageLoaded extends MessagingEvent {}

class MessageBroadcasted extends MessagingEvent {
  const MessageBroadcasted({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}

class InternetConnectionChanged extends MessagingEvent {
  const InternetConnectionChanged({
    required this.connected,
  });

  final bool connected;

  @override
  List<Object> get props => [connected];
}
