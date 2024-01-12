import 'package:flutter/material.dart';
import 'widgets/available_course.dart';
import 'profile_page.dart';
import 'menu_page.dart';
import 'widgets/category.dart';
import 'data/database_helper.dart';

class AvailableCourses extends StatefulWidget {
  final int userId;

  AvailableCourses({required this.userId});

  @override
  _AvailableCoursesState createState() => _AvailableCoursesState();
}

class _AvailableCoursesState extends State<AvailableCourses> {
  late Future<List<Map<String, dynamic>>> availableCourses;
  late Future<List<Map<String, dynamic>>> categories;

  Set<String> Categories = {};
  int courseToAdd = -1;

  void _updateCourses() {
    if (this.courseToAdd != -1)
      DatabaseHelper().enrollUserInCourse(widget.userId, this.courseToAdd);

    this.courseToAdd = -1;
    setState(() {
      this.availableCourses = DatabaseHelper().getAvailableCourses(
        widget.userId,
        this.Categories,
      );
    });
    print("available courses");
    print(availableCourses);
  }

  @override
  void initState() {
    super.initState();
    availableCourses = DatabaseHelper().getAvailableCourses(widget.userId, {});
    categories = DatabaseHelper().getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Color(0xFFFEF7FF),
          title: Center(
            child: Image.asset(
              'assets/logo.png',
              width: 150,
              height: 50,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              print("AVAILABLE");
              availableCourses.then((courses) {
                print('Available Courses:');
                for (var course in courses) {
                  print('Course ID: ${course['id']}');
                  print('Title: ${course['title']}');
                  print('Description: ${course['description']}');
                  print('Instructor: ${course['name']}');
                  print('Image URL: ${course['image_url']}');
                  print('------------------------');
                }
              }).catchError((error) {
                print('Error fetching available courses: $error');
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MenuPage(userId: widget.userId)));
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                print("AVAILABLE");
                print(availableCourses);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(userId: widget.userId)));
              },
            ),
          ],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Available Courses',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: availableCourses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Map<String, dynamic>> courses = snapshot.data ?? [];

                return Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Container(
                    height: 460,
                    child: courses.isNotEmpty
                        ? ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: courses.length,
                            separatorBuilder: (context, _) =>
                                SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              if (index < courses.length) {
                                return AvailableCourse(
                                  courses[index]['title'],
                                  courses[index]['name'] ?? " ",
                                  courses[index]['description'],
                                  courses[index]['image_url'],
                                  () {
                                    this.courseToAdd = courses[index]['id'];
                                    _updateCourses();
                                  },
                                );
                              } else {
                                return Container();
                              }
                            },
                          )
                        : Container(),
                  ),
                );
              }
            },
          ),
          SizedBox(height: 40),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: categories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Map<String, dynamic>> categories = snapshot.data ?? [];
                print("categories");
                print(categories);
                return Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Container(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: (categories.length / 2).ceil(),
                      separatorBuilder: (context, index) => SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              CategoryWidget(
                                  label: categories[2 * index]['category'],
                                  onPressed: () {
                                    if (this.Categories.contains(
                                        categories[2 * index]['category'])) {
                                      this.Categories.remove(
                                          categories[2 * index]['category']);
                                    } else
                                      this.Categories.add(
                                          categories[2 * index]['category']);
                                    _updateCourses();
                                  }),
                              SizedBox(height: 20),
                              CategoryWidget(
                                  label: categories[2 * index + 1]['category'],
                                  onPressed: () {
                                    if (this.Categories.contains(
                                        categories[2 * index + 1]
                                            ['category'])) {
                                      this.Categories.remove(
                                          categories[2 * index + 1]
                                              ['category']);
                                    } else
                                      this.Categories.add(
                                          categories[2 * index + 1]
                                              ['category']);
                                    _updateCourses();
                                  }),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ]));
  }
}
