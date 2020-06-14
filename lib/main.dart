import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'animations.dart';
import 'selection_widgets.dart';
import 'selection.dart';
import 'switcher.dart';

export 'selection_widgets.dart';
export 'selection.dart';
export 'switcher.dart';

const kPrimaryColor = Color(0xff4995f7);

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      home: Scaffold(
        body: App(),
      ),
    ),
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}

/// main app route with bookstore and location tabs
class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  SelectionController selectionController;
  TabController _tabController;

  final _tabs = [
    Tab(
      child: Text(
        "Bookstores",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    Tab(
      child: Text(
        "Location",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();

    // init selection controller
    selectionController = SelectionController<int>(
      selectionSet: {},
      switcher: IntSwitcher(),
      animationController:
          AnimationController(vsync: this, duration: kSelectionDuration),
    ) // subscribe to tile clicks to update the selection counter in the SelectionAppBar
      ..addListener(() {
        setState(() {});
      })
      // subscribe to selection status changes
      ..addStatusListener((status) {
        setState(() {});
      });

    _tabController =
        _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  void dispose() {
    selectionController.dispose();
    super.dispose();
  }

  Future<bool> _handlePop(BuildContext context) async {
    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.of(context).pop();
      return Future.value(false);
    } else if (selectionController.inSelection) {
      selectionController.close();
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final baseAnimation = CurvedAnimation(
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
      parent: selectionController.animationController,
    );
    final tapBarSlideAnimation = Tween(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -0.8),
    ).animate(baseAnimation);

    final selectionLength = selectionController.selectionSet.length > 0
        ? selectionController.selectionSet.length
        : 1;

    return Scaffold(
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor,
        ),
        child: Drawer(),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.0),
        child: SelectionAppBar(
          // creating our selection AppBar
          titleSpacing: 0.0,
          elevation: 0.0,
          elevationSelection: 2.0,
          selectionController: selectionController,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: () {},
            ),
          ],
          actionsSelection: [
            SizedBox.fromSize(size: const Size(48.0, 48.0)),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                // show deletion dialog....
              },
            ),
          ],
          title: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "Bookstore List Selection",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          titleSelection: Transform.translate(
            offset: const Offset(0, -1.1),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 4.1),
              child: CountSwitcher(
                // not letting to go less 1 to not play animation from 1 to 0
                childKey: ValueKey(selectionLength),
                valueIncreased: selectionController.lengthIncreased,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    // we prevented playing switch animation above, now restrict the value itself
                    selectionLength.toString(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Builder(
        builder: (context) => WillPopScope(
          onWillPop: () => _handlePop(context),
          child: Stack(
            children: <Widget>[
              AnimatedBuilder(
                animation: baseAnimation,
                child: TabBarView(
                  controller: _tabController,
                  // don't let user to switch tab by the swipe gesture when in selection
                  physics: selectionController.inSelection
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  children: <Widget>[
                    BookstoresListTab(selectionController: selectionController),
                    Center(child: Text("Locations")),
                  ],
                ),
                builder: (BuildContext context, Widget child) => Padding(
                  padding: EdgeInsets.only(
                      // offsetting the list back to top
                      top: 44.0 * (1 - baseAnimation.value)),
                  child: child,
                ),
              ),
              IgnorePointer(
                ignoring: selectionController.inSelection,
                child: FadeTransition(
                  opacity: ReverseAnimation(baseAnimation),
                  child: SlideTransition(
                    position: tapBarSlideAnimation,
                    child: Material(
                      elevation: 2.0,
                      color: Theme.of(context).primaryColor,
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.white,
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 15.0),
                        tabs: _tabs,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookstoresListTab extends StatefulWidget {
  BookstoresListTab({
    Key key,
    @required this.selectionController,
  }) : super(key: key);

  final SelectionController selectionController;

  @override
  _BookstoresListTabState createState() => _BookstoresListTabState();
}
