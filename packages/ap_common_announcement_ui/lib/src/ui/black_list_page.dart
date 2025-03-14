import 'package:ap_common_announcement_ui/src/api/announcement_helper.dart';
import 'package:ap_common_flutter_ui/ap_common_flutter_ui.dart';
import 'package:flutter/material.dart';

enum _State { loading, done, error }

class BlackListPage extends StatefulWidget {
  const BlackListPage({super.key});

  @override
  State<BlackListPage> createState() => _BlackListPageState();
}

class _BlackListPageState extends State<BlackListPage> {
  _State state = _State.loading;
  List<String> blackList = <String>[];

  @override
  void initState() {
    Future<dynamic>.microtask(
      () => _getData(),
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ApLocalizations.of(context).blackList),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    final ApLocalizations ap = ApLocalizations.of(context);
    switch (state) {
      case _State.loading:
        return Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      case _State.error:
        return InkWell(
          onTap: () {
            _getData();
          },
          child: HintContent(
            icon: ApIcon.classIcon,
            content: ap.clickToRetry,
          ),
        );
      case _State.done:
        return ListView.separated(
          itemCount: blackList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(blackList[index]),
              trailing: IconButton(
                onPressed: () =>
                    _removeFromBlackList(username: blackList[index]),
                icon: Icon(
                  Icons.delete_forever_outlined,
                  color: ApTheme.of(context).red,
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
        );
    }
  }

  void _getData() {
    setState(() => state = _State.loading);
    AnnouncementHelper.instance.getBlackList(
      // ignore: always_specify_types
      callback: GeneralCallback(
        onSuccess: (List<String> data) {
          blackList = data;
          setState(() => state = _State.done);
        },
        onFailure: (DioException e) {
          Toast.show(e.i18nMessage, context);
          setState(() => state = _State.error);
        },
        onError: (GeneralResponse response) {
          Toast.show(response.message, context);
          setState(() => state = _State.error);
        },
      ),
    );
  }

  void _removeFromBlackList({
    required String username,
  }) {
    setState(() => state = _State.loading);
    AnnouncementHelper.instance.removeFromBlackList(
      username: username,
      // ignore: always_specify_types
      callback: GeneralCallback(
        onSuccess: (_) {
          Toast.show(ApLocalizations.current.updateSuccess, context);
          setState(() => state = _State.done);
        },
        onFailure: (DioException e) {
          Toast.show(e.i18nMessage, context);
          setState(() => state = _State.done);
        },
        onError: (GeneralResponse response) {
          Toast.show(response.message, context);
          setState(() => state = _State.done);
        },
      ),
    );
  }
}
