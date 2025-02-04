import 'package:flutter/material.dart';
import 'package:mis_project/base_app_bar.dart';
import 'package:mis_project/models/auth_model.dart';
import 'package:mis_project/models/thesis_model.dart';
import 'package:mis_project/services/thesis_service.dart';
import 'package:mis_project/services/auth_service.dart';

class ThesisList extends StatefulWidget {
  const ThesisList({super.key});

  @override
  State<ThesisList> createState() => _ThesisListState();
}

class _ThesisListState extends State<ThesisList> {
  final TextEditingController _searchController = TextEditingController();
  List<Thesis> filteredTheses = [];
  List<Thesis> allTheses = [];

  @override
  void initState() {
    super.initState();
    allTheses = ThesisService.getThesis();
    filteredTheses = allTheses;
  }

  void _filterTheses(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTheses = allTheses;
      } else {
        filteredTheses = allTheses
            .where((thesis) =>
                thesis.title.toLowerCase().contains(query.toLowerCase()) ||
                thesis.student.toLowerCase().contains(query.toLowerCase()) ||
                thesis.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Листа на магистерски трудови',
        route: '/thesis_list',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search',
              onChanged: _filterTheses,
              trailing: [
                const Icon(Icons.mic),
                TextButton(
                  onPressed: () {
                    _searchController.clear();
                    _filterTheses('');
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTheses.length,
              itemBuilder: (context, index) {
                final thesis = filteredTheses[index];
                return Card(
                  elevation: 0,
                  color: Colors.grey[170],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          const Icon(Icons.book, color: Colors.white, size: 20),
                    ),
                    title: Text(thesis.title),
                    subtitle: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(thesis.student),
                      ],
                    ),
                    backgroundColor: Colors.grey[170],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(thesis.description),
                            const SizedBox(height: 16),
                            FutureBuilder<User?>(
                              future: AuthService.getLoggedInUser(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/thesis_details',
                                          arguments: thesis.id,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[120],
                                        foregroundColor: Colors.blue,
                                      ),
                                      child: const Text('Види повеќе'),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

