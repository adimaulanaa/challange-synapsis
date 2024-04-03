import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synapsis/framework/blocs/messaging/messaging_event.dart';
import 'package:synapsis/framework/blocs/messaging/messaging_state.dart';
import 'package:synapsis/framework/network/network_info.dart';
import 'package:synapsis/service_locator.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  MessagingBloc() : super(MessagingUninitialized()) {
    on<MessagingStarted>(_onMessagingStarted);
    on<MessageLoaded>(_onMessageLoaded);
    on<InternetConnectionChanged>(_onInternetConnectionChanged);
    on<MessageBroadcasted>(_onMessageBroadcasted);
    _prefs = serviceLocator.get<SharedPreferences>();
  }

  late SharedPreferences _prefs;

  Future<void> _onMessagingStarted(
      MessagingEvent event, Emitter<MessagingState> emit) async {}
  Future<void> _onMessageLoaded(
      MessageLoaded event, Emitter<MessagingState> emit) async {
    bool connectionStatus = await serviceLocator<NetworkInfo>().isConnected;
    String lastMessage = '';
    if (_prefs.containsKey(LAST_MESSAGE_EVENTS_KEY)) {
      lastMessage = _prefs.getString(LAST_MESSAGE_EVENTS_KEY) ?? '';
    }
    emit(
      MessagingInitialized(
        isInternetConnected: connectionStatus,
        lastMessage: lastMessage,
      ),
    );
  }

  Future<void> _onInternetConnectionChanged(
      InternetConnectionChanged event, Emitter<MessagingState> emit) async {
    _prefs.setBool(INTERNET_STATUS_EVENTS_KEY, event.connected);
    emit(InternetConnectionState(event.connected));
  }

  void _onMessageBroadcasted(
      MessageBroadcasted event, Emitter<MessagingState> emit) {
    emit(InMessagingState(message: event.message));
  }

  bool getConnection() {
    bool isConnected = true;

    if (_prefs.containsKey(INTERNET_STATUS_EVENTS_KEY)) {
      isConnected = _prefs.getBool(INTERNET_STATUS_EVENTS_KEY) ?? false;
    }

    return isConnected;
  }
}
