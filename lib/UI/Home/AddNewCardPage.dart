import 'package:distance_edu/Model/PaymentCard.dart';
import 'package:distance_edu/Model/FireAuth.dart';
import 'package:distance_edu/Model/Userbase.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../validator.dart';

class AddNewCardPage extends StatefulWidget {
  const AddNewCardPage({super.key});

  @override
  State<AddNewCardPage> createState() => _AddNewCardPageState();
}

class _AddNewCardPageState extends State<AddNewCardPage> {

  final GlobalKey<FormState> _cardForm = GlobalKey();

  final _cardHolderNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardExpiryDateController = TextEditingController();
  final _CVVController = TextEditingController();
  DateTime? pickedDate;
  bool isAdding = false;

  MaskTextInputFormatter cardMaskFormatter = MaskTextInputFormatter(
    mask: "#### #### #### ####"
  );
  MaskTextInputFormatter cvvMaskFormatter = MaskTextInputFormatter(
    mask: "###"
  );


  @override
  void initState() {
    // TODO: implement initState
    isAdding = false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(alignment: Alignment.bottomCenter, children: [
      Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 0, left: 16, right: 16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    )),
                const Text(
                  "Add New Card",
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
            child: SizedBox(
              child: SingleChildScrollView(
                child: Form(
                  key: _cardForm,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15, bottom: 4),
                            child: const Text(
                              "Card Holder Name",
                              style: TextStyle(
                                  color: Color(0xFF4E4E4E),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: _cardHolderNameController,
                            validator: (String? value){
                              return Validator.validateCardHolderName(cardHolderName: value!);
                            },
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(
                                color: Color(0xFF979797)
                              ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFD1D1D1), width: 1),
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 13, horizontal: 11),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF6F30C0), width: 1),
                                ),
                                hintText: "Name"
                            ),
                            style: const TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15, bottom: 4),
                            child: const Text(
                              "Card Number",
                              style: TextStyle(
                                  color: Color(0xFF4E4E4E),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            inputFormatters: [cardMaskFormatter],
                            controller: _cardNumberController,
                            validator: (String? value){
                              return Validator.validateCardNumber(cardNumber: value!);
                            },
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(
                                color: Color(0xFF979797)
                              ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFD1D1D1), width: 1),
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 13, horizontal: 11),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF6F30C0), width: 1),
                                ),
                                hintText: "1234 1234 1234 1234"
                            ),
                            style: const TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 15, bottom: 4),
                                child: const Text(
                                  "Expiry Date",
                                  style: TextStyle(
                                      color: Color(0xFF4E4E4E),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                width: (MediaQuery.of(context).size.width - 32) * 0.5,
                                child: TextFormField(
                                  controller: _cardExpiryDateController,
                                  validator: (String? value){
                                    return Validator.validateCerdExpiry(expiryDate: value!);
                                  },
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF979797)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide:
                                      const BorderSide(color: Color(0xFFD1D1D1), width: 1),
                                    ),
                                    contentPadding:
                                    const EdgeInsets.symmetric(vertical: 13, horizontal: 11),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide:
                                      const BorderSide(color: Color(0xFF6F30C0), width: 1),
                                    ),
                                    hintText: "mm/yyyy",
                                    suffixIcon:  const Icon(
                                        Icons.calendar_month,
                                        color: Color(0xFF6F30C0)
                                    ),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    pickedDate = await showMonthPicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(const Duration(days: 18262)));
                                    _cardExpiryDateController.text = "${pickedDate!.month}/${pickedDate!.year}";
                                  },
                                  style: const TextStyle(
                                      color: Color(0xFF979797),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 18,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 15, bottom: 4),
                                child: const Text(
                                  "CVV",
                                  style: TextStyle(
                                      color: Color(0xFF4E4E4E),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                width: 60,
                                child: TextFormField(
                                  inputFormatters: [cvvMaskFormatter],
                                  controller: _CVVController,
                                  validator: (String? value){
                                    return Validator.validateCVV(CVV: value!);
                                  },
                                  decoration: InputDecoration(
                                      hintStyle: const TextStyle(
                                          color: Color(0xFF979797)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFD1D1D1), width: 1),
                                      ),
                                      contentPadding:
                                      const EdgeInsets.symmetric(vertical: 13, horizontal: 11),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF6F30C0), width: 1),
                                      ),
                                      hintText: "CVV"
                                  ),
                                  style: const TextStyle(
                                      color: Color(0xFF979797),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 100,)
                    ],
                  ),
                ),
              ),
            ),
          ),
          ]),
        ),
      ),
          Positioned(
            bottom: 20,
            width: MediaQuery.of(context).size.width - 32,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              onTap: () async {
                if(_cardForm.currentState!.validate()){
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    isAdding = true;
                  });
                  PaymentCard newcard = PaymentCard(cardHolderName: _cardHolderNameController.text, cardNumber: _cardNumberController.text.replaceAll(" ", ""), expiryDate: pickedDate!, cvv: (int.parse(_CVVController.text)));
                  CardResponse response = await Userbase.addCard(FireAuth.auth.currentUser!.uid,newcard.toMap());
                  setState(() {
                    isAdding = false;
                  });
                  Fluttertoast.showToast(
                      msg: response.msg,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM
                  );
                  if(response.code){
                    Navigator.pop(context);
                  }
                }
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Color(0xFF6F30C0),
                      boxShadow: [
                        BoxShadow(color: Colors.white,spreadRadius:10, blurRadius: 150, offset: Offset(0, 50))
                      ]
                  ),
                  child: Center(
                    child: isAdding ?
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white,),
                    )
                        :const Text(
                      "Add New Card",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  )),
            ),
          ),
    ]),
    );
  }

}
