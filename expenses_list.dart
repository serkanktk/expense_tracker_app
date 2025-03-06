import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    // Burda expenses'ları list olarak döndüreceğiz. Fakat 1000 tane de expenses
    // olabilir. Eğer hepsini bir anda kullanıcıya gösterirsek sıkıntı yaşarız. O yüzden
    // Column() widget'ı yerine ListView widget'ını kullanmamız gerekiyor! Bu otomatik olarak
    // scrollable olan birlist döndürmemizi sağlıyor.

    // ListView.builder methodu ise list'deki itemlarun sadece kullanıcıya visible veya about to
    // be visible olduğu anlarda UI'da yaratılmasını sağlıyor.
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal,
            )),
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(
          expenses[index],
        ),
      ),
    );
  }
}
