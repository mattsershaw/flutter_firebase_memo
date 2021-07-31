import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/model/memo.dart';

class MemoPage extends StatelessWidget {
  final QueryDocumentSnapshot memo;
  MemoPage(this.memo);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((memo.data() as dynamic)['title']), // エラー回収済み(Error: The operator '[]' isn't defined for the class 'Object?'.)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('メモ内容', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Text((memo.data() as dynamic)['detail'], style: TextStyle(fontSize: 18),)
          ],
        ),
      ),
    );
  }
}
