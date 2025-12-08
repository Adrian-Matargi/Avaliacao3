import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../../core/theme/app_colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Carrinho de Compras'),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartViewModel.items.isEmpty
                ? const Center(
                    child: Text('Seu carrinho está vazio.', style: TextStyle(fontSize: 18)),
                  )
                : ListView.builder(
                    itemCount: cartViewModel.items.length,
                    itemBuilder: (context, index) {
                      final item = cartViewModel.items[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(item.product.image),
                        ),
                        title: Text(item.product.title),
                        subtitle: Text('Qtd: ${item.quantity} | R\$ ${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle, color: AppColors.errorColor),
                          onPressed: () {
                            cartViewModel.removeItem(item.product.id);
                          },
                        ),
                      );
                    },
                  ),
          ),
          // Resumo do Carrinho e Botão de Checkout
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                        'R\$ ${cartViewModel.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.accentColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: cartViewModel.items.isEmpty ? null : () {
                      cartViewModel.clearCart();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Compra finalizada com sucesso!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.backgroundColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Finalizar Compra', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}