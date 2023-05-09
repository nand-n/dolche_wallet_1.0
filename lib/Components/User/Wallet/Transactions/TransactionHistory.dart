// import 'package:flutter/material.dart';

// class TransactionHistory extends StatefulWidget {
//   const TransactionHistory({super.key});

//   @override
//   State<TransactionHistory> createState() => _TransactionHistoryState();
// }

// class _TransactionHistoryState extends State<TransactionHistory> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:validators/validators.dart';

import '../../../../pages/contact.dart';

class TransactionHistoryWidget extends StatefulWidget {
  @override
  _TransactionHistoryWidgetState createState() =>
      _TransactionHistoryWidgetState();
}

class _TransactionHistoryWidgetState extends State<TransactionHistoryWidget> {
  List _transactions = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";
      // String baseUrl =
      // 'https://dolchebackend.onrender.com/api/wallet/transactionHistory';
      String baseUrl = 'http://10.0.2.2:3001/api/wallet/transactionHistory';

      print(token + "Token");

      final response = await Dio().post(
        baseUrl,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            'Authorization': token,
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          _transactions = response.data['transacts'];
        });
      } else {
        // CircularProgressIndicator();
        print(response.statusMessage);
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
        // _errorMessage = 'Error fetching data'
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Center(
        child: _isLoading
            ? SpinKitChasingDots(
                color: Colors.blue,
                size: 50.0,
              )
            : _errorMessage.isNotEmpty
                ? Text(_errorMessage)
                : Transactions(
                    transactions: _transactions,
                    errorMessaage: _errorMessage,
                    isLoading: _isLoading,
                  ),
      ),
    );
  }
}

class Transactions extends StatefulWidget {
  List<dynamic> transactions = [];
  bool isLoading;
  String errorMessaage;

  Transactions({
    Key? key,
    required this.transactions,
    required this.errorMessaage,
    required this.isLoading,
  }) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late ScrollController _scrollController;
  bool _isScrolled = false;
  String _balance = "";
  // bool isLoading = widget.isLoading;

  List<dynamic> _services = [
    ['Withdraw', Iconsax.export_1, Colors.blue],
    ['Deposite', Iconsax.import, Colors.pink],
    ['P-2-P', Iconsax.wallet_3, Colors.orange],
    ['More', Iconsax.more, Colors.green],
  ];

  // final List<dynamic> _transactions = [
  //   [
  //     'Amazon',
  //     'https://img.icons8.com/color/2x/amazon.png',
  //     '6:25pm',
  //     '\$8.90'
  //   ],
  //   [
  //     'Netflix',
  //     'https://img.icons8.com/color-glass/2x/netflix.png',
  //     '2:22pm',
  //     '\$13.99'
  //   ],
  //   [
  //     'Apple Store',
  //     'https://img.icons8.com/color/2x/mac-os--v2.gif',
  //     '6:25pm',
  //     '\$4.99'
  //   ],
  //   [
  //     'Cash from ATM',
  //     'https://img.icons8.com/external-kiranshastry-lineal-color-kiranshastry/2x/external-atm-banking-and-finance-kiranshastry-lineal-color-kiranshastry.png',
  //     '5:50pm',
  //     '\$200.00'
  //   ],
  //   [
  //     'Netflix',
  //     'https://img.icons8.com/color-glass/2x/netflix.png',
  //     '2:22pm',
  //     '\$13.99'
  //   ],
  //   [
  //     'Amazon',
  //     'https://img.icons8.com/color/2x/amazon.png',
  //     '6:25pm',
  //     '\$8.90'
  //   ],
  // ];

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);
    getBalance();
    super.initState();
  }

  Future<void> getBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    String baseUrl = 'http://10.0.2.2:3001/api/wallet/balance';
    // 'https://dolchebackend.onrender.com/api/wallet/balance';
    final response = await Dio().post(
      baseUrl,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          'Authorization': token,
        },
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        _balance = response.data.toString();
      });
    } else {
      setState(() {
        _balance = "0";
      });
    }
  }

  void _listenToScrollChange() {
    if (_scrollController.offset >= 100.0) {
      setState(() {
        _isScrolled = true;
      });
    } else {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.grey.shade900,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade900,
            blurRadius: 20.0,
            spreadRadius: 5.0,
            offset: Offset(-20.0, 0.0),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      drawer: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 80.0,
                    height: 80.0,
                    margin: EdgeInsets.only(
                      left: 20,
                      top: 24.0,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('assets/images/avatar-1.png')),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text(
                    "John Doe",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(),
                Divider(
                  color: Colors.grey.shade800,
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Iconsax.home),
                  title: Text('Dashboard'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Iconsax.chart_2),
                  title: Text('About Us'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Iconsax.profile_2user),
                  title: Text('Contacts'),
                ),
                SizedBox(
                  height: 50,
                ),
                Divider(color: Colors.grey.shade800),
                ListTile(
                  onTap: () {},
                  leading: Icon(Iconsax.setting_2),
                  title: Text('Settings'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Iconsax.support),
                  title: Text('Support'),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              elevation: 0,
              pinned: true,
              stretch: true,
              toolbarHeight: 80,
              backgroundColor: Colors.white,
              leading: IconButton(
                color: Colors.black,
                onPressed: _handleMenuButtonPressed,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (_, value, __) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      child: Icon(
                        value.visible ? Iconsax.close_square : Iconsax.menu,
                        key: ValueKey<bool>(value.visible),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Iconsax.notification, color: Colors.grey.shade700),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Iconsax.more, color: Colors.grey.shade700),
                  onPressed: () {},
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              centerTitle: true,
              title: AnimatedOpacity(
                opacity: _isScrolled ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    Text(
                      // '\$ 1,840.00',
                      "\$ ${_balance}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 30,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                titlePadding: const EdgeInsets.only(left: 20, right: 20),
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isScrolled ? 0.0 : 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FadeIn(
                        duration: const Duration(milliseconds: 500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // '1,840.00',
                              "${_balance}",

                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              '\ETB',
                              // "\$ ${_balance}",
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeIn(
                        duration: const Duration(milliseconds: 500),
                        child: MaterialButton(
                          height: 30,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          onPressed: () {},
                          child: Text(
                            'Add Money',
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 30,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                height: 115,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _services.length,
                  itemBuilder: (context, index) {
                    return FadeInDown(
                      duration: Duration(milliseconds: (index + 1) * 100),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GestureDetector(
                          onTap: () {
                            if (_services[index][0] == 'Withdraw') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContactPage()));
                            }
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(
                                    _services[index][1],
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                _services[index][0],
                                style: TextStyle(
                                    color: Colors.grey.shade800, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ])),
            SliverFillRemaining(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  children: [
                    FadeInDown(
                      duration: Duration(milliseconds: 500),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transactoions',
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('${_balance} \ETB',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                )),
                          ]),
                    ),
                    // Expanded(
                    //   child: ListView.builder(
                    //     padding: EdgeInsets.only(top: 20),
                    //     physics: NeverScrollableScrollPhysics(),
                    //     itemCount: _transactions.length,
                    //     itemBuilder: (context, index) {
                    //       return FadeInDown(
                    //         duration: Duration(milliseconds: 500),
                    //         child: Container(
                    //           margin: EdgeInsets.only(bottom: 10),
                    //           padding: EdgeInsets.symmetric(
                    //               horizontal: 20, vertical: 10),
                    //           decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             borderRadius: BorderRadius.circular(15),
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 color: Colors.grey.shade200,
                    //                 blurRadius: 5,
                    //                 spreadRadius: 1,
                    //                 offset: Offset(0, 6),
                    //               ),
                    //             ],
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Row(
                    //                 children: [
                    //                   Image.network(
                    //                     _transactions[index][1],
                    //                     width: 50,
                    //                     height: 50,
                    //                   ),
                    //                   SizedBox(
                    //                     width: 15,
                    //                   ),
                    //                   Column(
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     children: [
                    //                       Text(
                    //                         _transactions[index][0],
                    //                         style: TextStyle(
                    //                             color: Colors.grey.shade900,
                    //                             fontWeight: FontWeight.w500,
                    //                             fontSize: 14),
                    //                       ),
                    //                       SizedBox(
                    //                         height: 5,
                    //                       ),
                    //                       Text(
                    //                         _transactions[index][2],
                    //                         style: TextStyle(
                    //                             color: Colors.grey.shade500,
                    //                             fontSize: 12),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ],
                    //               ),
                    //               Text(
                    //                 _transactions[index][3],
                    //                 style: TextStyle(
                    //                     color: Colors.grey.shade800,
                    //                     fontSize: 16,
                    //                     fontWeight: FontWeight.w700),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    Expanded(
                      child: Center(
                        child: widget.isLoading
                            ? SpinKitChasingDots(
                                color: Colors.blue,
                                size: 50,
                              )
                            : widget.errorMessaage.isNotEmpty
                                ? Text(widget.errorMessaage)
                                : ListView.builder(
                                    padding: EdgeInsets.only(top: 20),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: widget.transactions.length,
                                    itemBuilder: (context, index) {
                                      var transaction =
                                          widget.transactions[index];
                                      return FadeInDown(
                                        duration: Duration(milliseconds: 500),
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade200,
                                                blurRadius: 5,
                                                spreadRadius: 1,
                                                offset: Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            leading: Icon(Icons.attach_money),
                                            title: Text(
                                                "Type : ${transaction['type']}"),
                                            subtitle: Text(transaction['user']
                                                ['username']),
                                            trailing: Text(
                                                '\$${transaction['amount']}'),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}