import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactionList;
  final Function _deleteTransaction;

  TransactionList(this._transactionList, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        child: _transactionList.isEmpty
            ? FittedBox(
                child: Column(children: [
                  Text('You have not added any Transactions!',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      )),
                  Container(
                    child: Image.asset(
                      'resources/images/nodata.gif',
                      fit: BoxFit.cover,
                    ),
                  ),
                ]),
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return Card(
                    // color: Theme.of(context).backgroundColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: FittedBox(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'Rs ${_transactionList[index].amount.toStringAsFixed(2)}',
                            ),
                          ),
                        ),
                      ),
                      title: Text(_transactionList[index].title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      subtitle: Text(
                        DateFormat.yMMMd().format(_transactionList[index].date),
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: MediaQuery.of(context).size.width > 420
                          ? FlatButton.icon(
                              onPressed: () => _deleteTransaction(
                                  _transactionList[index].id),
                              icon: Icon(Icons.delete),
                              label: Text('Delete'),
                            )
                          : IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteTransaction(
                                  _transactionList[index].id),
                              color: Theme.of(context).disabledColor,
                            ),
                    ),
                    elevation: 10,
                  );
                },
                itemCount: _transactionList.length,
              ));
  }
}
