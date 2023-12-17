import 'package:mmd2/use_case/action_use_case/action_uc.dart';
import 'package:mmd2/use_case/author_use_case/author_uc.dart';
import 'package:mmd2/use_case/browser_use_case/browser_uc.dart';

class AppUC {
  ActionUC get action => ActionUC();
  AuthorUC get author => AuthorUC();

  BrowserUC get browser => BrowserUC();
}