import 'package:Documents/payment-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stripe_payment/stripe_payment.dart';

class CardsPage extends StatefulWidget {
  CardsPage({Key key}) : super(key: key);

  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/22',
      'cardHolderName': 'Alan Rickman',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '5555555555554444',
      'expiryDate': '04/21',
      'cardHolderName': 'Daniel Radcliffe',
      'cvvCode': '213',
      'showBackView': false,
    }
  ];

  payViaExistingCar(BuildContext context, card) async {
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(card['expiryDate'].split('/')[0]),
      expYear: int.parse(card['expiryDate'].split('/')[1]),
      cvc: card['cvvCode'],
    );
    var response = await StripeService.payViaExistingCard(
        amount: '2500', currency: 'USD', card: stripeCard);
    if (response.success == true) {
      Scaffold.of(context)
          .showSnackBar(
            SnackBar(
              content: Text(response.message),
              duration: new Duration(milliseconds: 1200),
            ),
          )
          .closed
          .then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose existing card'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: cards.length,
            itemBuilder: (BuildContext context, int index) {
              var card = cards[index];
              return InkWell(
                onTap: () {
                  payViaExistingCar(context, cards[index]);
                },
                child: CreditCardWidget(
                  cardNumber: card['cardNumber'],
                  expiryDate: card['expiryDate'],
                  cardHolderName: card['cardHolderName'],
                  cvvCode: card['cvvCode'],
                  showBackView: false,
                ),
              );
            }),
      ),
    );
  }
}
