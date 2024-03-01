import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:format/format.dart';

class IncrementDecrementButton extends StatefulWidget {
  final int value;
  final int minValue;
  final int maxValue;
  final String labelFormat; // i.e. FREQUENCY: {} PER DAY
  final Function callBack;
  const IncrementDecrementButton(
      {super.key, required this.value, required this.minValue, required this.maxValue, required this.labelFormat, required this.callBack});

  @override
  State<IncrementDecrementButton> createState() =>
      _IncrementDecrementButtonState();
}

class _IncrementDecrementButtonState extends State<IncrementDecrementButton> {
  int _value = 0;


  int get value => _value;

  set value(int newValue) {
    if (newValue <= widget.maxValue && newValue > widget.minValue) {
      _value = newValue;
    }
  }

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
        // "FREQUENCY: $value PER DAY"
        format(widget.labelFormat, value)
        , style: const TextStyle(fontSize: 18)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    value += 1;
                  });
                  widget.callBack(value);
                },
                child: Text(
                  "+",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: mainTheme.colorScheme.inversePrimary),
                )),
            TextButton(
                onPressed: () {
                  setState(() {
                    value -= 1;
                  });
                  widget.callBack(value);
                },
                child: Text(
                  "-",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: mainTheme.colorScheme.inversePrimary),
                )),
          ],
        )
      ],
    );
  }
}
