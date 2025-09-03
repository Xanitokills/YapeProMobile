import 'dart:async';
import 'package:flutter/material.dart';

class SalesView extends StatefulWidget {
  final void Function(String)? onNavigate;

  const SalesView({super.key, this.onNavigate});

  @override
  State<SalesView> createState() => _SalesViewState();
}

class _SalesViewState extends State<SalesView> {
  final _searchController = TextEditingController();
  final _cart = <Map<String, dynamic>>[];
  String _customer = '';

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      final existing = _cart.firstWhere(
        (item) => item['id'] == product['id'],
        orElse: () => <String, dynamic>{},
      );
      if (existing != null) {
        existing['quantity'] = (existing['quantity'] ?? 0) + 1;
      } else {
        _cart.add({'product': product, 'quantity': 1});
      }
    });
  }

  void _removeFromCart(String productId) {
    setState(
      () => _cart.removeWhere((item) => item['product']['id'] == productId),
    );
  }

  void _updateQuantity(String productId, int quantity) {
    setState(() {
      final item = _cart.firstWhere(
        (item) => item['product']['id'] == productId,
      );
      if (quantity <= 0) {
        _removeFromCart(productId);
      } else {
        item['quantity'] = quantity;
      }
    });
  }

  double _getTotal() {
    return _cart.fold(
      0.0,
      (sum, item) => sum + (item['product']['price'] * item['quantity']),
    );
  }

  Future<void> _handleCheckout() async {
    if (_cart.isEmpty) {
      _showAlert('Error', 'El carrito está vacío.');
      return;
    }
    // Simulate checkout
    await Future.delayed(const Duration(seconds: 1));
    _showAlert(
      'Éxito',
      'Orden procesada por S/ ${_getTotal().toStringAsFixed(2)}',
    );
    setState(() {
      _cart.clear();
      _customer = '';
    });
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        'id': '1',
        'name': 'Laptop HP Pavilion',
        'price': 2500.0,
        'stock': 5,
        'minStock': 2,
      },
      {
        'id': '2',
        'name': 'Mouse Inalámbrico',
        'price': 45.0,
        'stock': 15,
        'minStock': 10,
      },
      {
        'id': '3',
        'name': 'Teclado Mecánico',
        'price': 180.0,
        'stock': 1,
        'minStock': 5,
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Punto de Venta',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                      ),
                      child: const Text(
                        'Nuevo Producto',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Buscar productos...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              final isLowStock =
                                  (product['stock'] as int?)! <=
                                  (product['minStock'] as int?)!;
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'] as String,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'S/ ${(product['price'] as double?)?.toStringAsFixed(2) ?? '0.00'}',
                                        style: TextStyle(
                                          color: Colors.orange[700],
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        'Stock: ${product['stock']} ${isLowStock ? '(Bajo)' : ''}',
                                        style: TextStyle(
                                          color: isLowStock
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed:
                                            (product['stock'] as int?)! > 0
                                            ? () => _addToCart(product)
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              (product['stock'] as int?)! > 0
                                              ? Colors.orange[700]
                                              : Colors.grey,
                                        ),
                                        child: Text(
                                          (product['stock'] as int?)! > 0
                                              ? 'Agregar al Carrito'
                                              : 'Sin Stock',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (_cart.isNotEmpty)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Nombre del cliente (opcional)',
                                    ),
                                    onChanged: (value) =>
                                        setState(() => _customer = value),
                                  ),
                                  ..._cart.map(
                                    (item) => ListTile(
                                      title: Text(
                                        '${item['product']['name']} (S/ ${item['product']['price'].toStringAsFixed(2)} x ${item['quantity']})',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () => _updateQuantity(
                                              item['product']['id'],
                                              item['quantity'] - 1,
                                            ),
                                          ),
                                          Text('${item['quantity']}'),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () => _updateQuantity(
                                              item['product']['id'],
                                              item['quantity'] + 1,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            color: Colors.red,
                                            onPressed: () => _removeFromCart(
                                              item['product']['id'],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'S/ ${_getTotal().toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: _handleCheckout,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange[700],
                                    ),
                                    child: const Text(
                                      'Procesar con Yape',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
