import 'package:flutter/cupertino.dart';

class TransportScreen extends StatelessWidget {
  const TransportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Transport'),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.car_detailed,
                size: 64,
                color: CupertinoColors.systemGrey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'Transport Services',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coming Soon!',
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
