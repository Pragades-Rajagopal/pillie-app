import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pillie/app/pill/pages/pill_list_page.dart';
import 'package:pillie/app/user/services/user_service.dart';
import 'package:pillie/components/text_button.dart';
import 'package:pillie/components/text_form_field.dart';
import 'package:pillie/components/text_link.dart';

class SetDatePage extends StatefulWidget {
  final String userId;
  const SetDatePage({super.key, required this.userId});

  @override
  State<SetDatePage> createState() => _SetDatePageState();
}

class _SetDatePageState extends State<SetDatePage> {
  final TextEditingController _dayController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 14.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter the days when all your pills should reset',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    child: AppTextFormField(
                      labelText: "",
                      textController: _dayController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text("days", style: const TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 32),
              AppTextButton(
                buttonText: "Set Date",
                onTap: () async {
                  if (_dayController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("We will not reset your pills"),
                      ),
                    );
                  }
                  if (_dayController.text.isNotEmpty) {
                    final int days = int.parse(_dayController.text);
                    await UserService().updateResetDays(widget.userId, days);
                    if (context.mounted) {
                      // TODO: Fix navigation
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => PillListPage()),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 24),
              AppTextLink(
                onTap: () {
                  // TODO: Fix navigation
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => PillListPage()),
                  );
                },
                linkText: "Skip for now",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
