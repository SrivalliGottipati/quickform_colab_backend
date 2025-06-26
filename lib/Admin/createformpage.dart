// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../AppColors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class CreateFormPage extends StatefulWidget {
//   const CreateFormPage({Key? key}) : super(key: key);
//
//   @override
//   State<CreateFormPage> createState() => _CreateFormPageState();
// }
//
// class _CreateFormPageState extends State<CreateFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final linkController = TextEditingController();
//   final sectionController = TextEditingController();
//
//   DateTime? selectedDeadline;
//
//   final List<String> colleges = ['AU', 'ACET'];
//   final List<String> years = ['1', '2', '3', '4'];
//   final List<String> courses = ['B Tech', 'MCA'];
//   final List<String> btechBranches = ['CSE', 'AIML', 'ECE', 'IT', 'DS'];
//   final List<String> types = ['Thub', 'NonThub'];
//
//   Set<String> selectedColleges = {};
//   Set<String> selectedYears = {};
//   Set<String> selectedCourses = {};
//   Set<String> selectedBranches = {};
//   Set<String> selectedTypes = {};
//   Set<String> customSections = {};
//
//   Future<void> _pickDeadline() async {
//     final now = DateTime.now();
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDeadline ?? now,
//       firstDate: now,
//       lastDate: DateTime(now.year + 5),
//     );
//
//     if (pickedDate != null) {
//       final pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//
//       if (pickedTime != null) {
//         setState(() {
//           selectedDeadline = DateTime(
//             pickedDate.year,
//             pickedDate.month,
//             pickedDate.day,
//             pickedTime.hour,
//             pickedTime.minute,
//           );
//         });
//       }
//     }
//   }
//
//   Widget _buildMultiSelect({
//     required String label,
//     required List<String> options,
//     required Set<String> selectedValues,
//     bool isOptional = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             if (!isOptional)
//               const Text(' *', style: TextStyle(color: Colors.red)),
//           ],
//         ),
//         const SizedBox(height: 4),
//         Wrap(
//           spacing: 8.0,
//           runSpacing: -8.0,
//           children: options.map((option) {
//             final isSelected = selectedValues.contains(option);
//             return FilterChip(
//               label: Text(option),
//               selected: isSelected,
//               onSelected: (bool selected) {
//                 setState(() {
//                   if (selected) {
//                     selectedValues.add(option);
//                   } else {
//                     selectedValues.remove(option);
//                   }
//                 });
//               },
//             );
//           }).toList(),
//         ),
//         if (!isOptional && selectedValues.isEmpty)
//           const Padding(
//             padding: EdgeInsets.only(top: 4),
//             child: Text('Required', style: TextStyle(color: Colors.red)),
//           ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }
//
//   void _addSection() {
//     final section = sectionController.text.trim();
//     if (section.isNotEmpty && !customSections.contains(section)) {
//       setState(() {
//         customSections.add(section);
//         sectionController.clear();
//       });
//     }
//   }
//
//   Future<void> _submit() async {
//     if (_formKey.currentState!.validate() &&
//         selectedDeadline != null &&
//         selectedColleges.isNotEmpty &&
//         selectedYears.isNotEmpty &&
//         selectedCourses.isNotEmpty &&
//         (!selectedCourses.contains('B Tech') || selectedBranches.isNotEmpty)) {
//       try {
//         final adminUID = FirebaseAuth.instance.currentUser?.uid;
//
//         if (adminUID == null) {
//           throw Exception('User not logged in');
//         }
//
//         // Fetch admin details
//         final adminDoc = await FirebaseFirestore.instance
//             .collection('admins')
//             .doc(adminUID)
//             .get();
//
//         if (!adminDoc.exists) {
//           throw Exception('Admin details not found');
//         }
//
//         final adminData = adminDoc.data()!;
//         final createdBy = {
//           'adminID': adminUID,
//           'group': adminData['group'] ?? '',
//           'branch': adminData['branch'] ?? '',
//           'college': adminData['college'] ?? '',
//         };
//
//         final formData = {
//           'title': titleController.text.trim(),
//           'description': descriptionController.text.trim(),
//           'link': linkController.text.trim(),
//           'createdAt': Timestamp.now(),
//           'expiresAt': Timestamp.fromDate(selectedDeadline!),
//           'status': 'active',
//           'createdBy': createdBy,
//           'targetcollege': selectedColleges.toList(),
//           'targetyear': selectedYears.toList(),
//           'targetcourse': selectedCourses.toList(),
//           'targetbranch': selectedBranches.toList(),
//           'targetsection': customSections.toList(),
//           'type': selectedTypes.toList(),
//         };
//
//         final formRef = await FirebaseFirestore.instance.collection('forms').add(formData);
//
//         final formID = formRef.id;
//
//         // Save form ID in the admin's subcollection
//         await FirebaseFirestore.instance
//             .collection('admins')
//             .doc(adminUID)
//             .collection('AdminForms')
//             .doc(formID)
//             .set({
//           'formID': formID,
//           'timestamp': Timestamp.now(),
//         });
//
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Form submitted successfully')),
//         );
//
//         Navigator.pop(context);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to submit: $e')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please complete all required fields')),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     titleController.dispose();
//     descriptionController.dispose();
//     linkController.dispose();
//     sectionController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final deadlineText = selectedDeadline == null
//         ? 'Choose Deadline'
//         : DateFormat('yyyy-MM-dd HH:mm').format(selectedDeadline!);
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Create Form'),
//           backgroundColor: AppColors.third,
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   controller: titleController,
//                   decoration: const InputDecoration(
//                     labelText: 'Title *',
//                     alignLabelWithHint: true,
//                   ),
//                   validator: (value) =>
//                   value == null || value.isEmpty ? 'Enter title' : null,
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   controller: descriptionController,
//                   decoration: const InputDecoration(
//                     labelText: 'Description *',
//                     alignLabelWithHint: true,
//                   ),
//                   maxLines: 3,
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Enter description'
//                       : null,
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   controller: linkController,
//                   decoration: const InputDecoration(
//                     labelText: 'Link *',
//                     alignLabelWithHint: true,
//                   ),
//                   validator: (value) =>
//                   value == null || value.isEmpty ? 'Enter link' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _pickDeadline,
//                   child: Text(deadlineText),
//                 ),
//                 const SizedBox(height: 24),
//                 _buildMultiSelect(
//                   label: 'College',
//                   options: colleges,
//                   selectedValues: selectedColleges,
//                 ),
//                 _buildMultiSelect(
//                   label: 'Year',
//                   options: years,
//                   selectedValues: selectedYears,
//                 ),
//                 _buildMultiSelect(
//                   label: 'Course',
//                   options: courses,
//                   selectedValues: selectedCourses,
//                 ),
//                 if (selectedCourses.contains('B Tech'))
//                   _buildMultiSelect(
//                     label: 'Branch',
//                     options: btechBranches,
//                     selectedValues: selectedBranches,
//                   ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'Section (optional)',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: sectionController,
//                         decoration: const InputDecoration(
//                           hintText: 'Enter section name',
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.add),
//                       onPressed: _addSection,
//                     ),
//                   ],
//                 ),
//                 Wrap(
//                   spacing: 8.0,
//                   runSpacing: -8.0,
//                   children: customSections.map((section) {
//                     return Chip(
//                       label: Text(section),
//                       onDeleted: () {
//                         setState(() {
//                           customSections.remove(section);
//                         });
//                       },
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 16),
//                 _buildMultiSelect(
//                   label: 'Type (optional)',
//                   options: types,
//                   selectedValues: selectedTypes,
//                   isOptional: true,
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: _submit,
//                     child: const Text('Submit'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateFormPage extends StatefulWidget {
  const CreateFormPage({Key? key}) : super(key: key);

  @override
  State<CreateFormPage> createState() => _CreateFormPageState();
}

class _CreateFormPageState extends State<CreateFormPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  final sectionController = TextEditingController();

  DateTime? selectedDeadline;

  final List<String> colleges = ['AU', 'ACET'];
  final List<String> years = ['1', '2', '3', '4'];
  final List<String> courses = ['B Tech', 'MCA'];
  final List<String> btechBranches = ['CSE', 'AIML', 'ECE', 'IT', 'DS'];
  final List<String> types = ['Thub', 'NonThub'];

  Set<String> selectedColleges = {};
  Set<String> selectedYears = {};
  Set<String> selectedCourses = {};
  Set<String> selectedBranches = {};
  Set<String> selectedTypes = {};
  Set<String> customSections = {};

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDeadline ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Widget _buildMultiSelect({
    required String label,
    required List<String> options,
    required Set<String> selectedValues,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (!isOptional)
              const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8.0,
          runSpacing: -8.0,
          children: options.map((option) {
            final isSelected = selectedValues.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedValues.add(option);
                  } else {
                    selectedValues.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
        if (!isOptional && selectedValues.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text('Required', style: TextStyle(color: Colors.red)),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _addSection() {
    final section = sectionController.text.trim();
    if (section.isNotEmpty && !customSections.contains(section)) {
      setState(() {
        customSections.add(section);
        sectionController.clear();
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() &&
        selectedDeadline != null &&
        selectedColleges.isNotEmpty &&
        selectedYears.isNotEmpty &&
        selectedCourses.isNotEmpty &&
        (!selectedCourses.contains('B Tech') || selectedBranches.isNotEmpty)) {
      try {
        final adminUID = FirebaseAuth.instance.currentUser?.uid;

        if (adminUID == null) {
          throw Exception('User not logged in');
        }

        // Fetch admin details
        final adminDoc = await FirebaseFirestore.instance
            .collection('admins')
            .doc(adminUID)
            .get();

        if (!adminDoc.exists) {
          throw Exception('Admin details not found');
        }

        final adminData = adminDoc.data()!;
        final createdBy = {
          'adminID': adminUID,
          'group': adminData['group'] ?? '',
          'branch': adminData['branch'] ?? '',
          'college': adminData['college'] ?? '',
        };

        final formData = {
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'link': linkController.text.trim(),
          'createdAt': Timestamp.now(),
          'expiresAt': Timestamp.fromDate(selectedDeadline!),
          'status': 'active',
          'createdBy': createdBy,
          'targetcollege': selectedColleges.toList(),
          'targetyear': selectedYears.toList(),
          'targetcourse': selectedCourses.toList(),
          'targetbranch': selectedBranches.toList(),
          'targetsection': customSections.toList(),
          'type': selectedTypes.toList(),
        };

        final formRef = await FirebaseFirestore.instance.collection('forms').add(formData);

        final formID = formRef.id;

        // Save form ID in the admin's subcollection
        await FirebaseFirestore.instance
            .collection('admins')
            .doc(adminUID)
            .collection('AdminForms')
            .doc(formID)
            .set({
          'formID': formID,
          'timestamp': Timestamp.now(),
        });


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deadlineText = selectedDeadline == null
        ? 'Choose Deadline'
        : DateFormat('yyyy-MM-dd HH:mm').format(selectedDeadline!);

    return SafeArea(
        child: Scaffold(


          body:
          SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color.fromARGB(255, 230, 245, 255),
                    Color.fromARGB(255, 179, 229, 252),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title *',
                          alignLabelWithHint: true,
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Enter title' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description *',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter description'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: linkController,
                        decoration: const InputDecoration(
                          labelText: 'Link *',
                          alignLabelWithHint: true,
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Enter link' : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _pickDeadline,
                        child: Text(deadlineText),
                      ),
                      const SizedBox(height: 24),
                      _buildMultiSelect(
                        label: 'College',
                        options: colleges,
                        selectedValues: selectedColleges,
                      ),
                      _buildMultiSelect(
                        label: 'Year',
                        options: years,
                        selectedValues: selectedYears,
                      ),
                      _buildMultiSelect(
                        label: 'Course',
                        options: courses,
                        selectedValues: selectedCourses,
                      ),
                      if (selectedCourses.contains('B Tech'))
                        _buildMultiSelect(
                          label: 'Branch',
                          options: btechBranches,
                          selectedValues: selectedBranches,
                        ),
                      const SizedBox(height: 12),
                      const Text(
                        'Section (optional)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: sectionController,
                              decoration: const InputDecoration(
                                hintText: 'Enter section name',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _addSection,
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: -8.0,
                        children: customSections.map((section) {
                          return Chip(
                            label: Text(section),
                            onDeleted: () {
                              setState(() {
                                customSections.remove(section);
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      _buildMultiSelect(
                        label: 'Type (optional)',
                        options: types,
                        selectedValues: selectedTypes,
                        isOptional: true,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}


