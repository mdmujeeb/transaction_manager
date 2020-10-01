import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class BarGraph extends StatelessWidget {
  final List<Transaction> _recentTx;
  final double _totalWeeklySpend;

  BarGraph(this._recentTx, this._totalWeeklySpend);

  List<Map<String, Object>> get _groupedTransactionValues {
    return List.generate(7, (index) {
      final today = DateTime.now().subtract(Duration(days: index));

      final double amount = _recentTx
          .where((transaction) =>
              transaction.date.day == today.day &&
              transaction.date.month == today.month &&
              transaction.date.year == today.year)
          .fold(0.0, (sum, transaction) => sum += transaction.amount);

      String day = DateFormat.E().format(today);

      return {'day': day, 'amount': amount};
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Card(
            elevation: 6,
            margin: EdgeInsets.all(0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  ..._groupedTransactionValues.map((map) {
                    return Flexible(
                      fit: FlexFit.tight,
                      child: Column(children: [
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),
                        Container(
                          height: constraints.maxHeight * 0.15,
                          child: FittedBox(
                            child: Text(
                              '${(map['amount'] as double).toStringAsFixed(2)}',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),
                        Container(
                            height: constraints.maxHeight * 0.5,
                            width: 10,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    color: Color.fromRGBO(220, 220, 220, 1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                FractionallySizedBox(
                                  heightFactor: _totalWeeklySpend <= 0
                                      ? 0.0
                                      : (map['amount'] as double) /
                                          _totalWeeklySpend,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      border: Border.all(
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),
                        Container(
                          height: constraints.maxHeight * 0.15,
                          child: FittedBox(
                            child: Text(
                              map['day'],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),
                      ]),
                    );
                  }).toList(),
                  SizedBox(
                    width: 10,
                  ),
                ]));
      },
    );
  }
}
