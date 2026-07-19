// import 'package:adcc/features/events/view/image_card.dart';
// import 'package:adcc/modals/grid_item.dart';
// import 'package:flutter/material.dart';

// class AsymmetricImageGrid extends StatelessWidget {
//   final List<GridItem> items;
//   final double spacing;
//   final double height;

//   const AsymmetricImageGrid({
//     super.key,
//     required this.items,
//     this.spacing = 12,
//     this.height = 260,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // We need at least 4 items
//     if (items.length < 4) {
//       return const SizedBox.shrink();
//     }

//     return SizedBox(
//       height: height,
//       child: Row(
//         children: [
//           /// LEFT BIG CARD
//           Expanded(
//             flex: 2,
//             child: ImageCard(
//               item: items[0],
//             ),
//           ),

//           SizedBox(width: spacing),

//           /// RIGHT 3 SMALL CARDS
//           Expanded(
//             flex: 1,
//             child: Column(
//               children: [
//                 Expanded(child: ImageCard(item: items[1])),
//                 SizedBox(height: spacing),
//                Expanded(child: ImageCard(item: items[2])),
//                 SizedBox(height: spacing),
//                 Expanded(child: ImageCard(item: items[3])),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
