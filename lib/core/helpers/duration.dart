import 'dart:async';
import '../state.dart';

class DurationModel {
  final int duration;
  final bool running;
  const DurationModel({required this.duration, required this.running});
}

String durationString(int duration) {
  final minutes = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
  final seconds = (duration % 60).floor().toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

class DurationNotifier extends StateNotifier<DurationModel> {
  static const int _initialDuration = 0;
  static const _initialState =
      DurationModel(duration: _initialDuration, running: false);

  DurationNotifier() : super(_initialState);

  // final DurationTicker _ticker = DurationTicker();
  // StreamSubscription<int>? _tickerSubscription;
  Timer? _timer;
  void start() {
    if (state.running) {
      _restartTimer();
    } else {
      _startTimer();
    }
  }

  void _restartTimer() {
    // _tickerSubscription?.resume();
    // _timer?.res
    state = DurationModel(duration: state.duration, running: true);
  }

  void reset() {
    // _tickerSubscription?.cancel();
    state = _initialState;
  }

  void _startTimer() {
    // _tickerSubscription?.cancel();
    _timer?.cancel();
    state = const DurationModel(duration: _initialDuration, running: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // timer.tick;
      state = DurationModel(duration: state.duration + 1, running: true);
    });

    // _tickerSubscription = _ticker.tick(ticks: _initialDuration).listen((d) {
    //   state = DurationModel(duration: d, running: true);
    //   print('Updated to state ${state.duration} , ${state.running}');
    // });

    // _tickerSubscription?.onDone(() {
    //   print('onDone to state ${state.duration}');

    //   state = DurationModel(duration: state.duration, running: false);
    // });

    // state = const DurationModel(duration: _initialDuration, running: true);
    // print('Started to state ${state.duration}');
  }

  @override
  void dispose() {
    _timer?.cancel();
    // _tickerSubscription?.cancel();
    super.dispose();
  }
}

class DurationTicker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
      const Duration(seconds: 1),
      (x) => ticks + x + 1,
    ).take(ticks);
  }
}
