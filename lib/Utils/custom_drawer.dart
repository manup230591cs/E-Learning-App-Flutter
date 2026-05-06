import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:e_learning/About/about_screen.dart';
import 'package:e_learning/Courses/alll_courses.dart';
import 'package:e_learning/Courses/enrolled_course.dart';
import 'package:e_learning/Exam/exam_home.dart';

import 'package:e_learning/Home/home_page.dart';
import 'package:e_learning/Login/login_page.dart';

import 'package:e_learning/controllers/auth_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Image.asset(
                'images/logo.png', // Replace 'assets/logo.png' with your logo asset path
                width: 200,
                height: 200,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(OctIcons.home),
            title: const Text('Home'),
            onTap: () {
              Get.to(() => const MyHomePage());
            },
          ),
          ListTile(
            leading: const Icon(OctIcons.book),
            title: const Text('All Courses'),
            onTap: () {
              Get.to(() => const CourseListPage());
            },
          ),
          ListTile(
            leading: const Icon(OctIcons.diff_ignored),
            title: const Text('Enrolled'),
            onTap: () {
              Get.to(() => const EnrolledCoursesScreen());
            },
          ),
          ListTile(
            leading: const Icon(OctIcons.telescope),
            title: const Text('Exam'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExamHome()),
              );
            },
          ),
          ListTile(
            leading: const Icon(OctIcons.info),
            title: const Text('About'),
            onTap: () {
              Get.to(() => const AboutPage());
            },
          ),
          ListTile(
            leading: const Icon(OctIcons.sign_out),
            title: const Text('Sign Out'),
            onTap: () {
              // Navigate to LoginPage
              AuthController().signOutUsers();
              Get.off(() => const LoginPage());
            },
          ),
        ],
      ),
    );
  }
}
