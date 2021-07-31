import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/model/memo.dart';
import 'package:my_app/pages/add_edit_memo_page.dart';
import 'memo_page.dart';

class TopPage extends StatefulWidget {
  TopPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  CollectionReference? memos; // QueryDocumentSnapshotを使用していた

  Future<void> deleteMemo(String docId) async {
    var document = FirebaseFirestore.instance.collection('memo').doc(docId);
    document.delete();
  }


  // List<Memo> memoList = [];
  //
  // Future<void> getMemo() async {
  //   var snapshot = await FirebaseFirestore.instance.collection('memo').get(); // コレクション名の指定
  //   var docs = snapshot.docs; // ドキュメント名の指定
  //   docs.forEach((doc) {
  //     memoList.add(Memo(
  //       title: doc.data()['title'],
  //       detail: doc.data()['detail']
  //     ));
  //   });
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    memos = FirebaseFirestore.instance.collection('memo');
    // getMemo();
  }

  @override
  Widget build(BuildContext context) { // uiを描画
    return Scaffold( // uiの基盤になるようなデザイン
      appBar: AppBar(
        title: Text('Firebase × Flutter'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: memos?.snapshots(), // ドキュメントに値が入るとstreamが動く
        builder: (context, snapshot) { // そしてbuilderが動いていく
          if (snapshot.connectionState == ConnectionState.waiting) { // このif文でThe method '[]' was called on null. Receiver: nullを防ぐ
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length, // docsが取得できてなかったのでnullエラーが表示されていた
            itemBuilder: (context, index) {
              return ListTile(
                title: Text((snapshot.data?.docs[index].data() as dynamic)['title']),
                trailing: IconButton( // 編集のアイコン表示
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showModalBottomSheet(context: context, builder: (context) {
                      return SafeArea ( // wrap with widgetで少しの余白を追加
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // 編集・削除の表示の余白を最低限にするコード
                          children: [
                            ListTile(
                              leading: Icon(Icons.edit, color: Colors.blueAccent,),
                              title: Text('編集'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditMemoPage(memo: snapshot.data?.docs[index])));
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.delete, color: Colors.redAccent,),
                              title: Text('削除'),
                              onTap: () async {
                                await deleteMemo(snapshot.data!.docs[index].id);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    });
                  },
                ),
                onTap: () { // onTapでタップできるようになる
                  // 確認画面に遷移
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MemoPage(snapshot.data!.docs[index])));
                }
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton( // 右下の青いボタン
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditMemoPage()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
