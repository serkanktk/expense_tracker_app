import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          // tüm column elementlerinin soldan başlamasını sağlıyor
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              // tanımlamış olduğumuz bir theme'e erişmek istediğimizde
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text("\$${expense.amount.toStringAsFixed(2)}"),
                const Spacer(), // Önceki text Widget ekranda gösteriliyor ve kaplayabileceği maks yeri kaplıyor.
                // ardından araya bir spacer widget geliyor ve kalan öğeler ekranda gösteriliyor. Böylece kendinden önce
                // ve sonra gelen iki widget arasına boşluk atmış oluyoruz.
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 8),
                    Text(expense.formattedDate)
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
