import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'approval_request_list_screen.dart';
import 'production_order_approval_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  final List<Widget> _screens = [
    const ApprovalRequestListScreen(),
    const ProductionOrderApprovalListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    if (_currentIndex != index) {
      _fabAnimationController.forward().then((_) {
        _fabAnimationController.reverse();
      });
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 350),
        reverse: _currentIndex == 0,
        transitionBuilder:
            (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onDestinationSelected,
          animationDuration: const Duration(milliseconds: 400),
          destinations: [
            NavigationDestination(
              icon: ScaleTransition(
                scale: _fabScaleAnimation,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              selectedIcon: ScaleTransition(
                scale: _fabScaleAnimation,
                child: const Icon(Icons.shopping_bag_rounded),
              ),
              label: 'Sales Orders',
            ),
            NavigationDestination(
              icon: ScaleTransition(
                scale: _fabScaleAnimation,
                child: const Icon(Icons.precision_manufacturing_outlined),
              ),
              selectedIcon: ScaleTransition(
                scale: _fabScaleAnimation,
                child: const Icon(Icons.precision_manufacturing_rounded),
              ),
              label: 'Production',
            ),
          ],
        ),
      ),
    );
  }
}
