import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pillie/app/home/screens/pill_list_page.dart';
import 'package:pillie/components/text_button.dart';
import 'package:pillie/components/text_form_field.dart';
import 'package:pillie/databases/user_database.dart';
import 'package:pillie/models/user_model.dart';
import 'package:pillie/utils/dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;
  const EditProfilePage({
    super.key,
    required this.userId,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final db = UserDatabase();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _medicationController = TextEditingController();
  final _medicalNotesController = TextEditingController();
  final _organDonorController = TextEditingController();
  File? _imgFile;

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (mounted) setState(() => _imgFile = File(image.path));
    }
  }

  Future<String?> uploadImage() async {
    final env = await parseDotEnv();
    if (_imgFile == null) return null;
    final currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final fileName = '${widget.userId}_$currentTime';
    final path = 'uploads/$fileName';
    final imgPath = await Supabase.instance.client.storage
        .from('user-profile-picture')
        .upload(path, _imgFile!);
    final imageUrl = '${env["SUPABASE_URL"]}/storage/v1/object/public/$imgPath';
    return imageUrl;
    // TODO: add snack bar for max file size
  }

  dynamic sanitizeInput(TextEditingController controller) =>
      controller.text.isEmpty ? null : controller.text;

  void editUser() async {
    try {
      // Check if text fields are not null
      if (_formKey.currentState!.validate()) {
        final imageUrl = await uploadImage();
        await db.addUser(
          UserModel(
            name: _nameController.text,
            img: imageUrl,
            dob: sanitizeInput(_dobController),
            height: _heightController.text.isNotEmpty
                ? int.tryParse(sanitizeInput(_heightController).toString())
                : null,
            weight: _weightController.text.isNotEmpty
                ? int.tryParse(sanitizeInput(_weightController).toString())
                : null,
            bloodGroup: sanitizeInput(_bloodGroupController),
            medicalNotes: sanitizeInput(_medicalNotesController),
            medications: sanitizeInput(_medicationController),
            organDonor: sanitizeInput(_organDonorController),
          ),
        );
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PillListPage(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 14.0,
            ),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 180),
                    const Text(
                      "Please take a moment to share us some information",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    Stack(
                      children: [
                        if (_imgFile != null) ...{
                          CircleAvatar(
                            radius: 100,
                            backgroundImage: FileImage(_imgFile!),
                          )
                        } else ...{
                          CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.grey[400],
                            child: const Icon(
                              CupertinoIcons.profile_circled,
                              size: 120,
                              color: Colors.white,
                            ),
                          )
                        },
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(30)),
                            child: IconButton(
                              icon: Icon(CupertinoIcons.pencil_circle_fill,
                                  color: Theme.of(context).colorScheme.surface),
                              onPressed: pickImage,
                              iconSize: 40,
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextFormField(
                      labelText: 'Name',
                      textController: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is mandatory";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextFormField(
                      labelText: 'DOB (DD/MM/YYYY)',
                      textController: _dobController,
                      validator: (value) {
                        if (value!.isNotEmpty && value.length != 10) {
                          return "Enter in DD/MM/YYYY format";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextFormField(
                      labelText: 'Blood Group',
                      textController: _bloodGroupController,
                      validator: (value) {
                        if (value!.isNotEmpty && value.length <= 1) {
                          return "Enter the appropriate blood group";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppTextFormField(
                            labelText: 'Height (cms)',
                            textController: _heightController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppTextFormField(
                            labelText: 'Weight (kg)',
                            textController: _weightController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextFormField(
                      labelText: 'Medications',
                      textController: _medicationController,
                    ),
                    const SizedBox(height: 16),
                    AppTextFormField(
                      labelText: 'Medical Notes',
                      textController: _medicalNotesController,
                    ),
                    const SizedBox(height: 16),
                    AppTextFormField(
                      labelText: 'Organ Donor',
                      textController: _organDonorController,
                    ),
                    const SizedBox(height: 14),
                    AppTextButton(buttonText: 'Save', onTap: editUser),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
