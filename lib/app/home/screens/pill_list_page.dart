import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillie/app/auth/services/auth_service.dart';
import 'package:pillie/app/profile/screens/view_profile.dart';
import 'package:pillie/components/common_components.dart';
import 'package:pillie/components/pill_card.dart';
import 'package:pillie/databases/pill_database.dart';
import 'package:pillie/databases/user_database.dart';
import 'package:pillie/models/pill_modal.dart';

class PillListPage extends StatefulWidget {
  const PillListPage({super.key});

  @override
  State<PillListPage> createState() => _PillListPageState();
}

class _PillListPageState extends State<PillListPage> {
  UserDatabase userDatabase = UserDatabase();
  AuthService authService = AuthService();

  Future<void> logout() async => await authService.signOut();

  @override
  Widget build(BuildContext context) {
    final user = authService.getCurrentUser();
    return FutureBuilder(
      future: userDatabase.getUser(user!["uid"]),
      builder: (userContext, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
        final userProfileInfo = userSnapshot.data[0];
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: false,
                pinned: false,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: const EdgeInsets.all(18),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "Pillie",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.0,
                              ),
                            ),
                            Text(
                              'Welcome ${userProfileInfo["name"]}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewProfilePage(
                                userProfileInfo: userProfileInfo),
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            '${userProfileInfo["img"]}',
                          ),
                        ),
                      ),
                    ],
                  ),
                  background: Container(
                    color: Colors.lightGreen[200],
                  ),
                  stretchModes: const [StretchMode.fadeTitle],
                ),
                expandedHeight: 120,
              ),
              StreamBuilder(
                stream: PillDatabase(user["uid"]).pillStream,
                builder: (pillContext, pillSnapshot) {
                  if (!pillSnapshot.hasData) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (pillSnapshot.hasError) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text('Something went wrong'),
                      ),
                    );
                  }
                  final pills = pillSnapshot.data!;
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext pillListContext, int pillIndex) {
                        return GestureDetector(
                          onTap: () => showEditPillBottomSheet(
                              context, pills[pillIndex], user["uid"]),
                          child: PillCard(pill: pills[pillIndex], pillType: ""),
                        );
                      },
                      childCount: pills.length,
                    ),
                  );
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showAddPillBottomSheet(context, user["uid"]),
            backgroundColor: Colors.lightGreen[200],
            splashColor: Colors.transparent,
            elevation: 0.0,
            child: const Icon(CupertinoIcons.add),
          ),
        );
      },
    );
  }

  void showAddPillBottomSheet(BuildContext context, String userId) {
    final drugNameController = TextEditingController();
    final brandNameController = TextEditingController();
    final countController = TextEditingController();
    final dosageController = TextEditingController();
    final resetDaysController = TextEditingController();
    final List<String> options = ['Day', 'Noon', 'Night'];
    final Set<int> selectedOptions = {};

    void addPill() async {
      await PillDatabase(userId).addPill(PillModel(
        name: drugNameController.text,
        brand: brandNameController.text,
        count: int.tryParse(countController.text),
        resetDays: int.tryParse(resetDaysController.text),
        day: selectedOptions.contains(0) ? true : false,
        noon: selectedOptions.contains(1) ? true : false,
        night: selectedOptions.contains(2) ? true : false,
        dosage: double.tryParse(dosageController.text),
      ));
      if (context.mounted) Navigator.pop(context);
    }

    CommonComponents().pillBottomSheetModal(
      context,
      addPill,
      drugNameController,
      brandNameController,
      countController,
      dosageController,
      resetDaysController,
      options,
      selectedOptions,
      "Add Pill",
    );
  }

  void showEditPillBottomSheet(
      BuildContext context, PillModel pill, String userId) {
    final drugNameController = TextEditingController(text: pill.name ?? '');
    final brandNameController = TextEditingController(text: pill.brand ?? '');
    final countController =
        TextEditingController(text: pill.count?.toString() ?? '');
    final dosageController =
        TextEditingController(text: pill.dosage?.toString() ?? '');
    final resetDaysController =
        TextEditingController(text: pill.resetDays?.toString() ?? '');
    final List<String> options = ['Day', 'Noon', 'Night'];
    final Set<int> selectedOptions = {
      if (pill.day == true) 0,
      if (pill.noon == true) 1,
      if (pill.night == true) 2,
    };

    void editPill() async {
      await PillDatabase(userId).editPill(
        PillModel(
          name: drugNameController.text,
          brand: brandNameController.text,
          count: int.tryParse(countController.text),
          day: selectedOptions.contains(0) ? true : false,
          noon: selectedOptions.contains(1) ? true : false,
          night: selectedOptions.contains(2) ? true : false,
          dosage: double.tryParse(dosageController.text),
          resetDays: int.tryParse(resetDaysController.text),
        ),
        pill.id!,
      );
      if (context.mounted) Navigator.pop(context);
    }

    void deletePill() async {
      await PillDatabase(userId).deletePill(pill.id!);
      if (context.mounted) Navigator.pop(context);
    }

    CommonComponents().pillBottomSheetModal(
      context,
      editPill,
      drugNameController,
      brandNameController,
      countController,
      dosageController,
      resetDaysController,
      options,
      selectedOptions,
      'Edit Pill',
      secondaryButtonText: 'Delete',
      secondaryOnTapAction: deletePill,
    );
  }
}
