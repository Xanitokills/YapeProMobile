import 'package:flutter/material.dart';

class InventoryView extends StatefulWidget {
  final void Function(String)? onNavigate;

  const InventoryView({super.key, this.onNavigate});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        'id': '1',
        'name': 'Laptop HP Pavilion',
        'sku': 'HP-PAV-001',
        'category': 'Electrónicos',
        'price': 2500.0,
        'stock': 5,
        'minStock': 2,
      },
      {
        'id': '2',
        'name': 'Mouse Inalámbrico',
        'sku': 'MS-WRL-002',
        'category': 'Accesorios',
        'price': 45.0,
        'stock': 15,
        'minStock': 10,
      },
      {
        'id': '3',
        'name': 'Teclado Mecánico',
        'sku': 'KB-MEC-003',
        'category': 'Accesorios',
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
                      'Inventario',
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
                        'Agregar Producto',
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
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
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
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Filtros'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              final isLowStock =
                                  (product['stock'] != null &&
                                      product['minStock'] != null)
                                  ? (product['stock'] as int) <=
                                        (product['minStock'] as int)
                                  : false;
                              return ListTile(
                                title: Text(product['name'] as String),
                                subtitle: Text(
                                  'SKU: ${product['sku']} | ${product['category']}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'S/ ${(product['price'] != null ? (product['price'] as double).toStringAsFixed(2) : '0.00')}',
                                    ),
                                    Text(' | ${product['stock']}'),
                                    Text(
                                      ' | ${isLowStock ? 'Bajo' : 'OK'}',
                                      style: TextStyle(
                                        color: isLowStock
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.visibility),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Colors.red,
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
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
