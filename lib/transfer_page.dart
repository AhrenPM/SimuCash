//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data_architecture.dart';


class TransferPage extends StatefulWidget {
  userCard ownerCard;

  TransferPage({Key? key, required this.ownerCard}) : super(key: key);

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  String actionMessage = '';
  bool _emptyField = false;

  late TextEditingController _transferAmount;
  late int transferAmount;
  late Transaction newTr;

  // partner card is for testing purposes
  final partner = userCard("00002",100);
  //

  @override
  void initState() {
    super.initState();
    _transferAmount = TextEditingController();
  }

  @override
  void dispose() {
    _transferAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/simucash_logo.png',
          fit: BoxFit.cover,
          height: 40,
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, widget.ownerCard);
            },
            child: const Text('Back', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                  "If you would like to receive funds from someone else just press the receive button and wait for the confirmation message!"),
            ),
            const Text(
                "Otherwise, enter the amount you would like to send below:"),
            TextField(
              controller: _transferAmount,
              decoration: InputDecoration(
                  labelText: "How much would you like to send?",
                  errorText: _emptyField
                      ? 'Please enter an amount to transfer:'
                      : null,),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // This button executes the logic to receive money from an offline terminal to the online terminal with NFC
            FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _transferAmount.text.isEmpty
                      ? _emptyField = true
                      : _emptyField = false;
                });
                //TODO: replace newTr with info read from NFC
                transferAmount = int.parse(_transferAmount.text);
                newTr = Transaction(
                    amount: transferAmount,
                    origin_card_key: partner.card_key,
                    transfer_confirm: true,
                    transfer_time: DateTime.now(),
                    destination_card_key: widget.ownerCard.card_key,
                    transfer_id: generateTransferID(partner.card_key,widget.ownerCard.card_key,DateTime.now())
                );
                widget.ownerCard.addTransaction(newTr);
                print('The current account balance is: '+widget.ownerCard.amount.toString()+'.');
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text("You have successfully received \$"+ _transferAmount.text +" from card with card number "+partner.card_key+"."),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            _transferAmount.clear();
                            Navigator.pop(context, widget.ownerCard);
                          },
                          child: const Text('Return'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.account_balance_wallet_outlined,
                  color: Colors.white),
              label: const Text(
                'Receive',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              backgroundColor: const Color(0xffd8c690),
            ),
            // This function executes the logic to send money from an online terminal to an offline terminal with NFC
            FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _transferAmount.text.isEmpty
                      ? _emptyField = true
                      : _emptyField = false;
                });
                late String popupText;
                transferAmount = -1*int.parse(_transferAmount.text);
                if (widget.ownerCard.amount<=-1*transferAmount){
                  popupText = "You do not have enough balance in your card to proceed with a transfer of \$"+_transferAmount.text+" to the card with card number "+partner.card_key+". Please try again when your card balance is sufficient.";
                }
                else{
                  popupText = "You have successfully sent \$"+ _transferAmount.text +" to card with card number "+partner.card_key+".";
                  //TODO: replace newTr with info read from NFC
                  newTr = Transaction(
                      amount: transferAmount,
                      origin_card_key: partner.card_key,
                      transfer_confirm: true,
                      transfer_time: DateTime.now(),
                      destination_card_key: widget.ownerCard.card_key,
                      transfer_id: generateTransferID(partner.card_key,widget.ownerCard.card_key,DateTime.now())
                  );
                  widget.ownerCard.addTransaction(newTr);
                  //TODO delete debug when done
                  print('The current account balance is: '+widget.ownerCard.amount.toString()+'.');
                }
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(popupText),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            _transferAmount.clear();
                            Navigator.pop(context, widget.ownerCard);
                          },
                          child: const Text('Return'),
                        ),
                      ],
                    );
                  },
                );
              },
              label: const Text(
                '\$ Send',
                style: TextStyle(
                    color: Color(0xffbe9e44),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              backgroundColor: const Color(0xAA000000),
            ),
          ],
        ),
      ),
    );
  }
}
