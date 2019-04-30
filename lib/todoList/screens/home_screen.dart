import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/todoList/blocs.dart';
import 'package:flutter_app/todoList/models.dart';
import 'package:flutter_app/todoList/widgets/filter_button.dart';
import 'package:flutter_app/todoList/widgets/todos_bloc_provider.dart';

class HomeScreen extends StatefulWidget {
  final void Function() onInit;

  HomeScreen({@required this.onInit})
    : super(key: const Key('homeScreen'));

  @override
  State<StatefulWidget> createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {

  StreamController<AppTab> tabController;

  @override
  void initState() {
    super.initState();

    tabController = StreamController<AppTab>();
  }

  @override
  void dispose() {
    tabController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todosBloc = TodosBlocProvider.of(context);
    return StreamBuilder<AppTab>(
      initialData: AppTab.todos,
      stream: tabController.stream,
      builder: (context, activeTabSnapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('app title'),
            actions: _buildActions(
              todosBloc,
              activeTabSnapshot,
              true
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildActions(
      TodosListBloc todosBloc,
      AsyncSnapshot<AppTab> activeTabSnapshot,
      bool hasData
  ) {
    if (!hasData) return [];
    
    return [
      StreamBuilder<VisibilityFilter>(
        stream: todosBloc.activeFilter,
        builder: (context, snapshot) {
          return FilterButton(
            isActive: activeTabSnapshot.data == AppTab.todos,
            activeFilter: snapshot.data ?? VisibilityFilter.all,
            onSelected: todosBloc.updateFilter,
          );
        })
    ];
  }
}