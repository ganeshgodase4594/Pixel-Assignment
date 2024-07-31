
import 'package:flutter/material.dart';
import 'package:pixel_assignment/provider/pagination_provider.dart';
import 'package:provider/provider.dart';

import 'screen/screen.dart';


void main(){
  runApp(

   
    MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (_) =>DataPagination()),

    ],
    child: const MyApp(),
    ),
    
  );
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EmployeeListScreen(),
    );
  }
}

