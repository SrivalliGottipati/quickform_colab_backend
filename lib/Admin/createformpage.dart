import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../AppColors.dart';

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
  DateTime? selectedDeadline;

  List<String> selectedBranches = [];
  List<String> selectedSections = [];
  List<int> selectedYears = [];
  List<String> selectedColleges = [];

  final List<String> branches = ['CSE', 'AIML', 'ECE'];
  final List<String> sections = ['A', 'B', 'C'];
  final List<int> years = [1, 2, 3, 4];
  final List<String> colleges = ['AU', 'ACET', 'ACOE'];


  void _pickDeadline() async {
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


  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && selectedDeadline != null) {
      try {
        final formData = {
          'title': titleController.text,
          'description': descriptionController.text,
          'link': linkController.text,
          'createdAt': Timestamp.now(),
          'expiresAt': Timestamp.fromDate(selectedDeadline!),
          'status': 'active',
          'createdBy': {
            'adminID': 'admin123',
            'branchId': 'Optional',
            'collegeId': 'optional',
            'group': 'placement',
          },
          'targetBranches': selectedBranches,
          'targetSections': selectedSections,
          'targetYears': selectedYears,
          'targetColleges': selectedColleges,
        };

        await FirebaseFirestore.instance.collection('forms').add(formData);

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

  Widget _buildMultiSelect<T>(String label, List<T> options, List<T> selected, void Function(bool?, T) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 10,
          children: options.map((item) {
            final isSelected = selected.contains(item);
            return FilterChip(
              label: Text(item.toString()),
              selected: isSelected,
              onSelected: (value) => setState(() {
                if (value) {
                  selected.add(item);
                } else {
                  selected.remove(item);
                }
              }),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deadlineText = selectedDeadline == null
        ? 'Choose Deadline'
        : DateFormat('yyyy-MM-dd HH:mm').format(selectedDeadline!);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Form'),
          backgroundColor: AppColors.third,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter title' : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter description' : null,
                ),
                TextFormField(
                  controller: linkController,
                  decoration: const InputDecoration(labelText: 'Link'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter link' : null,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _pickDeadline,
                  child: Text(deadlineText),
                ),
                const SizedBox(height: 20),
                _buildMultiSelect('Target Branches', branches, selectedBranches, (v, item) {}),
                _buildMultiSelect('Target Sections', sections, selectedSections, (v, item) {}),
                _buildMultiSelect('Target Years', years, selectedYears, (v, item) {}),
                _buildMultiSelect('Target Colleges', colleges, selectedColleges, (v, item) {}),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
