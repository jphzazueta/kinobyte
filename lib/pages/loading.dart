import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Loading extends StatefulWidget {
  const Loading({super.key});

  // const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  Future<void> getData() async {
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/todos/1');
      http.Response response = await http.get(url);
      print(response.body);
      Map data = jsonDecode(response.body);
      print(data);
    }
    catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF06062B),
      body: Center(
        child: SpinKitFadingCube(
          color:Color(0xFFAFFFFF),
          size: 50.0
          )
      )
    );
  }
}