
import 'package:flutter/foundation.dart';

class ClassEndProvider extends ChangeNotifier {
  bool _isCallEnd = false;
  bool get isCallEnd => _isCallEnd;

  setCallEnd() {
    _isCallEnd = true;
    notifyListeners();
  }

  setCallStart() {
    _isCallEnd = false;
    notifyListeners();
  }
}
