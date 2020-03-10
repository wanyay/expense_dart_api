import 'package:aqueduct/managed_auth.dart';
import 'package:expense/controller/auth/ProfileController.dart';
import 'package:expense/controller/auth/login_controller.dart';
import 'package:expense/controller/auth/register_controller.dart';
import 'package:expense/controller/category_controller.dart';
import 'package:expense/model/User.dart';

import 'expense.dart';

class ExpenseChannel extends ApplicationChannel {

  ManagedContext context;
  AuthServer authServer;
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    final config = ExpenseConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);

    context = ManagedContext(dataModel, persistentStore);

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router
      .route('/api/v1/login')
      .link(() => LoginController(context));

    router
      .route('/api/v1/logout')
      .link(() => Authorizer.bearer(authServer))
      .link(() => LoginController(context));

    router
        .route('/api/v1/auth/token')
        .link(() => AuthController(authServer));

    router
        .route('/api/v1/register')
        .link(() => RegisterController(context, authServer));

    router
        .route("/api/v1/profile")
        .link(() => Authorizer.bearer(authServer))
        .link(() => ProfileController(context));

    router
        .route('/api/v1/categories')
        .link(() => CategoryController(context));


    return router;
  }
}

class ExpenseConfig extends Configuration {
  ExpenseConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
