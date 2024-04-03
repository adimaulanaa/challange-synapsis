// ignore_for_file: avoid_print

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:synapsis/config/global_vars.dart';
import 'package:synapsis/config/string_resource.dart';
import 'package:synapsis/env.dart';
import 'package:synapsis/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:synapsis/features/auth/presentation/bloc/auth_event.dart';
import 'package:synapsis/framework/core/exceptions/failures.dart';
import 'package:synapsis/framework/managers/http_manager.dart';

late HttpManager httpManager;

catchAllException(BuildContext context, String message,
    [bool showError = false]) {
  if (message == StringResources.INVALID_CREDENTIAL_FAILURE_MESSAGE ||
      message == StringResources.UNAUTHORISED_FAILURE_MESSAGE) {
    forceLogout(context, message);
  } else {
    if (showError) {
      FlushbarHelper.createError(
        message: message,
        title: "Error",
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }
}

forceLogout(BuildContext context, [String message = '']) async {
  printWarning('logout');
  await clearLoginInfo();

  Navigator.pushNamedAndRemoveUntil(
    context,
    '/',
    ModalRoute.withName('/'),
  );

  BlocProvider.of<AuthBloc>(context).add(LoggedOut());

  if (message.isNotEmpty) {
    FlushbarHelper.createError(
      message: message,
      title: "Error",
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}

manualLogout(BuildContext context, [String message = '']) async {
  printWarning('logout');
  await clearLoginInfo();

  BlocProvider.of<AuthBloc>(context).add(LoggedOut());

  if (message.isNotEmpty) {
    FlushbarHelper.createError(
      message: message,
      title: "Error",
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}

clearLoginInfo() async {
  var url = Uri.parse(Env().apiBaseUrl!);
  print(url.toString());
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlText.replaceAll(exp, ' ');
}

RegExp kanban = RegExp(r'K\w+-L\w+');

String stringDate(DateTime date) {
  var exp = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

  return exp;
}

extension Context on BuildContext {
  void showCustomDialog(String text) {
    showDialog(
      context: this,
      builder: (BuildContext context) {
        return AlertDialog(title: Text(text));
      },
    );
  }

  void push(Widget screen, {bool withNavBar = false}) {
    Navigator.of(this, rootNavigator: !withNavBar).push(
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  void pushAndRemoveUntil(Widget screen, {bool withNavBar = false}) {
    Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(builder: (BuildContext context) => screen),
        (Route<dynamic> route) => false);
  }

  // push tidak ada tombol back
  void pushReplacement(Widget screen, {bool withNavBar = false}) {
    Navigator.of(this, rootNavigator: !withNavBar).pushReplacement(
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  void pop() {
    Navigator.of(this).pop();
  }

  void clearAllAndNavigateTO(Widget screen, {bool withNavBar = false}) {
    Navigator.of(this, rootNavigator: !withNavBar).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
      (_) => false,
    );
  }
}

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case BadRequestFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_BAD_REQUEST_FAILURE) ??
              StringResources.BAD_REQUEST_FAILURE_MESSAGE;
    case UnauthorisedFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_UNAUTHORISED_FAILURE) ??
              StringResources.UNAUTHORISED_FAILURE_MESSAGE;
    case NotFoundFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_NOT_FOUND_FAILURE) ??
              StringResources.NOT_FOUND_MESSAGE;
    case FetchDataFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_FETCH_DATA_FAILURE) ??
              StringResources.FETCH_DATA_FAILURE_MESSAGE;
    case InvalidCredentialFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration().getValue(
                  GlobalVars.ERR_MESSAGE_INVALID_CREDENTIAL_FAILURE) ??
              StringResources.INVALID_CREDENTIAL_FAILURE_MESSAGE;
    case ServerFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_SERVER_FAILURE) ??
              StringResources.SERVER_FAILURE_MESSAGE;
    case AuthenticationFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_AUTH_FAILURE) ??
              StringResources.AUTHENTICATION_FAILURE_MESSAGE;
    case NetworkFailure:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_NETWORK_FAILURE) ??
              StringResources.NETWORK_FAILURE_MESSAGE;
    default:
      return failure.message.isNotEmpty
          ? failure.message
          : GlobalConfiguration()
                  .getValue(GlobalVars.ERR_MESSAGE_APP_FAILURE) ??
              'Unexpected error';
  }
}

void printWarning(dynamic text) {
  if (Env().isInDebugMode) {
    print('\x1B[33m$text\x1B[0m');
  }
}

void printError(dynamic text) {
  if (Env().isInDebugMode) {
    print('\x1B[31m$text\x1B[0m');
  }
}
