import 'package:flutter/material.dart';
import 'package:eventia/main.dart';  // Importing the main.dart for color constants

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int totalTickets = 0;
  double totalPrice = 0.0;

  final List<TicketCategory> categories = [
    TicketCategory(name: 'GA - PHASE 1', price: 999),
    TicketCategory(name: 'FANZONE - PHASE 1', price: 1699),
    TicketCategory(name: 'GA - COUPLE PASS', price: 1699),
    TicketCategory(name: 'FANZONE - COUPLE PASS', price: 2999),
  ];

  void addTicket(int index) {
    setState(() {
      categories[index].quantity++;
      totalTickets++;
      totalPrice += categories[index].price;
    });
  }

  void removeTicket(int index) {
    setState(() {
      if (categories[index].quantity > 0) {
        categories[index].quantity--;
        totalTickets--;
        totalPrice -= categories[index].price;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        title: const Text('Prateek Kuhad Silhouettes Tour',style: TextStyle(color: secondaryColor)),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: secondaryColor),
            onPressed: () {
              // Handle help or info action
            },
            tooltip: 'Help',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Sun 22 Dec at 6:00 PM | Savanna Party Lawn',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select Your Ticket Category',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length + 1, // +1 for the summary card
              itemBuilder: (context, index) {
                if (index == categories.length) {
                  // Simple text card for the summary
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Price: ₹${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          '$totalTickets Tickets',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: totalTickets > 0 ? () {
                            // Handle booking action
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: secondaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          ),
                          child: const Text('Proceed'),
                        ),
                      ],
                    ),
                  );
                } else {
                  final category = categories[index];
                  return Card(
                      color: cardColor,
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        category.name,
                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('₹${category.price.toStringAsFixed(2)}'),
                      trailing: category.quantity == 0
                      
                          ? ElevatedButton(
                        onPressed: () => addTicket(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: secondaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        child: const Text('Add'),
                      )
                          : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: primaryColor),
                            onPressed: () => removeTicket(index),
                          ),
                          Text('${category.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.add, color: primaryColor),
                            onPressed: () => addTicket(index),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),

    );
  }
}

class TicketCategory {
  final String name;
  final double price;
  int quantity;

  TicketCategory({
    required this.name,
    required this.price,
    this.quantity = 0,
  });
}
