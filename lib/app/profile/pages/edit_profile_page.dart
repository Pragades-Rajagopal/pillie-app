import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:pillie/components/drop_down_field.dart';
import 'package:pillie/components/text_button.dart';
import 'package:pillie/components/text_form_field.dart';
import 'package:pillie/app/user/services/user_service.dart';
import 'package:pillie/models/user_model.dart';
import 'package:pillie/utils/dotenv.dart';
import 'package:pillie/utils/helper_functions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Custom input formatter for DD/MM/YYYY
class _DobInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll("/", "");
    final buffer = StringBuffer();
    for (int i = 0; i < text.length && i < 8; i++) {
      buffer.write(text[i]);
      if ((i == 1 || i == 3) && i != text.length - 1) {
        buffer.write('/');
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String userId;
  final String? route;
  const EditProfilePage({super.key, required this.userId, this.route = "/"});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserService userService = UserService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _dobInputFormatter = _DobInputFormatter();
  final _bloodGroupController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _medicationController = TextEditingController();
  final _medicalNotesController = TextEditingController();
  final _organDonorController = TextEditingController();
  String _imgUrl = "";
  File? _imgFile;

  // if the route is not "/", then load existing user data
  @override
  void initState() {
    super.initState();
    if (widget.route != "/") {
      _loadUserData();
    }
  }

  void _loadUserData() async {
    final userInfo = await userService.getUser(widget.userId);
    if (userInfo != null && userInfo.isNotEmpty) {
      final user = UserModel.fromMap(userInfo[0]);
      setState(() {
        _nameController.text = user.name ?? '';
        _dobController.text = convertDateFormat(
          user.dob!,
          format: 'dmy',
          separator: '-',
        );
        _bloodGroupController.text = user.bloodGroup ?? '';
        _heightController.text = user.height != null
            ? user.height.toString()
            : '';
        _weightController.text = user.weight != null
            ? user.weight.toString()
            : '';
        _medicationController.text = user.medications ?? '';
        _medicalNotesController.text = user.medicalNotes ?? '';
        _organDonorController.text = user.organDonor ?? '';
        // Load image from URL if available
        if (user.img != null && user.img!.isNotEmpty) {
          _imgUrl = user.img!;
        }
      });
    }
  }

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
        await userService.upsertUser(
          UserModel(
            name: _nameController.text,
            img: imageUrl ?? _imgUrl,
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
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Something went wrong')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          if (widget.route != "/")
            SliverAppBar(
              pinned: false,
              expandedHeight: 60,
              // backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('Edit Profile', style: TextStyle(fontSize: 16)),
                centerTitle: true,
                // titlePadding: EdgeInsets.only(left: 18, bottom: 16),
              ),
            ),
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
                    if (widget.route == "/") ...{
                      const SizedBox(height: 180),
                      const Text(
                        "Please take a moment to share us some information",
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                    },
                    Stack(
                      children: [
                        if (_imgFile != null) ...{
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: FileImage(_imgFile!),
                          ),
                        } else if (_imgUrl.isNotEmpty) ...{
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(_imgUrl),
                          ),
                        } else ...{
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey[400],
                            child: const Icon(
                              CupertinoIcons.profile_circled,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        },
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              icon: Icon(
                                CupertinoIcons.pencil_circle,
                                color: Colors.black,
                              ),
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
                      inputFormatters: [_dobInputFormatter],
                      validator: (value) {
                        if (value!.isNotEmpty && value.length != 10) {
                          return "Enter in DD/MM/YYYY format";
                          // Custom input formatter for DD/MM/YYYY
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // AppTextFormField(
                    //   labelText: 'Blood Group',
                    //   textController: _bloodGroupController,
                    //   validator: (value) {
                    //     if (value!.isNotEmpty && value.length <= 1) {
                    //       return "Enter the appropriate blood group";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    AppDropDownField(
                      items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                      controller: _bloodGroupController,
                      label: 'Blood Group',
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
                              FilteringTextInputFormatter.digitsOnly,
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
                              FilteringTextInputFormatter.digitsOnly,
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
