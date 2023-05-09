import 'package:flutter/material.dart';
import 'package:ilocate/custom_widgets/CustomText.dart';
import 'package:ilocate/providers/itemProvider.dart';
import 'package:ilocate/screens/customs/button.dart';
import 'package:ilocate/screens/dashboard/pagescafold.dart';

class ItemDetail extends StatefulWidget {
  final int? itemID;
  const ItemDetail({Key? key, this.itemID}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  Map<String, dynamic>? _item;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadItem(widget.itemID.toString());
  }

  void _loadItem(String itemID) async {
    final item = await ItemProvider().getItem(itemID);
    setState(() {
      setState(() {
        _item = item;
        nameController.text = item!['name'].toString();
        quantityController.text = item!['quantity'].toString();
        priceController.text = item!['price_per_unit'].toString();
        supplierController.text = item!['supplier'].toString();
        descriptionController.text = item!['description'].toString();
        supplierController.text = item!['supplier_id'].toString();
      });
    });
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController pinNumberController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  clearInput() {
    nameController.clear();
    costController.clear();
    priceController.clear();
    quantityController.clear();
    pinNumberController.clear();
    supplierController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return PageScaffold(
      title: 'Item Details',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _item?['name'] ?? 'Item Details',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                            Image.asset(
                              // random image from unsplash
                              'assets/images/logo.png',
                              height: 200,
                              width: 200,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Item Name',
                                border: OutlineInputBorder(),
                              ),
                              controller: nameController,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Item Quantity',
                                border: OutlineInputBorder(),
                              ),
                              controller: quantityController,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Item Price',
                                border: OutlineInputBorder(),
                              ),
                              controller: priceController,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Item Category',
                                border: OutlineInputBorder(),
                              ),
                              initialValue: _item!['category'].toString(),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Item Description',
                                border: OutlineInputBorder(),
                              ),
                              controller: descriptionController,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Supplier ID',
                                border: OutlineInputBorder(),
                              ),
                              controller: supplierController,
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              placeholder: 'Save',
                              icon: Icons.save,
                              method: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  var name = nameController.text;
                                  var cost = costController.text;
                                  var price = priceController.text;
                                  var quantity = quantityController.text;
                                  var location = pinNumberController.text;
                                  var supplierId = supplierController.text;
                                  var description = descriptionController.text;

                                  ItemProvider()
                                      .updateItem(
                                    name,
                                    description,
                                    price,
                                    quantity,
                                    cost,
                                    location,
                                    supplierId,
                                    description,
                                  )
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
                                          content: Text('Error Updating Item'),
                                        ),
                                      );
                                    }
                                    clearInput();
                                  });
                                }
                              },
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  // random image from unsplash
                                  'assets/images/logo.png',
                                  height: 200,
                                  width: 200,
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  onPressed: () {
                                    _loadItem(widget.itemID.toString());
                                  },
                                  icon: const Icon(Icons.lightbulb_outline, color: Colors.yellow,),
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _loadItem(widget.itemID.toString());
                                    },
                                    icon: const Icon(Icons.refresh),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        placeholder:
                                            _item!['name'].toString() == ''
                                                ? 'Item Details'
                                                : _item!['name'].toString(),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Item Name',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: nameController,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Item Quantity',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: quantityController,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Item Price',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: priceController,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Item Category',
                                      border: OutlineInputBorder(),
                                    ),
                                    initialValue: _item!['category'].toString(),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Item Description',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: descriptionController,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Supplier ID',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: supplierController,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomButton(
                                    placeholder: 'Save',
                                    icon: Icons.save,
                                    method: () {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        var name = nameController.text;
                                        var cost = costController.text;
                                        var price = priceController.text;
                                        var quantity = quantityController.text;
                                        var location = pinNumberController.text;
                                        var supplierId =
                                            supplierController.text;
                                        var description =
                                            descriptionController.text;

                                        ItemProvider()
                                            .updateItem(
                                          name,
                                          description,
                                          price,
                                          quantity,
                                          cost,
                                          location,
                                          supplierId,
                                          widget.itemID.toString(),
                                        )
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
                              ),
                            ),
                          ],
                        ),
                ),
        ),
      ),
    );
  }
}
