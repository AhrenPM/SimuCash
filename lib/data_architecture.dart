class Account{
  final String u_id;
  final String password;
  userCard cards;
  late String primary_card_key;

  Account(this.u_id, this.password, this.cards);

  setPrimaryCard(){
    primary_card_key = cards.card_key;
    return;
  }
}

class userCard{
  final String card_key;
  int amount;
  var transactions = <Transaction>[];

  userCard(this.card_key, this.amount);

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
    for (var i = 0; i>numTransaction(); i++){
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
  final int amount;

  Transaction({required this.origin_card_key, required this.destination_card_key, required this.transfer_id, required this.transfer_time, required this.transfer_confirm, required this.amount});

  int getAmount(){
    return amount;
  }
}

String generateTransferID(String origin, String destination, DateTime time){
  String new_transfer_id = origin+destination+time.hashCode.toString();
  return new_transfer_id;
}