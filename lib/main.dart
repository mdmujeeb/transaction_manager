// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import './widgets/bar_graph.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';

bool _isIOS = true; //Platform.isIOS;

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(TransactionManagerApp());
}

class TransactionManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        // _isIOS
        //     ? CupertinoApp(
        //         title: 'Transaction Manager',
        //         theme: CupertinoThemeData(
        //           // backgroundColor: Colors.black,
        //           // dialogBackgroundColor: Colors.black,
        //           // scaffoldBackgroundColor: Colors.black,
        //           primaryColor: Colors.green,
        //           // scaffoldBackgroundColor: Colors.green,
        //           textTheme: CupertinoTextThemeData(
        //               textStyle: TextStyle(color: Colors.green, fontSize: 12)),
        //           // fontFamily: 'DS-DIGI',
        //         ),
        //         // appBarTheme: AppBarTheme(
        //         //     textTheme: ThemeData.light().textTheme.copyWith(
        //         //           title: TextStyle(fontFamily: 'DS-DIGI'),
        //         //         )),
        //         // textTheme: ThemeData.light().textTheme.copyWith(
        //         //       title: TextStyle(
        //         //         fontFamily: 'DS-DIGI',
        //         //       ),
        //         //     )),
        //         home: TransactionManagerHome(title: 'Personal Expenses'),
        //       )
        //     :
        MaterialApp(
      title: 'Transaction Manager',
      theme: ThemeData(
          // backgroundColor: Colors.black,
          // dialogBackgroundColor: Colors.black,
          // scaffoldBackgroundColor: Colors.black,
          primarySwatch: Colors.green,
          accentColor: Colors.green,
          // fontFamily: 'DS-DIGI',
          visualDensity: VisualDensity.adaptivePlatformDensity),
      // appBarTheme: AppBarTheme(
      //     textTheme: ThemeData.light().textTheme.copyWith(
      //           title: TextStyle(fontFamily: 'DS-DIGI'),
      //         )),
      // textTheme: ThemeData.light().textTheme.copyWith(
      //       title: TextStyle(
      //         fontFamily: 'DS-DIGI',
      //       ),
      //     )),
      home: TransactionManagerHome(title: 'Personal Expenses'),
    );
  }
}

class TransactionManagerHome extends StatefulWidget {
  final String title;
  TransactionManagerHome({Key key, this.title}) : super(key: key);

  @override
  _TransactionManagerHomeState createState() => _TransactionManagerHomeState();
}

class _TransactionManagerHomeState extends State<TransactionManagerHome> {
  final List<Transaction> _transactions = [
    // Transaction(
    //   id: 'T1',
    //   title: 'New Shoes',
    //   amount: 1500.70,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 'T2',
    //   title: 'Weekly Grocery',
    //   amount: 535.89,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  List<Transaction> get _getRecentTransactions {
    DateTime lastWeek = DateTime.now().subtract(Duration(days: 7));

    return _transactions
        .where((transaction) => transaction.date.compareTo(lastWeek) > 0)
        .toList();
  }

  double get _getTotalWeeklySpent {
    return _getRecentTransactions.fold(
        0.0, (sum, transaction) => sum += transaction.amount);
  }

  void _startAddingNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addTransaction),
        );
      },
    );
  }

  void _addTransaction(Transaction transaction) {
    setState(() {
      _transactions.add(transaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    var _appBar = AppBar(
      title: Text(
        'Personal Expenses',
        // style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.add,
              // color: Theme.of(context).primaryColor,
            ),
            onPressed: () => _startAddingNewTransaction(context)),
      ],
    );

    var _pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Show Chart',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _isIOS
                        ? CupertinoSwitch(
                            value: _showChart,
                            onChanged: (value) {
                              setState(() {
                                _showChart = value;
                              });
                            },
                          )
                        : Switch(
                            value: _showChart,
                            onChanged: (value) {
                              setState(() {
                                _showChart = value;
                              });
                            },
                          )
                  ],
                ),
              if (!isLandscape)
                Card(
                  child: Container(
                    height: (mediaQuery.size.height -
                            mediaQuery.padding.top -
                            _appBar.preferredSize.height) *
                        0.3,
                    child:
                        BarGraph(_getRecentTransactions, _getTotalWeeklySpent),
                    alignment: Alignment.center,
                  ),
                  elevation: 10,
                ),
              _showChart
                  ? Card(
                      child: Container(
                        height: (mediaQuery.size.height -
                                mediaQuery.padding.top -
                                _appBar.preferredSize.height) *
                            0.3,
                        child: BarGraph(
                            _getRecentTransactions, _getTotalWeeklySpent),
                        alignment: Alignment.center,
                      ),
                      elevation: 10,
                    )
                  : Container(
                      height: (mediaQuery.size.height -
                              mediaQuery.padding.top -
                              _appBar.preferredSize.height) *
                          0.7,
                      child: TransactionList(
                        _transactions,
                        _deleteTransaction,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );

    return _isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text("Personal Expenses"),
              trailing: CupertinoButton(
                child: Icon(Icons.add),
                onPressed: () => _startAddingNewTransaction(context),
              ),
            ),
            child: _pageBody)
        : Scaffold(
            appBar: _appBar,
            body: _pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: _isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddingNewTransaction(context),
                  ),
          );
  }
}
