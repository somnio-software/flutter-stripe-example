import 'package:Documents/payment-service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        var response =
            await StripeService.payViaNewCard(amount: '25000', currency: 'USD');
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            duration: new Duration(
                milliseconds: response.success == true ? 1200 : 3000),
          ),
        );

        break;
      case 1:
        Navigator.pushNamed(context, '/cards');
    }
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home '),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Icon icon;
              Text text;

              switch (index) {
                case 0:
                  icon = Icon(
                    Icons.add_circle,
                    color: theme.primaryColor,
                  );
                  text = Text('Pay via new card');
                  break;
                case 1:
                  icon = Icon(
                    Icons.credit_card,
                    color: theme.primaryColor,
                  );
                  text = Text('Pay via existing card');
                  break;
              }
              return InkWell(
                onTap: () {
                  onItemPress(context, index);
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
                  color: theme.primaryColor,
                ),
            itemCount: 2),
      ),
    );
  }
}
