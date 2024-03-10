class PaymentCard{
  String cardHolderName;
  String cardNumber;
  DateTime expiryDate;
  int cvv;

  PaymentCard({required this.cardHolderName, required this.cardNumber, required this.expiryDate, required this.cvv});

  Map<String , dynamic> toMap(){
    return {
      "cardHolderName" : cardHolderName,
      "cardNumber" : cardNumber,
      "expiryDate" : expiryDate,
      "cvv" : cvv
    };
  }
}

class CardResponse{
  PaymentCard? card;
  String msg;
  bool code;

  CardResponse({this.card, required this.msg, required this.code});
}