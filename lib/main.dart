import 'package:flutter/material.dart';
import 'package:my_pharmacy/CategoriesData.dart';
import 'package:my_pharmacy/CategoriesItems.dart';
import 'package:my_pharmacy/Login.dart';
import 'package:my_pharmacy/RegisterScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_pharmacy/bottomNavigationBar.dart';
import 'package:my_pharmacy/searchMed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          'LoginScreen': (buildContext) => Login(),
          'RegisterScreen': (buildContext) => RegisterScreen(),
          'bottomNavigationBar': (buildContext) => bottomNavigationBar(),
        },
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? 'LoginScreen'
            : 'bottomNavigationBar'),
  );
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  bool isSearching = false;
  String? searchedMedicine;
  late User signedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final User = _auth.currentUser;
      if (User != null) {
        signedInUser = User;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  List<CategoriesData> category = [
    CategoriesData('Alzheimer Disease', 'assets/Image/alzheimer disease.jpg',
        'https://www.nia.nih.gov/health/what-alzheimers-disease'),
    CategoriesData('Cardiovascular Disease', 'assets/Image/heart.jpg',
        'https://my.clevelandclinic.org/health/diseases/21493-cardiovascular-disease'),
    CategoriesData('Pneumonia ', 'assets/Image/penumina.jpg',
        'https://www.mayoclinic.org/diseases-conditions/pneumonia/symptoms-causes/syc-20354204'),
    CategoriesData('Kidney Cancer', 'assets/Image/kidneycancer.jpg',
        'https://www.mayoclinic.org/diseases-conditions/kidney-cancer/symptoms-causes/syc-20352664'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Container(
          width: 120,
          height: 45,
          child: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'LoginScreen', (route) => false);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        size: 30,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 4),
                      Text('Logout',
                          style: TextStyle(fontSize: 22, color: Colors.blue))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        extendBody: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.blue),
          elevation: 0,
          backgroundColor: Colors.grey.shade50,
          centerTitle: true,
          title: isSearching
              ? TextField(
                  onChanged: (searchedMedicine) {
                    this.searchedMedicine = searchedMedicine;
                  },
                )
              : Text(
                  'Categories',
                  style: TextStyle(color: Colors.blue),
                ),
          actions: [
            isSearching
                ? IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchMed(
                                  searchedMedicine ?? 'no data found!')));
                    },
                    icon: Icon(Icons.search))
                : Container(),
            isSearching
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = false;
                        searchedMedicine = 'no data found!';
                      });
                    },
                    icon: Icon(Icons.close))
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  ),
          ],
        ),
        body: Container(
          width: double.infinity,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Expanded(
                child: ListView.builder(
              itemBuilder: buildListItem,
              physics: BouncingScrollPhysics(),
              itemCount: category.length,
            ))
          ]),
        ),
      ),
    );
  }

  Widget buildListItem(BuildContext context, int index) {
    return CategoriesItems(category[index]);
  }
}
