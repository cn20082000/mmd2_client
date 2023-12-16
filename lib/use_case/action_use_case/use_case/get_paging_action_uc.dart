import 'package:mmd2/data/client/action_client.dart';
import 'package:mmd2/data/model/action_model.dart';
import 'package:mmd2/data/model/base_model.dart';

class GetPagingActionUC {
  Future<BaseModel<PagingModel<ActionModel>>?> invoke(int pageIndex, int pageSize) {
    return ActionClient().getPagingAction(pageIndex, pageSize);
  }
}