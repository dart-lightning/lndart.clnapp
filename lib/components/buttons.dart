import 'package:flutter/material.dart';

class MainCircleButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final double height;
  final double width;
  final String label;
  final Function onPress;

  const MainCircleButton(
      {Key? key,
      required this.icon,
      required this.label,
      required this.onPress,
      this.iconSize = 32,
      this.height = 55,
      this.width = 130})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              maximumSize: Size(width, height),
              minimumSize: Size(width, height),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () => onPress(),
            icon: Icon(icon,
                size: iconSize, color: Theme.of(context).colorScheme.primary),
            label: Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            )),
      ],
    );
  }
}
