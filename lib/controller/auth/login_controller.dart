import 'package:aqueduct/managed_auth.dart';
import 'package:expense/expense.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginController extends ResourceController {
  LoginController(this.context);

  final ManagedContext context;
  @Operation.post()
  Future<Response> createToken() async {
    final Map<String, dynamic> data = await request.body.decode();
    const clientID = "com.expense.wanyay";
    final username = data['username'];
    final password = data['password'];
    final body = "username=$username&password=$password&grant_type=password";

    final String clientCredentials =
        const Base64Encoder().convert("$clientID:".codeUnits);

    final http.Response response =
        await http.post("http://localhost:8888/api/v1/auth/token",
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
              "Authorization": "Basic $clientCredentials",
              "Accept": "application/json"
            },
            body: body);
    final Map<String, dynamic> map =
        json.decode(response.body) as Map<String, dynamic>;
    return Response.ok(map);
  }

  @Operation.delete()
  Future<Response> deleteTokens() async {
    final userId = request.authorization.ownerID;
    final query = Query<ManagedAuthToken>(context)
      ..where((token) => token.resourceOwner).identifiedBy(userId);
    final count = await query.delete();

    return Response.ok({"userId": userId, "tokensDeleted": count});
  }
}
