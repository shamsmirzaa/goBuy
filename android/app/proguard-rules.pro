# Keep Flutter Local Notifications classes
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep Firebase Messaging Service
-keep class com.google.firebase.messaging.** { *; }

# Keep WorkManager (if used)
-keep class androidx.work.** { *; }

# Keep Kotlin metadata
-keep class kotlin.** { *; }

# General ProGuard settings for Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**
