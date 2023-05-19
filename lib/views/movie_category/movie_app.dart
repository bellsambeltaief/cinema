import 'package:cinemamovie/models/category.dart';
import 'package:cinemamovie/views/movie_category/movie_list.dart';
import 'package:cinemamovie/views/movie_category/widgets/category_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {


  static Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('http://192.168.100.57:5000/api/categorie'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return List<Category>.from(jsonData.map((category) => Category.fromJson(category)));
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

class MovieApp extends StatefulWidget {
  const MovieApp({super.key});

  @override
  _MovieAppState createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  late Future<List<Category>> _categories;
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _categories = ApiService.getCategories();
  }

  void _onCategoryPressed(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
          children: [
            FutureBuilder<List<Category>>(
              future: _categories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Category> categories = snapshot.data!;
                  return SizedBox(
                    height: 50,
                    child: ListView(
                    scrollDirection: Axis.horizontal,
                      children: categories
                          .map((category) => CategoryButton(
                                category: category.name,
                                 onPressed: () => _onCategoryPressed(category.id ?? ""),
                              ))
                          .toList(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
           const SizedBox(height: 40),
            Container(child:
              _selectedCategory.isEmpty?
             const Text("No movies data" , style: TextStyle(color: Colors.white, fontSize: 30,),):
               MovieList(category: _selectedCategory),
              ),
           
           
               
            
                   
            
           
          
        
          ],
      ),
    );
  }
}

