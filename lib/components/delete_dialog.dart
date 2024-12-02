import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/db_provider.dart';

class DeleteDialog extends StatelessWidget {
  DeleteDialog({
    super.key,
    required this.id,
  });
  final DbProvider dbProvider = DbProvider();
  final BaseAuth baseAuth = BaseAuth();
  final String id;

  void deleteUser(context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await currentUser.delete();
    }
    baseAuth.signOut();
    //Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    dbProvider.deleteUser(id);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Are you sure you want to delete your account?'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () async {
                  deleteUser(context);
                },
                child:
                    const Text('delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
