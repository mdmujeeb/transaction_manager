import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../models/transaction.dart';

final _isIOS = Platform.isIOS;

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController amountController = TextEditingController();
  DateTime _selectedDate;

  void _addTx() {
    final String _title = titleController.text;
    final String _amount = amountController.text;
    double _dblAmount;

    if (_title.isEmpty || _amount.isEmpty || _selectedDate == null) {
      return;
    } else {
      _dblAmount = double.parse(_amount);
      if (_dblAmount < 0) {
        return;
      }
    }

    widget.addTransaction(new Transaction(
      id: DateTime.now().toString(),
      title: _title,
      amount: _dblAmount,
      date: _selectedDate,
    ));

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 3650)),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _addTx(),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _addTx(),
              ),
              Container(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen.'
                          : DateFormat.yMMMd().format(_selectedDate)),
                    ),
                    _isIOS
                        ? CupertinoButton(
                            child: Text(
                              'Choose Date',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: _presentDatePicker,
                          )
                        : FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            onPressed: _presentDatePicker,
                            child: Text(
                              'Choose Date',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                  ],
                ),
              ),
              _isIOS
                  ? CupertinoButton(
                      child: Text(
                        'Add Transaction',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _addTx,
                      color: Colors.green,
                    )
                  : FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        'Add Transaction',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.green,
                      onPressed: _addTx,
                    )
            ],
          ),
          alignment: Alignment.center,
        ),
        elevation: 10,
      ),
    );
  }
}
