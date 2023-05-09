import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:dolche_wallet/Components/User/Wallet/Services/FinancialSurvices.dart';
import 'package:dolche_wallet/Components/User/Wallet/Transactions/DepositeCash.dart';
import 'package:dolche_wallet/Components/User/Wallet/Transactions/RecievePayment.dart';
import 'package:dolche_wallet/Components/User/Wallet/Transactions/SendMoney.dart';
import 'package:dolche_wallet/Components/User/Wallet/Transactions/WithdrawMoney.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProducts extends StatefulWidget {
  const MainProducts({super.key});

  @override
  State<MainProducts> createState() => _MainProductsState();
}

class _MainProductsState extends State<MainProducts> {
  String _balance = "";
  late ScrollController _scrollController;
  bool _isScrolled = false;
  bool _balanceVisible = true;
  List _userInfo = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String id = '';
  String phone = '';
  String username = '';
  double balance = 0.0;
  String email = '';

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);
    _fetchUserInfo();
    super.initState();
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

  Future<void> _fetchUserInfo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";
      // String baseUrl =
      // 'https://dolchebackend.onrender.com/api/wallet/transactionHistory';
      String baseUrl = 'http://10.0.2.2:3001/api/wallet/userInfo';

      // print(token + "Token");

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
        final data = response.data;

        setState(() {
          _isLoading = false;
          // _userInfo = response.data;
          id = data['id'];
          phone = data['phone'];
          username = data['username'];
          balance = data['balance'];
          email = data['email'];
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
    print(_userInfo);
  }

  @override
  final _advancedDrawerController = AdvancedDrawerController();

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
                    // "John Doe",
                    username,
                    // _userInfo.join('username'),
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
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              elevation: 0,
              pinned: true,
              stretch: true,
              toolbarHeight: 60,
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
              // centerTitle: true,
              // title: AnimatedOpacity(
              //   opacity: _isScrolled ? 1.0 : 0.0,
              //   duration: const Duration(milliseconds: 500),
              //   child: Column(
              //     children: [
              //       Text(
              //         // '\$ 1,840.00',
              //         "\$ ${_balance}",
              //         style: TextStyle(
              //           color: Colors.black,
              //           fontSize: 22,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       SizedBox(
              //         height: 20,
              //       ),
              //       Container(
              //         width: 30,
              //         height: 4,
              //         decoration: BoxDecoration(
              //           color: Colors.grey.shade800,
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                titlePadding: const EdgeInsets.only(left: 10, right: 10),
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isScrolled ? 0.0 : 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FadeIn(
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: HexColor("#282B4F"),
                                  ),
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(top: 40),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 22.0,
                                            height: 22.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  'https://via.placeholder.com/48x48.png?text=Logo',
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4.0),
                                          Text(
                                            'Dolche',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                          Row(
                                            children: [
                                              Text(
                                                'Balance:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 4.0),
                                              // Text(
                                              //   '\$200',
                                              //   style: TextStyle(
                                              //     fontWeight: FontWeight.bold,
                                              //     fontSize: 20.0,
                                              //     color: Colors.white,
                                              //   ),
                                              // ),
                                              Text(
                                                // _balanceVisible ? '\$200' : '***',

                                                _balanceVisible
                                                    ? balance.toString()
                                                    : '***',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),

                                              // SizedBox(width: -2.0),
                                              // Icon(Icons.remove_red_eye, color: Colors.white),
                                              IconButton(
                                                icon: _balanceVisible
                                                    ? Icon(Icons.visibility_off,
                                                        size: 12,
                                                        color: Colors.white)
                                                    : Icon(Icons.visibility,
                                                        size: 12,
                                                        color: Colors.white),
                                                onPressed: () async {
                                                  setState(() {
                                                    _balanceVisible =
                                                        !_balanceVisible;
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      // SizedBox(height: 4.0),
                                      Text(
                                        'Cardholder Name',
                                        style: TextStyle(
                                          fontSize: 8.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 2.0),
                                      Text(
                                        // 'John Doe',
                                        username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 2.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Expiry Date',
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 2.0),
                                              Text(
                                                '12/24',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'CVV',
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 4.0),
                                              Row(
                                                children: [
                                                  Text(
                                                    '***',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.0),
                                                  Icon(Icons.credit_card,
                                                      color: Colors.white),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          // backgroundImage: NetworkImage(
                          //     'https://images.pexels.com/photos/3992186/pexels-photo-3992186.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=80'),
                          radius: 33,
                        ),
                        CircleAvatar(
                          // backgroundImage: NetworkImage(
                          //     'https://images.pexels.com/photos/1005956/pexels-photo-1005956.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=80'),
                          radius: 33,
                        ),
                        CircleAvatar(
                          // backgroundImage: NetworkImage(
                          //     'https://images.pexels.com/photos/8197930/pexels-photo-8197930.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=80'),
                          radius: 33,
                        ),
                        CircleAvatar(
                          // backgroundImage: NetworkImage(
                          //     'https://images.pexels.com/photos/1056700/pexels-photo-1056700.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=80'),
                          radius: 33,
                        ),
                        CircleAvatar(
                          // backgroundImage: NetworkImage(
                          //     'https://images.pexels.com/photos/1056710/pexels-photo-1056710.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=80'),
                          radius: 33,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            //Withdraw screen
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DepositeCash()));
                          },
                          child: Container(
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/deposite.png',
                                      width: 144,
                                      height: 86,
                                    ),
                                    Text(
                                      "Deposite Cash",
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: HexColor("#41414A")),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            print(prefs.remove("token"));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Withdraw()));
                          },
                          child: Container(
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/withdraw.png',
                                      width: 144,
                                      height: 86,
                                    ),
                                    Text(
                                      "Withdraw Cash",
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: HexColor("#41414A")),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SendMoney()));
                          },
                          child: Container(
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/sendmoney.png',
                                      width: 144,
                                      height: 86,
                                    ),
                                    Text(
                                      "Send Money",
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: HexColor("#41414A")),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            //Withdraw screen
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FinancialServices()));
                          },
                          child: Container(
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/fiancialservice.png',
                                      width: 144,
                                      height: 86,
                                    ),
                                    Text(
                                      "Fiancial Service",
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: HexColor("#41414A")),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ]),
                ),
              ),
            ]))
          ],
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
