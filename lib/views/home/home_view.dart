import 'package:cln_common/cln_common.dart';
import 'package:clnapp/api/api.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/utils/error.dart';
import 'package:clnapp/views/app_view.dart';
import 'package:clnapp/views/home/info_view.dart';
import 'package:clnapp/views/home/paymentlist_view.dart';
import 'package:clnapp/views/setting/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/scheduler.dart';

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
    return FutureBuilder(
        future: Future.wait([
          widget.provider.get<AppApi>().getInfo(),
          widget.provider.get<AppApi>().listincome()
        ]),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
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
            var getInfo = snapshot.data[0];
            return SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(children: <Widget>[
                  /// For the balance of the node.
                  InfoView(
                    getinfo: getInfo,
                    provider: widget.provider,
                    income: snapshot.data[1],
                  ),

                  /// For the all the transaction of the node.
                  PaymentListView(
                    provider: widget.provider,
                    incomeList: snapshot.data[1],
                  ),
                ]));
          }

          /// Logging an error on the screen
          SchedulerBinding.instance.addPostFrameCallback((_) {
            PopUp.showPopUp(context, 'Oops an error occured', error!, true);
          });
          return const Center(
              child: Text(
            'Nothing to show here',
            style: TextStyle(fontSize: 30),
          ));
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
