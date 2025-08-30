import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pillie/app/pill/services/pill_service.dart';
import 'package:pillie/components/text_button.dart';
import 'package:pillie/components/text_form_field.dart';
import 'package:pillie/models/pill_model.dart';

class CommonComponents {
  Future<void> showPillModalBottomSheet(
    BuildContext context,
    PillService? pillService, {
    List<String> options = const ['Day', 'Noon', 'Night'],
    String? pillId,
    String? drugName,
    String? brand,
    String? dosage,
    String? count,
    Set<int>? selectedTime,
    bool isEdit = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final formKey = GlobalKey<FormState>();
        final TextEditingController nameController = TextEditingController();
        final TextEditingController dosageController = TextEditingController();
        final TextEditingController brandController = TextEditingController();
        final TextEditingController countController = TextEditingController();
        final Set<int> selectedTimeOfDay = {};

        if (isEdit) {
          nameController.text = drugName ?? '';
          brandController.text = brand ?? '';
          dosageController.text = dosage ?? '';
          countController.text = count ?? '';
          selectedTimeOfDay.addAll(selectedTime ?? {});
        }
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextFormField(
                      textController: nameController,
                      labelText: "Drug Name *",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a drug name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    AppTextFormField(
                      textController: brandController,
                      labelText: "Brand",
                    ),
                    const SizedBox(height: 12),
                    AppTextFormField(
                      textController: dosageController,
                      labelText: "Dosage",
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 12),
                    AppTextFormField(
                      textController: countController,
                      keyboardType: TextInputType.number,
                      labelText: 'Pill count *',
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a pill count';
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return 'Count must be a number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      children: List<Widget>.generate(options.length, (
                        int index,
                      ) {
                        return FilterChip(
                          showCheckmark: false,
                          label: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            child: Text(options[index]),
                          ),
                          selected: selectedTimeOfDay.contains(index),
                          shadowColor: Colors.transparent,
                          selectedShadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: selectedTimeOfDay.contains(index)
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainer
                                  : Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          selectedColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainer,
                          labelStyle: selectedTimeOfDay.contains(index)
                              ? const TextStyle(color: Colors.black)
                              : TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                          onSelected: (bool selectedValue) {
                            setModalState(() {
                              if (selectedValue) {
                                selectedTimeOfDay.add(index);
                              } else {
                                selectedTimeOfDay.remove(index);
                              }
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    AppTextButton(
                      onTap: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        final String name = nameController.text.trim();
                        final String dosage = dosageController.text.trim();
                        final String brand = brandController.text.trim();
                        final int? count = int.tryParse(
                          countController.text.trim(),
                        );

                        final pillData = PillModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: name,
                          dosage: dosage.isNotEmpty
                              ? double.tryParse(dosage)
                              : null,
                          brand: brand.isNotEmpty ? brand : null,
                          count: count!,
                          day: selectedTimeOfDay.contains(0),
                          noon: selectedTimeOfDay.contains(1),
                          night: selectedTimeOfDay.contains(2),
                        );
                        if (isEdit) {
                          await pillService?.editPill(pillData, pillId!);
                        } else {
                          await pillService?.addPill(pillData);
                        }
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      buttonText: isEdit ? "Edit Pill" : "Add Pill",
                    ),
                    if (isEdit) ...{
                      const SizedBox(height: 12),
                      AppTextButton(
                        onTap: () async {
                          if (isEdit && pillId != null) {
                            await pillService?.deletePill(pillId);
                          }
                          // TODO: Rebuild the pill list page after deletion
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        buttonText: "Delete Pill",
                        buttonColor: Colors.red,
                        textColor: Colors.white,
                      ),
                    },
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
