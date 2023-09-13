import 'dart:async';
import 'package:flutter/material.dart';
import 'package:user_login/constants/strings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../widgets/genie_dialog.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  /// Variable Instances
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int totalSeconds = 0;
  bool isRunning = false;
  bool isStopwatchRunning = false;
  Timer? timer;

  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _formattedTime = '00:00:00';

  /// Start the stopwatch
  void _startStopwatch() {
    if (!_stopwatch.isRunning) {
      setState(() {
        isStopwatchRunning = true;
      });
      _stopwatch.start();
      _timer = Timer.periodic(Duration(seconds: 1), _updateStopwatch);
    }
  }

  /// Stop the stopwatch
  void _stopStopwatch() {
    if (_stopwatch.isRunning) {
      setState(() {
        isStopwatchRunning = false;
      });
      _stopwatch.stop();
      if (_timer != null) {
        _timer!.cancel();
      }
    }
  }

  /// Reset the stopwatch
  void _resetStopwatch() {
    _stopStopwatch();
    setState(() {
      isStopwatchRunning = false;
    });
    _stopwatch.reset();
    setState(() {
      _formattedTime = '00:00:00';
    });
  }

  /// Update the stopwatch, and format counter to show on the screen
  void _updateStopwatch(Timer timer) {
    setState(() {
      final hours = _stopwatch.elapsed.inHours.toString().padLeft(2, '0');
      final minutes =
          (_stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, '0');
      final seconds =
          (_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
      _formattedTime = '$hours:$minutes:$seconds';
    });
  }

  /// Start the timer
  void _startTimer() {
    if (totalSeconds > 0) {
      setState(() {
        isRunning = true;
      });
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (totalSeconds > 0) {
          setState(() {
            totalSeconds--;
            hours = totalSeconds ~/ 3600;
            minutes = (totalSeconds % 3600) ~/ 60;
            seconds = totalSeconds % 60;
          });
        } else {
          t.cancel();
          _showTimerPopup();
        }
      });
    }
  }

  /// Reset the timer
  void _resetTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    setState(() {
      isRunning = false;
      hours = 0;
      minutes = 0;
      seconds = 0;
      totalSeconds = 0;
    });
  }

  /// Show popup when timer reached to 00:00:00
  void _showTimerPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GenieDialog(
          title: timerTitle,
          description: timerDescription,
        );
      },
    );
    setState(() {
      isRunning = false;
    });
  }

  /// Need to dispose the timer & stopwatch
  @override
  void dispose() {
    _stopwatch.stop();
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Tab View
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(timerStopwatchTitle),
          bottom: const TabBar(
            tabs: [
              Tab(text: timerTitle, icon: Icon(Icons.watch_later_outlined)),
              Tab(text: stopwatchTitle, icon: Icon(Icons.timer)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            /// Timer UI
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.tealAccent.shade400, Colors.teal.shade100],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isRunning ? const SpinKitDoubleBounce(
                    color: Colors.blue,
                    size: 100.0,
                  ) : Icon(
                    Icons.circle,
                    color: Colors.lightBlue.shade500,
                    size: 100,
                    shadows: const [
                      Shadow(
                        blurRadius: 1.0,
                        color: Colors.blue,
                        offset: Offset(3.0, 3.0),
                      ),
                    ],
                  ),
                  Row(children: [
                    _buildSelectorRow(hourText, hours, (value) {
                      setState(() {
                        hours = value;
                        totalSeconds = hours * 3600 + minutes * 60 + seconds;
                      });
                    }),
                    _buildSelectorRow(minuteText, minutes, (value) {
                      setState(() {
                        minutes = value;
                        totalSeconds = hours * 3600 + minutes * 60 + seconds;
                      });
                    }),
                    _buildSelectorRow(secondsText, seconds, (value) {
                      setState(() {
                        seconds = value;
                        totalSeconds = hours * 3600 + minutes * 60 + seconds;
                      });
                    }),
                  ]),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isRunning ? _resetTimer : _startTimer,
                    child: isRunning
                        ? const Text(resetTimerText)
                        : const Text(startTimerText),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$remainingTimerText ${hours.toString().padLeft(2, zeroText)}:${minutes.toString().padLeft(2, zeroText)}:${seconds.toString().padLeft(2, zeroText)}',
                      style: const TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            blurRadius: 1.0,
                            color: Colors.red,
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
            /// Stopwatch UI
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.tealAccent.shade400, Colors.teal.shade100],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isStopwatchRunning ? const SpinKitDoubleBounce(
                    color: Colors.blue,
                    size: 100.0,
                  ) : Icon(
                    Icons.circle,
                    color: Colors.lightBlue.shade500,
                    size: 100,
                    shadows: const [
                      Shadow(
                        blurRadius: 1.0,
                        color: Colors.blue,
                        offset: Offset(3.0, 3.0),
                      ),
                    ],
                  ),
                  Text(
                    _formattedTime,
                      style: const TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            blurRadius: 1.0,
                            color: Colors.red,
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _startStopwatch,
                        child: Text('Start'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _stopStopwatch,
                        child: Text('Stop'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _resetStopwatch,
                        child: Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorRow(
      String label, int value, void Function(int) onChanged) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(width: 20),
          Text('$label:', style: const TextStyle(
            fontSize: 16.0,
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            shadows: [
              Shadow(
                blurRadius: 1.0,
                color: Colors.blue,
                offset: Offset(3.0, 3.0),
              ),
            ],
          ),),
          Column(
            children: [
              IconButton(
                icon: const Icon(
                    Icons.remove,
                  size: 24,
                  color: Colors.blue,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Colors.blue,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
                onPressed: isRunning
                    ? null
                    : () {
                        if (value > 0) {
                          onChanged(value - 1);
                        }
                      },
              ),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Colors.blue,
                      offset: Offset(3.0, 3.0),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                    Icons.add,
                  size: 24,
                  color: Colors.blue,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Colors.blue,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],),
                onPressed: isRunning
                    ? null
                    : () {
                        if (value < (label == 'Hours' ? 12 : 59)) {
                          onChanged(value + 1);
                        }
                      },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
