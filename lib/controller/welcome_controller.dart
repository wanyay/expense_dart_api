import 'package:aqueduct/aqueduct.dart';
import 'package:expense/expense.dart';

class WelcomeController extends ResourceController {
  @Operation.get()
  Future<Response> getIndex() async {
    var html = File("web/index.html").readAsStringSync();
    return Response.ok(html)..contentType = ContentType.html;
  }
}