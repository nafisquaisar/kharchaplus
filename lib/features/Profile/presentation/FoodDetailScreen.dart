import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodDetailScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Detail"),
      ),
      body: Center(
        child: Text("Food Detail Screen"),
      ),
    );
  }

}