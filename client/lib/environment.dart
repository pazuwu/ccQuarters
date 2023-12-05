import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get filename {
    if (kReleaseMode) {
      return "env/.env.production";
    }

    return "env/.env.dev";
  }

  static String get apiUrl =>
      dotenv.env["API_URL"] ?? "ANNOUNCEMENTS_API_URL not found!";

  static String get vtApiUrl =>
      dotenv.env["VT_API_URL"] ?? "VT_API_URL not found!";

  static String get projectId =>
      dotenv.env["PROJECT_ID"] ?? "PROJECT_ID not found!";

  static String get authDomain =>
      dotenv.env["AUTH_DOMAIN"] ?? "AUTH_DOMAIN not found!";

  static String get databaseUrl =>
      dotenv.env["DATABASE_URL"] ?? "DATABASE_URL not found!";

  static String get storageBucket =>
      dotenv.env["STORAGE_BUCKET"] ?? "STORAGE_BUCKET not found!";

  static String get apiKeyWeb =>
      dotenv.env["API_KEY_WEB"] ?? "API_KEY_WEB not found!";

  static String get appIdWeb =>
      dotenv.env["APP_ID_WEB"] ?? "APP_ID_WEB not found!";

  static String get messagingSenderIdWeb =>
      dotenv.env["MESSAGING_SENDER_ID_WEB"] ??
      "MESSAGING_SENDER_ID_WEB not found!";

  static String get measurementIdWeb =>
      dotenv.env["MEASUREMENT_ID_WEB"] ?? "MEASUREMENT_ID_WEB not found!";

  static String get apiKeyMobile =>
      dotenv.env["API_KEY_MOBILE"] ?? "API_KEY_MOBILE not found!";

  static String get appIdMobile =>
      dotenv.env["APP_ID_MOBILE"] ?? "APP_ID_MOBILE not found!";

  static String get messagingSenderIdMobile =>
      dotenv.env["MESSAGING_SENDER_ID_MOBILE"] ??
      "MESSAGING_SENDER_ID_MOBILE not found!";
}
