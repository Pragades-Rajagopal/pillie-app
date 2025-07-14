import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillie/app/auth/services/auth_service.dart';
import 'package:pillie/components/pill_card.dart';
import 'package:pillie/databases/pill_database.dart';
import 'package:pillie/databases/user_database.dart';

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
                        // onTap: () => Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const ProfilePage(),
                        //   ),
                        // ),
                        onTap: logout,
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
                        return PillCard(pill: pills[pillIndex], pillType: "");
                      },
                      childCount: pills.length,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
