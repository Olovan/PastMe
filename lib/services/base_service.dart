
import 'package:flutter/foundation.dart';

enum ViewState { Busy, Idle }

class BaseService extends ChangeNotifier {
  int pendingActions = 0;
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;

  setState(ViewState state) {
    switch(state) {
      case ViewState.Busy:
        pendingActions++;
        break;
      case ViewState.Idle:
        pendingActions--;
        break;
      default:
      // do nothing
    }
    _state = pendingActions > 0 ? ViewState.Busy : ViewState.Idle;
    notifyListeners();
  }
}