import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';

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
  int _cheese = 0;
  int _level = 1;
  int _numRats = 0;
  int _machineCost = 5;
  int _friendCost = 10;

  // Timer stuff for hiring rat friends
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_){
      if (_numRats > 0){
        setState(() {
          _cheese += _numRats;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Always clean up timers
    super.dispose();
  }
  // END TIMER

  // Add Cheese
  void _incrementCheese() {
    _cheese = (_cheese+1 * _level);
    setState(() {});
  }

  // Upgrade Cheese Maker Machine
  void _upgradeMachine(){
    if (_cheese > _machineCost){
      _cheese -= _machineCost;
      _machineCost+=(5*_level);
      _level++;
    }
    setState(() {});
  }

  // Need method to hire rat friend
  void _hireRat(){
    if (_cheese > _friendCost){
      _cheese -= _friendCost;
      _friendCost+=(5*_level);
      _numRats++;
    }
    setState(() {});
  }

  // RESTART GAME
  void _restart(){
    _cheese = 0;
    _level = 1;
    _numRats = 0;
    _machineCost = 5;
    _friendCost = 10;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(centerTitle: true, title: const Text('🧀 Cheddah Game')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //Text('$_counter', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),

            Text('🧀: $_cheese Cheese', style: const TextStyle(fontSize: 48)),
            Text('Lvl $_level Cheese Machine: +$_level🧀', style:const TextStyle(fontSize: 24)),
            Text('$_numRats Rat Friends: 1 Cheese/s', style:const TextStyle(fontSize: 24)),


            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _upgradeMachine,
              child: Text('Upgrade Cheese Machine ($_machineCost Cheese)'),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _hireRat,
              child: Text('Hire Rat Friend ($_friendCost Cheese)'),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCheese,
              child: const Text('MAKE CHEESE'),
            ),

            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: _restart,
              child: const Text('Restart Game'),
            ),
          ],
        ),
      ),
    );
  }
}
