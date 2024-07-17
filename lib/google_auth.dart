import 'dart:convert';

import 'package:googleapis/storage/v1.dart' as storage;
import 'package:googleapis_auth/auth_io.dart';

class GoogleAuth {
  static const _scopes = [storage.StorageApi.devstorageReadOnlyScope];

  static Future<AutoRefreshingAuthClient> getClient() async {
    var credentialsJson = json.decode(r'''
    {
      "type": "service_account",
      "project_id": "resumefunctionality",
      "private_key_id": "private_key_id",
      "private_key": "-----BEGIN PRIVATE KEY-----\nyour_key_here\n-----END PRIVATE KEY-----\n",
      "client_email": "your_service_account_email@resumefunctionality.iam.gserviceaccount.com",
      "client_id": "your_client_id",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/your_service_account_email%40resumefunctionality.iam.gserviceaccount.com"
    }
    ''');

    var credentials = ServiceAccountCredentials.fromJson(credentialsJson);
    return await clientViaServiceAccount(credentials, _scopes);
  }
}
