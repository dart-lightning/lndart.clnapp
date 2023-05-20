import 'package:cln_common/cln_common.dart';
import 'package:clnapp/api/api.dart';
import 'package:clnapp/components/error.dart';
import 'package:clnapp/model/app_model/get_info.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/views/app_view.dart';
import 'package:clnapp/views/home/info_view.dart';
import 'package:clnapp/views/home/paymentlist_view.dart';
import 'package:clnapp/views/setting/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class HomeView extends StatefulAppView {
  const HomeView({Key? key, required AppProvider provider})
      : super(key: key, provider: provider);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  late final pages = [
    _buildMainView(context: context),
    SettingView(provider: widget.provider),
  ];

  Widget _buildMainView({required BuildContext context}) {
    return FutureBuilder<AppGetInfo>(
        future: widget.provider.get<AppApi>().getInfo(),
        builder: (context, AsyncSnapshot<AppGetInfo> snapshot) {
          String? error;
          if (snapshot.connectionState == ConnectionState.waiting) {
            /// This case can occur in the interval when the node is fetching
            /// the data.
            return const Center(
              child: Text('Loading...'),
            );
          }
          if (snapshot.hasError) {
            /// This error resonates with the user either not having his/her node up
            /// or the file they have chosen can't communicate with the server.
            LogManager.getInstance.error("${snapshot.error}");
            LogManager.getInstance.error("${snapshot.stackTrace}");
            error = snapshot.error!.toString();
          } else if (snapshot.hasData) {
            /// This is the case when the node is up and the provided parameters are
            /// correct.
            var getInfo = snapshot.data!;
            return SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(children: <Widget>[
                  /// For the balance of the node.
                  InfoView(getinfo: getInfo, provider: widget.provider),

                  /// For the all the transaction of the node.
                  PaymentListView(provider: widget.provider),
                ]));
          }

          /// Logging an error on the screen
          return ErrorContainer(errorText: error!);
        });
  }

  Widget _buildBottomNavigation() {
    return BottomNavyBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      selectedIndex: _currentIndex,
      showElevation: true,
      containerHeight: 68,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomNavyBarItem>[
        bottomNavyBar(title: 'Home', icon: Icons.home_filled),
        bottomNavyBar(title: 'Settings', icon: Icons.settings_outlined),
      ],
    );
  }

  BottomNavyBarItem bottomNavyBar(
      {required String title, required IconData icon}) {
    return BottomNavyBarItem(
      icon: Icon(icon),
      title: Text(title),
      textAlign: TextAlign.center,
      activeColor: Theme.of(context).colorScheme.primary,
      inactiveColor: Theme.of(context).highlightColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CLN App"),
        centerTitle: false,
        primary: true,
        elevation: 0,
        leading: Container(),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}
