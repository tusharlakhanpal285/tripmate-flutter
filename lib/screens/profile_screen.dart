import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'login_screen.dart';
import 'my_trips_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  // ------------------ UPCOMING FEATURE ------------------
  void showUpcomingFeature() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🚀 This feature is coming soon!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ------------------ EDIT PROFILE ------------------
  Future<void> editProfile() async {
    final nameController =
    TextEditingController(text: _user?.displayName ?? "");

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Edit Profile"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: "Display Name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;

              await _user?.updateDisplayName(
                nameController.text.trim(),
              );
              await _user?.reload();

              _user = FirebaseAuth.instance.currentUser;

              if (!mounted) return;
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  // ------------------ CONFIRM LOGOUT ------------------
  Future<void> confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5), // 👈 same header blue
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  // ------------------ IMAGE UPLOAD ------------------
  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() => _isUploading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final file = File(pickedFile.path);

      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      await user.updatePhotoURL(downloadUrl);
      await user.reload();

      _user = FirebaseAuth.instance.currentUser;

      if (!mounted) return;
      setState(() => _isUploading = false);
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // ------------------ UI ------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Column(
        children: [
          // 🔵 HEADER WITH GRADIENT
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF42A5F5),
                  Color(0xFF1E88E5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      backgroundImage: _user?.photoURL != null
                          ? NetworkImage(_user!.photoURL!)
                          : null,
                      child: _user?.photoURL == null
                          ? const Icon(Icons.person,
                          size: 60, color: Colors.grey)
                          : null,
                    ),

                    // 📷 Camera Button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (_) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),

                                ListTile(
                                  leading: const Icon(Icons.photo),
                                  title: const Text("Choose from Gallery"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    pickAndUploadImage();
                                  },
                                ),

                                if (_user?.photoURL != null)
                                  ListTile(
                                    leading: const Icon(Icons.delete,
                                        color: Colors.red),
                                    title: const Text("Remove Image"),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await _user?.updatePhotoURL(null);
                                      await _user?.reload();
                                      _user =
                                          FirebaseAuth.instance.currentUser;
                                      if (!mounted) return;
                                      setState(() {});
                                    },
                                  ),

                                const SizedBox(height: 15),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Color(0xFF1E88E5),
                          ),
                        ),
                      ),
                    ),

                    if (_isUploading)
                      const Positioned.fill(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  _user?.displayName ??
                      _user?.email?.split('@')[0] ??
                      "User",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _user?.email ?? "",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding:
              const EdgeInsets.symmetric(horizontal: 16),
              children: [
                buildTile(Icons.edit, "Edit Profile",
                    onTap: editProfile),

                buildTile(Icons.book, "My Bookings",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                            const MyTripsScreen()),
                      );
                    }),

                buildTile(Icons.favorite, "Wishlist",
                    onTap: showUpcomingFeature),

                buildTile(Icons.notifications, "Notifications",
                    onTap: showUpcomingFeature),

                const SizedBox(height: 20),

                buildTile(Icons.logout, "Logout",
                    isLogout: true, onTap: confirmLogout),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTile(
      IconData icon,
      String title, {
        bool isLogout = false,
        VoidCallback? onTap,
      }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color:
          isLogout ? Colors.red : const Color(0xFF1E88E5),
        ),
        title: Text(
          title,
          style: TextStyle(
            color:
            isLogout ? Colors.red : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing:
        const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}