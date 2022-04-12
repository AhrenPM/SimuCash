import 'dart:async';

import 'package:flutter/material.dart';

import 'Widgets.dart';
import 'data_architecture.dart';
import 'transfer_page.dart';

class HomePage extends StatefulWidget {
  userCard ownerCard;

  HomePage({Key? key, required this.ownerCard}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late TextEditingController _addFund;
  late int fundToAdd;

  void initState() {
    super.initState();
    _addFund = TextEditingController();
  }

  @override
  void dispose() {
    _addFund.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Debug purpose
    /*for (var i = 0; i<=20; i++){
      widget.ownerCard.addTransaction(Transaction(
          transfer_time: DateTime.now(),
          origin_card_key: '00000',
          amount: receivedAmount(),
          transfer_confirm: true,
          destination_card_key: widget.ownerCard.card_key,
          transfer_id: generateTransferID('00000', widget.ownerCard.card_key, DateTime.now())
      ));
    }*/
    //
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
                Navigator.pop(context);
              },
              child:
              const Text('Log Out', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80.0, vertical: 14),
                  child: Column(children: [
                    const Text('Account Balance',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Text('\$'+double.parse(widget.ownerCard.amount.toStringAsFixed(2)).toString(),
                            style: const TextStyle(
                                color: Color(0xffbe9e44),
                                fontSize: 48,
                                fontWeight: FontWeight.w600)))
                  ]),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: widget.ownerCard.numTransaction()>=0
                        ?Wrap(
                        children: <Widget>[
                          DataTable(
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    'Date',
                                    style: TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Type',
                                    style: TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Amount',
                                    style: TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                widget.ownerCard.numTransaction()+1,
                                    (int index) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(widget.ownerCard.transactions[index].transfer_time.year.toString()+"-"+widget.ownerCard.transactions[index].transfer_time.month.toString()+"-"+widget.ownerCard.transactions[index].transfer_time.day.toString())),
                                    DataCell(Text(widget.ownerCard.transactions[index].amount>0
                                        ? "Received"
                                        : "Sent"
                                    )),
                                    DataCell(Text('\$'+widget.ownerCard.transactions[index].amount.abs().toString())),
                                  ],
                                ),
                              )
                          )
                        ]
                    )
                        : DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Date',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Type',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Amount',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ], rows: const [
                          DataRow(
                              cells: [
                                DataCell(Text('1111-11-11', style: TextStyle(color: Colors.white,),)),
                                DataCell(Text('received', style: TextStyle(color: Colors.white,),)),
                                DataCell(Text('\$0000.00', style: TextStyle(color: Colors.white,),)),
                    ]),
                    ]
                    )
                  ),
              ),
            ),
          ]),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton.extended(
                onPressed: () {
                  final waitDuration = waitTime();
                  final fundingAmount = receivedAmount();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Proceeding with transaction'),
                      duration: Duration(milliseconds: waitDuration),
                    ),
                  );
                  Timer(Duration(milliseconds: waitDuration+((waitDuration)/100).round()), () {
                    //print('The current account balance is: '+widget.ownerCard.amount.toString()+'.');
                    widget.ownerCard.addTransaction(Transaction(
                        transfer_time: DateTime.now(),
                        origin_card_key: '00000',
                        amount: fundingAmount,
                        transfer_confirm: true,
                        destination_card_key: widget.ownerCard.card_key,
                        transfer_id: generateTransferID('00000', widget.ownerCard.card_key, DateTime.now())
                    ));
                    setState(() {
                      widget.ownerCard = widget.ownerCard;
                    });
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text("You have successfully added \$"+ fundingAmount.toString() +" from your bank to your card."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Return'),
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Funds',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                backgroundColor: Color(0xffd8c690),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  _asyncTransferPage(context);
                },
                label: const Text(
                  '\$ Transfer',
                  style: TextStyle(
                      color: Color(0xffbe9e44),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                backgroundColor: Color(0xAA000000),
              ),
            ],
          ),
        )
    );
  }

  void _asyncTransferPage(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransferPage(ownerCard: widget.ownerCard,),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      widget.ownerCard = result;
    });
  }
}
