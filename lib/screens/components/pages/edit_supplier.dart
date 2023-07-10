import 'package:SmartShop/providers/UserProvider.dart';
import 'package:SmartShop/responsive.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/providers/itemProvider.dart';
import 'package:SmartShop/screens/customs/button.dart';
import 'package:SmartShop/screens/dashboard/pagescafold.dart';

class EditSupplier extends StatefulWidget {
  final int? itemID;
  const EditSupplier({Key? key, this.itemID}) : super(key: key);

  @override
  _EditSupplierState createState() => _EditSupplierState();
}

class _EditSupplierState extends State<EditSupplier> {
  Map<String, dynamic>? _item;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadItem(widget.itemID.toString());
  }

  void _loadItem(String itemID) async {
    final item = await UserProvider().getSupplier(itemID);
    setState(() {
      _item = item;
      nameController.text = item!['name'].toString();
      emailController.text = item!['email'].toString();
      phoneController.text = item!['phone'].toString();
      addressController.text = item!['address'].toString();
    });
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return PageScaffold(
        title: 'Supplier Details',
        body: Form(
            key: formKey,
            child: Card(
                margin: const EdgeInsets.all(16),
                child: _item == null
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: isMobile
                            ? ListView(
                                scrollDirection: Axis.vertical,
                                children: [
                                  Image.asset(
                                    // random image from unsplash
                                    'assets/images/logo.png',
                                    height: Responsive.isMobile(context)
                                        ? 200
                                        : 400,
                                    width: Responsive.isMobile(context)
                                        ? 200
                                        : 400,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: nameController,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: emailController,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Phone Number',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: phoneController,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Supplier Address',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: addressController,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomButton(
                                    placeholder: 'Save',
                                    icon: Icons.save,
                                    method: () {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        var name = nameController.text;
                                        var email = emailController.text;
                                        var phone = phoneController.text;
                                        var address = addressController.text;

                                        UserProvider()
                                            .updateSupplier(name, email,
                                                address, phone, widget.itemID!)
                                            .then((value) {
                                          if (value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text('Item Updated'),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('Error Updating Item'),
                                              ),
                                            );
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          // random image from unsplash
                                          'assets/images/logo.png',
                                          height: Responsive.isMobile(context)
                                              ? 200
                                              : 250,
                                          width: Responsive.isMobile(context)
                                              ? 200
                                              : 250,
                                        ),
                                        const SizedBox(width: 16),
                                        IconButton(
                                          onPressed: () {
                                            _loadItem(widget.itemID.toString());
                                          },
                                          icon: const Icon(
                                            Icons.lightbulb_outline,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: ListView(
                                        scrollDirection: Axis.vertical,
                                        children: [
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Name',
                                              border: OutlineInputBorder(),
                                            ),
                                            controller: nameController,
                                          ),
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Email',
                                              border: OutlineInputBorder(),
                                            ),
                                            controller: emailController,
                                          ),
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Phone Number',
                                              border: OutlineInputBorder(),
                                            ),
                                            controller: phoneController,
                                          ),
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Supplier Address',
                                              border: OutlineInputBorder(),
                                            ),
                                            controller: addressController,
                                          ),
                                          const SizedBox(height: 16),
                                          CustomButton(
                                            placeholder: 'Save',
                                            icon: Icons.save,
                                            method: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                formKey.currentState!.save();
                                                var name = nameController.text;
                                                var email =
                                                    emailController.text;
                                                var phone =
                                                    phoneController.text;
                                                var address =
                                                    addressController.text;

                                                UserProvider()
                                                    .updateSupplier(
                                                        name,
                                                        email,
                                                        address,
                                                        phone,
                                                        widget.itemID!)
                                                    .then((value) {
                                                  if (value) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Item Updated'),
                                                      ),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Error Updating Item'),
                                                      ),
                                                    );
                                                  }
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                      ))));
  }
}
