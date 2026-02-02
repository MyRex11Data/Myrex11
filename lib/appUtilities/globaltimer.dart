import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GlobalTimerManager with WidgetsBindingObserver {
  late Isolate _isolate;
  final ReceivePort _receivePort = ReceivePort();
  bool _isTimerRunning = false;
  Duration? _remainingDuration;
  final ValueNotifier<Duration?> remainingDurationNotifier =
      ValueNotifier(null); // No initial duration
  DateTime? _pausedAt;
  DateTime? _lastBackgroundEntryTime;

  GlobalTimerManager() {
    WidgetsBinding.instance.addObserver(this);
    _receivePort.listen((message) {
      if (message is Duration) {
        _remainingDuration = message;
        remainingDurationNotifier.value =
            _remainingDuration; // Update the ValueNotifier
      } else if (message == 'TIMER_FINISHED') {
        _isTimerRunning = false;
        _isolate.kill(priority: Isolate.immediate);
      }
    });
  }

  Duration get remainingDuration => _remainingDuration ?? Duration.zero;

  void startTimer(Duration duration, {String? type}) async {
    if (_isTimerRunning) return;
    _remainingDuration = duration;
    remainingDurationNotifier.value =
        _remainingDuration; // Set initial remaining time

    if (type == "MyMatch") {
      _remainingDuration = Duration(seconds: 0);
      remainingDurationNotifier.value =
          _remainingDuration; // Update ValueNotifier if MyMatch type
    }

    // Start background fetch to periodically run your timer logic.
    // BackgroundFetch.start().then((int status) {
    //   print("[BackgroundFetch] Start success: $status");
    // }).catchError((e) {
    //   print("[BackgroundFetch] Start failed: $e");
    // });

    _isTimerRunning = true;
    _isolate =
        await Isolate.spawn(_timerIsolate, [_receivePort.sendPort, duration]);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState.paused) {
    //   print("Entered Background");
    //   _pausedAt = DateTime.now();
    //   _lastBackgroundEntryTime = _pausedAt;
    // } else if (state == AppLifecycleState.resumed &&
    //     _pausedAt != null &&
    //     _isTimerRunning) {
    //   final elapsed = DateTime.now().difference(_pausedAt!);
    //   print("Time elapsed during background: $elapsed");
    //   _remainingDuration = remainingDuration - elapsed;
    //   remainingDurationNotifier.value =
    //       _remainingDuration; // Update after app resumes
    //   print("jjjjjjjjjjj" + remainingDurationNotifier.value.toString());
    //   _pausedAt = null;
    // }
  }

  static void _timerIsolate(List<dynamic> args) async {
    SendPort sendPort = args[0];
    Duration duration = args[1];

    Timer.periodic(Duration(seconds: 1), (timer) {
      duration -= Duration(seconds: 1);
      sendPort.send(duration);
      if (duration.inSeconds <= 0) {
        timer.cancel();
        sendPort.send('TIMER_FINISHED');
      }
    });
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isolate.kill(priority: Isolate.immediate);
    _receivePort.close();
    remainingDurationNotifier.dispose();
  }

  String formatRemainingTime(Duration duration) {
    if (duration.inMinutes == 0 && duration.inSeconds == 0) {
      return '00:00';
    } else if (duration.inDays >= 1) {
      return duration.inDays > 1
          ? "${duration.inDays} Days"
          : "${duration.inDays} Day";
    } else if (duration.inHours >= 1) {
      return "${duration.inHours}h : ${duration.inMinutes.remainder(60)}m";
    } else {
      final minutes =
          duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return "${minutes}m : ${seconds}s";
    }
  }
}


// class GlobalTimerManager with WidgetsBindingObserver {
//   late Isolate _isolate;
//   final ReceivePort _receivePort = ReceivePort();
//   bool _isTimerRunning = false;
//   Duration? _remainingDuration ;
//   //= Duration(seconds: 10); // Set initial duration
//   final ValueNotifier<Duration> remainingDurationNotifier = ValueNotifier(Duration(seconds: 10)); // Notifier for duration updates
//   DateTime? _pausedAt; // Time when the app is paused
//   DateTime? _lastBackgroundEntryTime; // Time when the app was last put in the background
//
//   GlobalTimerManager() {
//     WidgetsBinding.instance.addObserver(this);
//     _receivePort.listen((message) {
//       if (message is Duration) {
//         _remainingDuration = message;
//         remainingDurationNotifier.value = _remainingDuration!; // Update the ValueNotifier
//       } else if (message == 'TIMER_FINISHED') {
//         _isTimerRunning = false;
//         _isolate.kill(priority: Isolate.immediate);
//       }
//     });
//   }
//
//
//   Duration get remainingDuration => _remainingDuration!;
//
//   void startTimer(Duration duration,{String? type}) async {
//
//     if (_isTimerRunning) return;
//     if(type=="MyMatch"){
//       _remainingDuration = Duration(seconds: 0);
//     }
//     int status = await BackgroundFetch.configure(BackgroundFetchConfig(
//       minimumFetchInterval: 15,
//       stopOnTerminate: false,
//       enableHeadless: true,
//       requiresBatteryNotLow: false,
//       requiresCharging: false,
//       requiresStorageNotLow: false,
//       requiresDeviceIdle: false,
//       // requiredNetworkType: NetworkType.NONE
//     ), (String taskId) async {  // <-- Event handler
//       _timerIsolate([_receivePort.sendPort, duration]);
//     }, (String taskId) async {  // <-- Task timeout handler.
//       // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
//       print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
//       // BackgroundFetch.finish(taskId);
//     });
//     _isTimerRunning = true;
//     _remainingDuration = duration;
//   //  _registerBackgroundTask(duration);
//     _isolate = await Isolate.spawn(_timerIsolate, [_receivePort.sendPort, duration]);
//   }
//
//   void _registerBackgroundTask(Duration duration) {
//     // This WorkManager task does not continuously keep the timer running; it's more for task scheduling.
//     Workmanager().registerOneOffTask(
//       'uniqueName',
//       'backgroundTimerTask',
//       inputData: {'duration': duration.inSeconds},
//       initialDelay: Duration(seconds: 0),
//       existingWorkPolicy: ExistingWorkPolicy.replace,
//     );
//   }
//
//   static Future<void> runBackgroundTask(Map<String, dynamic>? inputData) async {
//     // WorkManager task, does not keep running indefinitely, handles scheduled tasks.
//     if (inputData == null) return;
//
//     int durationInSeconds = inputData['duration'] ?? 0;
//     Duration duration = Duration(seconds: durationInSeconds);
//
//     Timer.periodic(Duration(seconds: 1), (timer) {
//       duration -= Duration(seconds: 1);
//       if (duration.inSeconds <= 0) {
//         timer.cancel();
//         Workmanager().cancelAll(); // Cancel the task when the timer finishes
//       }
//     });
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       _pausedAt = DateTime.now();
//       _lastBackgroundEntryTime = _pausedAt;
//     } else if (state == AppLifecycleState.resumed && _pausedAt != null && _isTimerRunning) {
//       // Calculate elapsed time while the app was in the background.
//       final elapsed = DateTime.now().difference(_pausedAt!);
//       _remainingDuration = remainingDuration-elapsed; // Adjust the remaining duration by subtracting the elapsed time
//       _receivePort.sendPort.send(_remainingDuration);
//       _pausedAt = null;
//     }
//   }
//
//   static void _timerIsolate(List<dynamic> args) async{
//     SendPort sendPort = args[0];
//     Duration duration = args[1];
//
//     Timer.periodic(Duration(seconds: 1), (timer) {
//       duration -= Duration(seconds: 1);
//       sendPort.send(duration);
//       if (duration.inSeconds <= 0) {
//         timer.cancel();
//         sendPort.send('TIMER_FINISHED');
//       }
//     });
//   }
//
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _isolate.kill(priority: Isolate.immediate);
//     _receivePort.close();
//     remainingDurationNotifier.dispose(); // Dispose of the ValueNotifier
//   }
//
//   String formatRemainingTime(Duration duration) {
//     if (duration.inMinutes == 0 && duration.inSeconds == 0) {
//       return '00:00';
//     } else if (duration.inDays >= 1) {
//       return duration.inDays > 1 ? "${duration.inDays} Days" : "${duration.inDays} Day";
//     } else if (duration.inHours >= 1) {
//       return "${duration.inHours}h : ${duration.inMinutes.remainder(60)}m";
//     } else {
//       final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
//       final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
//       return "${minutes}m : ${seconds}s";
//     }
//   }
// }










