import 'package:expense/expense.dart';

class Category extends ManagedObject<_Category> implements _Category {
  @override
  void willInsert() {
    createdAt = DateTime.now().toUtc();
  }

  @override
  void willUpdate() {
    updatedAt = DateTime.now().toUtc();
  }
}

class _Category {
  @primaryKey
  int id;

  @Column(unique: true)
  String name;

  @Column(nullable: true)
  DateTime createdAt;
  
  @Column(nullable: true)
  DateTime updatedAt;
}