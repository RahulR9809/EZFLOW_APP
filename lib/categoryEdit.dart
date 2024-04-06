import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firstproject/db/db.dart';
import 'package:firstproject/db/data_model.dart';

class EditCategory extends StatefulWidget {
  final AddModel category;

  EditCategory({required this.category});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late File _image;
  bool _imageValidationError = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _image = File(widget.category.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Category',
          style: GoogleFonts.aleo(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            _getImage();
          },
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Category Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                if (_imageValidationError)
                  Text(
                    'Please add an image',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    _updateCategory();
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageValidationError = false;
      });
    }
  }

  void _updateCategory() {
    if (_formKey.currentState?.validate() == true && _image.existsSync()) {
      AddModel updatedCategory = AddModel(
        id: widget.category.id,
        name: _nameController.text,
        image: _image.path,
        categoryId: widget.category.categoryId,
      );

      editModel(widget.category.id!, updatedCategory);

      Navigator.pop(context, true);
    } else {
      setState(() {
        _imageValidationError = true;
      });
    }
  }
}
