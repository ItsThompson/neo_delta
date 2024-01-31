import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';

class RecurringDeltaButton extends StatefulWidget {
  final int index;
  const RecurringDeltaButton({super.key, required this.index});

  @override
  State<RecurringDeltaButton> createState() => _RecurringDeltaButtonState();
}



class _RecurringDeltaButtonState extends State<RecurringDeltaButton> {
  double _margin = 5;
  bool _isComplete = false;

  bool isComplete(int index){
      Random random = Random();
      return random.nextBool();
  }

  @override
  void initState(){
      super.initState();
      _isComplete = isComplete(widget.index);
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        height: 150,
        width: double.infinity,
        child: GestureDetector(
        // Long Press: Mark as complete
        // Double Tap: Go to profile
          onDoubleTap: () {
            // Navigator.pushNamed(context, '/')
          },
          onLongPress: () {
            setState(() {
              _isComplete = !_isComplete;
            });
          },
          onTapDown: (_) {
            setState(() {
              _margin = 10;
            });
          },
          onTapUp: (_) {
            setState(() {
              _margin = 5;
            });
          },
          onTapCancel: () {
            setState(() {
              _margin = 5;
            });
          },
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.all(_margin),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: _isComplete
                    ? mainTheme.colorScheme.primary
                    : mainTheme.colorScheme.inversePrimary.withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Delta ${widget.index}"),
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.asset("assets/landmark.png"),
                  ),
                  const Text(
                    "3 LEFT THIS WEEK",
                    style: TextStyle(fontSize: 10),
                  )
                ],
              )),
        ));
  }
}
