import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:async';

class BehavioralEvent {
  final String description;
  final DateTime timestamp;

  BehavioralEvent(this.description, this.timestamp);
}

class BehavioralScreen extends StatefulWidget {
  const BehavioralScreen({super.key});

  @override
  State<BehavioralScreen> createState() => _BehavioralScreenState();
}

class _BehavioralScreenState extends State<BehavioralScreen> {
  bool isMonitoring = false;
  final List<BehavioralEvent> events = [];
  final Random random = Random();
  Timer? _timer;

  final List<String> possibleEvents = [
    'User opened settings',
    'Keyboard activity detected',
    'Mouse movement detected',
    'System idle',
    'New app launched',
    'File access detected',
    'Network connection established',
    'Camera access detected',
    'Microphone access detected',
    'System resources checked'
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleMonitoring() {
    setState(() {
      isMonitoring = !isMonitoring;
      if (isMonitoring) {
        _startMonitoring();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!isMonitoring) {
        timer.cancel();
        return;
      }
      _addRandomEvent();
    });
  }

  void _addRandomEvent() {
    setState(() {
      events.insert(
        0,
        BehavioralEvent(
          possibleEvents[random.nextInt(possibleEvents.length)],
          DateTime.now(),
        ),
      );
    });
  }

  void _checkForAnomalies() {
    bool hasAnomaly = random.nextBool();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          hasAnomaly ? 'Warning: Anomaly Detected!' : 'System Check Complete',
          style: TextStyle(
            color: hasAnomaly ? Colors.red : Colors.green,
          ),
        ),
        content: Text(
          hasAnomaly
              ? 'Suspicious behavior patterns detected. Please review recent activities.'
              : 'No suspicious behavior detected. System is secure.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Behavioral Monitoring'),
        actions: [
          Switch(
            value: isMonitoring,
            onChanged: (value) => _toggleMonitoring(),
            activeColor: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                Icon(
                  isMonitoring ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  isMonitoring ? 'Monitoring Active' : 'Monitoring Inactive',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Text(
                      'No events recorded yet',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.security),
                          title: Text(event.description),
                          subtitle: Text(
                            DateFormat('MMM dd, yyyy HH:mm:ss')
                                .format(event.timestamp),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _checkForAnomalies,
        icon: const Icon(Icons.search),
        label: const Text('Check for Anomalies'),
      ),
    );
  }
}
