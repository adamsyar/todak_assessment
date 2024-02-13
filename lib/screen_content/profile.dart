import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todak_assessment/main.dart';
import 'package:todak_assessment/object/profile_obj.dart';
import 'package:todak_assessment/shared_preferences.dart'; // Import ProfileInfo and SharedPreferencesHandler

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool expand = false;
  ProfileInfo? _profileInfo;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    ProfileInfo profile = await SharedPreferencesHandler.getProfile();
    setState(() {
      _profileInfo = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CupertinoColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/avatar1.png'),
                ),
                const SizedBox(height: 10),
                // Use _profileInfo to display profile information
                Text(
                  _profileInfo?.name ?? 'Default Name',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                buildAddress(),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector buildAddress() {
    return GestureDetector(
      onTap: () {
        setState(() {
          expand = !expand;
        });
      },
      child: Container(
        decoration: const BoxDecoration(
          color: CupertinoColors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  CupertinoButton(
                    minSize: 0,
                    padding: const EdgeInsets.only(
                        left: 10, right: 0, bottom: 3, top: 0),
                    onPressed: null,
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: expand ? 0.5 : 0,
                      child: const Icon(
                        CupertinoIcons.chevron_down,
                        color: CupertinoColors.black,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: expand ? 5 : 0,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: expand
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: _profileInfo?.addresses.length ?? 0,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Text(
                                _profileInfo?.addresses[index] ??
                                    'Default Address',
                                softWrap: true,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              if (index <
                                  (_profileInfo?.addresses.length ?? 0) - 1)
                                const Divider(), // Add divider if not the last item
                            ],
                          );
                        },
                      )
                    : const SizedBox(height: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
