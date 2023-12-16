import 'package:mmd2/use_case/action_use_case/action_uc.dart';
import 'package:mmd2/use_case/browser_use_case/browser_uc.dart';

class AppUC {
  ActionUC get action => ActionUC();

  BrowserUC get browser => BrowserUC();
}