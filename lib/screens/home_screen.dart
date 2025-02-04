import 'package:flutter/material.dart';
import 'package:mis_project/base_app_bar.dart';
import 'package:mis_project/services/auth_service.dart';
import 'package:mis_project/models/auth_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: '', route: '/'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.grey[200],
                child: Image.asset(
                  'assets/images/logo.png',
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              // const Spacer(),
              const SizedBox(height: 40),
              const Text(
                'Систем за преглед на магистерски трудови',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/thesis_list'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Листа на магистерски трудови',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/process'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Постапка за пријавување',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<User?>(
                    future: AuthService.getLoggedInUser(),
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context,
                              snapshot.hasData ? '/my_thesis' : '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          snapshot.hasData
                              ? 'Мој магистерски труд'
                              : 'Најави се',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      );
                    },
                  ),
                ],
              ),
               const Spacer(),

            ],
          ),
        ),
      ),
    );
  }
}


