// lib/screens/home/add_plant_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/plant_model.dart';
import '../../utils/constants.dart'; // استيراد الثوابت

class AddPlantScreen extends StatefulWidget {
  final PlantModel? plantToEdit;
  const AddPlantScreen({super.key, this.plantToEdit});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _sunlightController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.plantToEdit != null) {
      _nameController.text = widget.plantToEdit!.name;
      _categoryController.text = widget.plantToEdit!.category;
      _descriptionController.text = widget.plantToEdit!.description;
      _imageUrlController.text = widget.plantToEdit!.image;
      _sunlightController.text = widget.plantToEdit!.sunlight;
      _humidityController.text = widget.plantToEdit!.humidity;
      _heightController.text = widget.plantToEdit!.height;
    }
  }

  Future<void> _savePlant() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final String uid = FirebaseAuth.instance.currentUser!.uid;
        final Map<String, dynamic> plantData = {
          'name': _nameController.text.trim(),
          'category': _categoryController.text.trim(),
          'description': _descriptionController.text.trim(),
          'image': _imageUrlController.text.trim(),
          'sunlight': _sunlightController.text.trim().isEmpty ? 'Medium' : _sunlightController.text.trim(),
          'humidity': _humidityController.text.trim().isEmpty ? '50%' : _humidityController.text.trim(),
          'height': _heightController.text.trim().isEmpty ? '30cm' : _heightController.text.trim(),
          'userId': uid,
          'updatedAt': Timestamp.now(),
        };

        if (widget.plantToEdit == null) {
          plantData['createdAt'] = Timestamp.now();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('my_plants')
              .add(plantData);
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('my_plants')
              .doc(widget.plantToEdit!.id)
              .update(plantData);
        }

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.plantToEdit == null ? "Plant added!" : "Plant updated!"),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isEditing = widget.plantToEdit != null;

    // ألوان ديناميكية
    final Color bgColor = Theme.of(context).scaffoldBackgroundColor;
    final Color cardColor = isDark ? AppColors.darkCard : Colors.white;
    final Color textColor = isDark ? AppColors.darkText : AppColors.primaryText;
    final Color inputFieldColor = isDark ? AppColors.darkBackground : AppColors.buttonBG;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Plant" : "New Creation",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      isEditing ? "Update Details" : "Add New Plant",
                      style: TextStyle(fontSize: 28, color: textColor, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 25),
                      height: 4, width: 60,
                      decoration: BoxDecoration(color: AppColors.accentBrown, borderRadius: BorderRadius.circular(2)),
                    ),
                  ],
                ),
              ),

              _buildFormSection(cardColor, [
                _buildTextField(_nameController, "Plant Name", Icons.eco_outlined, inputFieldColor, textColor),
                _buildTextField(_categoryController, "Category", Icons.category_outlined, inputFieldColor, textColor),
                _buildTextField(_imageUrlController, "Image URL", Icons.image_outlined, inputFieldColor, textColor),
                _buildTextField(_descriptionController, "Description", Icons.description_outlined, inputFieldColor, textColor, maxLines: 3),
              ]),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: Text("Plant Requirements",
                    style: TextStyle(color: isDark ? AppColors.darkAccent : AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 18)),
              ),

              _buildFormSection(cardColor, [
                _buildTextField(_sunlightController, "Sunlight", Icons.wb_sunny_outlined, inputFieldColor, textColor),
                _buildTextField(_humidityController, "Humidity", Icons.water_drop_outlined, inputFieldColor, textColor),
                _buildTextField(_heightController, "Current Height", Icons.straighten_outlined, inputFieldColor, textColor),
              ]),

              const SizedBox(height: 30),

              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _savePlant,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      elevation: 4,
                    ),
                    child: Text(
                      isEditing ? "Save Changes" : "Upload Plant",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(Color color, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: const Border(right: BorderSide(color: AppColors.primaryGreen, width: 8)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, Color fieldColor, Color txtColor, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: txtColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: txtColor.withOpacity(0.6)),
          prefixIcon: Icon(icon, color: AppColors.primaryGreen),
          filled: true,
          fillColor: fieldColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        validator: (value) {
          if ((label == "Plant Name" || label == "Category" || label == "Image URL") && (value == null || value.isEmpty)) {
            return "This field is required";
          }
          return null;
        },
      ),
    );
  }
}