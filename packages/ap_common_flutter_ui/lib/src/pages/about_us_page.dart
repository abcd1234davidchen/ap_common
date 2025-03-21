import 'package:ap_common_flutter_ui/ap_common_flutter_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({
    super.key,
    required this.assetImage,
    required this.fbFanPageUrl,
    required this.fbFanPageId,
    this.instagramUsername,
    required this.githubUrl,
    required this.githubName,
    required this.email,
    required this.appLicense,
    this.actions,
    this.applicationName,
    this.applicationVersion,
    this.applicationIcon,
    this.applicationLegalese,
  });

  /// /about
  static const String routerName = '/about';
  final String assetImage;
  final String fbFanPageUrl;
  final String fbFanPageId;
  final String? instagramUsername;
  final String githubUrl;
  final String githubName;
  final String email;
  final String appLicense;
  final String? applicationName;
  final String? applicationVersion;
  final Widget? applicationIcon;
  final String? applicationLegalese;
  final List<Widget>? actions;

  @override
  AboutUsPageState createState() => AboutUsPageState();
}

class AboutUsPageState extends State<AboutUsPage> {
  ApLocalizations get app => ApLocalizations.of(context);

  @override
  void initState() {
    AnalyticsUtil.instance.setCurrentScreen(
      'AboutUsPage',
      'about_us_page.dart',
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double expandedHeight = MediaQuery.of(context).size.height * 0.25;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: expandedHeight,
            pinned: true,
            title: Text(app.about),
            actions: <Widget>[
              ...widget.actions ?? <Widget>[],
              IconButton(
                icon: Icon(ApIcon.codeIcon),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => LicensePage(
                        applicationName: widget.applicationName,
                        applicationVersion: widget.applicationVersion,
                        applicationIcon: widget.applicationIcon,
                        applicationLegalese: widget.applicationLegalese,
                      ),
                    ),
                  );
                  AnalyticsUtil.instance.logEvent('license_page_click');
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                widget.assetImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                _item(app.aboutAuthorTitle, app.aboutAuthorContent),
                _item(app.about, app.aboutUsContent),
                _item(app.aboutRecruitTitle, app.aboutRecruitContent),
                Stack(
                  children: <Widget>[
                    _item(app.aboutItcTitle, app.aboutItcContent),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 26.0,
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          ApImageAssets.gdgOnCampusNkustItc,
                          width: 64.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    _item(
                      app.aboutNsysuCodeClubTitle,
                      app.aboutNsysuCodeClubContent,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 26.0,
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          ApImageAssets.nsysuGdsc,
                          width: 64.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      left: 16.0,
                      bottom: 16.0,
                      right: 16.0,
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SelectableText(
                          app.aboutContactUsTitle,
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: Image.asset(ApImageAssets.fb),
                                onPressed: () {
                                  PlatformUtil.instance.launchUrl(
                                    'https://m.me/${widget.fbFanPageId}',
                                  );
                                  AnalyticsUtil.instance.logEvent('fb_click');
                                },
                                iconSize: 48.0,
                              ),
                              if (widget.instagramUsername
                                  case final String username?)
                                IconButton(
                                  icon: Image.asset(ApImageAssets.instagram),
                                  onPressed: () {
                                    PlatformUtil.instance.launchUrl(
                                      'https://ig.me/m/$username',
                                    );
                                    AnalyticsUtil.instance
                                        .logEvent('instagram_click');
                                  },
                                  iconSize: 48.0,
                                ),
                              IconButton(
                                icon: Image.asset(ApImageAssets.github),
                                onPressed: () {
                                  PlatformUtil.instance
                                      .launchUrl(widget.githubUrl)
                                      .catchError(
                                    (dynamic onError) {
                                      if (!context.mounted) return;
                                      UiUtil.instance.showToast(
                                        context,
                                        app.platformError,
                                      );
                                    },
                                  );
                                  AnalyticsUtil.instance
                                      .logEvent('github_click');
                                },
                                iconSize: 48.0,
                              ),
                              IconButton(
                                icon: Image.asset(ApImageAssets.email),
                                onPressed: () {
                                  PlatformUtil.instance
                                      .launchUrl('mailto:${widget.email}')
                                      .catchError(
                                    (dynamic onError) {
                                      if (!context.mounted) return;
                                      UiUtil.instance.showToast(
                                        context,
                                        app.platformError,
                                      );
                                    },
                                  );
                                  AnalyticsUtil.instance
                                      .logEvent('email_click');
                                },
                                iconSize: 48.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _item(app.aboutOpenSourceTitle, widget.appLicense),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(String text, String subText) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.only(
            top: 24.0,
            left: 16.0,
            bottom: 16.0,
            right: 16.0,
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 52.0),
                child: SelectableLinkify(
                  text: text,
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              SelectableLinkify(
                text: subText,
                style: TextStyle(
                  fontSize: 14.0,
                  color: ApTheme.of(context).grey,
                ),
                options: const LinkifyOptions(humanize: false),
                onOpen: (LinkableElement link) async =>
                    PlatformUtil.instance.launchUrl(link.url),
              ),
            ],
          ),
        ),
      );
}
