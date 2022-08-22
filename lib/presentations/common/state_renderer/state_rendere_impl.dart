
import 'package:e_commerce_clean/presentations/common/state_renderer/state_renderer.dart';
import 'package:flutter/material.dart';

import '../../../app/constants.dart';
import '../../resources/strings_manager.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();

  String getMessage();
}

/// loading State (popup , full screen)

class LoadingState extends FlowState {
  StateRendererType stateRendererType;

  String? message;

  LoadingState(
      {required this.stateRendererType, String message = AppStrings.loading});

  @override
  String getMessage() => message ?? AppStrings.loading;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

/// error State (popup , full screen)

class ErrorState extends FlowState {
  StateRendererType stateRendererType;

  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

/// content State

class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() => Constants.empty;

  @override
  StateRendererType getStateRendererType() => StateRendererType.contentState;
}

/// empty State

class EmptyState extends FlowState {
  String message;

  EmptyState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.fullScreenEmptyState;
}

extension FlowStateWxtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.popupLoadingState) {
            /// show popup loading
            showPopup(context, getStateRendererType(), getMessage());

            /// show content of the screen
            return contentScreenWidget;
          } else {
            /// full screen loading state
            return StateRenderer(
                message: getMessage(),
                stateRendererType: getStateRendererType(),
                retryActionFunction: retryActionFunction);
          }
        }

      case ErrorState:
        {

            dismissDialog( context) ;
            if (getStateRendererType() == StateRendererType.popupErrorState) {
              /// show popup error
              showPopup(context, getStateRendererType(), getMessage());

              /// show content of the screen
              return contentScreenWidget;
            } else {
              /// full screen loading state
              return StateRenderer(
                  message: getMessage(),
                  stateRendererType: getStateRendererType(),
                  retryActionFunction: retryActionFunction);
            }
          }


      case EmptyState:
        {
          return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: () {});
        }

      case ContentState:
        {
          dismissDialog( context) ;
          return contentScreenWidget;
        }
      default:
        {
          dismissDialog( context) ;
          return contentScreenWidget;
        }
    }
  }

  _isCurrenDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  dismissDialog(BuildContext context) {
    if (_isCurrenDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopup(BuildContext context, StateRendererType stateRendererType,
      String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
            stateRendererType: stateRendererType,
            message: message,
            retryActionFunction: () {})));
  }
}
