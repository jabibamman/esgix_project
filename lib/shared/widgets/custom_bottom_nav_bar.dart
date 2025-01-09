import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../core/routes.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final bool allowBack;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.allowBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (allowBack) {
          Navigator.pop(context);
          return;
        }

        if (index != currentIndex) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.bottomNavRoutes[index],
          );
        }

        if (onTap != null) {
          onTap!(index);
        }
      },
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.darkGray,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messages',
        ),
      ],
    );
  }
}
