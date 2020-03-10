import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

class Migration2 extends Migration {
  @override
  Future upgrade() async {
    database.createTable(SchemaTable("_Category", [
      SchemaColumn("id", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("name", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: true),
      SchemaColumn("createdAt", ManagedPropertyType.datetime,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: true,
          isUnique: false),
      SchemaColumn("updatedAt", ManagedPropertyType.datetime,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: true,
          isUnique: false)
    ]));
  }

  @override
  Future downgrade() async {}

  @override
  Future seed() async {
    final categories = ["Lunch", "Breakfast", "YBS", "Taxi", "Tea", "Smoking"];
    for (final category in categories) {
      await database.store.execute(
          "INSERT INTO _Category (name) VALUES (@name)",
          substitutionValues: {"name": category});
    }
  }
}
