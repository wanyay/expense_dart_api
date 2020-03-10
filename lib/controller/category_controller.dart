import 'package:expense/expense.dart';
import 'package:expense/model/Category.dart';

class CategoryController extends ResourceController {

  CategoryController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAll() async {
    final categoryQuery = Query<Category>(context);
    final categories = await categoryQuery.fetch();
    return Response.ok(categories);
  }
}