import 'package:mmd2/use_case/author_use_case/use_case/create_author_uc.dart';
import 'package:mmd2/use_case/author_use_case/use_case/get_paging_author_uc.dart';
import 'package:mmd2/use_case/author_use_case/use_case/preview_author_uc.dart';
import 'package:mmd2/use_case/author_use_case/use_case/update_author_uc.dart';

class AuthorUC {
  GetPagingAuthorUC get getPagingAuthor => GetPagingAuthorUC();
  CreateAuthorUC get createAuthor => CreateAuthorUC();
  UpdateAuthorUC get updateAuthor => UpdateAuthorUC();
  PreviewAuthorUC get previewAuthor => PreviewAuthorUC();
}