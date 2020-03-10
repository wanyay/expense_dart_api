import 'package:expense/expense.dart';
import 'package:expense/model/User.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterController extends ResourceController {
  RegisterController(this.context, this.authServer);

  final ManagedContext context;
  final AuthServer authServer;

  @Operation.post()
  Future<Response> createUser(@Bind.body() User user) async {
    if (user.username == null || user.password == null) {
      return Response.badRequest(
        body: {"error": "username and password required."}
      );
    }
    user
      ..salt = AuthUtility.generateRandomSalt()
      ..hashedPassword = authServer.hashPassword(user.password, user.salt);

    final savedUser = await Query(context, values: user).insert();

    const clientID = "com.expense.wanyay";
    final username = user.username;
    final password = user.password;
    final body = "username=$username&password=$password&grant_type=password";

    final String clientCredentials = const Base64Encoder().convert("$clientID:".codeUnits);

    if(savedUser is User) {
      final http.Response response = await http.post("http://localhost:8888/auth/token",
          headers: {
            "Content-Type": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic $clientCredentials"
          },
          body: body
      );

      Map<String, dynamic> map = json.decode(response.body) as Map<String, dynamic>;
      return Response.ok(map);
    }else {
      return Response.serverError();
    }
  }
}