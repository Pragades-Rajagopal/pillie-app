import 'package:flutter/material.dart';
import 'package:pillie/app/auth/services/auth_service.dart';
import 'package:pillie/app/profile/pages/view_profile_page.dart';
import 'package:pillie/app/user/services/user_service.dart';
import 'package:pillie/models/user_model.dart';

class PillListPage extends StatefulWidget {
  const PillListPage({super.key});

  @override
  State<PillListPage> createState() => _PillListPageState();
}

class _PillListPageState extends State<PillListPage> {
  UserService userService = UserService();
  AuthService authService = AuthService();
  UserModel? user;
  List<Map<String, dynamic>> pills = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final currentUser = authService.getCurrentUser();
    UserModel? fetchedUser;
    if (currentUser != null) {
      final userInfo = await userService.getUser(currentUser["uid"]);
      if (userInfo != null && userInfo.isNotEmpty) {
        fetchedUser = UserModel.fromMap(userInfo[0]);
      }
    }
    // Placeholder pill data
    final fetchedPills = [
      {'name': 'Aspirin', 'pillsLeft': 12},
      {'name': 'Vitamin D', 'pillsLeft': 8},
      {'name': 'Ibuprofen', 'pillsLeft': 20},
      {'name': 'Metformin', 'pillsLeft': 5},
      {'name': 'Salbutamol', 'pillsLeft': 3},
      {'name': 'Salbutamol', 'pillsLeft': 3},
      {'name': 'Salbutamol', 'pillsLeft': 3},
      {'name': 'Salbutamol', 'pillsLeft': 3},
      {'name': 'Salbutamol', 'pillsLeft': 3},
      {'name': 'Salbutamol', 'pillsLeft': 3},
      {'name': 'Salbutamol', 'pillsLeft': 3},
    ];
    setState(() {
      user = fetchedUser;
      pills = fetchedPills;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            expandedHeight: 80,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            flexibleSpace: FlexibleSpaceBar(
              background: user == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 40,
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              user?.name ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(28),
                            onTap: user?.id != null
                                ? () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ViewProfilePage(
                                          userProfileInfo: user!,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            child: user?.img != null && user!.img!.isNotEmpty
                                ? CircleAvatar(
                                    radius: 28,
                                    backgroundImage: NetworkImage(user!.img!),
                                  )
                                : const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.person,
                                      size: 32,
                                      color: Colors.blue,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 32.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 4.0),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: pills.length,
                  itemBuilder: (context, index) {
                    final pill = pills[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[400]!,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Text(
                              pill['name'] ?? 'Medicine',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${pill['pillsLeft'] ?? 0} pills left this month',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
