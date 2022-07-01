import 'package:Reminder/src/data/local/object_box_helper.dart';
import 'package:flutter/material.dart';

class LifeCycle extends StatefulWidget {
  Widget child;

  LifeCycle({Key? key, required this.child}) : super(key: key);

  @override
  State<LifeCycle> createState() => _LifeCycleState();
}

class _LifeCycleState extends State<LifeCycle> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.detached){
      ObjectBoxHelper().close();
    }
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
