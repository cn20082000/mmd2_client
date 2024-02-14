import 'package:mmd2/use_case/author_use_case/use_case/create_author_uc.dart';
import 'package:mmd2/use_case/author_use_case/use_case/get_paging_author_uc.dart';
import 'package:mmd2/use_case/author_use_case/use_case/preview_author_uc.dart';
import 'package:mmd2/use_case/author_use_case/use_case/sync_video_uc.dart';
import 'package:mmd2/use_case/author_use_case/use_case/update_author_uc.dart';

class AuthorUC {
  GetPagingAuthorUC get getPaging => GetPagingAuthorUC();
  CreateAuthorUC get create => CreateAuthorUC();
  UpdateAuthorUC get update => UpdateAuthorUC();
  PreviewAuthorUC get preview => PreviewAuthorUC();
  SyncVideoUC get syncVideo => SyncVideoUC();
}