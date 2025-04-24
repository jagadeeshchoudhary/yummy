import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:yummy/models/models.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    super.key,
    required this.cartManager,
    required this.didUpdate,
    required this.onSubmit,
  });

  final CartManager cartManager;
  final Function() didUpdate;
  final Function(Order) onSubmit;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final Map<int, Widget> myTab = const {
    0: Text('Delivery'),
    1: Text('Self Pick-Up'),
  };
  Set<int> selectedSegment = {0};
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  final DateTime _firstDate = DateTime(DateTime.now().year - 2);
  final DateTime _lastDate = DateTime(DateTime.now().year + 1);
  final TextEditingController _nameController = TextEditingController();

  void onSegementSelected(Set<int> selectedIndex) {
    setState(() {
      selectedSegment = selectedIndex;
    });
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Select Date';
    } else {
      final formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(dateTime);
    }
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: _firstDate,
      lastDate: _lastDate,
      initialDate: selectedDate ?? DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) {
      return 'Select Time';
    } else {
      final hour = timeOfDay.hour.toString().padLeft(2, '0');
      final minute = timeOfDay.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }
  }

  void _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          alwaysUse24HourFormat: true,
        ),
        child: child!,
      ),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Order Details',
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildOrderSegmented(),
            const SizedBox(height: 16),
            _builtTextField(),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  child: Text(
                    formatDate(selectedDate),
                  ),
                  onPressed: () => _selectDate(context),
                ),
                TextButton(
                  child: Text(
                    formatTimeOfDay(selectedTime),
                  ),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Order Summery'),
            _buildOrderSummery(context),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSegmented() {
    return SegmentedButton(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(
          value: 0,
          label: Text('Delivery'),
          icon: Icon(Icons.pedal_bike),
        ),
        ButtonSegment(
          value: 1,
          label: Text('Pickup'),
          icon: Icon(Icons.local_mall),
        ),
      ],
      selected: selectedSegment,
      onSelectionChanged: onSegementSelected,
    );
  }

  Widget _builtTextField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Contact Name',
      ),
    );
  }

  Widget _buildOrderSummery(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: widget.cartManager.items.length,
      itemBuilder: (context, index) {
        final item = widget.cartManager.itemAt(index);
        return Dismissible(
          direction: DismissDirection.endToStart,
          key: Key(item.id),
          background: Container(),
          secondaryBackground: const SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.delete),
              ],
            ),
          ),
          onDismissed: (direction) {
            setState(() {
              widget.cartManager.removeItem(item.id);
            });
            widget.didUpdate();
          },
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(
                  width: 2.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: Text('x${item.quantity}'),
              ),
            ),
            title: Text(item.name),
            subtitle: Text('Price: \$${item.price}'),
          ),
        );
      },
    ));
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: widget.cartManager.isEmpty
          ? null
          : () {
              final order = Order(
                selectedSegment: selectedSegment,
                selectedTime: selectedTime,
                selectedDate: selectedDate,
                name: _nameController.text,
                items: widget.cartManager.items,
              );
              widget.cartManager.resetCart();
              widget.onSubmit(order);
            },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Submit Order - \$${widget.cartManager.totalCost.toStringAsFixed(2)}',
        ),
      ),
    );
  }
}
