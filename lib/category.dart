// ignore_for_file: non_constant_identifier_names, unused_element, use_build_context_synchronously, avoid_print, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:io';

import 'package:firstproject/SubCategory.dart';
import 'package:firstproject/categoryEdit.dart';
import 'package:firstproject/db/data_model.dart';
import 'package:firstproject/db/db.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

ValueNotifier<List<AddModel>> AddListNotifier = ValueNotifier([]);

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<AddModel> allModels = [];
  List<AddModel> filteredModels = []; 

  @override
  void initState() { 
    super.initState();
    getAllModels();
  }

  Future<void> _onCategoryUpdated() async {
    await getAllModels();
    setState(() {});
  }

  Future<void> getAllModels({String? filter}) async {
    final addModelBox = await Hive.openBox<AddModel>('category');
    allModels = addModelBox.values.toList();

    if (filter != null && filter.isNotEmpty) {
      filteredModels = allModels
          .where((model) =>
              model.name.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    } else {
      filteredModels = List.from(allModels);
    }

    AddListNotifier.value = filteredModels;
  }

  Future<void> onDeleteButtonPressed(int? id) async { 
    try {
      if (id != null) {
        await deletemodel(id);
        await getAllModels();
        setState(() {});
      } else {
        print('Invalid id: $id');
      }
    } catch (e) {
      print('Error during deletion: $e');
    }
  }
  
  Future<void> _confirmationDialog(BuildContext context, int? id) async {
    return showDialog<void>(
      context: context,
      builder: ((BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Confirm Deletion')),
          content: const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text('Are you sure?'),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left:20 ), 
              child: Row(  
                children: [ 
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); 
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await onDeleteButtonPressed(id);
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: const Text('Confirm'),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }




  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
           title: Padding(
             padding: const EdgeInsets.all(20.0),
             child: Text(
                 'Categories',
                 style: GoogleFonts.libreFranklin( 
                   textStyle: TextStyle(
                     fontWeight: FontWeight.w500,
                     fontSize: 25,
                     shadows: [
                       Shadow(
              color: Colors.black.withOpacity(0.3), 
              offset: const Offset(0, 2),
              blurRadius: 5, 
                       ),
                     ],
                    
                   ),
                 ),
               ),
           ),
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 21, 20, 20)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              style: const TextStyle(color: Color.fromARGB(255, 73, 71, 71)),
              onChanged: (value) {
                getAllModels(filter: value);
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<AddModel>>(
              valueListenable: AddListNotifier,
              builder: (context, snapshot, child) {
                return snapshot.isEmpty
                    ? const Center(
                        child: Text('No categories found'),
                      )
                    : _buildCategoryGrid(snapshot);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(List<AddModel> Category) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: Category.length,
      itemBuilder: (context, index) {
        final currentCategory = Category[index];
        return CategoryItem(
          category: currentCategory,
          onDeletePressed: () {
            _confirmationDialog(context, currentCategory.id);
          },
               onCategoryUpdated: () async {
          await getAllModels();
          setState(() {});
        },
        );
      },
    );
  } 
}

class CategoryItem extends StatelessWidget {
  
  final AddModel category;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onCategoryUpdated;
  const CategoryItem({
    required this.category,
    this.onDeletePressed,
     this.onCategoryUpdated,
  });
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategory(
              data: category, selectedCategory: '', bookNames: [], bookPrices: {},
            ),
          ),
        );
       
      },
      
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(category.image)),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10.0),   
          ),
          child: Stack(
            children: [
              Positioned(
                top: 18.0,
                right: 18.0,
                child: PopupMenuButton<String>(
                  child: const Icon(
                    Icons.more_vert_outlined,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 20.0,
                  ),
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onSelected: (String value) async {
                    if (value == 'edit') {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context)=>EditCategory(category: category),
                        ),
                        
                        ).then((value) {
                          if (value == true) {
                              onCategoryUpdated?.call();
          }
                        });
                     
                    } else if (value == 'delete') {
                      onDeletePressed?.call();
                    }
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromARGB(70, 19, 18, 18),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            category.name,
                            style:  GoogleFonts.cabin(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0), 
                ],
              ),
            ],
          ),
        ),
      ), 
    );
  }
  
}
