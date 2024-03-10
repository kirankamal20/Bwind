import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {

  String? _language;

  @override
  void initState() {
    _language = "English (US)";
    super.initState();
  }

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
                  "Language",
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      languageTile("English (US)", "English (US)", _language,
                              (value) {
                            setState(() {
                      _language = value.toString();
                            });
                          }),
                      languageTile("English (UK)", "English (UK)", _language,
                              (value) {
                            setState(() {
                              _language = value.toString();
                            });
                          }),
                      languageTile("Spanish", "Spanish", _language,
                              (value) {
                            setState(() {
                      _language = value.toString();
                            });
                          }), languageTile("Hindi", "Hindi", _language,
                              (value) {
                            setState(() {
                      _language = value.toString();
                            });
                          }), languageTile("Arabic", "Arabic", _language,
                              (value) {
                            setState(() {
                      _language = value.toString();
                            });
                          }), languageTile("Russian", "Russian", _language,
                              (value) {
                            setState(() {
                      _language = value.toString();
                            });
                          }), languageTile("Bengali", "Bengali", _language,
                              (value) {
                            setState(() {
                      _language = value.toString();
                            });
                          }),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ));
  }

  languageTile(title, value, groupValue, void Function(dynamic)? onChange) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 9),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Color(0xFF4E4E4E),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 28,
              width: 38,
              child: Transform.scale(
                  scale: 1.2,
                  child:Radio(
                      value: value,
                      groupValue: groupValue,
                      onChanged: onChange
                  )
              ),
            )

          ],
        ),
      ),
    );
  }


}
