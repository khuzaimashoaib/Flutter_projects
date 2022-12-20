import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Details extends StatelessWidget {
  final Map rates;

  const Details({required this.rates});

  @override
  Widget build(BuildContext context) {
    List currencies = rates.keys.toList();
    List exchangeRates = rates.values.toList();

    return Scaffold(
      body: SafeArea(
          child: ListView.builder(
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                String currency = currencies[index].toString().toUpperCase();
                String exchangeRate = exchangeRates[index].toString();
                return ListTile(
                  title: Text("$currency: $exchangeRate", style: const TextStyle(color: Colors.white),),
                );
              })),
    );
  }
}
