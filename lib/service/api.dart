
import 'dart:convert';

import 'package:http/http.dart' as http;



  const String url="https://dummyjson.com/users";

  Future<List<dynamic>> getData(int limit,int offset) async{

    String URL = "https://dummyjson.com/users?offset=$offset?limit=$limit";
    final response= await http.get(Uri.parse(URL));

    if(response.statusCode==200){
      Map<String,dynamic> data =jsonDecode(response.body);
      return  data['users'];

    }else{
      throw Exception('Failed to load users');
    }

  }

