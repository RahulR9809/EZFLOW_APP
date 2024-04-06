// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, empty_catches, sort_child_properties_last, unused_field, prefer_const_constructors_in_immutables

import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:firstproject/AddSellProducts.dart';
import 'package:firstproject/db/data_model.dart';
import 'package:firstproject/db/db.dart';
import 'package:firstproject/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  Profile({
    Key? key,

  }) : super(key: key);

  set id(int id) {}
  @override
  State<Profile> createState() => _ProfileState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _ProfileState extends State<Profile> {
  final TextEditingController _categoryController = TextEditingController();
  bool _imageValidationError = false;
  File? catgeoryimage;
  
  late Box _classBox;
  late Box _userBox;
  bool _isBoxInitialized = false;
  bool _isUserBoxInitialized = false;

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    _classBox = await Hive.openBox('classes');
    _userBox = await Hive.openBox('user');
    setState(() {
      _isBoxInitialized = true;
      _isUserBoxInitialized = true;
    });

    // Check if image path is already saved
    final imagePath = _userBox.get('imagePath', defaultValue: '');
    if (imagePath.isNotEmpty) {
      setState(() {
        _imageFile = File(imagePath);
   });
}
}


  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _userBox.put('imagePath', pickedFile.path); // Save image path in Hive
    }
  }

  void _editUsername() {
    TextEditingController usernameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Username'),
          content: TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: 'Enter new username',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (usernameController.text.isNotEmpty) {
                  _userBox.put('username', usernameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
  },
);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.libreFranklin(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 2),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: Container(),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.settings),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EZFLOW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            exit(0);
                          },
                          child: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.article_outlined),
              title: Text('Terms of Use'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TermsOfUse()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutApp()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share App'),
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListTile(
                title: Center(
                    child: Text(
                  'Version 1',
                  style: TextStyle(
                      fontSize: 13,
                      color: const Color.fromARGB(255, 119, 119, 119)),
                )),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                   SizedBox(
              height: MediaQuery.of(context).size.height * 0.05, // Adjust the height as needed
            ),
          Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.white,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : null,
                            child: _imageFile == null
                                ? Icon(Icons.person,
                                    size: 120,
                                    color: Color.fromARGB(255, 155, 173, 235))
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 105, 102, 123),
                            ),
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    _isUserBoxInitialized
                        ? ValueListenableBuilder(
                            valueListenable: _userBox.listenable(),
                            builder: (context, Box box, _) {
                              final username = _userBox.get('username',
                                  defaultValue: 'Username');
                              return GestureDetector(
                                onTap: _editUsername,
                                child: Text(
                                  username,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              );
                            },
                          )
                        : SizedBox.shrink(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06, // Adjust the height as needed
            ),
           const Divider(), 
            ListTile(
              leading: Icon(Icons.category),
              title: Text(
                'Add Category',
                style: GoogleFonts.alegreyaSc(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                _showAddCategoryDialog(_categoryController);
              },
            ), 
            const Divider(),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text(
                'Sell Products',
                style: GoogleFonts.alegreyaSc(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SellProducts()));
              },
            ),
            const Divider(),
            ListTile(
               leading: Icon(Icons.privacy_tip),
              title: Text(
                'Privacy Policy',
                style: GoogleFonts.alegreyaSc(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicy()));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCategoryDialog(
    TextEditingController controller,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Center(child: Text('Add Category')),
              content: Container(
                height: 350,
                width: 450,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () => pickImage(setState),
                        child: Container(
                          color: const Color.fromARGB(255, 172, 170, 170),
                          width: 450,
                          height: 150,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (catgeoryimage != null)
                                Image.file(
                                  catgeoryimage!,
                                  fit: BoxFit.cover,
                                )
                              else
                                Container(
                                  width: 160,
                                  height: 160,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 172, 170, 170),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              if (_imageValidationError)
                                Positioned(
                                  bottom: 0,
                                  child: Text(
                                    'Please add an image',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: 'Category Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a category name';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          catgeoryimage = null;
                          controller.clear();
                          _formKey.currentState?.reset();
                          _imageValidationError = false;
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true &&
                            catgeoryimage != null) {
                          AddModel newCategory = AddModel(
                            name: _categoryController.text,
                            image: catgeoryimage?.path ?? "",
                          );
                          AddListNotifier.value = [];
                          AddListNotifier.notifyListeners();

                          Addlist(newCategory);

                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Category successfully!'),
                            ),
                          );
                          setState(() {
                            controller.clear();
                            catgeoryimage = null;
                            _formKey.currentState?.reset();
                            _imageValidationError = false;
                          });
                        } else {
                          setState(() {
                            _imageValidationError = true;
                          });
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> pickImage(Function setState) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          catgeoryimage = File(pickedFile.path);

          _imageValidationError = false;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }
}

class ImageProvider extends ChangeNotifier {
  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  void setImage(File? image) {
    _selectedImage = image;
    notifyListeners();
  }
}
