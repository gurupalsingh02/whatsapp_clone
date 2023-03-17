import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';

final commonFireBaseStorageRepositoryProvider = Provider((ref) =>
    CommonFireBaseStorageRepository(firebaseStorage: FirebaseStorage.instance));

class CommonFireBaseStorageRepository {
  final FirebaseStorage firebaseStorage;
  CommonFireBaseStorageRepository({required this.firebaseStorage});

  Future<String> storeFileToFirebase(String ref, File file) async {
    print(1);
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    print(2);
    TaskSnapshot taskSnapshot = await uploadTask;
    print(3);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    print(4);
    return downloadUrl;
  }
}
