import 'package:flutter/material.dart';
import '../../db_helper/db_helper_class.dart';
import '../../model/item.dart';
import '../../shared_prefrance/prefrance.dart';

class ExpensePage extends StatefulWidget {
  final Item? item;

  const ExpensePage({Key? key, this.item}) : super(key: key);

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DbHelper _dbHelper = DbHelper();
  late int _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    if (widget.item != null) {
      _nameController.text = widget.item!.itemName;
      _priceController.text = widget.item!.itemPrice.toString();
      _descriptionController.text = widget.item!.itemDescription;
    }
  }

  Future<void> _loadUserId() async {
    _userId = (await PrefrenceManager.getUserId())!;
  }

  Future<void> _addItem() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    final item = Item(
      itemId: widget.item?.itemId,
      itemName: _nameController.text,
      itemPrice: double.tryParse(_priceController.text) ?? 0.0,
      itemDescription: _descriptionController.text,
      userId: _userId,
      createdAt: widget.item?.createdAt ?? DateTime.now(),
    );

    try {
      if (widget.item == null) {
        await _dbHelper.insertItem(item);
      } else {
        await _dbHelper.updateItem(item);
      }
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.item == null ? 'Item added successfully!' : 'Item updated successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      _showErrorDialog(widget.item == null ? 'Failed to add item' : 'Failed to update item');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Item Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Item Description'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                ),
                child: Text(widget.item == null ? 'Add Item' : 'Update Item', style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
