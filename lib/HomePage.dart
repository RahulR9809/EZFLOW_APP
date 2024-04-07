// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors, avoid_print, unnecessary_brace_in_string_interps, prefer_const_literals_to_create_immutables

import 'package:firstproject/ProductUpdates.dart';
import 'package:firstproject/ReturnedDetails.dart';
import 'package:firstproject/category.dart';
import 'package:firstproject/db/data_model.dart';
import 'package:firstproject/db/db.dart';
import 'package:firstproject/profile.dart';
import 'package:firstproject/profitDetails.dart';
import 'package:firstproject/sellDetails.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  int productCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.home, size: 30),
      const Icon(Icons.category, size: 30),
      const Icon(Icons.person, size: 30),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(0, 247, 226, 226),
        height: 60,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: const Duration(milliseconds: 300),
        index: index,
        items: items,
        onTap: (int tappedIndex) {
          setState(() {
            index = tappedIndex;
          });
        },
      ),
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    switch (index) {
      case 0:
        return HomePageContent();
      case 1:
        return CategoryPage();
      case 2:
        return Profile(
);
      default:
        return const HomePage();
    }
  }
}
// ignore: must_be_immutable
class HomePageContent extends StatefulWidget {
  

  const HomePageContent({
    Key? key,
  }) : super(key: key);
  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

int productCount = 0;

class _HomePageContentState extends State<HomePageContent> {
  int totalPrice=0;
  @override
  void initState() {
    super.initState();
    Hive.openBox<SellProduct>('sell_products');
     Hive.openBox<ReturnProduct>('retunItems');
    getsellproduct();
    getReturn();
    getAllProducts();
    initData();
  }

  Future<void> initData() async {
    await getProductCount();
    await getTodayProfit();
  }


Future<double> getTodayProfit() async {
  try {
    final sellProductsBox = await Hive.openBox<SellProduct>('sell_products');
    print('Sell products count: ${sellProductsBox.length}');
    double todayProfit = 0;

    DateTime today = DateTime.now();
    for (int i = 0; i < sellProductsBox.length; i++) {
      SellProduct product = sellProductsBox.getAt(i)!;
      DateTime productDate = product.sellDate ?? DateTime.now();
      if (productDate.year == today.year &&
          productDate.month == today.month &&
          productDate.day == today.day) {
        todayProfit += double.parse(product.sellPrice);
      }
    }
    
    final returnbox = Hive.box<ReturnProduct>('retunItems');
    for (int j = 0; j < returnbox.length; j++) {
      ReturnProduct returnProduct = returnbox.getAt(j)!;
      if (returnProduct.returnDate?.year == today.year &&
          returnProduct.returnDate?.month == today.month &&
          returnProduct.returnDate?.day == today.day) {
        todayProfit -= double.parse(returnProduct.returnPrice);
      }
    }

    print('Today\'s Profit: $todayProfit');
  
   return todayProfit;
  } catch (e) {
    print('Error fetching today\'s profit: $e');
    return 0;
  }
}



  Future<void> getProductCount() async {
    try {
      final productBox = await Hive.openBox<Product>('product');
      // ignore: unnecessary_null_comparison
      if (productBox != null) {
        setState(() {
          productCount = productBox.length;
        });
        print('Product count: $productCount');
      } else {
        print('Error: subcategoryBox is null');
      }
    } catch (e) {
      print('Error fetching product count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          'EZFLOW',
          style: GoogleFonts.libreFranklin(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 2),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfitDetails()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height * 0.16,
                  width: MediaQuery.of(context).size.width * 0.92,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder<double>(
                          future: getTodayProfit(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text(
                                'Error fetching today\'s profit',
                              );
                            }
                            return Text(
                              'Today\'s Profit: ₹${snapshot.data}',
                              style: GoogleFonts.abel(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 13,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.43,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Stock',
                                    style: GoogleFonts.aleo(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${productCount}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total customers',
                                    style: GoogleFonts.aleo(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${sellListNotifier.value.length}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Returned',
                                    style: GoogleFonts.aleo(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${returnListNotifier.value.length}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductUpdates()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            height: MediaQuery.of(context).size.height * 0.14,
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: Center(
                                child: Text(
                              'Product Updates',
                              style: GoogleFonts.abel(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReturnPage()),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.40,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.autorenew_rounded,
                            size: 40,
                            color: const Color.fromARGB(255, 50, 50, 50),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Return Details',
                            style: GoogleFonts.arima(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellDetails(
                                    selectedProducts: [],
                                  )));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width * 0.92,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Sell Details',
                            style: GoogleFonts.arima(
                              fontSize: 16,
                              color: Color.fromARGB(255, 8, 8, 8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.article_outlined,
                            size: 40,
                            color: Color.fromARGB(255, 59, 59, 59),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
