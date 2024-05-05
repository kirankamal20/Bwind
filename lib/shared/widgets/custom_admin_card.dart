import 'package:flutter/material.dart';

class CustomWidgetCard extends StatelessWidget {
  final String cardName;
  final Function() onTap;
  const CustomWidgetCard(
      {super.key, required this.cardName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Card(
        child: ListTile(
          onTap: onTap,
          title: Text(
            cardName,
            style: const TextStyle(color: Colors.black),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
