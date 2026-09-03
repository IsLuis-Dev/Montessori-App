import 'package:flutter/material.dart';
import 'package:cintli_montessori/core/theme/app_icons.dart';

/// Barra superior reutilizable con navegación posterior o apertura del menú.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(AppIcons.arrowBack),
                onPressed: () => Navigator.pop(context),
              )
              : Builder(
                builder:
                    (context) => IconButton(
                      icon: const Icon(AppIcons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
              ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
