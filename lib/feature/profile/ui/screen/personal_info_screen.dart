import 'package:egytravel_app/feature/profile/logic/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final controller = Get.find<ProfileController>();
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController nationalityController;
  late TextEditingController dobController;

  @override
  void initState() {
    super.initState();
    final p = controller.profile.value;
    nameController = TextEditingController(text: p?.name);
    phoneController = TextEditingController(text: p?.phone);
    nationalityController = TextEditingController(text: p?.nationality);
    dobController = TextEditingController(text: p?.dateOfBirth);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    nationalityController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Personal Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1628), Color(0xFF0D1B2E)],
          ),
        ),
        child: Obx(() {
          return Skeletonizer(
            enabled: controller.isLoading.value,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Full Name'),
                  _buildTextField(nameController, Icons.person_outline_rounded),
                  const SizedBox(height: 20),
                  _buildLabel('Phone Number'),
                  _buildTextField(phoneController, Icons.phone_outlined),
                  const SizedBox(height: 20),
                  _buildLabel('Nationality (Optional)'),
                  _buildTextField(nationalityController, Icons.public_rounded),
                  const SizedBox(height: 20),
                  _buildLabel('Date of Birth (Optional)'),
                  _buildTextField(
                    dobController,
                    Icons.calendar_today_outlined,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(const Duration(days: 6570)),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Color(0xFF6366F1),
                                onPrimary: Colors.white,
                                surface: Color(0xFF0D1B2E),
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        dobController.text = formattedDate;
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isUpdatingProfile.value
                          ? null
                          : () {
                              controller.updateProfile(
                                name: nameController.text,
                                phone: phoneController.text,
                                nationality: nationalityController.text,
                                dateOfBirth: dobController.text,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: controller.isUpdatingProfile.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon,
      {bool readOnly = false, VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white38, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
