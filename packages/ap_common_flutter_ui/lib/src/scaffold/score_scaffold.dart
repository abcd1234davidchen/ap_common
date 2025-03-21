import 'package:ap_common_flutter_ui/ap_common_flutter_ui.dart';
import 'package:flutter/material.dart';

enum ScoreState { loading, finish, error, empty, offlineEmpty, custom }

class ScoreScaffold extends StatefulWidget {
  const ScoreScaffold({
    super.key,
    required this.state,
    required this.scoreData,
    required this.onRefresh,
    this.title,
    this.itemPicker,
    this.semesterData,
    this.onSelect,
    this.onSearchButtonClick,
    this.middleTitle,
    this.finalTitle,
    this.onScoreSelect,
    this.middleScoreBuilder,
    this.finalScoreBuilder,
    this.customHint,
    this.isShowSearchButton = false,
    this.details,
    this.bottom,
    this.customStateHint,
  });
  static const String routerName = '/score';

  final ScoreState state;
  final String? customStateHint;
  final String? title;
  final ScoreData? scoreData;
  final SemesterData? semesterData;
  final Function(int index)? onSelect;
  final Function()? onSearchButtonClick;
  final Function()? onRefresh;
  final Widget? itemPicker;
  final String? middleTitle;
  final String? finalTitle;
  final Function(int index)? onScoreSelect;
  final Widget Function(int index)? middleScoreBuilder;
  final Widget Function(int index)? finalScoreBuilder;
  final List<String>? details;

  final bool isShowSearchButton;

  final String? customHint;

  final Widget? bottom;

  @override
  ScoreScaffoldState createState() => ScoreScaffoldState();
}

class ScoreScaffoldState extends State<ScoreScaffold> {
  ApLocalizations get app => ApLocalizations.of(context);

  @override
  void initState() {
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
        title: Text(widget.title ?? app.score),
        bottom: widget.bottom as PreferredSizeWidget?,
      ),
      floatingActionButton: widget.isShowSearchButton
          ? FloatingActionButton(
              onPressed: () {
                _pickSemester();
                AnalyticsUtil.instance.logEvent('score_search_button_click');
              },
              child: const Icon(Icons.search),
            )
          : null,
      body: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const SizedBox(height: 8.0),
          if (widget.semesterData != null && widget.itemPicker == null)
            ItemPicker(
              dialogTitle: app.pickSemester,
              onSelected: widget.onSelect,
              items: widget.semesterData!.semesters,
              currentIndex: widget.semesterData!.currentIndex,
              featureTag: 'score',
            ),
          if (widget.itemPicker != null) widget.itemPicker!,
          if (widget.customHint != null && widget.customHint!.isNotEmpty)
            Text(
              widget.customHint!,
              style: TextStyle(color: ApTheme.of(context).grey),
              textAlign: TextAlign.center,
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await widget.onRefresh?.call();
                AnalyticsUtil.instance.logEvent('score_refresh');
                return;
              },
              child: _body(),
            ),
          ),
        ],
      ),
    );
  }

  String get hintContent {
    switch (widget.state) {
      case ScoreState.error:
        return app.clickToRetry;
      case ScoreState.empty:
        return app.scoreEmpty;
      case ScoreState.offlineEmpty:
        return app.noOfflineData;
      case ScoreState.custom:
        return widget.customStateHint ?? app.unknownError;
      default:
        return '';
    }
  }

  Widget _body() {
    switch (widget.state) {
      case ScoreState.loading:
        return Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      case ScoreState.error:
      case ScoreState.empty:
      case ScoreState.custom:
      case ScoreState.offlineEmpty:
        return InkWell(
          onTap: () {
            if (widget.state == ScoreState.empty) {
              _pickSemester();
            } else {
              widget.onRefresh?.call();
            }
          },
          child: HintContent(
            icon: ApIcon.assignment,
            content: hintContent,
          ),
        );
      default:
        return ScoreContent(
          scoreData: widget.scoreData,
          onRefresh: widget.onRefresh,
          middleTitle: widget.middleTitle,
          finalTitle: widget.finalTitle,
          onScoreSelect: widget.onScoreSelect,
          middleScoreBuilder: widget.middleScoreBuilder,
          finalScoreBuilder: widget.finalScoreBuilder,
          details: widget.details,
        );
    }
  }

  void _pickSemester() {
    if (widget.semesterData != null) {
      showDialog(
        context: context,
        builder: (_) => SimpleOptionDialog(
          title: app.pickSemester,
          items: widget.semesterData!.semesters,
          index: widget.semesterData!.currentIndex,
          onSelected: widget.onSelect,
        ),
      );
    }
    widget.onSearchButtonClick?.call();
  }
}

class ScoreContent extends StatefulWidget {
  const ScoreContent({
    super.key,
    required this.scoreData,
    this.onRefresh,
    this.middleTitle,
    this.finalTitle,
    this.onScoreSelect,
    this.middleScoreBuilder,
    this.finalScoreBuilder,
    this.details,
  });

  final ScoreData? scoreData;
  final Function()? onRefresh;
  final String? middleTitle;
  final String? finalTitle;
  final Function(int index)? onScoreSelect;
  final Widget Function(int index)? middleScoreBuilder;
  final Widget Function(int index)? finalScoreBuilder;
  final List<String>? details;

  @override
  _ScoreContentState createState() => _ScoreContentState();
}

class _ScoreContentState extends State<ScoreContent> {
  TextStyle get _textBlueStyle =>
      TextStyle(color: ApTheme.of(context).blueText, fontSize: 16.0);

  TextStyle get _textStyle => const TextStyle(fontSize: 15.0);

  BoxDecoration get _boxDecoration => BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            10.0,
          ),
        ),
        border: Border.all(color: Colors.grey, width: 1.5),
      );

  TableBorder get _tableBorder => const TableBorder.symmetric(
        inside: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      );

  bool get isTablet =>
      MediaQuery.of(context).size.shortestSide >= 680 ||
      MediaQuery.of(context).orientation == Orientation.landscape;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Flex(
          direction: isTablet ? Axis.horizontal : Axis.vertical,
          children: <Widget>[
            Flexible(
              flex: isTablet ? 2 : 0,
              child: DecoratedBox(
                decoration: _boxDecoration,
                child: Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(2.5),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: _tableBorder,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        ScoreTextBorder(
                          text: ApLocalizations.of(context).subject,
                          style: _textBlueStyle,
                        ),
                        ScoreTextBorder(
                          text: widget.middleTitle ??
                              ApLocalizations.of(context).midtermScoreTitle,
                          style: _textBlueStyle,
                        ),
                        ScoreTextBorder(
                          text: widget.finalTitle ??
                              ApLocalizations.of(context).semesterScoreTitle,
                          style: _textBlueStyle,
                        ),
                      ],
                    ),
                    for (int i = 0; i < widget.scoreData!.scores.length; i++)
                      TableRow(
                        children: <Widget>[
                          ScoreTextBorder(
                            text: widget.scoreData!.scores[i].title,
                            style: _textStyle,
                            onTap: (widget.onScoreSelect != null)
                                ? () {
                                    widget.onScoreSelect!(i);
                                    AnalyticsUtil.instance
                                        .logEvent('score_title_click');
                                  }
                                : null,
                          ),
                          if (widget.middleScoreBuilder == null)
                            ScoreTextBorder(
                              text: widget.scoreData!.scores[i].middleScore,
                              style: _textStyle,
                            ),
                          if (widget.middleScoreBuilder != null)
                            widget.middleScoreBuilder!(i),
                          if (widget.finalScoreBuilder == null)
                            ScoreTextBorder(
                              text: widget.scoreData!.scores[i].semesterScore,
                              style: _textStyle,
                            ),
                          if (widget.finalScoreBuilder != null)
                            widget.finalScoreBuilder!(i),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: isTablet ? 0.0 : 20.0,
              width: isTablet ? 20 : 0.0,
            ),
            if (widget.details != null && widget.details!.isNotEmpty)
              Flexible(
                flex: isTablet ? 1 : 0,
                child: DecoratedBox(
                  decoration: _boxDecoration,
                  child: Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: _tableBorder,
                    children: <TableRow>[
                      for (final String text in widget.details!)
                        TableRow(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(2.0),
                              alignment: Alignment.center,
                              child: SelectableText(
                                text,
                                textAlign: TextAlign.center,
                                style: _textBlueStyle,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ScoreTextBorder extends StatelessWidget {
  const ScoreTextBorder({
    super.key,
    required this.text,
    required this.style,
    this.onTap,
  });
  final String? text;
  final TextStyle style;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        alignment: Alignment.center,
        child: SelectableText(
          text ?? '',
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );
  }
}

/*
class ScoreCardContent extends StatefulWidget {
  const ScoreCardContent({
    super.key,
    required this.scoreData,
    this.onRefresh,
    this.middleTitle,
    this.finalTitle,
    this.onScoreSelect,
    this.middleScoreBuilder,
    this.finalScoreBuilder,
    this.details,
  });

  final ScoreData? scoreData;
  final Function()? onRefresh;
  final String? middleTitle;
  final String? finalTitle;
  final Function(int index)? onScoreSelect;
  final Widget Function(int index)? middleScoreBuilder;
  final Widget Function(int index)? finalScoreBuilder;
  final List<String>? details;

  @override
  _ScoreCardContentState createState() => _ScoreCardContentState();
}

class _ScoreCardContentState extends State<ScoreCardContent> {
  TextStyle get _textPrimaryStyle => TextStyle(
      color: ApTheme.of(context).blueText,
      fontSize: 16.0,
      fontWeight: FontWeight.w600);

  TextStyle get _textSecondaryStyle =>
      const TextStyle(color: ApColors.secondary, fontSize: 16.0);

  TextStyle get _textStyle => const TextStyle(fontSize: 15.0);

  bool get isTablet =>
      MediaQuery.of(context).size.shortestSide >= 680 ||
      MediaQuery.of(context).orientation == Orientation.landscape;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.scoreData!.scores.length,
      itemBuilder: (_, int index) {
        return Card(
          //elevation: 4.0,
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 24.0,
            ),
            title: Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.scoreData!.scores[index].title,
                        style: _textPrimaryStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            (widget.middleTitle ??
                                    ApLocalizations.of(context)
                                        .midtermScoreTitle) +
                                (widget.middleScoreBuilder != null
                                    ? ''
                                    : ' : ${widget.scoreData!.scores[index].middleScore ?? ''}'),
                            style: _textSecondaryStyle,
                          ),
                          if (widget.middleScoreBuilder != null)
                            widget.middleScoreBuilder!(index),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      if (widget.finalScoreBuilder == null)
                        Text(
                          widget.scoreData!.scores[index].semesterScore ?? '',
                          style: _textStyle,
                        ),
                      if (widget.finalScoreBuilder != null)
                        widget.finalScoreBuilder!(index),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
*/
