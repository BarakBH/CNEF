// import 'package:flutter/material.dart';
//
// class PostCard extends StatefulWidget {
//   final snap;
//
//   const PostCard({Key? key,this.snap}) : super(key: key);
//
//   @override
//   State<PostCard> createState() => _PostCardState();
// }
//
// class _PostCardState extends State<PostCard> {
//   @override
//
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//
//     return Container(
//       // boundary needed for web
//        padding: const EdgeInsets.symmetric(
//         vertical: 10,
//       ),
//       child: Column(
//         children: [
//       // HEADER SECTION OF THE POST
//       Container(
//       padding: const EdgeInsets.symmetric(
//         vertical: 4,
//         horizontal: 16,
//       ).copyWith(right: 0),
//       child: Row(
//         children: <Widget>[
//           CircleAvatar(
//             radius: 16,
//             backgroundImage: NetworkImage(
//               widget.snap['profImage'].toString(),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(
//                 left: 8,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     widget.snap['username'].toString(),
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           widget.snap['uid'].toString() == user.uid
//               ? IconButton(
//             onPressed: () {
//               showDialog(
//                 useRootNavigator: false,
//                 context: context,
//                 builder: (context) {
//                   return Dialog(
//                     child: ListView(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 16),
//                         shrinkWrap: true,
//                         children: [
//                           'Delete',
//                         ]
//                             .map(
//                               (e) => InkWell(
//                               child: Container(
//                                 padding:
//                                 const EdgeInsets.symmetric(
//                                     vertical: 12,
//                                     horizontal: 16),
//                                 child: Text(e),
//                               ),
//                              ),
//                         )
//                             .toList()),
//                   );
//                 },
//               );
//             },
//             icon: const Icon(Icons.more_vert),
//           )
//               : Container(),
//         ],
//       ),
//     ),
//   }
// }
