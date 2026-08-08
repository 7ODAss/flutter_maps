import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/core/utils/app_color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/app_strings.dart';
import '../../business_logic/phone_auth/phone_auth_cubit.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  Widget buildDrawerHeader(context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsetsDirectional.fromSTEB(70, 10, 70, 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue[100],
          ),
          child: Image.asset('assets/images/mahmoud.png', fit: BoxFit.cover),
        ),
        Text(
          '7ODAs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          '01063881930',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildDrawerListItem({
    required IconData leadingIcon,
    required String title,
    Widget? trailing,
    Function()? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(leadingIcon, color: color ?? AppColor.blue),
      title: Text(title),
      trailing: trailing ??= Icon(Icons.arrow_right, color: AppColor.blue),
      onTap: onTap,
    );
  }

  Widget buildDrawerListItemsDivider() {
    return Divider(height: 0, thickness: 1, indent: 18, endIndent: 24);
  }

  void _launchURL(Uri url) async {
    await canLaunchUrl(url) ? launchUrl(url) : throw 'Could not launch $url';
  }

  Widget buildIcon(Widget icon, Uri url) {
    return IconButton(
      onPressed: () => _launchURL(url),
      icon: icon,
      color: AppColor.blue,
      iconSize: 35,
    );
  }

  Widget buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: Row(
        children: [
          buildIcon(
            FaIcon(FontAwesomeIcons.facebook),
            Uri.parse('https://www.facebook.com/groups/omarahmedx14'),
          ),
          const SizedBox(width: 15),
          buildIcon(
            FaIcon(FontAwesomeIcons.youtube),
            Uri.parse('https://www.youtube.com/c/OmarAhmedx14/videos'),
          ),
          const SizedBox(width: 20),
          buildIcon(
            FaIcon(FontAwesomeIcons.telegram),
            Uri.parse('https://t.me/OmarX14'),
          ),
        ],
      ),
    );
  }

  Widget buildLogoutBlocProvider(context) {
    return BlocProvider<PhoneAuthCubit>(
      create: (context) => phoneAuthCubit,
      child: buildDrawerListItem(
        leadingIcon: Icons.logout,
        title: 'Logout',
        onTap: () async {
          await phoneAuthCubit.logOut();
          Navigator.of(context).pushReplacementNamed(AppStrings.loginScreen);
        },
        color: Colors.red,
        trailing: SizedBox(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 400,
            child: DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(color: Colors.blue[100]),
              child: buildDrawerHeader(context),
            ),
          ),
          buildDrawerListItem(leadingIcon: Icons.person, title: 'My Profile'),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.history,
            title: 'Places History',
            onTap: () {},
          ),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(leadingIcon: Icons.settings, title: 'Settings'),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(leadingIcon: Icons.help, title: 'Help'),
          buildDrawerListItemsDivider(),
          buildLogoutBlocProvider(context),
          const SizedBox(height: 150),
          ListTile(
            leading: Text(
              'Follow us',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          buildSocialMediaIcons(),
        ],
      ),
    );
  }
}
