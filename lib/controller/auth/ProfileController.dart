import 'package:expense/expense.dart';
import 'package:expense/model/User.dart';

class ProfileController extends ResourceController {
  ProfileController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getProfile() async {
    final id = request.authorization.ownerID;
    final query = Query<User>(context)
      ..where((u) => u.id).equalTo(id);

    return Response.ok(await query.fetchOne());
  }
}