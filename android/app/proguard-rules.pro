# Preserve Flutter-related classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**
-ignorewarnings

# Firebase core
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Firebase Messaging
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.messaging.**
-keep class com.google.firebase.messaging.FirebaseMessagingService
-keep class com.google.firebase.iid.**
-keep class com.google.android.gms.internal.firebase_messaging.** { *; }


# Firebase Crashlytics
-keep class com.google.firebase.crashlytics.** { *; }
-dontwarn com.google.firebase.crashlytics.**

# Firebase Performance
-keepattributes Annotation
-keepattributes InnerClasses

# Awesome Notifications (if used)
-keep class me.carda.awesome_notifications.** { *; }
-dontwarn me.carda.awesome_notifications.**

# AppsFlyer (if used)
-keep class com.appsflyer.** { *; }
-keepclassmembers class * {
    @com.appsflyer.** <methods>;
}

# Common Flutter plugins (safe to keep)
-keep class fr.g123k.deviceapps.** { *; }
-keep class io.flutter.plugins.connectivity.** { *; }
-keep class io.flutter.plugins.deviceinfo.** { *; }
-keep class io.flutter.plugins.share.** { *; }
-keep class io.flutter.plugins.firebase.dynamiclinks.** { *; }

# Ignore warnings for older/detached plugins
-dontwarn fr.g123k.deviceapps.**
-dontwarn io.flutter.plugins.connectivity.**
-dontwarn io.flutter.plugins.deviceinfo.**
-dontwarn io.flutter.plugins.share.**
-dontwarn io.flutter.plugins.firebase.dynamiclinks.**

# --- Flutter SharedPreferences plugin ---
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-dontwarn io.flutter.plugins.sharedpreferences.**

# --- Android SharedPreferences classes ---
-keep class android.content.SharedPreferences { *; }
-keep class android.content.SharedPreferences$Editor { *; }

# --- Google Guava (used internally by SharedPreferences) ---
-keep class com.google.common.reflect.** { *; }
-dontwarn com.google.common.reflect.**

# Explicitly keep TypeToken to avoid parameterization errors
-keep class com.google.common.reflect.TypeToken { *; }

# --- DataStore / Preferences Protobuf ---
-keep class androidx.datastore.preferences.protobuf.** { *; }



