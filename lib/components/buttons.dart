import 'package:flutter/widgets.dart';

class MainCircleButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final double height;
  final double width;
  final String label;

  const MainCircleButton(
      {Key? key,
      required this.icon,
      required this.label,
      this.iconSize = 32,
      this.height = 55,
      this.width = 55})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: iconSize,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
