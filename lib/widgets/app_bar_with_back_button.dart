import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';

class AppBarWithBackButton extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String route;
  const AppBarWithBackButton(
      {super.key, required this.title, this.route = '/'});

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: route != '/'
            ? null
            : Container(
                margin: const EdgeInsets.only(left: 5),
                child: IconButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.replace('/');
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ))),
        actions: route == '/'
            ? []
            : [
                Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: IconButton(
                        onPressed: () {
                          context.replace(route);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                        ))),
              ],
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        titleSpacing: 30,
        automaticallyImplyLeading: false,
        backgroundColor: mainTheme.colorScheme.background);
  }
}
