import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book_app/models/laporan.dart';

class LikeButton extends StatefulWidget {
  final Laporan _laporan;
  final void Function(int newLikeCount)? _onLikeRefresh;
  const LikeButton({
    super.key,
    required Laporan laporan,
    void Function(int newLikeCount)? onLikeRefresh,
  })  : _laporan = laporan,
        _onLikeRefresh = onLikeRefresh;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  final String colletionName = "likes";

  bool isLoading = false;

  bool liked = false;
  late String userId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void checkIfUserLiked() async {
    debugPrint("check status like");
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection(colletionName)
          .where('laporanId', isEqualTo: widget._laporan.docId)
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          liked = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<int> countLike() async {
    debugPrint("count like");
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection(colletionName)
          .where('laporanId', isEqualTo: widget._laporan.docId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      rethrow;
    }
  }

  void like() async {
    setState(() {
      isLoading = true;
    });

    try {
      CollectionReference likesCollection =
          _firestore.collection(colletionName);
      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      await likesCollection.doc().set({
        'userId': userId,
        'laporanId': widget._laporan.docId,
        'tanggal': timestamp,
      }).catchError((e) {
        throw e;
      });
      setState(() {
        liked = true;
      });

      int likes = await countLike();

      widget._onLikeRefresh?.call(likes);
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    userId = auth.currentUser!.uid;
    checkIfUserLiked();
  }

  @override
  Widget build(BuildContext context) {
    return liked
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: () {
                if (!isLoading) {
                  like();
                }
              },
              child: Icon(
                Icons.favorite,
                color: Colors.red[200],
              ),
            ),
          );
  }
}
