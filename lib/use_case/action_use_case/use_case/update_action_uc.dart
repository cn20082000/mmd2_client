import 'package:mmd2/data/client/action_client.dart';
import 'package:mmd2/data/model/action_model.dart';
import 'package:mmd2/data/model/base_model.dart';

class UpdateActionUC {
  Future<BaseModel<ActionModel>?> invoke(ActionModel body) {
    return ActionClient().updateAction(body);
  }
}