import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AccountWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function() function;
  const AccountWidget(
      {super.key,
      required this.icon,
      required this.text,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 20,
            left: 20,
          ),
          height: 50,
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white70,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                offset: Offset(0, 5),
                blurRadius: 0.5,
              ),
              BoxShadow(
                color: Colors.grey.shade100,
                offset: Offset(5, 0),
                blurRadius: 0.5,
              ),
            ],
          ),
          child: GestureDetector(
            onTap: function,
            child: Container(
              child: Row(
                children: [
                  Icon(
                    icon,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    text,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
