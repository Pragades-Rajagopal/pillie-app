import 'package:flutter/material.dart';
import 'package:pillie/app/auth/services/auth_service.dart';
import 'package:pillie/app/profile/pages/view_profile_page.dart';
import 'package:pillie/app/user/services/user_service.dart';
import 'package:pillie/components/common_components.dart';
import 'package:pillie/components/pill_card.dart';
import 'package:pillie/models/user_model.dart';
import 'package:pillie/app/pill/services/pill_service.dart';
import 'package:pillie/models/pill_model.dart';

class PillListPage extends StatefulWidget {
  const PillListPage({super.key});

  @override
  State<PillListPage> createState() => _PillListPageState();
}

class _PillListPageState extends State<PillListPage> {
  final ScrollController _scrollController = ScrollController();
  UserService userService = UserService();
  AuthService authService = AuthService();
  PillService? pillService;
  UserModel? user;

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
    setState(() {
      user = fetchedUser;
      pillService = user != null ? PillService(user!.id!) : null;
    });
  }

  Future<void> _showAddPillBottomSheet() async {
    await CommonComponents().showPillModalBottomSheet(context, pillService);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPillBottomSheet(),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        splashColor: Colors.transparent,
        elevation: 0.0,
        child: const Icon(Icons.add, size: 32, color: Colors.black),
      ),
      body: CustomScrollView(
        controller: _scrollController,
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
                                color: Colors.black,
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
            sliver: pillService == null
                ? const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : StreamBuilder<List<PillModel>>(
                    stream: pillService!.pillStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      print(snapshot.error);
                      final pills = snapshot.data ?? [];
                      if (pills.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: Center(child: Text('No pills found.')),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildListDelegate([
                          PillCard(pills: pills, pillService: pillService),
                        ]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
