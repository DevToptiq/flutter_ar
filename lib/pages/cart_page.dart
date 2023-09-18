import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/customizewidgets/cart_item_view.dart';
import 'package:user_app/pages/checkout_page.dart';
import 'package:user_app/providers/cart_provider.dart';
import 'package:user_app/utils/constants.dart';

class CartPage extends StatelessWidget {
  static const String routeName = '/cart';

  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).clearCart();
            },
            child: const Text('CLEAR'),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.cartList.length,
                itemBuilder: (context, index) {
                  final cartModel = provider.cartList[index];
                  return CartItemView(
                      cartModel: cartModel, cartProvider: provider);
                },
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'SUBTOTAL: $currencySymbol${provider.getCartSubTotal()}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: provider.cartList.isEmpty ? null : () {
                        Navigator.pushNamed(context, CheckoutPage.routeName);
                      },
                      child: const Text("CHECKOUT"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
