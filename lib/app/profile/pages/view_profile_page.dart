import 'package:flutter/material.dart';
import 'package:pillie/app/profile/pages/edit_profile_page.dart';
import 'package:pillie/components/text_link.dart';
import 'package:pillie/models/user_model.dart';
import 'package:pillie/utils/helper_functions.dart';

class ViewProfilePage extends StatefulWidget {
  final UserModel userProfileInfo;
  const ViewProfilePage({super.key, required this.userProfileInfo});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userInfo = widget.userProfileInfo;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
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
                        Text(
                          '${userInfo.name}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage('${userInfo.img}'),
                  ),
                ],
              ),
              stretchModes: const [StretchMode.fadeTitle],
            ),
            expandedHeight: 120,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 14.0,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dataElement('Blood Group', userInfo.bloodGroup),
                  dataElement(
                    'DOB',
                    userInfo.dob != null
                        ? convertDateFormat(
                            userInfo.dob.toString(),
                            format: 'dmy',
                            separator: '-',
                          )
                        : '',
                  ),
                  dataElement(
                    'Height',
                    userInfo.height != null ? userInfo.height.toString() : '',
                  ),
                  dataElement(
                    'Weight',
                    userInfo.weight != null ? userInfo.weight.toString() : '',
                  ),
                  dataElement('Medications', userInfo.medications),
                  dataElement('Medical Notes', userInfo.medicalNotes),
                  dataElement('Organ Donor', userInfo.organDonor),
                  const SizedBox(height: 20),
                  AppTextLink(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          userId: userInfo.id!,
                          route: "/profile",
                        ),
                      ),
                    ),
                    linkText: 'Edit Profile',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dataElement(String header, String? value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(header, style: TextStyle(fontSize: 20.0, color: Colors.grey[600])),
      Text(
        value == null || value.isEmpty ? '-' : value,
        style: TextStyle(fontSize: 28.0, color: Colors.black),
      ),
      const SizedBox(height: 12),
    ],
  );
}
