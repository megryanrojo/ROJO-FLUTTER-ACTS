import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../widgets/product_card.dart';
import '../widgets/net_image.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _title('Facilities'),
        SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: SampleData.facilityImages.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: NetImage(SampleData.facilityImages[index], fit: BoxFit.cover),
              ),
            ),
          ),
        ),

        _title('Sports & Areas'),
        GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.85,
          children: SampleData.gridItems.map((e) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(e['icon'] as IconData, size: 28),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(e['name'] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        _title('Gallery'),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: SampleData.facilityImages.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => SizedBox(
              width: 200,
              child: NetImage(
                SampleData.facilityImages[index],
                height: 120,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        _title('Products'),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemCount: SampleData.products.length,
          itemBuilder: (context, i) {
            final p = SampleData.products[i];
            return ProductCard(
              product: p,
              onBook: () {
                context.read<AppState>().book(p);
                _snack(context, 'Booked ${p.title}');
              },
              onReserve: () => _snack(context, 'Reserved ${p.title}'),
            );
          },
        ),
      ],
    );
  }

  Widget _title(String t) => Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 12),
        child: Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }
}
