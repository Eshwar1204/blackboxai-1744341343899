import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

class ThreatScreen extends StatefulWidget {
  const ThreatScreen({super.key});

  @override
  State<ThreatScreen> createState() => _ThreatScreenState();
}

class _ThreatScreenState extends State<ThreatScreen> with SingleTickerProviderStateMixin {
  late int threatScore;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    threatScore = _generateThreatScore();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _generateThreatScore() {
    return Random().nextInt(101); // 0 to 100
  }

  String _getThreatLevel(int score) {
    if (score < 33) return 'Low Risk';
    if (score < 67) return 'Moderate Risk';
    return 'High Risk';
  }

  Color _getThreatColor(int score) {
    if (score < 33) return Colors.green;
    if (score < 67) return Colors.orange;
    return Colors.red;
  }

  IconData _getThreatIcon(int score) {
    if (score < 33) return FontAwesomeIcons.shield;
    if (score < 67) return FontAwesomeIcons.triangleExclamation;
    return FontAwesomeIcons.skull;
  }

  String _getThreatMessage(int score) {
    if (score < 33) {
      return 'Your system appears to be secure. Continue maintaining good security practices.';
    } else if (score < 67) {
      return 'Some security concerns detected. Review system activities and update security measures.';
    } else {
      return 'Critical security risks detected! Immediate action recommended.';
    }
  }

  Future<void> _refreshThreatScore() async {
    setState(() {
      isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      threatScore = _generateThreatScore();
      isLoading = false;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Threat Intelligence'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshThreatScore,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Current Threat Level',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: CircularProgressIndicator(
                                value: _animation.value,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getThreatColor(threatScore),
                                ),
                                strokeWidth: 15,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FaIcon(
                                  _getThreatIcon(threatScore),
                                  size: 50,
                                  color: _getThreatColor(threatScore),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '$threatScore',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: _getThreatColor(threatScore),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _getThreatLevel(threatScore),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _getThreatColor(threatScore),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Risk Assessment',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getThreatMessage(threatScore),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshThreatScore,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
