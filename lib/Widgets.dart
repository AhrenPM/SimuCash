import 'dart:math';

double receivedAmount(){
  Random amount = Random();
  return double.parse(((amount.nextInt(100000)+1)/100).toStringAsFixed(2));
}

int waitTime(){
  Random time = Random();
  return time.nextInt(3000)+1;
}