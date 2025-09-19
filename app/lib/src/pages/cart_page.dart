import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../../theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(appStateProvider.select((s) => s.cartItems));
    final total = items.fold<double>(0, (sum, i) => sum + (i.offer.price * i.quantity));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparison Cart'),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text('Your comparison cart is empty'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        child: ListTile(
                          leading: item.offer.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(item.offer.imageUrl!, width: 48, height: 48, fit: BoxFit.cover),
                                )
                              : const Icon(Icons.shopping_bag),
                          title: Text(item.offer.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                          subtitle: Text('${item.offer.store} • ${item.offer.currency} ${item.offer.price.toStringAsFixed(2)}'),
                          trailing: SizedBox(
                            width: 140,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    if (item.quantity > 1) {
                                      ref.read(appStateProvider.notifier).removeFromCart(item.offer.id);
                                      // Re-add with quantity-1
                                      for (int i = 0; i < item.quantity - 1; i++) {
                                        ref.read(appStateProvider.notifier).addToCart(item.offer);
                                      }
                                    } else {
                                      ref.read(appStateProvider.notifier).removeFromCart(item.offer.id);
                                    }
                                  },
                                ),
                                Text('${item.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => ref.read(appStateProvider.notifier).addToCart(item.offer),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            if (item.offer.productUrl != null) {
                              final url = Uri.parse(item.offer.productUrl!);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url, mode: LaunchMode.externalApplication);
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: ShoplyColors.shadow, offset: const Offset(0, -1), blurRadius: 4),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Estimated total', style: TextStyle(fontWeight: FontWeight.w600)),
                            Text('₹ or $ depends on store • Not a checkout', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(total.toStringAsFixed(2), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          // This is just a comparison cart; checkout happens at the store.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Select an item to complete purchase on the store')),
                          );
                        },
                        child: const Text('Choose store'),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
