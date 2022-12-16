import 'dart:async';
import '../state.dart';

class TimerModel {
  final int timeLeft;
  final bool running;
  const TimerModel({required this.timeLeft, required this.running});
}

class TimerNotifier extends StateNotifier<TimerModel> {
  static const _initialState =
      TimerModel(timeLeft: _initialDuration, running: false);

  TimerNotifier() : super(_initialState);

  static const int _initialDuration = 60;

  final Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  // static String _durationString(int duration) {
  //   final minutes = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
  //   final seconds = (duration % 60).floor().toString().padLeft(2, '0');
  //   return '$minutes:$seconds';
  // }

  void start() {
    if (state.running) {
      _restartTimer();
    } else {
      _startTimer();
    }
  }

  void _restartTimer() {
    _tickerSubscription?.resume();
    state = TimerModel(timeLeft: state.timeLeft, running: true);
  }

  void reset() {
    _tickerSubscription?.cancel();
    state = _initialState;
  }

  void _startTimer() {
    _tickerSubscription?.cancel();

    _tickerSubscription =
        _ticker.tick(ticks: _initialDuration).listen((duration) {
      state = TimerModel(timeLeft: duration, running: true);
    });

    _tickerSubscription?.onDone(() {
      state = TimerModel(timeLeft: state.timeLeft, running: false);
    });

    state = const TimerModel(timeLeft: _initialDuration, running: true);
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }
}

class Ticker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
      const Duration(seconds: 1),
      (x) => ticks - x - 1,
    ).take(ticks);
  }
}
