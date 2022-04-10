class Account{
  late String username;
  late String password;
  var u_id;
  var cards = <userCard>[];
  var primary_card;
  var primary_card_key;
  var amount;

  Account(this.username, this.password, userCard card){
    username = username;
    password = password;
    cards.add(card);
    primary_card = cards.first;
    primary_card_key=primary_card.card_key;
  }

  userAmount(){
    amount = 0;
    for (var i = 0; i<cards.length; i++){
      amount = amount + cards[i].amount;
    }
    return;
  }
}

class userCard{
  late String card_key;
  double amount;
  var transactions = <Transaction>[];

  userCard(this.card_key, this.amount, [Transaction? tr]){
    card_key = card_key;
    amount = amount;
    if (tr!=null){
      addTransaction(tr);
    }
  }

  addTransaction(Transaction trans){
    transactions.add(trans);
    amount = amount + trans.getAmount();
    return;
  }

  bool isNew(){
    return transactions.isEmpty;
  }

  int numTransaction(){
    var size = transactions.length-1;
    return size;
  }

  initAmount(){
    for (var i = 0; i<numTransaction(); i++){
      amount = amount + transactions[i].getAmount();
    }
    return;
  }
}

class Transaction{
  final String origin_card_key;
  final String destination_card_key;
  final String transfer_id;
  final DateTime transfer_time;
  final bool transfer_confirm;
  final double amount;

  Transaction({required this.origin_card_key, required this.destination_card_key, required this.transfer_id, required this.transfer_time, required this.transfer_confirm, required this.amount});

  double getAmount(){
    return amount;
  }
}

String generateTransferID(String origin, String destination, DateTime time){
  String new_transfer_id = origin+destination+time.hashCode.toString();
  return new_transfer_id;
}

