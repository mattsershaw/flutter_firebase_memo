class Memo {
  String title; // ?はnullable
  String detail;
  DateTime? createdTime;
  DateTime? updatedDate;

  Memo({required this.title, required this.detail, this.createdTime, this.updatedDate});
}

// void a() {
//   Memo(title: 'test', detail: 'テストです', createdTime: DateTime.now());
// }
