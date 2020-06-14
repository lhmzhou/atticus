import 'package:flutter/material.dart';
import 'main.dart';

const Duration kSelectionDuration = Duration(milliseconds: 500);
const double kIconButtonIconSize = 24.0;

/// button that shows menu and close buttons, convenient to use with [SelectionAppBar].
class AnimatedMenuCloseButton extends StatefulWidget {
  AnimatedMenuCloseButton({
    Key key,
    this.animateDirection,
    this.iconSize,
    this.iconColor,
    this.onMenuClick,
    this.onCloseClick,
  }) : super(key: key);

  /// if true, on mount will animate to close icon.
  /// else will animate backwards.
  /// if omitted - menu icon will be shown on mount without any animation.
  final bool animateDirection;
  final double iconSize;
  final Color iconColor;

  /// handle click when menu is shown
  final Function onMenuClick;

  /// handle click when close icon is shown
  final Function onCloseClick;

  AnimatedMenuCloseButtonState createState() => AnimatedMenuCloseButtonState();
}

class AnimatedMenuCloseButtonState extends State<AnimatedMenuCloseButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: kSelectionDuration);
    _animation =
        CurveTween(curve: Curves.easeOut).animate(_animationController);

    if (widget.animateDirection != null) {
      if (widget.animateDirection) {
        _animationController.forward();
      } else {
        _animationController.value = 0.0;
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: widget.iconSize ?? kIconButtonIconSize,
      onPressed: widget.animateDirection == true
          ? widget.onCloseClick
          : widget.onMenuClick,
      icon: AnimatedIcon(
        icon: widget.animateDirection == null || widget.animateDirection == true
            ? AnimatedIcons.menu_close
            : AnimatedIcons.close_menu,
        color: widget.iconColor,
        progress: _animation,
      ),
    );
  }
}

/// an [AppBar] has the properties to specify how it will look in the selection mode.
/// Also performs a fade switch animation while switching in and out of the selection mode.
class SelectionAppBar extends AppBar {
  SelectionAppBar({
    Key key,
    @required SelectionController selectionController,
    @required Widget storeName,

    /// store name to show in selection
    @required Widget storeNameSelection,
    @required List<Widget> actions,

    /// actions to show in selection
    @required List<Widget> actionsSelection,

    /// go to selection animation
    Curve curve = Curves.easeOutCubic,

    /// back from selection animation
    Curve reverseCurve = Curves.easeInCubic,
    bool automaticallyImplyLeading = true,
    Widget flexibleSpace,
    PreferredSizeWidget bottom,
    double elevation = 2.0,

    /// elevation in selection
    double elevationSelection = 2.0,
    ShapeBorder shape,
    Color backgroundColor,
    Brightness brightness,
    IconThemeData iconTheme,
    IconThemeData actionsIconTheme,
    TextTheme textTheme,
    bool primary = true,
    bool centerTitle,
    bool excludeHeaderSemantics = false,
    double titleSpacing = NavigationToolbar.kMiddleSpacing,
    double toolbarOpacity = 1.0,
    double bottomOpacity = 1.0,
  }) : super(
          key: key,
          leading: AnimatedBuilder(
            animation: selectionController.animationController,
            builder: (BuildContext context, Widget child) {
              final bool inSelection = !selectionController.wasEverSelected
                  ? null
                  : selectionController.inSelection;
              return AnimatedMenuCloseButton(
                key: ValueKey(inSelection),
                animateDirection: inSelection,
                onCloseClick: selectionController.close,
                onMenuClick: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          storeName: AnimationSwitcher(
            animation: CurvedAnimation(
              curve: curve,
              reverseCurve: reverseCurve,
              parent: selectionController.animationController,
            ),
            child1: storeName,
            child2: storeNameSelection,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: AnimationSwitcher(
                animation: CurvedAnimation(
                  curve: curve,
                  reverseCurve: reverseCurve,
                  parent: selectionController.animationController,
                ),
                child1: Row(children: actions),
                child2: Row(children: actionsSelection),
              ),
            ),
          ],
          automaticallyImplyLeading: automaticallyImplyLeading,
          flexibleSpace: flexibleSpace,
          bottom: bottom,
          elevation:
              selectionController.inSelection ? elevationSelection : elevation,
          shape: shape,
          backgroundColor: backgroundColor,
          brightness: brightness,
          iconTheme: iconTheme,
          actionsIconTheme: actionsIconTheme,
          textTheme: textTheme,
          primary: primary,
          centerTitle: centerTitle,
          excludeHeaderSemantics: excludeHeaderSemantics,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: bottomOpacity,
        );
}


class SelectableBookstoreTile extends StatefulWidget {
  SelectableBookstoreTile({
    Key key,
    @required this.bookstore,
    @required this.selectionController,
    this.onTap,
    this.selected = false,
  })  : assert(bookstore != null),
        super(key: key);

  final Bookstore bookstore;

  /// our controller to have a control of a selection from the tile widget
  final SelectionController selectionController;
  final Function onTap;

  /// basically makes tiles to be selected on first render, after this can be done via internal state
  final bool selected;

  @override
  _SelectableBookstoreTileState createState() => _SelectableBookstoreTileState();
}

class _SelectableBookstoreTileState extends State<SelectableBookstoreTile>
    with SingleTickerProviderStateMixin {
  bool _selected;

  // declare some animations for our tile
  AnimationController _animationController;
  Animation<double> _animationOpacity;
  Animation<double> _animationOpacityInverse;
  Animation<double> _animationBorderRadius;
  Animation<double> _animationScale;
  Animation<double> _animationScaleInverse;

  @override
  void initState() {
    super.initState();

    /// Get the selected condition from the parent
    _selected = widget.selected ?? false;
    _animationController = AnimationController(
      vsync: this,
      duration: kSelectionDuration,
    );

    /// define our animations
    final CurvedAnimation animationBase = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _animationOpacity =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationBase);
    _animationOpacityInverse =
        Tween<double>(begin: 1.0, end: 0.0).animate(animationBase);
    _animationBorderRadius =
        Tween<double>(begin: 10.0, end: 20.0).animate(animationBase);
    _animationScale =
        Tween<double>(begin: 1.0, end: 1.2).animate(animationBase);
    _animationScaleInverse =
        Tween<double>(begin: 1.23, end: 1.0).animate(animationBase);

    /// check if controller is "closing", i.e. user pressed global close button to quit the selection.
    /// doing this check, if user will start to fling down very fast at this moment, some tiles that will be built at this moment
    /// will know about they have to play the unselection animation too.
    if (widget.selectionController.notInSelection) {
      /// Perform unselection animation
      if (_selected) {
        _selected = false;
        _animationController.value =
            widget.selectionController.animationController.value;
        _animationController.reverse();
      }
    } else {
      if (_selected) {
        _animationController.value = 1;
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    /// toggle tile selection on tap if selection controller is now in the selection mode
    if (widget.selectionController.inSelection) {
      _toggleSelection();
    } else {
      print("Tile is tapped!");
    }
  }

  void _select() {
    widget.selectionController.selectItem(widget.bookstore.id);
    _animationController.forward();
  }

  // performs unselect animation and calls [onSelected] and [notifyUnselection]
  void _unselect() {
    widget.selectionController.unselectItem(widget.bookstore.id);
    _animationController.reverse();
  }

  void _toggleSelection() {
    setState(() {
      _selected = !_selected;
    });
    if (_selected) {
      _select();
    } else
      _unselect();
  }

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      selectedColor: Theme.of(context).textTheme.headline6.color,
      child: ListTile(
        subtitle: Text(
          widget.bookstore.location,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.caption.color,
            height: 0.9,
          ),
        ),
        selected: _selected,
        dense: true,
        isThreeLine: false,
        contentPadding: const EdgeInsets.only(left: 10.0, top: 0.0),
        onTap: _handleTap,
        onLongPress: _toggleSelection,
        name: Text(
          widget.bookstore.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget child) => ClipRRect(
            borderRadius: BorderRadius.circular(_animationBorderRadius.value),
            child: Stack(
              children: <Widget>[
                FadeTransition(
                  opacity: _animationOpacityInverse, /// inverse values
                  child: ScaleTransition(
                    scale: _animationScale,
                    child: Container(
                      width: 48.0,
                      height: 48.0,
                      child: Image.network(widget.bookstore.webUrl),
                    ),
                  ),
                ),
                if (_animationController.value != 0)
                  FadeTransition(
                    opacity: _animationOpacity,
                    child: Container(
                      width: 48.0,
                      height: 48.0,
                      color: Theme.of(context).primaryColor,
                      child: ScaleTransition(
                        scale: _animationScaleInverse,
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
