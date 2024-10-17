import 'package:flutter/material.dart';

class Layouts extends StatelessWidget {
  const Layouts({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final largeScreen = screenWidth > 600;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxHeight = constraints.maxHeight;
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.pink,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: largeScreen ? Colors.orange : Colors.red,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.green,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(color: Colors.blue),
                          ),
                          Expanded(
                            child: Container(color: Colors.yellow),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}