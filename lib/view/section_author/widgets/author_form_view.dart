import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mmd2/common/app.dart';
import 'package:mmd2/common/constants.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/util/extension/string_ext.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorFormView extends StatefulWidget {
  final String title;
  final AuthorModel? item;
  final Future<AuthorModel?> Function(AuthorModel)? onPreview;
  final void Function(AuthorModel)? onDone;

  const AuthorFormView({super.key, required this.title, this.item, this.onDone, this.onPreview});

  @override
  State<AuthorFormView> createState() => _AuthorFormViewState();
}

class _AuthorFormViewState extends State<AuthorFormView> {
  AuthorModel? item;

  final profileRelativeUrlCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final profileUrlCtrl = TextEditingController();
  final avatarUrlCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final statusCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    item = widget.item;
    profileRelativeUrlCtrl.text = item?.profileRelativeUrl ?? "";
    nameCtrl.text = item?.name ?? "";
    profileUrlCtrl.text = item?.profileUrl ?? "";
    avatarUrlCtrl.text = item?.avatarUrl ?? "";
    descriptionCtrl.text = item?.description ?? "";
    statusCtrl.text = item?.isAlive == true ? "Alive" : "Dead";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: profileRelativeUrlCtrl,
                    autofocus: true,
                    textInputAction: TextInputAction.none,
                    maxLength: 255,
                    decoration: const InputDecoration(
                      labelText: "Profile relative url",
                    ),
                    onSubmitted: (_) => _previewAuthor(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _previewAuthor(),
                  icon: const Icon(Icons.refresh),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (item?.avatarUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 84,
                      width: 84,
                      child: CachedNetworkImage(
                        imageUrl: (item?.avatarUrl).nullOrEmpty(Constants.defaultImage),
                        httpHeaders: App.additionHeader,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const Placeholder(),
                      ),
                    ),
                  ),
                if (item?.avatarUrl != null) const SizedBox(width: 16),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameCtrl,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Name",
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: profileUrlCtrl,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: "Profile url",
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              launchUrl(Uri.parse(profileUrlCtrl.text));
                            },
                            icon: const Icon(Icons.call_made),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            TextField(
              controller: descriptionCtrl,
              readOnly: true,
              minLines: 1,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),
            TextField(
              controller: statusCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Status",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            widget.onDone?.call(_buildAuthor);
            Navigator.pop(context);
          },
          child: const Text("Done"),
        ),
      ],
    );
  }

  AuthorModel get _buildAuthor => AuthorModel(
        id: item?.id,
        profileRelativeUrl: profileRelativeUrlCtrl.text.trim(),
      );

  Future<void> _previewAuthor() async {
    final previewItem = await widget.onPreview?.call(_buildAuthor);

    setState(() {
      item = previewItem;
    });
    nameCtrl.text = item?.name ?? "";
    profileUrlCtrl.text = item?.profileUrl ?? "";
    avatarUrlCtrl.text = item?.avatarUrl ?? "";
    descriptionCtrl.text = item?.description ?? "";
    statusCtrl.text = item?.isAlive == true ? "Alive" : "Dead";
  }
}
