import 'package:flutter/material.dart';
import '../models/sparepart.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SparePartCard extends StatelessWidget {
  final SparePart sparePart;

  final NumberFormat formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp.',
    decimalDigits: 0,
  );

  SparePartCard({super.key, required this.sparePart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: sparePart.fullImageUrl,
              fit: BoxFit.cover,

              errorWidget: (context, url, error) => const Icon(Icons.image),
            ),
          ),
          Text(
            sparePart.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            formatCurrency.format(sparePart.price),
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
