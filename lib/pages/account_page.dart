import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:yummy/models/models.dart';

typedef LogoutCallback = void Function(bool didLogout);

class AccountPage extends StatefulWidget {
  const AccountPage({
    super.key,
    required this.user,
    required this.onLogOut,
  });

  final User user;
  final LogoutCallback onLogOut;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfile(),
            Expanded(
              child: _buildMenu(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage(
            widget.user.profileImageUrl,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.user.firstName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(widget.user.role),
        Text('${widget.user.points} Points'),
      ],
    );
  }

  Widget _buildMenu() {
    return ListView(
      children: [
        ListTile(
            title: const Text('View Kodeco'),
            onTap: () async {
              await launchUrl(
                Uri.parse('https://www.kodeco.com/'),
              );
            }),
        ListTile(
          title: const Text('Log Out'),
          onTap: () => widget.onLogOut(true),
        ),
      ],
    );
  }
}
