import 'package:flutter/material.dart';
import '../services/api.dart';
import '../../theme.dart';

class PlatformResultCard extends StatelessWidget {
  final PlatformResult platformResult;
  final void Function(ProductOffer) onAddToCart;
  final void Function(ProductOffer) onGoToStore;

  const PlatformResultCard({
    super.key,
    required this.platformResult,
    required this.onAddToCart,
    required this.onGoToStore,
  });

  @override
  Widget build(BuildContext context) {
    final platform = platformResult.platform;
    final items = platformResult.items;
    final notAvailable = platformResult.notAvailable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text(
                platform,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              if (notAvailable)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Not available'),
                ),
            ],
          ),
        ),
        if (!notAvailable && items.isNotEmpty)
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return _ProductCard(
                  offer: item,
                  onAddToCart: onAddToCart,
                  onGoToStore: onGoToStore,
                );
              },
            ),
          )
        else if (!notAvailable && items.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Text('No items found on this platform', style: TextStyle(color: ShoplyColors.textSecondary)),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductOffer offer;
  final void Function(ProductOffer) onAddToCart;
  final void Function(ProductOffer) onGoToStore;

  const _ProductCard({
    required this.offer,
    required this.onAddToCart,
    required this.onGoToStore,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: offer.imageUrl != null
                            ? Image.network(offer.imageUrl!, fit: BoxFit.cover)
                            : Container(color: Colors.grey.shade200),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text('${offer.currency} ${offer.price.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              if (offer.originalPrice != null && offer.originalPrice! > offer.price)
                                Text(
                                  '${offer.currency} ${offer.originalPrice!.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: ShoplyColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          if (offer.offerText != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: ShoplyColors.highlight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                offer.offerText!,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => onAddToCart(offer),
                      style: ElevatedButton.styleFrom(backgroundColor: ShoplyColors.accent),
                      child: const Text('Add'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: offer.productUrl == null ? null : () => onGoToStore(offer),
                      child: const Text('Go to store'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
