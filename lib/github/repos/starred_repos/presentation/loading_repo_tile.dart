import 'package:flutter/material.dart';

class LoadingRepoTile extends StatelessWidget {
  const LoadingRepoTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Loading'),
    );
  }
}
