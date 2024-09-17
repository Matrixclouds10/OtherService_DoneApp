import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async => _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson(
            {
              "type": "service_account",
              "project_id": "done-8e8c2",
              "private_key_id": "0adbe122be455d4ae4ab541e459488194079b578",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC5aDS0+oJLo8UV\n7t8FEgfKlwyU/YR+67TU8Iu/ePYL7gmQGashT8q3+k/rtBvEXSftzCop0LX/jtK8\nqsB7tLdfDA1znHuzStynO5DJGCD4xpGg3RnxH4Av0GY5VLXnW2qjz4X3lrcJ5AS6\nsxTI/g2uJbcEbmeT+dDYMhKsAiJTH406T6Srmr/qY2cYZPKx9pFk+Ikx9h6Asflc\nLmdepdpI2HQeyckd2fEq68adhDUvZpZcczeU6hdzONCznBD+zChx+5mqHudeFkqI\n6xzGpiS/5vuQnyRup8G+BOOaN+1lk9SCIm9vqDr0mUWiFpLPlBorNHr48smR0tyV\n2x6rdMz3AgMBAAECggEAAk6AYEN6a5L4eLN80EP9m8o3BE5nrxGnkqnMs9dMabmD\njFKcDPJsqwzOslskn6Netpgj9/C6V+Qt/fh8wrLAszR3su09f1vZPpL3yzv9X4GV\nVnD4GSMSQopwVixCR8iLM1bfF8V/PzG8uH9sar3NBkCxhbBH3+KOw3Y4bmu/9lSw\ntB1iL236ivwGGgSkFaSBrx8vk38iVMmnneq8k57DhWew7JqsL25o0Rn9WG5bDZT2\ncMXOjX3fX2oFYX8wIkRjtqtQRQpphcCkYZyBpWYFcKB6vm/isKKH6JQKhmRouOCK\nNN40UZ0wHtYeDAIOfZzLahv8r+2k4OXVVfJQsKm5MQKBgQDceoQjCwB7+4xNlauF\nmLwTOpC4baH3J2KRjAE6NjlOlHIlhReWTEFUBIdlQaAYoR9Wvir8wzYbfziPF8q0\n8qT0/5tXO2tWJiYxfBjE/+fSMKf54PBx3sScTca5+vZtbBbEWhT719rL2/qb2kaR\naQcHiKkVCOJ50wojN6JVAYrG6QKBgQDXRzB6/rvLNvl9teAOdX44YmkA+yCpS5CF\nV6vbh+KqSqRDUA9BkJFQgkkx0PUyIa4xkoh+NX19+tE+5BTXBu7EUBFy25mXFAcd\n8KRpFfWckujDS7+JYDkoNVQLK8Pqj7F4msY9M7N30J9hxnsV9NLBq3KwuTVg0n4k\nAWem6qBI3wKBgEHQRJ9dSmC4HxKNyeyQQhwPUGHtP/rSA+dkfn1M8GBXiZdPmlHg\nI2QcEfqU02BmwD8ZdyWKdB1TJaP5OyY2hC0qG8m3T/wgWShOXep4ZU/l/E5n6f5j\nvBbYVKjxlBvntwgXx8nBjmtqF+3sA0KmslV6YtaHl2s8JvuKQOfVFQL5AoGATdFT\n+wHdzGWA5io6Zb+e8q7QGiSs98Vy5mB8pQyHqNr2acak3SRvAtU1tCY+m/KEzzKS\n2FxpkoJ55Ov5hIjjAl+XDxfGe1AoCnCUXdAsSn7oWMAm6ne38YrlaGxXk5CBrID2\nK+VmeGcXVfazQ4qOLKfW+37XhrpQEp/XYgTqD60CgYBapixrQsb9qHC0UlAM3hKc\nv3f8FOhXZar75YplSj6WcwXyVHL3g1GybWwYRoprQbIc40UwjwxSCpztQF5+nkph\n0wnxaFh9jBzFNvm77tK17A+nAxjGJ1PV3hWAowgcCClMhTxE9L4qzhk8R6jPmZM4\nP0aeicGZkCau+wbk05p5ow==\n-----END PRIVATE KEY-----\n",
              "client_email": "firebase-adminsdk-9cnjb@done-8e8c2.iam.gserviceaccount.com",
              "client_id": "106815617501158423447",
              "auth_uri": "https://accounts.google.com/o/oauth2/auth",
              "token_uri": "https://oauth2.googleapis.com/token",
              "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
              "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-9cnjb%40done-8e8c2.iam.gserviceaccount.com",
              "universe_domain": "googleapis.com"
            }
            ),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
