import 'dart:io';

import 'package:SmartShop/providers/authProvider.dart';
import 'package:SmartShop/responsive.dart';
import 'package:SmartShop/screens/customs/button.dart';
import 'package:SmartShop/screens/dashboard/pagescafold.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  Map<String, dynamic>? _user;
  String? message;
  File? _image;

  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordConfirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessage();
    _loadUserProfile();
  }

  _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  _filePickerForDesktop() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
  }

  _imgFromGallery() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
  }

  _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 150,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Responsive.isMobile(context)
                        ? _openCamera()
                        : _filePickerForDesktop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Responsive.isMobile(context)
                        ? _imgFromGallery()
                        : _filePickerForDesktop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: smartShopAmber,
            radius: 80,
            backgroundImage: Image.asset(
                    _image != null ? _image!.path : 'assets/images/default.png')
                .image,
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: InkWell(
              onTap: () {},
              child: IconButton(
                onPressed: () {
                  _showPicker(context);
                },
                icon: Icon(
                  Icons.camera_alt,
                  color: smartShopWhite,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildNickname() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
      ),
      controller: nameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter nickname';
        }
        return null;
      },
    );
  }

  _buildEmail() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      controller: emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter email';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  _buildPhone() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Phone',
        border: OutlineInputBorder(),
      ),
      controller: phoneController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter phone number';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  _buildPassword() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      controller: passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  _buildNewPassword() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'New Password',
        border: OutlineInputBorder(),
      ),
      controller: newPasswordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  _buildNewPasswordConfirm() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Confirm Password',
        border: OutlineInputBorder(),
      ),
      controller: newPasswordConfirmController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  void _setMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }

  void _loadMessage() async {
    final message = await DatabaseProvider().getMessage();
    _setMessage(message);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message ?? 'Error loading message'),
          duration: const Duration(seconds: 2),
        ),
      );
    });

    // clear message
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('message');
  }

  void _loadUserProfile() async {
    final user = await AuthProvider().getProfile();
    setState(() {
      _user = user;
      nameController.text = user['name'].toString();
      emailController.text = user['email'].toString();
      phoneController.text = user['phone'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Profile',
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Form(
            key: formKey,
            child: Card(
                margin: const EdgeInsets.all(16),
                elevation: 4,
                child: _user == null
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Responsive.isMobile(context)
                            ? Column(
                                children: [
                                  _buildProfileImage(),
                                  const SizedBox(height: 16),
                                  _buildNickname(),
                                  const SizedBox(height: 16),
                                  _buildEmail(),
                                  const SizedBox(height: 16),
                                  _buildPhone(),
                                  const SizedBox(height: 16),
                                  _buildPassword(),
                                  const SizedBox(height: 16),
                                  CustomButton(
                                    method: () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();

                                        var name = nameController.text;
                                        var email = emailController.text;
                                        var phone = phoneController.text;

                                        final success = await AuthProvider()
                                            .updateProfile(
                                                name, email, phone);
                                        if (success != null) {
                                          _loadUserProfile();
                                          _setMessage(
                                              'Profile updated successfully');
                                        } else {
                                          _setMessage('Error updating profile');
                                        }
                                      }
                                    },
                                    placeholder: 'Update Profile',
                                  )
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: _buildProfileImage(),
                                      ),
                                      const SizedBox(width: 32),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            _buildNickname(),
                                            const SizedBox(height: 16),
                                            _buildEmail(),
                                            const SizedBox(height: 16),
                                            _buildPhone(),
                                            const SizedBox(height: 16),
                                            CustomButton(
                                              width: 200,
                                              method: () async {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  formKey.currentState!.save();
                                                  var name =
                                                      nameController.text;
                                                  var email =
                                                      emailController.text;
                                                  var phone =
                                                      phoneController.text;

                                                  final success =
                                                      await AuthProvider()
                                                          .updateProfile(
                                                              name,
                                                              email,
                                                              phone
                                                              );
                                                  if (success != null) {
                                                    _loadUserProfile();
                                                    _setMessage(
                                                        'Profile updated successfully');
                                                  } else {
                                                    _setMessage(
                                                        'Error updating profile');
                                                  }
                                                }
                                              },
                                              placeholder: 'Update Profile',
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                          ],

                                          //  update password fields
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      )),
          ),
          //    password forms
          const SizedBox(height: 8),
          Form(
            key: formKey2,
            child: Card(
                margin: const EdgeInsets.all(16),
                elevation: 4,
                child: _user == null
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Responsive.isMobile(context)
                            ? ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: [
                                  const SizedBox(height: 16),
                                  _buildPassword(),
                                  const SizedBox(height: 16),
                                  _buildNewPassword(),
                                  const SizedBox(height: 16),
                                  _buildNewPasswordConfirm(),
                                  const SizedBox(height: 16),
                                  CustomButton(
                                    method: () async {
                                      if (formKey2.currentState!.validate()) {
                                        formKey2.currentState!.save();

                                        var oldPassword =
                                            passwordController.text;
                                        var newPassword =
                                            newPasswordController.text;
                                        var newPasswordConfirm =
                                            newPasswordConfirmController.text;

                                        if (newPassword != newPasswordConfirm) {
                                          _setMessage('Passwords do not match');
                                          return;
                                        }

                                        final success = await AuthProvider()
                                            .updatePassword(
                                            oldPassword,
                                            newPasswordConfirm,
                                            newPassword);
                                        if (success) {
                                          _loadUserProfile();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Profile()));
                                        } else {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Profile()));
                                        }
                                      }
                                    },
                                    placeholder: 'Update Profile',
                                  )
                                ],
                              )
                            : ListView(
                                shrinkWrap: true,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 32),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const SizedBox(height: 16),
                                            _buildPassword(),
                                            const SizedBox(height: 16),
                                            _buildNewPassword(),
                                            const SizedBox(height: 16),
                                            _buildNewPasswordConfirm(),
                                            const SizedBox(height: 16),
                                            CustomButton(
                                              width: 200,
                                              method: () async {
                                                if (formKey2.currentState!
                                                    .validate()) {
                                                  formKey2.currentState!.save();

                                                  var oldPassword =
                                                      passwordController.text;
                                                  var newPassword =
                                                      newPasswordController
                                                          .text;
                                                  var newPasswordConfirm =
                                                      newPasswordConfirmController
                                                          .text;

                                                  if (newPassword !=
                                                      newPasswordConfirm) {
                                                    _setMessage(
                                                        'Passwords do not match');
                                                    return;
                                                  }

                                                  final success =
                                                  await AuthProvider()
                                                      .updatePassword(
                                                      oldPassword,
                                                      newPasswordConfirm,
                                                      newPassword);
                                                  if (success) {
                                                    _loadUserProfile();
                                                  } else {
                                                    _loadUserProfile();
                                                  }
                                                  _loadMessage();

                                                }

                                              },
                                              placeholder: 'Update Password',
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                          ],

                                          //  update password fields
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      )),
          ),
        ],
      ),
    );
  }
}
