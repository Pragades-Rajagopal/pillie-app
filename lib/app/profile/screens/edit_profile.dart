import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pillie/components/text_button.dart';
import 'package:pillie/components/text_form_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _medicationController = TextEditingController();
  final _medicalNotesController = TextEditingController();
  final _organDonorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            snap: true,
            pinned: false,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Please take a moment to share us some information",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              stretchModes: [StretchMode.fadeTitle],
            ),
            expandedHeight: 180,
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
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.grey[400],
                          child: const Icon(
                            CupertinoIcons.profile_circled,
                            size: 120,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(30)),
                            child: IconButton(
                              icon: Icon(CupertinoIcons.pencil_circle_fill,
                                  color: Theme.of(context).colorScheme.surface),
                              onPressed: () {},
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
                    AppTextButton(buttonText: 'Save', onTap: () {}),
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
