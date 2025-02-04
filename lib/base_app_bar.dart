import 'package:flutter/material.dart';
import 'package:mis_project/models/auth_model.dart';
import 'package:mis_project/services/auth_service.dart';
import 'package:mis_project/services/thesis_service.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String route;

  const BaseAppBar({super.key, required this.title, required this.route});

  void _showUserMenu(BuildContext context, User user) {
    final thesis = ThesisService.getThesisByStudentId(user.username);
    final name = thesis?.student;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.account_circle, size: 40, color: Colors.blue),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${name} !',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('(${user.username})',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await AuthService.logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //bool isHomeRoute = ModalRoute.of(context)?.settings.name
    bool isHomeRoute = route == '/';
    return AppBar(
      backgroundColor: Colors.white,
      // Only show back button if not on home route and can pop
      leading: !isHomeRoute
          // && Navigator.canPop(context)
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
            )
          : null,
      title: Text(title, style: const TextStyle(color: Colors.black)),
      actions: [
        FutureBuilder<User?>(
          future: AuthService.getLoggedInUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GestureDetector(
                onTap: () => _showUserMenu(context, snapshot.data!),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Row(
                      children: [
                        const Icon(Icons.account_circle, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          snapshot.data!.username,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

