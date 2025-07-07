import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pillie/components/text_button.dart';
import 'package:pillie/components/text_form_field.dart';

class CommonComponents {
  void pillBottomSheetModal(
    BuildContext context,
    dynamic Function() onTapFunc,
    TextEditingController drugNameController,
    TextEditingController brandNameController,
    TextEditingController countController,
    TextEditingController dosageController,
    TextEditingController resetDaysController,
    List<String> options,
    Set<int> selectedOptions,
    String buttonText, {
    dynamic Function()? secondaryOnTapAction,
    String? secondaryButtonText = '',
  }) {
    GlobalKey formKey = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 12.0, 18.0, 32.0),
            child: StatefulBuilder(
              builder: (context, setState) => Form(
                key: formKey,
                child: Column(
                  children: [
                    AppTextFormField(
                      labelText: 'Drug Name',
                      textController: drugNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Mandatory';
                        }
                        return '';
                      },
                    ),
                    const SizedBox(height: 12),
                    AppTextFormField(
                      labelText: 'Brand Name',
                      textController: brandNameController,
                    ),
                    const SizedBox(height: 12),
                    AppTextFormField(
                      labelText: 'Count',
                      textController: countController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 12),
                    AppTextFormField(
                      labelText: 'Dosage',
                      textController: dosageController,
                    ),
                    const SizedBox(height: 12),
                    AppTextFormField(
                      labelText: 'Reset in Days',
                      textController: resetDaysController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      children:
                          List<Widget>.generate(options.length, (int index) {
                        return FilterChip(
                          showCheckmark: false,
                          label: Text(options[index]),
                          selected: selectedOptions.contains(index),
                          shadowColor: Colors.transparent,
                          selectedShadowColor: Colors.transparent,
                          // labelStyle: TextStyle(
                          //   color: Theme.of(context).colorScheme.tertiary,
                          // ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary,
                              width: 2.0,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          selectedColor: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.5),
                          onSelected: (bool selectedValue) {
                            setState(() {
                              if (selectedValue) {
                                selectedOptions.add(index);
                              } else {
                                selectedOptions.remove(index);
                              }
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 18),
                    AppTextButton(buttonText: buttonText, onTap: onTapFunc),
                    if (secondaryOnTapAction != null) ...{
                      const SizedBox(height: 18),
                      AppTextButton(
                        buttonText: secondaryButtonText!,
                        onTap: secondaryOnTapAction,
                        buttonColor: Colors.red,
                      ),
                    }
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
