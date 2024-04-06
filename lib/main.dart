
import 'package:firstproject/db/data_model.dart';
import 'package:firstproject/spashScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';


Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
Hive.initFlutter();

if(!Hive.isAdapterRegistered(AddModelAdapter().typeId)){
  Hive.registerAdapter(AddModelAdapter());

}
if(!Hive.isAdapterRegistered(ProductAdapter().typeId)){
  Hive.registerAdapter(ProductAdapter());
}
if(!Hive.isAdapterRegistered(SellProductAdapter().typeId)){
  Hive.registerAdapter(SellProductAdapter());
}
if(!Hive.isAdapterRegistered(ReturnProductAdapter().typeId)){
  Hive.registerAdapter(ReturnProductAdapter());
}


  runApp(const HomeApp());
}  
class HomeApp extends StatelessWidget {

const HomeApp({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
  debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
