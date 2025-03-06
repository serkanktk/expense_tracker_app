import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
// IOS styling language
import 'package:flutter/cupertino.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  /*
  var _enteredTitle = "";

  void _saveTitleInput(String inputValue) {
    // no need to wrap this with setState, because we don't update UI based on this variable
    _enteredTitle = inputValue;
  }
  */

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  // TextEditingController() objesi yarattığında Flutter'a bu widget'a artık ihtiyaç
  // duyulmadığında silinmesi gerektiğini de söylemelisin.
  // Yani model overlay kapatıldığında, bu controller'ın da silinmesi gerekiyor!

  // "dipose" is a part of StatefulWidget's lifecycle. It is called automatically when
  // the widget and its state are about to be destroyed or removed from the UI.

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    // this line will only be executed once the pickedDate value is available
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              "Please make sure a valid title, amount, date and category was entered."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("Okay"))
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              "Please make sure a valid title, amount, date and category was entered."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("Okay"))
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    // trim boşlukları silmek için kullanılıyor.

    // tryParse("Hello") => null, tryParse("1.12") => 1.12
    final enteredAmount = double.tryParse(_amountController.text);

    final amountIsValid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsValid ||
        _selectedDate == null) {
      _showDialog();
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text.trim(),
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth; // available width for layout

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            // padding bırakmak için
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          // onChanged: _saveTitleInput,
                          // the max amount of characters that can be entered to this input field
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text("Title"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: "\$ ",
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    // onChanged: _saveTitleInput,
                    // the max amount of characters that can be entered to this input field
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: "\$ ",
                          label: Text("Amount"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _selectedDate == null
                                ? "No date selected"
                                : formatter.format(_selectedDate!),
                          ),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toUpperCase())))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value == null) {
                            return;
                          }
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text("Save Expense"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
