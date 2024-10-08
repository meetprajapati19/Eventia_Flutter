import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// import 'package:eventia/Add_event/CreateEventPages/AddField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveEventData(Map<String, dynamic> eventData) async {
    try {
      await _db.collection('eventss').add(eventData);
    } catch (e) {
      print("Error saving event data: $e");
    }
  }
}

class BasicInfoScreen extends StatefulWidget {
  @override
  _BasicInfoScreenState createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  String eventName = '';
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  String duration = '';
  String location = '';
  int capacity = 0;
  int ageLimit = 0;
  bool chatEnvironment = false;
  bool isOnline = true;
  bool isPaid = false;
  List<Map<String, dynamic>> passes = [];
  File? eventPoster;

  bool isSave = false;

  final ImagePicker _picker = ImagePicker();

  // Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Time Picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  // Add a Pass
  void _addPass() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String passName = '';
        double passPrice = 0.0;
        int passQuantity = 0;
        int peoplePerPass = 0;

        return AlertDialog(
          title: Text('Add Pass'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Pass Name',
                  border: UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,
                ),
                onChanged: (value) => passName = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => passPrice = double.tryParse(value) ?? 0.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => passQuantity = int.tryParse(value) ?? 0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'People Per Pass',
                  border: UnderlineInputBorder(), // Keeps only the bottom border
        enabledBorder: UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(),
        fillColor: Colors.transparent, // Removes any background color
        filled: false,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => peoplePerPass = int.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (passName.isNotEmpty &&
                    passQuantity > 0 &&
                    passPrice >= 0 &&
                    peoplePerPass > 0) {
                  setState(() {
                    passes.add({
                      'name': passName,
                      'price': passPrice,
                      'quantity': passQuantity,
                      'peoplePerPass': peoplePerPass,
                    });
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields correctly')),
                  );
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Edit a Pass
  void _editPass(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String passName = passes[index]['name'];
        double passPrice = passes[index]['price'];
        int passQuantity = passes[index]['quantity'];
        int peoplePerPass = passes[index]['peoplePerPass'];

        return AlertDialog(
          title: Text('Edit Pass'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: passName,
                decoration: InputDecoration(
                  labelText: 'Pass Name',
                  border: InputBorder.none,
                ),
                onChanged: (value) => passName = value,
              ),
              TextFormField(
                initialValue: passPrice.toString(),
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => passPrice = double.tryParse(value) ?? 0.0,
              ),
              TextFormField(
                initialValue: passQuantity.toString(),
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => passQuantity = int.tryParse(value) ?? 0,
              ),
              TextFormField(
                initialValue: peoplePerPass.toString(),
                decoration: InputDecoration(
                  labelText: 'People Per Pass',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => peoplePerPass = int.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (passName.isNotEmpty &&
                    passQuantity > 0 &&
                    passPrice >= 0 &&
                    peoplePerPass > 0) {
                  setState(() {
                    passes[index] = {
                      'name': passName,
                      'price': passPrice,
                      'quantity': passQuantity,
                      'peoplePerPass': peoplePerPass,
                    };
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields correctly')),
                  );
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Remove a Pass
  void _removePass(int index) {
    setState(() {
      passes.removeAt(index);
    });
  }

  // Pick Event Poster
  Future<void> _pickPoster() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        eventPoster = File(pickedFile.path);
      });
    }
  }

  // Add dynamic fields


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      border: UnderlineInputBorder(),
                      filled: false,
                    ),
                    onChanged: (value) => eventName = value,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter event name' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    title: Text(selectedTime == null
                        ? 'Select Time'
                        : 'Time: ${selectedTime!.format(context)}'),
                    trailing: Icon(Icons.access_time),
                    onTap: () => _selectTime(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    title: Text(selectedDate == null
                        ? 'Select Date'
                        : 'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Duration',
                      border: UnderlineInputBorder(),
                      filled: false,
                    ),
                    onChanged: (value) => duration = value,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter duration' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: UnderlineInputBorder(),
                      filled: false,
                    ),
                    onChanged: (value) => location = value,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter location' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Capacity',
                      border: UnderlineInputBorder(),
                      filled: false,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                    capacity = int.tryParse(value) ?? 0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Age Limit',
                      border: UnderlineInputBorder(),
                      filled: false,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => ageLimit = int.tryParse(value) ?? 0,
                  ),
                ),
                ListTile(
                  title: Text('Online/Offline'),
                  trailing: Switch(
                    value: isOnline,
                    onChanged: (value) {
                      setState(() {
                        isOnline = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('Paid/Unpaid'),
                  trailing: Switch(
                    value: isPaid,
                    onChanged: (value) {
                      setState(() {
                        isPaid = value;
                      });
                    },
                  ),
                ),
                if (isPaid)
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _addPass,
                        child: Text('Add Pass'),
                      ),
                      for (int i = 0; i < passes.length; i++)
                        ListTile(
                          title: Text('${passes[i]['name']}'),
                          subtitle: Text(
                              'Price: ${passes[i]['price']}, Quantity: ${passes[i]['quantity']}, People Per Pass: ${passes[i]['peoplePerPass']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editPass(i),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _removePass(i),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ListTile(
                  title: Text('Chat Environment'),
                  trailing: Switch(
                    value: chatEnvironment,
                    onChanged: (value) {
                      setState(() {
                        chatEnvironment = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: eventPoster == null
                      ? ElevatedButton(
                    onPressed: _pickPoster,
                    child: Text('Pick Event Poster'),
                  )
                      : Image.file(eventPoster!),
                ),

                Padding(padding: EdgeInsets.all(16.0),
                    child: AddField(), ),
                ElevatedButton(
                  onPressed: () {

                    if (_formKey.currentState!.validate()) {
                      FirebaseService().saveEventData({
                        'eventName': eventName,
                        'selectedTime': selectedTime?.format(context),
                        'selectedDate': selectedDate,
                        'duration': duration,
                        'location': location,
                        'capacity': capacity,
                        'ageLimit': ageLimit,
                        'isOnline': isOnline,
                        'isPaid': isPaid,
                        'passes': passes,
                        'chatEnvironment': chatEnvironment,
                        'eventPoster': eventPoster?.path,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Event Data Saved')),
                      );
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}












class AddField extends StatefulWidget {
  final bool isSave; // Add isSave parameter

  AddField({this.isSave = false}); // Default to false if not provided

  @override
  _AddFieldState createState() => _AddFieldState();
}

class _AddFieldState extends State<AddField> {
  List<FieldModel> fields = [];

  @override
  void initState() {
    super.initState();
    // Automatically save fields if isSave is true
    if (widget.isSave) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        saveFields().then((_) {
          // Optionally show a confirmation or navigate after saving
        });
      });
    }
  }

  void addTextField() {
    setState(() {
      fields.add(FieldModel(type: 'text')); // Only required parameters
    });
  }


  void addPhotoField() {
    setState(() {
      fields.add(FieldModel(type: 'photo'));
    });
  }

  void addFileField() {
    setState(() {
      fields.add(FieldModel(type: 'file'));
    });
  }

  void addSocialMediaField() {
    setState(() {
      fields.add(FieldModel(type: 'social_media'));
    });
  }

  void removeField(int index) {
    setState(() {
      fields.removeAt(index);
    });
  }

  void showFieldOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300, // Set a fixed height for better layout
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.text_fields),
                  title: Text('Text'),
                  onTap: () {
                    addTextField();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text('Photo'),
                  onTap: () {
                    addPhotoField();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.file_present),
                  title: Text('File'),
                  onTap: () {
                    addFileField();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Social Media'),
                  onTap: () {
                    addSocialMediaField();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> saveFields() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final documentRef = firestore.collection('events').doc(); // Create a new document

      List<Map<String, dynamic>> fieldMaps = fields.map((field) => field.toMap()).toList();

      await documentRef.set({
        'fields': fieldMaps,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fields saved successfully!'),
        ),
      );
    } catch (e) {
      // Handle any errors that occur during saving
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save fields: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          for (int i = 0; i < fields.length; i++)
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: getFieldWidget(fields[i], () => removeField(i)),
                ),
                if (i < fields.length - 1) SizedBox(height: 15.0,) // Add a divider between fields
              ],
            ),
          SizedBox(height: 20),
          if (!widget.isSave) // Conditionally show Add More button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: showFieldOptions,
                child: Text('Add More'),
              ),
            ),
          SizedBox(height: 20),
          if (!widget.isSave) // Conditionally show Save button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveFields, // Save fields when button is pressed
                child: Text('Save'),
              ),
            ),
        ],
      ),
    );
  }

  Widget getFieldWidget(FieldModel field, VoidCallback onDelete) {
    switch (field.type) {
      case 'text':
        return TextFieldWidget(
          titleController: field.titleController,
          descriptionController: field.descriptionController!,
          onDelete: onDelete,
        );
      case 'photo':
        return PhotoFieldWidget(
          titleController: field.titleController,
          imagePaths: field.imagePaths,
          onDelete: onDelete,
        );
      case 'file':
        return FileFieldWidget(
          titleController: field.titleController,
          fileNames: field.fileNames,
          onDelete: onDelete,
        );
      case 'social_media':
        return SocialMediaFieldWidget(
          titleController: field.titleController,
          linkController: field.linkController!,
          onDelete: onDelete,
        );
      default:
        return Container(); // Fallback in case of unknown type
    }
  }
}

// Field Model
class FieldModel {
  final String type;
  final TextEditingController titleController;
  final TextEditingController? descriptionController; // Optional
  final List<String> imagePaths; // For photos
  final List<String> fileNames; // For files
  final TextEditingController? linkController; // Optional

  FieldModel({
    required this.type,
    TextEditingController? titleController,
    this.descriptionController,
    List<String>? imagePaths,
    List<String>? fileNames,
    this.linkController,
  })  : titleController = titleController ?? TextEditingController(),
        imagePaths = imagePaths ?? [],
        fileNames = fileNames ?? [];

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': titleController.text,
      'description': descriptionController?.text ?? '',
      'imagePaths': imagePaths,
      'fileNames': fileNames,
      'link': linkController?.text ?? '',
    };
  }
}


// Widget for Text Field
class TextFieldWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final VoidCallback onDelete;

  TextFieldWidget({
    required this.titleController,
    required this.descriptionController,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Text Field"),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
        SizedBox(height: 8), // Padding between elements
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            border: UnderlineInputBorder(), // No border by default
            enabledBorder:
            UnderlineInputBorder(), // No border when enabled but not focused
            focusedBorder:
            UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
        ),
        SizedBox(height: 16), // Padding between title and description
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            border: UnderlineInputBorder(), // No border by default
            enabledBorder:
            UnderlineInputBorder(), // No border when enabled but not focused
            focusedBorder:
            UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
          keyboardType: TextInputType.multiline,  // Enables multiline input
          minLines: 1,  // Minimum number of lines the TextField will show
          maxLines: null,
        ),
      ],
    );
  }
}

// Widget for Photo Field
class PhotoFieldWidget extends StatefulWidget {
  final TextEditingController titleController;
  final List<String> imagePaths;
  final VoidCallback onDelete;

  PhotoFieldWidget({
    required this.titleController,
    required this.imagePaths,
    required this.onDelete,
  });

  @override
  _PhotoFieldWidgetState createState() => _PhotoFieldWidgetState();
}

class _PhotoFieldWidgetState extends State<PhotoFieldWidget> {
  List<XFile> _imageFiles = [];

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles.addAll(pickedFiles);
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Photo Field"),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: widget.onDelete,
            ),
          ],
        ),
        SizedBox(height: 8), // Padding between elements
        TextField(
          controller: widget.titleController,
          decoration: InputDecoration(
            labelText: "Title",
            border: UnderlineInputBorder(), // No border by default
            enabledBorder:
            UnderlineInputBorder(), // No border when enabled but not focused
            focusedBorder:
            UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
        ),
        SizedBox(height: 16), // Padding between title and image button
        ElevatedButton(
          onPressed: pickImages,
          child: Text('Pick Images'),
        ),
        _imageFiles.isNotEmpty
            ? Wrap(
          children: _imageFiles.map((imageFile) {
            int index = _imageFiles.indexOf(imageFile);
            return Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  width: 100,
                  height: 100,
                  child: Image.file(
                    File(imageFile.path),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => removeImage(index),
                  ),
                ),
              ],
            );
          }).toList(),
        )
            : Container(),
      ],
    );
  }
}

// Widget for File Field
class FileFieldWidget extends StatefulWidget {
  final TextEditingController titleController;
  final List<String> fileNames;
  final VoidCallback onDelete;

  FileFieldWidget({
    required this.titleController,
    required this.fileNames,
    required this.onDelete,
  });

  @override
  _FileFieldWidgetState createState() => _FileFieldWidgetState();
}

class _FileFieldWidgetState extends State<FileFieldWidget> {
  late List<String> _fileNames;

  @override
  void initState() {
    super.initState();
    _fileNames = widget.fileNames;
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _fileNames.addAll(result.files.map((file) => file.name).toList());
      });
    }
  }

  void removeFile(int index) {
    setState(() {
      _fileNames.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("File Field"),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: widget.onDelete,
            ),
          ],
        ),
        SizedBox(height: 8), // Padding between elements
        TextField(
          controller: widget.titleController,
          decoration: InputDecoration(
            labelText: "Title",
            border: UnderlineInputBorder(), // No border by default
            enabledBorder:
            UnderlineInputBorder(), // No border when enabled but not focused
            focusedBorder:
            UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
        ),
        SizedBox(height: 16), // Padding between title and file button
        ElevatedButton(
          onPressed: pickFiles,
          child: Text('Pick Files'),
        ),
        _fileNames.isNotEmpty
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _fileNames.map((fileName) {
            int index = _fileNames.indexOf(fileName);
            return ListTile(
              title: Text(fileName),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => removeFile(index),
              ),
            );
          }).toList(),
        )
            : Container(),
      ],
    );
  }
}

// Widget for Social Media Field
class SocialMediaFieldWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController linkController;
  final VoidCallback onDelete;

  SocialMediaFieldWidget({
    required this.titleController,
    required this.linkController,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Social Media Field"),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
        SizedBox(height: 8), // Padding between elements
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            border: UnderlineInputBorder(), // No border by default
            enabledBorder:
            UnderlineInputBorder(), // No border when enabled but not focused
            focusedBorder:
            UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
        ),
        SizedBox(height: 16), // Padding between title and link
        TextField(
          controller: linkController,
          decoration: InputDecoration(
            labelText: 'Link',
            border: UnderlineInputBorder(), // No border by default
            enabledBorder:
            UnderlineInputBorder(), // No border when enabled but not focused
            focusedBorder:
            UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
        ),
      ],
    );
  }
}
