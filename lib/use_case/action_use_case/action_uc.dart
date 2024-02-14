import 'package:mmd2/use_case/action_use_case/use_case/create_action_uc.dart';
import 'package:mmd2/use_case/action_use_case/use_case/get_paging_action_uc.dart';
import 'package:mmd2/use_case/action_use_case/use_case/update_action_uc.dart';

class ActionUC {
  GetPagingActionUC get getPaging => GetPagingActionUC();
  CreateActionUC get create => CreateActionUC();
  UpdateActionUC get update => UpdateActionUC();
}