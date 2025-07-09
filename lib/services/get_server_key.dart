import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "gobuy-ecom",
        "private_key_id": "726fa0c01f16b8504e144ffa57dd23c3a54167fb",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCW2KaOk+23YwkB\nPLlo742EIlRGa1VuhDT5qilhJqmMlmOerGcyeMkGNKafGAItRbbOPoaPONjmjAyc\nVrp1VRwfTZRMDPek1Lh26NbNKn0UHAQ/RxYAHyhwH2/QzvWMhiU9w97MpW5EeqQd\n2JgF3CgOTXykNMjmMpsSrXhHR9hwDFUJzDkyalPscNMXbB1bAeoJ/53QhheCJrQw\nrOKNsCh05LjSfgCGgD6xVzA3E021S4e8Rq4T/WdyOx9EwTzxiHc8h6xOG2+/YD+a\nEFqX72ah4ujwCOSdmgGn5trmpBvxCwn+HPpENmyNthPNDtL6eFgoRXzLgTXgacfu\n7t8UCLmfAgMBAAECggEAB166dIjhum4KSJcw7+GUZnpO58niuK2Y8QHRV7/N1OKc\nJ2qA+ERSfg0gfvFrWc7oKZeAd4rtfgYlr5XFMmpgH19o+XZAuzrxcE3cANYsmkjs\nJDNS7dqX3TKMAgW6lY0QUL47KoCCrLHZRuQIOXESO/CpQFSb5DNgxD7Ze5IVDxRX\n5vyArRtgMe14+g5YDyCVIVkpD7ohmDGFVz9+HCF2xze/8rRIBRrqFJMyqUTZ0D30\nSje5BiyqTvYw+mQI7UgNdz2nIP5QpUHtB0NfAdi1rvOs3DV+HjWMQdduBxPyj/Xq\nELWVWLcsa5bqQy6nAqlDMOixX32bFDGXB9El8lxUMQKBgQDVQ+WEma2loTG5Y50l\nWbjdotUuH5dxDEugQEykZfY5rU6KcZRgIOwJw9GtOWUwCCTtsyfAkkxxG4mIlNfl\nPzhSu0CEe1GGxiy0VUyL8mw9omWOgL5H+bIoADZo+DnS6yC0cM7TFrwEkYhj/bEi\nANwpSsRNL6vVC19Jan852bpP3QKBgQC1EsffKUhUU22PG1FwIdqJc0uAusAsbkBU\n9PJIazz6ZdhyTL8x9HRzpkOItcOdq0Akp72b9z4di0LIXpntQfwipIbEJ2uZDr3+\nnxOTYttNe3anCT87mtFtSqcFen1XlNPyNETf1pxfxOf7b1pRaODzsEMfSMRiIJ7I\nmTV178VVqwKBgEXPhPlECRi3zHwgRJeuaBp9LAV+J+fEm5jok24ZRmGY/qXJCkXx\nYPLNW/y1Vg9ECzqYM8IQ4d8AoaPI/Wc4q6pBS5xSddyFUKrzZSxGffIrD813DVKo\nRQ5dC3KPFvaZK0qFxt5IieGA9kGtEOfNmkQWCm4t1bTWlSmGKAF66UctAoGAPJXU\nGm8NrGldtwxE62foXyUcli3mLveUvthWWLTI6l85VMUpE+XfMPLolc17bj3mcF1P\nq+fF+Mynw7MjfaceXdj+3pLyBXxRReij/CSPjBVLVghaB+99MzxPNh4N4kgBwoCK\nqvp7x+9yT0aqyaJ14hOP4d/PFaYkeqoIoTVgqZECgYBglSTjdjkQOF5ymP9rULrw\ntGpVtCh85G0X92NNhkQCQAckYMfmiDrljSHy3njPvZ6mD20kA+bf0c+62kZSpK8W\nMDp8FbURyRixrSCABXReug5C01Q3PMAJisXOCNbBweq+KjOmJ8OKGsMtytafVOwW\n0t+zwNAeQTWqoSJ5Pbfntg==\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@gobuy-ecom.iam.gserviceaccount.com",
        "client_id": "103473962148096760934",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40gobuy-ecom.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      }),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
