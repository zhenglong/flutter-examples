import 'package:flutter/material.dart';
import 'package:flutter_app/todoList/models.dart';

class FilterButton extends StatelessWidget {

  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final bool isActive;

  FilterButton({this.onSelected, this.activeFilter, this.isActive, Key key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = theme.textTheme.body1;
    final activeStyle = theme.textTheme.body1.copyWith(
      color: theme.accentColor
    );
    final button = _Button(
      onSelected: onSelected,
      activeFilter: activeFilter,
      activeStyle: activeStyle,
      defaultStyle: defaultStyle,
    );
    return AnimatedOpacity(
      opacity: isActive ? 1.0 : 0.0,
      duration: Duration(milliseconds: 150),
      child: isActive ? button : IgnorePointer(child: button,),
    );
  }
}

class _Button extends StatelessWidget {

  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  const _Button({
    Key key,
    @required this.onSelected,
    @required this.activeFilter,
    @required this.activeStyle,
    @required this.defaultStyle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VisibilityFilter>(
      key: Key('_button'),
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<VisibilityFilter>>[
          PopupMenuItem<VisibilityFilter>(
            key: Key('show all'),
            value: VisibilityFilter.all,
            child: Text('show all', style: activeFilter == VisibilityFilter.all ? activeStyle : defaultStyle,),
          ),
          PopupMenuItem<VisibilityFilter>(
            key: Key('show active'),
            value: VisibilityFilter.active,
            child: Text('show active', style: activeFilter == VisibilityFilter.active ? activeStyle : defaultStyle,),
          ),
          PopupMenuItem<VisibilityFilter>(
            key: Key('show complete'),
            value: VisibilityFilter.completed,
            child: Text('show completed', style: activeFilter == VisibilityFilter.completed ? activeStyle : defaultStyle,),
          )
        ];
      },
      icon: Icon(Icons.filter_list),);
  }
}