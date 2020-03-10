import 'harness/app.dart';

void main() {
  final harness = Harness()..install();

  test("GET /register returns 200 OK", () async {
    final response = await harness.agent.post("/register",
      body: {
        'username': "wanyay",
        'password': "m@thibuu"
      }
    );
    expectResponse(response, 200, body: {
      "id": greaterThan(0),
      "username": "wanyay"
    });
  });
}