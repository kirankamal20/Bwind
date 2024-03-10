import 'package:flutter/material.dart';

class PaymentOptionSettingPage extends StatefulWidget {
  const PaymentOptionSettingPage({super.key});

  @override
  State<PaymentOptionSettingPage> createState() => _PaymentOptionSettingPageState();
}

class _PaymentOptionSettingPageState extends State<PaymentOptionSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 0, left: 16, right: 16),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
              const Text(
                "Payment",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 0,
                width: 35,
              )
            ],
          ),
        ]),
      ),
    );
  }
}
