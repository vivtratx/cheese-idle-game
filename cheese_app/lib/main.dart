import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CounterPage());
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {

  late final ConfettiController _confetti =
      ConfettiController(duration: const Duration(seconds: 3));

  // Initialize everything we'll need
  int _cheese = 0;
  int _level = 1;
  int _numRats = 0;
  int _machineCost = 5;
  int _friendCost = 10;

  // Timer stuffs
  Timer? _incomeTimer;

  // Party mode: solid color cycling
  bool _party = false;
  Timer? _partyTimer;
  int _colorIndex = 0;
  Color _backgroundColor = Colors.yellow[100]!;

  static final List<Color> _rainbow = <Color>[
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    _incomeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_numRats > 0) {
        setState(() => _cheese += _numRats);
      }
    });
  }

  @override
  // Always clean up your timers!
  void dispose() {
    _incomeTimer?.cancel();
    _partyTimer?.cancel();
    _confetti.dispose();
    super.dispose();
  }

  void _incrementCheese() {
    setState(() {
      _cheese += _level; // precedence fix
    });
  }

  void _upgradeMachine() {
    if (_cheese >= _machineCost) {
      setState(() {
        _cheese -= _machineCost;
        _machineCost += (5 * _level);
        _level++;
      });
    }
  }

  void _hireRat() {
    if (_cheese >= _friendCost) {
      setState(() {
        _cheese -= _friendCost;
        _friendCost += (5 * _level);
        _numRats++;
      });
    }
  }

  void _toggleParty() {
    setState(() {
      _party = !_party;
      if (_party) {
        // start color cycling + confetti
        _confetti.play();
        _partyTimer?.cancel();
        _partyTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
          setState(() {
            _backgroundColor = _rainbow[_colorIndex % _rainbow.length];
            _colorIndex++;
          });
        });
      } else {
        // stop party + restore yellow
        _confetti.stop();
        _partyTimer?.cancel();
        _backgroundColor = Colors.yellow[100]!;
      }
    });
  }

  void _restart() {
    setState(() {
      _cheese = 0;
      _level = 1;
      _numRats = 0;
      _machineCost = 5;
      _friendCost = 10;

      _party = false;
      _partyTimer?.cancel();
      _confetti.stop();
      _backgroundColor = Colors.yellow[100]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Core UI
        Scaffold(
          backgroundColor: _backgroundColor,
          appBar: AppBar(
            centerTitle: true,
            forceMaterialTransparency: true,
            title: const Text("🧀 Viv's Very Cheesy Cheddah Game"),
            leading: IconButton(
              tooltip: _party ? 'STOP DA PARTY' : 'PAAARTAYYYYY!',
              icon: Text(_party ? 'X' : '🎉', style: const TextStyle(fontSize: 18)),
              onPressed: _toggleParty,
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🧀: $_cheese Cheese', style: const TextStyle(fontSize: 48)),
                Text('Lvl $_level Cheese Machine: +$_level🧀',
                    style: const TextStyle(fontSize: 24)),
                Text('$_numRats Rat Friends: $_numRats Cheese/s',
                    style: const TextStyle(fontSize: 24)),

                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 172, 129, 2),
                    backgroundColor: Colors.amberAccent,
                  ),
                  onPressed: _upgradeMachine,
                  child: Text('Upgrade Cheese Machine ($_machineCost Cheese)',
                      style: const TextStyle(fontSize: 15)),
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 172, 129, 2),
                    backgroundColor: Colors.amberAccent,
                  ),
                  onPressed: _hireRat,
                  child: Text('Hire Rat Friend ($_friendCost Cheese)',
                      style: const TextStyle(fontSize: 15)),
                ),

                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 172, 129, 2),
                    backgroundColor: Colors.amberAccent,
                  ),
                  onPressed: _incrementCheese,
                  child: const Text('MAKE CHEESE', style: TextStyle(fontSize: 40)),
                ),

                const SizedBox(height: 100),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 172, 129, 2),
                    backgroundColor: Colors.amberAccent,
                  ),
                  onPressed: _restart,
                  child: const Text('Restart Game'),
                ),
              ],
            ),
          ),
        ),

        // Confetti for da party (only in party mode)
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confetti,
            shouldLoop: true,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: _party ? 0.08 : 0.0, // off when not partying
            numberOfParticles: 18,
            minBlastForce: 149,
            maxBlastForce: 150,
            gravity: 0.7,
            colors: const [
              Colors.red,
              Colors.orange,
              Colors.yellow,
              Colors.green,
              Colors.blue,
              Colors.indigo,
              Colors.purple,
            ],
          ),
        ),
      ],
    );
  }
}
